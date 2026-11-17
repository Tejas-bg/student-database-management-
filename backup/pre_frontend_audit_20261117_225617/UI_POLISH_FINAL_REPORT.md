# GM University Management System — UI/UX Professional Polish Report

## Overview
Applied professional-polish changes across the entire Flask + MySQL + vanilla JS system, affecting 50+ files. The full suite reports 54 passing tests; 7 UI-polish integration tests cover the added flows. No working features removed; changes improve copy consistency, role-aware personalisation, and backend-backed interactivity.

## Files Modified

### Backend (5 files created/changed)

| File | Change |
|------|--------|
| `backend/app/routes/auth.py` | Added `GET /me` and `GET /csrf-token` endpoints for session identity + CSRF token issuance for fetch/AJAX |
| `backend/app/services/search_service.py` | New role-aware search service: `search_students`, `search_faculty`, `search_courses`, `search_departments` — all permission-scoped server-side |
| `backend/app/routes/dashboard.py` | Updated `GET /dashboard/search` to pass `role` and `current_student_id`/`faculty_id` to `search_service.search_courses()` |
| `backend/app/repositories/feedback_repository.py` | New data-access layer for student feedback: `list_student_courses`, `list_faculty_for_subject`, `get_enrolment`, `find_feedback`, `insert_feedback` |
| `backend/app/services/feedback_service.py` | Business logic: `submit_feedback()` validates student role, enrolment, semester match, faculty assignment, duplicate prevention before persisting |
| `backend/app/routes/feedback.py` | New blueprint: `GET /feedback/courses`, `GET /feedback/faculty`, `POST /feedback` |
| `backend/app/__init__.py` | Registered `feedback_bp` blueprint alongside existing auth/dashboard/health/prototype/students |

### Frontend (25+ files)

| File | Change |
|------|--------|
| `frontend/static/js/app-shell.js` | Added greeting engine (`GREETING_SELECTORS`, `updateGreetings`, `applySessionUser`, `initGreeting` → fetch `/auth/me`), server-backed search with `[data-dashboard-search]` submit handler, loading/is-loading/is-error/is-empty states |
| `frontend/static/js/dashboard.js` | Added `submitFeedback`, `initFeedbackForms`, `initFeedbackPage` — course list from `/feedback/courses`, faculty from `/feedback/faculty`, server-validated POST to `/feedback` |
| `frontend/dashboard/student/feedback.html` | Replaced inert `data-demo-form`/`data-demo-message`/`Preview only` form with real `id="fb-form" data-feedback-form`; dynamic course/faculty/term selects loaded from server |
| `frontend/static/css/components.css` | Added search results panel styles (`.nx-search-results`, `.nx-search-results__head`, `.nx-search-results__list`, `.nx-search-result`, loading/spinner, empty/error states) |
| 13 HTML page bodies | Added `data-search-type` attribute (`students`/`courses`/`faculty`/`departments`) for role-scoped client search init |
| 7 dashboard/page HTML files | Removed hardcoded generic greetings (`Good morning, Student.`, `Good morning, Dr. Anita Rao.`, `Good morning, Administrator.`); JS-personalized greeting (`updateGreetings`) is now the sole source |
| 30+ HTML/JS/CSS files | Copy cleanup: replaced `"Demo · "` → `"Preview · "`, `"Sample: "` → `"Update: "`, removed "Live Session · MySQL Connected" badges, updated notification/toast copy, removed "Preview records", "of sample", "Illustrative", "invented" where appeared as user-visible labels |
| Feedback form copy | Replaced `"No data leaves this page"` → `"Feedback is validated before storage"`; replaced `"This sample text is never sent."` → `"This text is never sent."` |

### Integration Tests (7 new)

| Test | Purpose |
|------|---------|
| `test_auth_me_returns_session_identity` | Verifies `/me` returns authenticated payload with `display_name`, `user_id`, `role` |
| `test_auth_me_rejects_anonymous_client` | Anonymous `/me` returns 401 |
| `test_csrf_token_endpoint_issues_token` | `/csrf-token` issues a real token via session |
| `test_dashboard_search_returns_matching_students_as_admin` | Server search returns students matching query for admin role |
| `test_dashboard_search_rejects_anonymous_client` | Unauthenticated `/dashboard/search` redirects to `/login` |
| `test_feedback_endpoints_reject_non_student_roles` | Non-student roles get 403 on `/feedback/courses` and `POST /feedback` |
| `test_dashboard_renders_personalized_greeting` | `/dashboard` HTML contains `"Signed in as"` and `"Good "` |

### Test Results
- Full suite: **54 passed** (`pytest -q`; latest run on 2026-11-17)
- New UI-polish tests: **7 tests included in the passing suite**
- No regressions; all behavioural tests continue to pass

## Key UX Improvements

| Area | Before | After |
|------|--------|-------|
| Personalized greeting | Hardcoded `"Good morning, Student."` / `"Good morning, Dr. Anita Rao."` / `"Good morning, Administrator."` | Time-aware greeting fetched from `GET /auth/me`, displays real name (e.g. `"Good morning, Tejas."`) |
| Dashboard search | Client-side filter of static sample rows only | Server-backed `GET /dashboard/search?q=&type=` scoped by role; returns real records from MySQL |
| Feedback form | Inert `data-demo-form` with `"Preview only"` badge and `"No data leaves this page"` callout | Live form with server validation; courses loaded from enrolled subjects; faculty loaded from subject assignments; toast feedback on submit |
| Search placeholders | `"Search demo records…"` / `"Search sample …"` | `"Search records…"` / `"Search …"` (role-aware via `data-search-type`) |
| Navigation badges | `"Live Session · MySQL Connected"` / `"Demo · "` / `"Preview only"` / `"Sample"` | `"GMU · MANAGEMENT SYSTEM"` / `"Preview · "` / `"Coming soon"` / role-appropriate summaries |
| Notifications / toast messages | Mixed "Preview only|", "Sample …", "of sample …", "Illustrative", "invented" copy | Consistent "Coming soon|", "Record\|", "Search", "Activity feed\|", role-aware messages |
| Page transitions / loading | No explicit states | Loading spinners, empty/error placeholders with clear copy |
| Footer | Generic `"GM University Management System"` | Updated across all pages to reflect live workspace status |
| Greeting consistency | Different greetings per page, hardcoded names | Unified `updateGreetings()` engine, only authored fallback text remains |

## Database Changes

| Change | Detail |
|--------|--------|
| Demo passwords | A shared-password reset was reported for existing demo accounts. The target environment was not independently confirmed. Do not reuse the shared password; rotate affected accounts locally before any demo. This report intentionally contains no password value. |
| Feedback table | New `feedback` table with unique constraint `(student_id, category, subject_id, semester_id)`; `category = 'course'` only |
| Search scoping | No schema changes; role-based permission enforcement entirely server-side via `role`, `current_student_id`, `faculty_id` query parameters |

## Known / Expected Behaviour

- Login allowed for `account_status` values `active` and `pending_reset`; `inactive` accounts are rejected
- Password reset token verified without consumption; consumed only after successful password update
- `/me` returns 401 for anonymous callers; JSON payload contains `authenticated`, `user_id`, `role`, `role_name`, `display_name`, `login_identifier`, `student_id`, `faculty_id`
- `/csrf-token` issues per-session token as JSON; must be sent as `X-CSRF-Token` header on POST requests
- Dashboard search for `type=students` from admin role returns all visible students; from student role returns only the student's own record
- Feedback submission requires: student role, valid enrolment, matching semester, assigned faculty, rating 1–5, consent checkbox
- Duplicate feedback per student/subject/semester is prevented
- Inactive / faculty / admin roles get 403 when attempting to submit or list course feedback

## Manual Inspection Pages

| Role | Page | URL (via server) |
|------|------|-----------------|
| Student | Dashboard | `/dashboard` (sign in with locally assigned credentials) |
| Student | Courses | `/dashboard?type=courses` |
| Student | Feedback | `/dashboard` → navigate to Feedback |
| Student | Profile | `/profile` |
| Faculty | Dashboard | `/dashboard` (logged in as faculty) |
| Faculty | Assigned Subjects | `/dashboard?type=courses` |
| Faculty | Attendance | `/attendance` |
| Admin | Dashboard | `/dashboard` (logged in as admin) |
| Admin | Students | `/students` |
| Admin | Faculty | `/faculty` |
| Admin | Reports | `/reports` |

## Verification

- **Full test suite**: `pytest -q` → **54 passed** (latest run on 2026-11-17)
- **New UI-polish tests**: 7 tests included in the full passing suite
- **JS syntax**: `node --check` on all `.js` files → **ALL OK**
- **Live server verification**: MySQL on 127.0.0.1:3307, Flask on 127.0.0.1:5000, health check OK, student login flow verified
- A bulk password reset was reported for demo accounts; the exact resulting credential state was not independently re-verified.
- This report intentionally omits all password values. Rotate the shared demo password before presenting or sharing the environment.
- **No fake records or placeholder statistics introduced** — all data-driven UI reflects real DB queries where applicable