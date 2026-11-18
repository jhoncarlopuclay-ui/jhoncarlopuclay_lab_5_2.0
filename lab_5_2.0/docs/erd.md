# Data model

```mermaid
erDiagram
  AUTH_USERS ||--|| PROFILES : has
  SCHOLARSHIP_PROGRAMS ||--o{ SCHOLARS : assigns
  SCHOLARS ||--o{ GRADE_SUBMISSIONS : submits
  GRADE_SUBMISSIONS ||--o| COMPLIANCE_EVALUATIONS : produces
  PROFILES ||--o{ GRADE_SUBMISSIONS : verifies
  PROFILES ||--o{ COMPLIANCE_EVALUATIONS : evaluates
  PROFILES ||--o{ AUDIT_LOG : acts

  PROFILES {
    uuid id PK
    text full_name
    text role
  }
  SCHOLARSHIP_PROGRAMS {
    uuid id PK
    text program_name UK
    numeric required_gwa
    integer min_units
    boolean allow_failing_grade
    boolean active
  }
  SCHOLARS {
    uuid id PK
    text student_id UK
    text full_name
    text degree_program
    text year_level
    uuid scholarship_id FK
    text status
  }
  GRADE_SUBMISSIONS {
    uuid id PK
    uuid scholar_id FK
    text academic_year
    text semester
    numeric gwa
    integer units_enrolled
    integer failed_subjects
    integer incomplete_subjects
    text submission_status
    timestamptz submitted_at
    uuid verified_by FK
    timestamptz verified_at
  }
  COMPLIANCE_EVALUATIONS {
    uuid id PK
    uuid submission_id FK
    uuid scholar_id FK
    text result
    jsonb reasons
    uuid evaluated_by FK
    timestamptz evaluated_at
  }
  AUDIT_LOG {
    bigint id PK
    uuid actor_id FK
    text table_name
    uuid record_id
    text action
    jsonb old_data
    jsonb new_data
    timestamptz changed_at
  }
```

`grade_submissions` has a unique constraint over `(scholar_id, academic_year, semester)`. The evaluation records the result and reason list from that verified snapshot. The static prototype derives an evaluation from the latest verified submission at render time; the Supabase schema provides a dedicated table and server-side evaluation function for a deployed workflow.
