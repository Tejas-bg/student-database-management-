#!/usr/bin/env pwsh
# ==============================================================================
# GM University Management System — Database Setup Script
# ==============================================================================
# Purpose: Reproducibly initialise the MySQL database, schema, seeds, and views.
# Execution order: database → schema → seeds → views
# Idempotent: schema/seeds guarded by table checks; views use OR REPLACE
# ==============================================================================

# Configuration (keep in sync with .env)
$DbHost   = "127.0.0.1"
$DbPort   = "3307"
$DbUser   = "root"
$DbName   = "gmu_management_system"
$BaseDir  = "C:\Users\tejas\Documents\NEXUS"

# Helper: run a mysql command via cmd.exe (single-quoted arg so < is literal for cmd redirection)
function Run-Mysql {
    param([string]$Sql)
    & cmd /c 'mysql -u ' + $DbUser + ' -h ' + $DbHost + ' -P ' + $DbPort + ' ' + $DbName + ' -e "' + $Sql + '"'
}

# Helper: run a SQL file via mysql CLI redirection
function Run-MysqlFile {
    param([string]$FilePath)
    & cmd /c 'mysql -u ' + $DbUser + ' -h ' + $DbHost + ' -P ' + $DbPort + ' ' + $DbName + ' < "' + $FilePath + '"'
}

# --- Phase 1: Create database if it does not exist ---
Write-Host "=== Phase 1: Create database if needed ==="
$sd1 = "CREATE DATABASE IF NOT EXISTS `" + $DbName + "` CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;"
Run-Mysql -Sql $sd1
Write-Host "Database ensured.`n"

# --- Phase 2: Apply schema if the 'roles' table does not exist ---
Write-Host "=== Phase 2: Apply schema (if needed) ==="
$tables = Run-Mysql -Sql "SHOW TABLES FROM `" + $DbName + "`;"
if $tables -notmatch "roles" {
    Write-Host "Roles table not found — applying schema from " + $BaseDir + "\database\schema\001_schema.sql ...`n"
    Run-MysqlFile -FilePath $BaseDir "\database\schema\001_schema.sql"
    Write-Host "Schema applied successfully.`n" -ForegroundColor Green
} else {
    Write-Host "Schema already present (roles table exists) — skipping.`n" -ForegroundColor Yellow
}

# --- Phase 3: Apply seeds if the 'users' table has no rows ---
Write-Host "=== Phase 3: Apply seeds (if needed) ==="
$users = Run-Mysql -Sql "SELECT COUNT(*) FROM users;"
$uc = [int]($users -replace "\D+", "")
if $uc -eq 0 {
    Write-Host "No user data found — applying seeds from " + $BaseDir + "\database\seeds\001_sample_data.sql ...`n"
    Run-MysqlFile -FilePath $BaseDir "\database\seeds\001_sample_data.sql"
    Write-Host "Seeds applied successfully.`n" -ForegroundColor Green
} else {
    Write-Host "Seed data already present (users table has " + $uc + " row(s)) — skipping.`n" -ForegroundColor Yellow
}

# --- Phase 4: Create/Replace views (always safe) ---
Write-Host "=== Phase 4: Create/Replace views ==="
Write-Host "Ensuring views exist (CREATE OR REPLACE VIEW is idempotent) ...`n"
Run-MysqlFile -FilePath $BaseDir "\database\views\001_views.sql"
Write-Host "Views ensured successfully.`n" -ForegroundColor Green

# --- Phase 5: Verify both required views exist ---
Write-Host "=== Phase 5: Verification ==="

Write-Host "Verifying vw_student_profile exists:" -ForegroundColor Gray
$v1 = Run-Mysql -Sql "SHOW CREATE VIEW vw_student_profile;"
if $v1 -match "vw_student_profile" {
    Write-Host "  ```v``` ```v``` ``` ✓ vw_student_profile found.`n" -ForegroundColor Green
} else {
    Write-Error "  ```v``` ```v``` ``` ✗ vw_student_profile NOT found!"
}

Write-Host "Verifying vw_faculty_workload exists:" -ForegroundColor Gray
$v2 = Run-Mysql -Sql "SHOW CREATE VIEW vw_faculty_workload;"
if $v2 -match "vw_faculty_workload" {
    Write-Host "  ```v``` ```v``` ``` ✓ vw_faculty_workload found.`n" -ForegroundColor Green
} else {
    Write-Error "  ```v``` ```v``` ``` ✗ vw_faculty_workload NOT found!"
}

# --- Phase 6: Quick sanity check ---
Write-Host "=== Phase 6: Quick sanity check ==="
$sv = Run-Mysql -Sql "SELECT COUNT(*) FROM vw_student_profile;"
Write-Host "  vw_student_profile returns rows: $sv"

$fv = Run-Mysql -Sql "SELECT COUNT(*) FROM vw_faculty_workload;"
Write-Host "  vw_faculty_workload returns rows: $fv"

# --- Completion ---
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Setup complete!" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "To run on a new computer:" -ForegroundColor Yellow
Write-Host "  1. Start MySQL 8.0+ on 127.0.0.1:3307" -ForegroundColor Gray
Write-Host "  2. Run this script:" -ForegroundColor Gray
Write-Host "       pwsh .\scripts\setup.ps1" -ForegroundColor Gray
Write-Host "  3. Verify views exist:" -ForegroundColor Gray
Write-Host "       mysql -u root -h 127.0.0.1 -P 3307 gmu_management_system -e "SHOW CREATE VIEW vw_student_profile; SHOW CREATE VIEW vw_faculty_workload;"" -ForegroundColor Gray
Write-Host ""
Write-Host "Notes:" -ForegroundColor Yellow
Write-Host "  - Schema and seeds are skipped if tables/data already exist (idempotent)." -ForegroundColor Gray
Write-Host "  - Views are always safe to re-execute (CREATE OR REPLACE VIEW)." -ForegroundColor Gray
Write-Host "  - Do NOT run against a production database unless you intend to reset." -ForegroundColor Gray