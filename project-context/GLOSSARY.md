# GM University Management System — Glossary

> Beginner-friendly definitions of the technical words used in this project.
> Terms are grouped by area. Read the section you need.

---

## 1. Project and process terms

**DBMS (Database Management System)**
Software that stores, organizes, and retrieves data. MySQL is a DBMS.

**RDBMS (Relational Database Management System)**
A DBMS that stores data in tables with relationships. MySQL is an RDBMS.

**Schema**
The blueprint of the database: tables, columns, types, keys, and constraints.

**Migration**
A versioned SQL script that changes the schema. Migrations let you apply changes in order and repeat them safely.

**Seed data**
Fake sample data used to populate the database for development and demos.

**CRUD**
Create, Read, Update, Delete — the four basic data operations.

**Three-tier architecture**
A design with three layers: presentation (browser), application (Flask), and data (MySQL).

**ADR (Architecture Decision Record)**
A short document that records a decision, the options considered, and why the choice was made.

**Scope creep**
Slowly adding features that were not planned, which makes the project harder to finish.

**Viva**
An oral examination where you explain and defend your project.

**Traceability**
The ability to connect a requirement to the module that implements it, the stage where it is built, and the test that verifies it.

---

## 2. Database terms

**Table**
A grid of rows and columns that stores one kind of record (for example, students).

**Row / Record**
One entry in a table (one student).

**Column / Field**
One attribute of a record (for example, `full_name`).

**Primary key (PK)**
A column or combination of columns that uniquely identifies each row. No duplicates, no nulls.

**Foreign key (FK)**
A column that points to a primary key in another table. It creates a relationship and enforces integrity.

**Constraint**
A rule the database enforces, such as `NOT NULL`, `UNIQUE`, `CHECK`, or a foreign key.

**Referential integrity**
The guarantee that a foreign key always points to an existing row.

**Index**
A data structure that speeds up lookups on a column. Indexes make reads faster but writes slightly slower.

**Normalization**
Organizing tables to reduce duplication and update errors. The project targets **3NF**.

**1NF (First Normal Form)**
Each column holds a single value, and each row is unique.

**2NF (Second Normal Form)**
1NF plus every non-key column depends on the whole primary key, not part of it.

**3NF (Third Normal Form)**
2NF plus no non-key column depends on another non-key column. This removes transitive dependencies.

**Denormalization**
Deliberately adding redundancy for performance. Not planned for the baseline.

**ER diagram (Entity–Relationship diagram)**
A picture of entities, their attributes, and how they relate.

**Cardinality**
How many rows on one side of a relationship can match rows on the other side (one-to-one, one-to-many, many-to-many).

**Junction table / Associative entity**
A table that connects two tables in a many-to-many relationship (for example, `enrolments`).

**View**
A saved query that behaves like a read-only table. Useful for reports.

**Stored procedure**
A named block of SQL stored in the database and called by name.

**Trigger**
SQL that runs automatically when a row is inserted, updated, or deleted.

**Transaction**
A group of database operations that succeed or fail together.

**COMMIT**
Permanently saves a transaction.

**ROLLBACK**
Undoes a transaction.

**SAVEPOINT**
A marker inside a transaction that you can roll back to without undoing the whole transaction.

**DDL (Data Definition Language)**
SQL that defines structure: `CREATE`, `ALTER`, `DROP`.

**DML (Data Manipulation Language)**
SQL that changes data: `INSERT`, `UPDATE`, `DELETE`.

**DQL (Data Query Language)**
SQL that reads data: `SELECT`.

**DCL (Data Control Language)**
SQL that controls access: `GRANT`, `REVOKE`.

**TCL (Transaction Control Language)**
SQL that controls transactions: `COMMIT`, `ROLLBACK`, `SAVEPOINT`.

**Join**
Combining rows from two or more tables based on a related column.

**Subquery**
A query inside another query.

**Aggregate function**
A function that summarizes many rows: `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`.

**InnoDB**
MySQL's default storage engine. It supports transactions and foreign keys.

**`utf8mb4`**
A character set that supports all Unicode characters, including emoji.

**Least privilege**
Giving a user only the permissions they need, and no more.

---

## 3. Backend terms

**Flask**
A small Python web framework.

**Route**
A URL pattern mapped to a Python function.

**Blueprint**
A way to group related routes in Flask.

**Application factory**
A function (`create_app()`) that builds and configures the Flask app. It makes testing easier.

**Controller / route handler**
The function that receives a request and returns a response.

**Service**
A function or class that contains business rules.

**Repository**
A module that contains database queries for one area.

**Validation**
Checking that input is correct and safe before using it.

**Authentication**
Proving who the user is (login).

**Authorization**
Checking what an authenticated user is allowed to do (roles and permissions).

**Session**
Server-side state that remembers a logged-in user across requests.

**CSRF (Cross-Site Request Forgery)**
An attack that tricks a logged-in user into submitting an unwanted request. CSRF tokens prevent it.

**XSS (Cross-Site Scripting)**
An attack that injects malicious script into a page. Output escaping prevents it.

**SQL injection**
An attack that inserts SQL through user input. Parameterized queries prevent it.

**Parameterized query**
A query with placeholders for values, so the database treats input as data, not code.

**Hash**
A one-way transformation of a value. Passwords are stored as hashes so the original cannot be recovered.

**Environment variable**
A value supplied by the operating system or a `.env` file, used for configuration and secrets.

**`.env` file**
A local file that holds environment variables. It is ignored by Git.

**REST / JSON**
A common way for the frontend to exchange data with the backend.

**HTTP status code**
A number that describes the result: `200` OK, `400` bad request, `401` unauthenticated, `403` forbidden, `404` not found, `500` server error.

---

## 4. Frontend terms

**HTML**
The structure of a web page.

**CSS**
The styling of a web page.

**JavaScript**
The behaviour of a web page.

**Bootstrap 5**
A CSS framework with ready-made layout and components.

**Chart.js**
A JavaScript library for charts.

**Jinja2**
Flask's template engine. It lets you insert data into HTML safely.

**Autoescaping**
Jinja2's default behaviour of escaping HTML in variables to prevent XSS.

**Responsive design**
Design that adapts to different screen sizes.

**Design token**
A named value for colour, spacing, type, or radius, used consistently across the UI.

**Light / dark theme**
Two colour schemes that the user can switch between.

**WCAG 2.1 AA**
A widely used accessibility standard. AA is the target level for this project.

**Contrast ratio**
A measure of how readable text is against its background. AA requires 4.5:1 for normal text.

**`prefers-reduced-motion`**
A browser setting that tells the site to reduce animation for users who need it.

**`prefers-color-scheme`**
A browser setting that tells the site whether the user prefers light or dark.

---

## 5. Tooling terms

**VS Code**
Visual Studio Code, the code editor used for this project.

**Agent Mode**
A VS Code AI mode where the assistant can read, edit, and run things in the workspace, with your approval.

**Instruction file**
A Markdown file that tells the AI how to behave in the workspace.

**Skill**
A reusable instruction file for a specific kind of task.

**Prompt file**
A reusable prompt that can be attached to a chat.

**Git**
A version control system that records changes to files.

**Commit**
A saved snapshot of changes in Git.

**Branch**
A separate line of development in Git.

**Checkpoint**
A commit or tag you can return to if something goes wrong.

**`.gitignore`**
A file that tells Git which files and folders not to track.

**Terminal**
The command-line window inside VS Code where you run commands.

---

## 6. Project-specific terms

**GM University Management System**
The name of this project. Short display name: GMU Management System.

**Official logo**
The GM University logo downloaded from the official website and stored at `frontend/static/img/branding/gmu-official-logo.jpg`. It must never be altered.

**University Gold**
The accent colour `#E3B559`, published by GM University. Used sparingly.

**University Maroon, Warm Ivory, Graphite, Muted Grey**
The core colours in the GM University Management System palette, derived from the official logo. Obsidian and Silver remain neutral support colours.

**Module**
A functional area of the system, such as Students or Attendance.

**Stage**
A phase in the roadmap. Stages are completed in order.

**Stage gate**
The checklist that must pass before the next stage starts.
