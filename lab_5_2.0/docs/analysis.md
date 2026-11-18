# Scholarship Monitoring System — Part I Analysis

## A. Problem analysis

| No. | Problem | Cause | Effect |
|---:|---|---|---|
| 1 | Scholar records are duplicated or inconsistent | Separate spreadsheets and paper files | Staff cannot rely on a single current record |
| 2 | Scholarship conditions are applied inconsistently | Rules are stored in separate documents or remembered by staff | Similar scholars may receive different decisions |
| 3 | Grade submissions arrive through multiple channels | Email, paper, messaging, and shared drives | Records are missed, delayed, or hard to locate |
| 4 | Deadlines are tracked manually | No central term calendar or pending queue | Late submissions are discovered too late |
| 5 | Verification progress is unclear | No standard pending/verified/returned state | Follow-up and responsibility are ambiguous |
| 6 | Compliance calculations are manual | GWA, units, and grade rules are checked independently | Arithmetic and policy errors affect scholarship decisions |
| 7 | Deficiencies are not consistently recorded | No structured reason list or resolution tracking | Scholars may not know what they must correct |
| 8 | Renewal dates and decisions are easy to miss | Renewal evidence is spread across semester files | Eligible renewals may be delayed or overlooked |
| 9 | Reports take time to assemble | Data must be reconciled across files | Coordinators lack timely program-wide visibility |
| 10 | Grade data is exposed too broadly | Shared files lack role-based permissions and audit history | Sensitive academic information may be disclosed or altered |

## B. Stakeholders and actors

| Stakeholder | Information needed | Responsibility | Actor? | Why |
|---|---|---|---|---|
| Scholar | Own program conditions, deadlines, submission receipt, deficiencies, status | Submit accurate grades and resolve deficiencies | Yes | Uses the system to view requirements and submit/view own records |
| Scholarship Staff | Scholar records, submissions, documents, verification queue | Maintain records, validate and verify evidence, follow up | Yes | Performs operational use cases |
| Scholarship Coordinator | Program policies, exceptions, aggregate compliance, renewal queue | Configure rules, oversee evaluations and renewals, report outcomes | Yes | Makes authorized configuration and oversight decisions |
| Scholarship Committee | Evaluations, exceptions, renewal/disqualification recommendations | Decide escalated scholarship cases | Yes (supporting) | Receives reports and records committee decisions in later phases |
| Registrar | Official grades, enrollment units, academic calendar | Supply authoritative academic records | Supporting external actor | May provide verified records through a future integration |
| System Administrator | Accounts, roles, audit events, service health | Provision access and maintain system configuration | Yes | Administers identity and system access |

## C. Requirements elicitation: interview questions

1. How are scholars registered today, and which office validates student identity and scholarship eligibility?
2. How are students assigned to a scholarship program, and who can approve a change?
3. What information and supporting documents must a scholar submit each semester?
4. How are academic years, semester dates, submission windows, and late submissions determined?
5. What grading scale does the institution use, and does a lower or higher GWA represent stronger performance?
6. For each scholarship, what GWA threshold, minimum units, and failed/incomplete grade policies apply?
7. Who checks a submission, what evidence do they use, and can a submission be returned for correction?
8. What must be recorded when a staff member verifies or corrects a grade record?
9. How are deficiencies communicated, assigned for follow-up, and considered resolved?
10. What conditions make a scholar active, probationary, eligible for renewal, renewed, or disqualified?
11. How are scholars notified about deadlines, verification, deficiencies, and renewal outcomes?
12. Which reports and dashboard totals do staff, coordinators, and the committee need, and how often?
13. Which roles may view, create, verify, edit, export, and administer academic records?
14. How long must grade submissions and decision history be retained, and who may access archived records?
15. Which registrar or student information system is the authoritative source for grades and units?

## D. Functional requirements

| ID | Requirement |
|---|---|
| FR-01 | The system shall allow authorized staff to register scholar records. |
| FR-02 | The system shall associate each scholar with one active scholarship program. |
| FR-03 | The system shall maintain a maximum GWA, minimum units, and failing-grade policy for each scholarship program. |
| FR-04 | The system shall allow an authorized user to record a semester grade submission for a scholar. |
| FR-05 | The system shall record the academic year and semester of every submission. |
| FR-06 | The system shall allow authorized staff to verify or return a pending grade submission. |
| FR-07 | The system shall evaluate verified academic information against the assigned scholarship requirements. |
| FR-08 | The system shall identify and display the conditions causing a compliance deficiency. |
| FR-09 | The system shall maintain each scholar's current scholarship status. |
| FR-10 | The system shall identify pending grade submissions and display their count. |
| FR-11 | The system shall allow authorized staff to view, search, and update scholar records. |
| FR-12 | The system shall allow authorized users to search scholars by student ID or name and filter by program or status. |
| FR-13 | The system shall authenticate users and enforce role-based access to protected functions and grade information. |
| FR-14 | The system shall display dashboard counts for active scholars, pending and verified submissions, compliant scholars, and scholars with deficiencies. |
| FR-15 | The system shall allow authorized users to view a scholar's assigned program requirements. |
| FR-16 | The system shall prevent duplicate submissions for the same scholar, academic year, and semester. |
| FR-17 | The system shall allow authorized staff to generate a compliance report for verified records. |
| FR-18 | The system shall record who verified a submission and when it was verified. |
| FR-19 | The system shall retain an audit trail of changes to verified academic records. |
| FR-20 | The system shall allow authorized staff to initiate and record scholarship renewal decisions. |

## E. Non-functional requirements

| ID | Category | Requirement |
|---|---|---|
| NFR-01 | Security | The system shall require authentication for protected records and enforce role-based permissions on the server/database. |
| NFR-02 | Privacy | The system shall restrict identifiable grade data to the scholar concerned and authorized staff, subject to institutional policy. |
| NFR-03 | Usability | The system shall provide consistent navigation, clear status labels, and field-level validation usable on desktop and mobile screens. |
| NFR-04 | Performance | The system shall display a normal dashboard with up to 5,000 scholar records within three seconds on the institution's supported network. |
| NFR-05 | Reliability | The hosted system shall target 99% monthly availability, excluding scheduled maintenance. |
| NFR-06 | Data integrity | The system shall enforce valid ranges, required references, unique student IDs, unique scholar-term submissions, and auditable verification. |
| NFR-07 | Compatibility | The web interface shall support current versions of mainstream desktop and mobile browsers. |
| NFR-08 | Maintainability | Scholarship policy values shall be configurable per program rather than embedded as a shared fixed threshold in application logic. |

## F. Business rules

| ID | Business rule |
|---|---|
| BR-01 | Every scholar must be assigned to an active scholarship program. |
| BR-02 | Every scholarship program must define its academic requirements. |
| BR-03 | A grade submission must belong to one scholar, academic year, and semester; only one submission per scholar and term is allowed. |
| BR-04 | Only authorized personnel may verify submitted grades. |
| BR-05 | Only verified submissions may be used for final compliance evaluation. |
| BR-06 | A scholar cannot be marked Compliant while mandatory requirements are incomplete. |
| BR-07 | Scholar status must be based on the rules of the assigned scholarship program. |
| BR-08 | Changes to verified academic records must be traceable and follow an authorized correction process. |
| BR-09 | A submission cannot be verified twice without an authorized correction process. |
| BR-10 | Sensitive grade information must only be visible to authorized users and the scholar concerned. |
| BR-11 | For the prototype's 1.00–5.00 scale, lower GWA is better and submitted GWA must be at or below the program's maximum. Institutions must confirm and configure their own scale before production use. |
| BR-12 | Enrolled units must meet the assigned program minimum; failed grades are acceptable only when that program permits them. |
| BR-13 | Incomplete subjects are a deficiency until resolved. |
| BR-14 | Student IDs must be nonblank and unique. GWA must be 1.00–5.00; units and subject counts cannot be negative. |
| BR-15 | The current status is derived from the latest verified term. A pending term is For Verification; future renewal outcomes remain explicit decisions. |

## G. Scholar statuses

| Status | Condition |
|---|---|
| Active | Registered under an active program with no current pending or evaluated term status. |
| Pending Submission | The expected term submission has not been received by its due date/window. |
| For Verification | A grade submission is awaiting authorized staff review. |
| Compliant | The latest verified submission meets every applicable program condition. |
| With Deficiency | The latest verified submission fails one or more mandatory conditions. |
| Probationary | An authorized scholarship decision places the scholar on probation after a deficiency or exception. |
| For Renewal | The scholar's renewal decision is pending at the renewal point. |
| Renewed | An authorized decision approves continuation for the next scholarship period. |
| Disqualified | An authorized decision ends eligibility under institutional policy. |

## H. Use cases

| ID | Use case | Primary actor |
|---|---|---|
| UC-01 | Login | All registered users |
| UC-02 | Register Scholar | Scholarship Staff |
| UC-03 | Assign Scholarship | Scholarship Staff |
| UC-04 | Configure Scholarship Requirements | Scholarship Coordinator |
| UC-05 | View Requirements | Scholar, Scholarship Staff |
| UC-06 | Submit Grades | Scholar / Scholarship Staff |
| UC-07 | Verify Grade Submission | Scholarship Staff |
| UC-08 | Evaluate Academic Compliance | Scholarship Coordinator |
| UC-09 | Record Deficiency | Scholarship Staff |
| UC-10 | View Deficiency | Scholar, Scholarship Staff |
| UC-11 | Update Scholar Status | Scholarship Coordinator |
| UC-12 | Process Scholarship Renewal | Scholarship Coordinator / Committee |
| UC-13 | Search Scholar | Scholarship Staff |
| UC-14 | Filter Scholars | Scholarship Staff |
| UC-15 | Generate Compliance Report | Scholarship Coordinator |
| UC-16 | View Dashboard | Scholarship Staff, Coordinator |
| UC-17 | Logout | All registered users |

The diagram in [`use-case-diagram.puml`](use-case-diagram.puml) includes actor associations, a system boundary, four include relationships, and two extend relationships.

## I. Detailed use cases

### UC-06 — Submit Grades

| Element | Description |
|---|---|
| Primary actor | Scholar; staff may assist with entry |
| Goal | Record academic results for a specific term for verification |
| Preconditions | User is authenticated; scholar and program exist; submission window is open under policy. |
| Trigger | Scholar selects “Submit grades” or staff starts a submission. |
| Main flow | 1. System displays scholar and assigned requirements. 2. Actor enters academic year, semester, GWA, units, failed subjects, and incomplete subjects. 3. System validates required values, ranges, authorization, and absence of a duplicate term record. 4. Actor saves. 5. System stores the record as Pending and records submission time. |
| Alternative flow | A1. Staff enters a paper or registrar supplied submission on behalf of the scholar and records the submitter/source in the deployed extension. |
| Exception flow | E1. Invalid GWA/counts or missing fields are rejected with a clear correction message. E2. Duplicate scholar-term record is rejected. |
| Postconditions | One pending submission exists; it is not yet eligible for final evaluation. |
| Related requirements | FR-04, FR-05, FR-16; NFR-03, NFR-06 |
| Business rules | BR-03, BR-05, BR-14 |

### UC-07 — Verify Grade Submission

| Element | Description |
|---|---|
| Primary actor | Scholarship Staff |
| Goal | Confirm that a pending submission is ready for policy evaluation |
| Preconditions | Staff is authenticated and authorized; a pending submission exists. |
| Trigger | Staff opens the verification queue and selects a submission. |
| Main flow | 1. System shows scholar, term, values, and assigned program. 2. Staff checks the submission against source evidence. 3. Staff confirms verification. 4. System changes status to Verified and records verifier and timestamp. 5. System evaluates the verified submission and refreshes scholar status. |
| Alternative flow | A1. Staff returns a submission for correction, records a reason, and the record remains excluded from final compliance. |
| Exception flow | E1. A non-staff user is denied. E2. A non-pending record cannot be verified again. |
| Postconditions | The record is Verified or Returned; verification actor/time are recorded; verified data is eligible for evaluation. |
| Related requirements | FR-06, FR-07, FR-18, FR-19 |
| Business rules | BR-04, BR-05, BR-08, BR-09 |

### UC-08 — Evaluate Academic Compliance

| Element | Description |
|---|---|
| Primary actor | Scholarship Coordinator (system performs calculation) |
| Goal | Determine whether a verified term meets the scholar's program rules |
| Preconditions | Submission is verified; scholar has an active assigned program with configured requirements. |
| Trigger | Verification completes or authorized coordinator requests recalculation after a correction. |
| Main flow | 1. System loads the scholar's assigned program rules. 2. System checks GWA at or below maximum, units at or above minimum, failing-grade policy, and incomplete subjects. 3. System records Compliant if all checks pass; otherwise With Deficiency and the failed condition(s). 4. System updates current scholar status and dashboard counts. |
| Alternative flow | A1. Several conditions fail; system records and displays each deficiency. |
| Exception flow | E1. Unverified submission is rejected for final evaluation. E2. Missing/inactive program requirements prevent evaluation and surface a configuration error. |
| Postconditions | Evaluation result, reasons, and time are available; latest scholar status is updated. |
| Related requirements | FR-03, FR-07, FR-08, FR-09, FR-14 |
| Business rules | BR-01, BR-02, BR-05, BR-06, BR-07, BR-11, BR-12, BR-13 |

### UC-12 — Process Scholarship Renewal

| Element | Description |
|---|---|
| Primary actor | Scholarship Coordinator; Scholarship Committee for escalated cases |
| Goal | Record an authorized continuation decision for the next scholarship period |
| Preconditions | Scholar is in a renewal window; required term evaluations and supporting evidence are available. |
| Trigger | Coordinator opens the renewal queue for a new award period. |
| Main flow | 1. System lists scholars due for renewal with program rules and verified history. 2. Coordinator reviews eligibility and any deficiencies. 3. Coordinator records Renewed, For Renewal, Probationary, or Disqualified decision and rationale. 4. System records actor, date, and decision history. 5. System updates the scholar's status and generates an updated renewal report. |
| Alternative flow | A1. Coordinator refers an exception to the Scholarship Committee, records the referral, and leaves the status For Renewal until decided. |
| Exception flow | E1. Missing required evaluation prevents an eligibility recommendation and identifies the missing term. E2. Unauthorized users cannot enter the decision. |
| Postconditions | Renewal decision and rationale are traceable; next-period status is visible. |
| Related requirements | FR-09, FR-20, FR-17 |
| Business rules | BR-07, BR-08, BR-10 |

## J. Requirements traceability

| Requirement | Actor | Use case | Business rule | Planned / implemented feature |
|---|---|---|---|---|
| FR-01 | Scholarship Staff | UC-02 Register Scholar | BR-14 | Scholar create/edit form |
| FR-02 | Scholarship Staff | UC-03 Assign Scholarship | BR-01 | Program selector on scholar record |
| FR-03 | Scholarship Coordinator | UC-04 Configure Scholarship Requirements | BR-02, BR-11 | Program configuration cards and editable rules |
| FR-04 | Scholar / Staff | UC-06 Submit Grades | BR-03 | Grade submission form |
| FR-05 | Scholar / Staff | UC-06 Submit Grades | BR-03 | Academic year and semester fields |
| FR-06 | Scholarship Staff | UC-07 Verify Grade Submission | BR-04, BR-05 | Pending queue and verification action |
| FR-07 | Coordinator / System | UC-08 Evaluate Academic Compliance | BR-02, BR-07 | Requirement comparison on verified record |
| FR-08 | Scholarship Staff | UC-09 Record Deficiency | BR-06, BR-13 | Per-condition deficiency reasons |
| FR-09 | Scholarship Coordinator | UC-11 Update Scholar Status | BR-07, BR-15 | Latest verified result/status badge |
| FR-10 | Scholarship Staff | UC-16 View Dashboard | BR-03, BR-05 | Live pending count and review queue |
| FR-11 | Scholarship Staff | UC-02 Register Scholar | BR-14 | Searchable scholar list and edit action |
| FR-12 | Scholarship Staff | UC-13 / UC-14 Search and Filter | BR-10 | ID/name search, program/status filters |
| FR-13 | All roles | UC-01 Login | BR-04, BR-10 | Supabase Auth, role-aware RLS |
| FR-14 | Staff / Coordinator | UC-16 View Dashboard | BR-05, BR-07 | Status metrics and compliance chart |
| FR-15 | Scholar / Staff | UC-05 View Requirements | BR-02 | Program requirement detail view |
| FR-16 | System | UC-06 Submit Grades | BR-03 | Unique scholar/term constraint and validation |
| FR-17 | Coordinator | UC-15 Generate Compliance Report | BR-07 | Compliance CSV export |
| FR-18 | Scholarship Staff | UC-07 Verify Grade Submission | BR-08 | Verifier identity and timestamp fields |
| FR-19 | Administrator | UC-07 Verify Grade Submission | BR-08 | Audit log and verified record correction guard |
| FR-20 | Coordinator / Committee | UC-12 Process Scholarship Renewal | BR-07 | Defined use case; renewal workflow is a later lab |

## Development functional-test results

The prototype is delivered with a demo dataset to exercise the workflow. Run these checks in a browser before class submission and record the observed result/date in your screenshots or a commit note.

| Test | Scenario | Expected result |
|---|---|---|
| TC-01 | Enter demo workspace (or sign in with configured staff account) | Dashboard opens; unauthenticated cloud session is gated |
| TC-02 | Create scholar with complete fields | Scholar appears in list |
| TC-03 | Create scholar without Student ID / with duplicate ID | Browser/form validation rejects it |
| TC-04 | Submit grades with valid fields | Submission is saved as Pending |
| TC-05 | Verify a pending submission as staff | Becomes Verified and one-time verification is enforced |
| TC-06 | Use a passing sample for a program | Compliance shows Compliant |
| TC-07 | Use GWA above threshold, too few units, or disallowed failure | Compliance shows With Deficiency with reason |
| TC-08 | Search by student ID or name | Matching scholar appears |
| TC-09 | Filter by program/status | Only matching scholars appear |
| TC-10 | Open GitHub Pages URL after deployment | Site is reachable over HTTPS |

**Manual completion evidence still needed for a course submission:** record actual browser test results, take 2–4 screenshots, make at least four meaningful Git commits, and provide the GitHub repository and deployed URL. The current environment supplied no remote repository, Supabase project credentials, or deployment account, so those external artifacts are not represented as completed.
