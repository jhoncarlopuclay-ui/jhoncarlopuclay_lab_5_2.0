-- ScholarTrack schema. Run in Supabase SQL Editor. GWA uses a 1.00–5.00 scale;
-- lower is better, and each program stores its own maximum permitted GWA.
create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  role text not null default 'staff' check (role in ('admin','staff','scholar')),
  created_at timestamptz not null default now()
);
create table if not exists public.scholarship_programs (
  id uuid primary key default gen_random_uuid(),
  program_name text not null unique,
  required_gwa numeric(3,2) not null check(required_gwa between 1 and 5),
  min_units integer not null check(min_units between 0 and 40),
  allow_failing_grade boolean not null default false,
  active boolean not null default true,
  created_at timestamptz not null default now()
);
create table if not exists public.scholars (
  id uuid primary key default gen_random_uuid(),
  student_id text not null unique,
  full_name text not null,
  degree_program text not null,
  year_level text not null,
  scholarship_id uuid not null references public.scholarship_programs(id),
  status text not null default 'Active' check(status in ('Active','Pending Submission','For Verification','Compliant','With Deficiency','Probationary','For Renewal','Renewed','Disqualified')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create table if not exists public.grade_submissions (
  id uuid primary key default gen_random_uuid(),
  scholar_id uuid not null references public.scholars(id) on delete cascade,
  academic_year text not null,
  semester text not null check(semester in ('First Semester','Second Semester','Summer')),
  gwa numeric(3,2) not null check(gwa between 1 and 5),
  units_enrolled integer not null check(units_enrolled between 0 and 40),
  failed_subjects integer not null default 0 check(failed_subjects >= 0),
  incomplete_subjects integer not null default 0 check(incomplete_subjects >= 0),
  submission_status text not null default 'Pending' check(submission_status in ('Pending','Verified','Returned')),
  submitted_at timestamptz not null default now(),
  verified_by uuid references public.profiles(id),
  verified_at timestamptz,
  check ((submission_status = 'Verified' and verified_by is not null and verified_at is not null)
    or submission_status <> 'Verified')
);
alter table public.grade_submissions
  drop constraint if exists grade_submissions_scholar_id_academic_year_semester_key;
-- Returned submissions can be corrected and resubmitted for the same term.
create unique index if not exists one_active_submission_per_scholar_term
  on public.grade_submissions(scholar_id, academic_year, semester)
  where submission_status <> 'Returned';
create table if not exists public.compliance_evaluations (
  id uuid primary key default gen_random_uuid(),
  submission_id uuid not null unique references public.grade_submissions(id) on delete cascade,
  scholar_id uuid not null references public.scholars(id) on delete cascade,
  result text not null check(result in ('Compliant','With Deficiency')),
  reasons jsonb not null default '[]'::jsonb,
  evaluated_by uuid references public.profiles(id),
  evaluated_at timestamptz not null default now()
);
create table if not exists public.audit_log (
  id bigint generated always as identity primary key,
  actor_id uuid references public.profiles(id),
  table_name text not null,
  record_id uuid,
  action text not null,
  old_data jsonb,
  new_data jsonb,
  changed_at timestamptz not null default now()
);

create or replace function public.current_role() returns text language sql stable security definer
set search_path = public as $$ select role from public.profiles where id = auth.uid() $$;
create or replace function public.audit_grade_changes() returns trigger language plpgsql security definer
set search_path = public as $$ begin
  if old.submission_status = 'Verified' and new is distinct from old and public.current_role() <> 'admin' then
    raise exception 'Verified grade records require an authorized admin correction process';
  end if;
  insert into public.audit_log(actor_id,table_name,record_id,action,old_data,new_data)
  values(auth.uid(),tg_table_name,coalesce(new.id,old.id),tg_op,to_jsonb(old),to_jsonb(new));
  return new;
end $$;
drop trigger if exists grade_submission_audit on public.grade_submissions;
create trigger grade_submission_audit before update on public.grade_submissions
for each row execute function public.audit_grade_changes();

create or replace function public.verify_grade_submission(p_submission_id uuid) returns void
language plpgsql security definer set search_path = public as $$
declare v_row public.grade_submissions;
begin
  if public.current_role() not in ('admin','staff') then raise exception 'Only authorized staff may verify'; end if;
  select * into v_row from public.grade_submissions where id=p_submission_id for update;
  if not found or v_row.submission_status <> 'Pending' then raise exception 'Submission must be pending'; end if;
  update public.grade_submissions set submission_status='Verified',verified_by=auth.uid(),verified_at=now()
    where id=p_submission_id;
end $$;

create or replace function public.evaluate_compliance(p_submission_id uuid) returns public.compliance_evaluations
language plpgsql security definer set search_path = public as $$
declare g public.grade_submissions; s public.scholars; p public.scholarship_programs;
  r text := 'Compliant'; why jsonb := '[]'::jsonb; out_row public.compliance_evaluations;
begin
  if public.current_role() not in ('admin','staff') then raise exception 'Only authorized staff may evaluate'; end if;
  select * into g from public.grade_submissions where id=p_submission_id;
  if not found or g.submission_status <> 'Verified' then raise exception 'Only verified submissions can be evaluated'; end if;
  select * into s from public.scholars where id=g.scholar_id;
  select * into p from public.scholarship_programs where id=s.scholarship_id and active=true;
  if not found then raise exception 'Scholar must have an active scholarship program'; end if;
  if g.gwa > p.required_gwa then r:='With Deficiency'; why:=why||jsonb_build_array('GWA exceeds program maximum'); end if;
  if g.units_enrolled < p.min_units then r:='With Deficiency'; why:=why||jsonb_build_array('Enrolled units below program minimum'); end if;
  if not p.allow_failing_grade and g.failed_subjects>0 then r:='With Deficiency'; why:=why||jsonb_build_array('Failing grade not allowed'); end if;
  if g.incomplete_subjects>0 then r:='With Deficiency'; why:=why||jsonb_build_array('Incomplete subjects must be resolved'); end if;
  insert into public.compliance_evaluations(submission_id,scholar_id,result,reasons,evaluated_by)
    values(g.id,s.id,r,why,auth.uid()) on conflict(submission_id) do update set result=excluded.result,reasons=excluded.reasons,evaluated_by=excluded.evaluated_by,evaluated_at=now()
    returning * into out_row;
  update public.scholars set status=r,updated_at=now() where id=s.id;
  return out_row;
end $$;

alter table public.profiles enable row level security;
alter table public.scholarship_programs enable row level security;
alter table public.scholars enable row level security;
alter table public.grade_submissions enable row level security;
alter table public.compliance_evaluations enable row level security;
alter table public.audit_log enable row level security;
drop policy if exists "signed in profiles readable" on public.profiles;
drop policy if exists "admins manage profiles" on public.profiles;
drop policy if exists "staff read programs" on public.scholarship_programs;
drop policy if exists "admins manage programs" on public.scholarship_programs;
drop policy if exists "staff manage scholars" on public.scholars;
drop policy if exists "scholar and staff read submissions" on public.grade_submissions;
drop policy if exists "staff create submissions" on public.grade_submissions;
drop policy if exists "staff update submissions" on public.grade_submissions;
drop policy if exists "staff read evaluations" on public.compliance_evaluations;
drop policy if exists "staff write evaluations" on public.compliance_evaluations;
drop policy if exists "admins read audit" on public.audit_log;
create policy "signed in profiles readable" on public.profiles for select to authenticated using (id=auth.uid() or public.current_role() in ('admin','staff'));
create policy "admins manage profiles" on public.profiles for all to authenticated using (public.current_role()='admin') with check (public.current_role()='admin');
create policy "staff read programs" on public.scholarship_programs for select to authenticated using (public.current_role() in ('admin','staff'));
create policy "admins manage programs" on public.scholarship_programs for all to authenticated using (public.current_role()='admin') with check (public.current_role()='admin');
create policy "staff manage scholars" on public.scholars for all to authenticated using (public.current_role() in ('admin','staff')) with check (public.current_role() in ('admin','staff'));
create policy "scholar and staff read submissions" on public.grade_submissions for select to authenticated using (public.current_role() in ('admin','staff') or exists(select 1 from public.scholars s where s.id=scholar_id and s.student_id=(auth.jwt()->'user_metadata'->>'student_id')));
create policy "staff create submissions" on public.grade_submissions for insert to authenticated with check (public.current_role() in ('admin','staff'));
create policy "staff update submissions" on public.grade_submissions for update to authenticated using (public.current_role() in ('admin','staff')) with check (public.current_role() in ('admin','staff'));
create policy "staff read evaluations" on public.compliance_evaluations for select to authenticated using (public.current_role() in ('admin','staff'));
create policy "staff write evaluations" on public.compliance_evaluations for all to authenticated using (public.current_role() in ('admin','staff')) with check (public.current_role() in ('admin','staff'));
create policy "admins read audit" on public.audit_log for select to authenticated using (public.current_role()='admin');
grant execute on function public.verify_grade_submission(uuid) to authenticated;
grant execute on function public.evaluate_compliance(uuid) to authenticated;

-- Example requirements only; confirm these values against actual program policy.
-- Disable the older sample program choices so the scholar selector shows the
-- three requested programs. Existing scholar links and records remain intact.
update public.scholarship_programs set active=false
where program_name in ('University Merit Grant','National Scholars Program','STEM Excellence Award','Access & Opportunity Grant');
insert into public.scholarship_programs(program_name,required_gwa,min_units,allow_failing_grade,active) values
('ADSSU Scholarship',2.00,15,false,true),
('CHED Scholarship',2.00,18,false,true),
('TES Scholarship',2.25,15,true,true)
on conflict(program_name) do update set active=true;
