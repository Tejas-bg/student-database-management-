# GMU Login — Design Specification

> **Status:** Stage 1 design preview. The page exists and is responsive; authentication is **not** implemented.
> **Files:** `frontend/login.html`, `frontend/static/css/login.css`, `frontend/static/js/login.js`.
> **Related:** `GMU_BRAND_GUIDELINES.md`, `VISUAL_IDENTITY.md`.

---

## 1. Purpose

One common sign-in page for every type of user:

- Students
- Faculty
- Administrators

There is **no** role selector, no user-type dropdown, and no separate role cards. The user enters an identifier and password. The backend will later determine the role from the registered MySQL account.

---

## 2. What the preview does and does not do

### Implemented in the preview

- Branded split-screen layout using the official logo.
- University Login ID field with a hint about accepted identifier types.
- Password field with show/hide control.
- Empty-field validation with per-field messages and an error summary.
- Loading state on the Sign In button.
- Honest “preview only” status after submission.
- Forgot-password dialog explaining that recovery is a future feature.
- Responsive desktop, tablet, and mobile layouts.
- Reduced-motion support.
- Visible keyboard focus and a skip link.

### Deliberately not implemented

- Real authentication.
- MySQL connection or account lookup.
- Password hashing or storage.
- Sessions or cookies.
- Password reset.
- Any fake successful login, fake user, or redirect.
- “Remember me” — omitted because secure token handling does not exist yet.

The Sign In button never pretends to sign anyone in. It validates, shows a brief loading animation, then displays a preview message.

---

## 3. Layout

### Desktop (≥ 861px)

A two-column split screen:

**Left — brand panel (maroon)**

- Dotted gold texture, masked toward the top-right.
- Two thin gold concentric rings, partially off-canvas.
- Official logo at 96px, with a two-line institution label.
- Gold eyebrow: “One university · One sign-in”.
- Welcome heading: **Welcome to GM University**.
- Supporting line: **Your academic journey, connected in one place.**
- Footer: system name and tagline.
- A thin gold rule separates the copy from the footer.

**Right — sign-in panel (warm ivory)**

- Preview badge and a link to the design reference.
- Eyebrow and heading: **Sign in to your account**.
- Supporting line explaining automatic role detection.
- Gold information alert stating that authentication is not connected.
- Error summary (hidden until validation fails).
- Login ID field, password field with toggle, forgot-password link, Sign In button.
- Security note.
- Independence disclaimer and version label.

The form column is capped at 560px and vertically centred, so it remains the most prominent interactive element.

On desktop the shell is exactly one viewport tall. The maroon brand panel stays fixed in place, and the sign-in panel is the only vertical scroll container (`overflow-y: auto`, `overscroll-behavior: contain`). The sign-in panel is focusable (`tabindex="0"`), so the mouse wheel, touchpad, Page Up, Page Down, Home, and End scroll it even before an input receives focus. The page behind it does not scroll, so the layout never produces a second, nested scrollbar.

### Tablet (≤ 1100px)

The split remains, but padding and heading sizes reduce. Gold rings shrink so they never crowd the copy.

### Mobile (≤ 860px)

- Single column.
- Brand panel becomes a compact header: logo, institution, welcome copy, tagline.
- The desktop fixed-panel behaviour is disabled: the page itself scrolls normally and the sign-in panel uses `overflow: visible`.
- Form panel follows immediately.
- No horizontal overflow.
- At ≤ 480px the logo drops to 56px, labels and forgot-password stack, and inputs stay at least 52px tall.

---

## 4. Colour and surface

| Element | Value |
|---|---|
| Brand panel | University Maroon `#5B2020` |
| Brand text | Warm Ivory `#F8F6F0` |
| Accent rule, eyebrow, focus halo | University Gold `#E3B559` |
| Form background | Warm Ivory `#F8F6F0` |
| Input surface | White `#FFFFFF` |
| Primary text | Graphite `#242424` |
| Secondary text | `#5C5C5C` |
| Input border | `#CFC8BC` |
| Error | `#B42318` on `#FDECEA` |
| Submit button | Gold `#E3B559` with Deep Maroon `#421919` text |

The submit button uses gold because it is the single most important action and maroon already dominates the left panel. Gold on maroon text passes 7.96:1.

---

## 5. Typography

| Element | Style |
|---|---|
| Welcome heading | Inter 600, `clamp(2.6rem, 4.7vw, 4.5rem)`, line-height 0.98, tracking −0.04em |
| Panel heading | Inter 600, `clamp(1.8rem, 2.4vw, 2.15rem)` |
| Body | Inter 400, 0.9375rem–1.125rem, line-height 1.6 |
| Eyebrow | JetBrains Mono 500, 0.6875rem, uppercase, 0.14em tracking |
| Labels | Inter 600, 0.8125rem |
| Hints | Inter 400, 0.75rem |

---

## 6. Interaction rules

### Password visibility

- Button has `aria-pressed` and an accessible label that switches between “Show password” and “Hide password”.
- Icons swap; the caret stays at the end of the value.
- The value is never logged or stored.

### Validation

- Triggered on submit, not while typing.
- Both fields are checked for empty values.
- Each invalid field receives `aria-invalid="true"` and a visible message linked by `aria-describedby`.
- An error summary appears above the form and focus moves to the first invalid field.
- Messages clear as soon as the user edits the field.

### Loading

- The button is disabled, `aria-busy="true"`, label changes to “Checking fields…”, and a spinner appears.
- Duration is a short demonstration pause (about 900ms).
- It then returns to normal and shows a preview-only status message.

### Forgot password

- Opens a native `<dialog>` with a clear explanation.
- Backdrop click and the Close button dismiss it.
- Focus returns to the trigger button when it closes.
- Browsers without `<dialog>` support receive an honest fallback message instead.

### Keyboard

- Skip link is the first focusable element.
- Logical tab order follows the visual order.
- Focus is always visible: 4px gold halo plus a maroon border (the scrollable panel shows an inset maroon outline).
- The sign-in panel is focusable, so Page Up, Page Down, Home, and End scroll it.
- No keyboard trap.

### Motion

- Two short entrance animations (opacity + 10px rise).
- Spinner rotates only while loading.
- `prefers-reduced-motion: reduce` removes entrance animation and hover translation.

---

## 7. Accessibility

- Target: WCAG 2.1 AA.
- Landmarks: `<main>` with two labelled `<section>` elements.
- One `<h1>` (welcome) and one `<h2>` (form heading).
- All inputs have visible labels and hints.
- The error region uses `role="alert"`; the status region uses `role="status"` with `aria-live="polite"`.
- Decorative patterns and icons are `aria-hidden="true"`.
- The login page does not rely on colour alone for validation.
- Contrast pairs are documented in `GMU_BRAND_GUIDELINES.md`.

---

## 8. Future authentication flow (not built)

When Stage 4 begins, the flow will be:

1. User submits the **single** common form.
2. Flask validates the input.
3. The backend looks up the account in MySQL by the approved identifier.
4. The backend verifies the stored password hash.
5. The backend reads the account's registered role.
6. A secure server-side session is created.
7. The response redirects by role:

| Role | Destination |
|---|---|
| Student | `/student/dashboard` |
| Faculty | `/faculty/dashboard` |
| Administrator | `/admin/dashboard` |

### Identifier policy (proposed, configurable)

| Role | Preferred identifier | Notes |
|---|---|---|
| Student | Student USN | Aadhaar only if university policy explicitly approves it |
| Faculty | Employee ID | Individual password |
| Administrator | Registered Gmail address | Individual secure password |

Rules:

- A username's **format must never be used to infer the role**.
- Role authorization must never run only in frontend JavaScript.
- Password reset must follow an approved university process before it is enabled.
- "Remember me" may only be added once secure, revocable token handling exists.

---

## 9. Responsive test checklist

- [ ] 1920 × 1080 and 1366 × 768 desktop: maroon brand panel stationary; sign-in panel scrolls independently when its content is taller than the viewport; mouse wheel and Page Up/Page Down/Home/End work; page itself does not scroll.
- [ ] 1024 × 768 tablet: reduced padding, no overlap.
- [ ] 768 × 1024 portrait: single column, brand header compact, whole page scrolls naturally.
- [ ] 390 × 844 and 375 × 812 mobile: logo 56px, inputs ≥ 52px, no horizontal scroll, brand panel not fixed.
- [ ] 320px width: labels wrap without clipping.
- [ ] 200% browser zoom: no clipping or overlap.
- [ ] Keyboard only: skip link, fields, toggle, forgot, submit, dialog.
- [ ] Reduced motion: no entrance animation, spinner still communicates loading.
- [ ] Console: no errors.

---

## 10. Content rules

- Never write “Signed in successfully” in the preview.
- Never show a fake name, fake dashboard, or fake role.
- Always explain that credentials are not sent.
- Keep the independence disclaimer visible on the page, not only in the README.
- If a feature is not built, say so plainly.
