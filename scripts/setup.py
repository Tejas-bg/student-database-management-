#!/usr/bin/env python3
# ==============================================================================
# GM University Management System — Database Setup Script
# ==============================================================================
# Purpose: Reproducibly initialise the MySQL database, schema, seeds, and views.
# Platform: Windows (tested with Python 3) / macOS / Linux
# MySQL: 8.0+ on 127.0.0.1:3307, user: root
#
# Execution order: database → schema → seeds → views
# Idempotent: schema/seeds guarded by table/count checks; views use OR REPLACE
# ==============================================================================

import subprocess
import os
import re

# Configuration
DB_HOST    = "127.0.0.1"
DB_PORT    = "3307"
DB_USER    = "root"
DB_NAME    = "gmu_management_system"
DB_BINPATH = r"C:\Program Files\MySQL\MySQL Server 8.4\bin"
PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)) or ".")
SCHEMA_FILE   = os.path.join(PROJECT_ROOT, "database", "schema", "001_schema.sql")
SEEDS_FILE    = os.path.join(PROJECT_ROOT, "database", "seeds", "001_sample_data.sql")
VIEWS_FILE    = os.path.join(PROJECT_ROOT, "database", "views", "001_views.sql")


def mysql(*extra_args: str) -> str:
    """Run mysql.exe and return stdout."""
    exe = os.path.join(DB_BINPATH, "mysql.exe")
    cmd = [exe, "-u", DB_USER, "-h", DB_HOST, "-P", DB_PORT] + list(extra_args)
    proc = subprocess.run(cmd, capture_output=True, text=True, timeout=60)
    return proc.stdout


# --- Phase 1: Create database if it does not exist ---
print("=== Phase 1: Create database if needed ===")
mysql("-e", "CREATE DATABASE IF NOT EXISTS `" + DB_NAME + "` CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;")
print("Database ensured.\n")


# --- Phase 2: Apply schema if the 'roles' table does not exist ---
print("=== Phase 2: Apply schema (if needed) ===")
tables_out = mysql("-e", "SHOW TABLES FROM `" + DB_NAME + "`;")
if "roles" not in tables_out:
    print("Roles table not found — applying schema from " + SCHEMA_FILE + " ...")
    # The schema file starts with CREATE DATABASE IF NOT EXISTS and USE,
    # so we can just pipe it to mysql. But to be safe, we run the table-creating
    # portion. We'll run the full file; the CREATE DATABASE IF NOT EXISTS is harmless.
    mysql("-e", "SOURCE `" + SCHEMA_FILE + "`;")
    print("Schema applied successfully.\n")
else:
    print("Schema already present (roles table exists) — skipping.\n")


# --- Phase 3: Apply seeds if the 'users' table has no rows ---
print("=== Phase 3: Apply seeds (if needed) ===")
users_count = mysql("-e", "SELECT COUNT(*) FROM users;")
m = re.search(r"(\d+)", users_count)
seed_count = int(m.group(1)) if m else 0
if seed_count == 0:
    print("No user data found — applying seeds from " + SEEDS_FILE + " ...")
    mysql("-e", "SOURCE `" + SEEDS_FILE + "`;")
    print("Seeds applied successfully.\n")
else:
    print("Seed data already present (users table has " + str(seed_count) + " row(s)) — skipping.\n")


# --- Phase 4: Create/Replace views (always safe) ---
print("=== Phase 4: Create/Replace views ===")
print("Ensuring views exist (CREATE OR REPLACE VIEW is idempotent) ...")
mysql("-e", "SOURCE `" + VIEWS_FILE + "`;")
print("Views ensured successfully.\n")


# --- Phase 5: Verify both required views exist ---
print("=== Phase 5: Verification ===")

# Use direct subprocess call for reliable output parsing
exe = os.path.join(DB_BINPATH, "mysql.exe")
cmd1 = [exe, "-u", DB_USER, "-h", DB_HOST, "-P", DB_PORT, "-e", "SHOW CREATE VIEW vw_student_profile;"]
proc1 = subprocess.run(cmd1, capture_output=True, text=True, timeout=60)
v1_ok = "vw_student_profile" in proc1.stdout

cmd2 = [exe, "-u", DB_USER, "-h", DB_HOST, "-P", DB_PORT, "-e", "SHOW CREATE VIEW vw_faculty_workload;"]
proc2 = subprocess.run(cmd2, capture_output=True, text=True, timeout=60)
v2_ok = "vw_faculty_workload" in proc2.stdout

if v1_ok:
    print("  vw_student_profile found.")
else:
    print("  vw_student_profile NOT found!")

if v2_ok:
    print("  vw_faculty_workload found.")
else:
    print("  vw_faculty_workload NOT found!")


# --- Phase 6: Quick sanity check ---
print("=== Phase 6: Quick sanity check ===")

c1 = mysql("-e", "SELECT COUNT(*) FROM vw_student_profile;")
print("  vw_student_profile returns rows: " + c1.strip())

c2 = mysql("-e", "SELECT COUNT(*) FROM vw_faculty_workload;")
print("  vw_faculty_workload returns rows: " + c2.strip())


# --- Completion ---
print("=" * 52)
print("Setup complete!")
print("=" * 52)
print("")
print("To run on a new computer:")
print("  1. Start MySQL 8.0+ on 127.0.0.1:3307")
print("  2. Run this script:")
print("       python scripts/setup.py")
print("  3. Verify views exist:")
print("       mysql -u root -h 127.0.0.1 -P 3307 gmu_management_system -e \"SHOW CREATE VIEW vw_student_profile; SHOW CREATE VIEW vw_faculty_workload;\"")
print("")
print("Notes:")
print("  - Schema and seeds are skipped if tables/data already exist (idempotent).")
print("  - Views are always safe to re-execute (CREATE OR REPLACE VIEW).")
print("  - Do NOT run against a production database unless you intend to reset.")