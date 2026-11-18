# ScholarTrack

A responsive scholarship monitoring prototype for the Systems Analysis and Design laboratory. It demonstrates the vertical workflow from scholar registration through semester grade submission, staff verification, rules-based compliance evaluation, and monitoring.

## Run the prototype

Open `index.html` in a browser. The demo workspace needs no account and persists data in the browser's local storage. Demo data is fictional. Use the navigation to add a scholar, select a scholarship program, submit grades, verify the pending submission, and inspect the compliance result. The supplied sample grading scale is **1.00 (best) to 5.00 (fail)**; each program's `required_gwa` is the maximum permitted value. Incomplete subjects are treated as a deficiency until resolved.

## Connect Supabase

1. Create a Supabase project and run [`supabase/schema.sql`](supabase/schema.sql) in its SQL editor.
2. Create staff users in Supabase Auth. Add the matching row to `profiles`, with role `admin` or `staff`. Provision roles through trusted administration; never permit users to set their own role.
3. Replace the placeholders in [`config.js`](config.js) with `window.SCHOLARTRACK_SUPABASE_URL` and `window.SCHOLARTRACK_SUPABASE_ANON_KEY` from Supabase Project Settings → API Keys. These values are public client configuration; database access is enforced by RLS. Never place a service-role key in browser code.
4. Staff authentication then gates the workspace. Grade verification and compliance evaluation are enforced in SQL through role-checked functions; submissions remain pending until staff verifies them.

The hosted integration uses Supabase Auth and PostgreSQL. Use the demo mode as the working classroom flow when backend credentials are unavailable. This repository does not claim that a cloud database or live deployment has been provisioned.

## Analysis deliverables

- [Part I requirements and traceability packet](docs/analysis.md)
- [Use case diagram (PlantUML source)](docs/use-case-diagram.puml)
- [Database relationship diagram (Mermaid)](docs/erd.md)
- [Supabase schema and access controls](supabase/schema.sql)

## Core workflow

1. Register a scholar with a unique student ID and active scholarship program.
2. Submit a term's GWA, unit count, failed-subject count, and incomplete-subject count. Submission starts Pending.
3. Authorized staff verifies a pending record. Re-verification is disallowed.
4. Verified records are evaluated against the assigned program: GWA at or below maximum, units at or above minimum, failing grades allowed only when the program permits, and no incomplete subjects.
5. The scholar's current status and compliance dashboard update from the latest verified record.

## Deployment and submission

Publish the root folder with GitHub Pages (Settings → Pages → deploy from branch / root). For a class submission, add screenshots of the complete workflow and test outcomes, commit the project in meaningful stages, and submit the repository and deployment URLs. A URL and external repository are not supplied by this local workspace.
