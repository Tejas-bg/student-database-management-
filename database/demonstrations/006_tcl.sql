-- GM University Management System
-- Stage 3: TCL / transaction demonstration (DESIGN ONLY - NOT EXECUTED)
-- COMMIT, ROLLBACK, SAVEPOINT examples using fictional data.

USE gmu_management_system;

-- ---------------------------------------------------------------------------
-- A. Successful transaction with COMMIT
-- ---------------------------------------------------------------------------
START TRANSACTION;

INSERT INTO fee_payments
  (student_id, fee_structure_id, amount_paid, payment_date, payment_mode,
   transaction_ref, receipt_no, payment_status, remarks)
VALUES
  (1, 3, 1500.00, '2026-03-20', 'upi', 'TXN-DEMO-COMMIT-001', 'RCPT-DEMO-0001',
   'success', 'Demo transaction - committed');

COMMIT;

-- ---------------------------------------------------------------------------
-- B. Failed transaction with ROLLBACK
-- ---------------------------------------------------------------------------
START TRANSACTION;

INSERT INTO fee_payments
  (student_id, fee_structure_id, amount_paid, payment_date, payment_mode,
   transaction_ref, receipt_no, payment_status, remarks)
VALUES
  (2, 3, 1500.00, '2026-03-20', 'upi', 'TXN-DEMO-ROLLBACK-001', 'RCPT-DEMO-0002',
   'pending', 'Demo transaction - will be rolled back');

-- Simulate a validation failure or downstream error
ROLLBACK;

-- ---------------------------------------------------------------------------
-- C. SAVEPOINT and partial rollback (bulk marks entry)
-- ---------------------------------------------------------------------------
START TRANSACTION;

INSERT INTO internal_marks (assessment_id, enrolment_id, marks_obtained, remarks, entered_by_user_id)
VALUES (1, 1, 24.00, 'Demo savepoint row 1', 2);

SAVEPOINT after_first_mark;

INSERT INTO internal_marks (assessment_id, enrolment_id, marks_obtained, remarks, entered_by_user_id)
VALUES (1, 5, 20.00, 'Demo savepoint row 2', 2);

-- Suppose the second row fails validation; undo only that row
ROLLBACK TO SAVEPOINT after_first_mark;

-- Keep the first row and commit the transaction
COMMIT;

-- ---------------------------------------------------------------------------
-- D. Transaction with a guarded update and error handling outline
-- ---------------------------------------------------------------------------
START TRANSACTION;

UPDATE fee_payments
SET payment_status = 'refunded',
    remarks = 'Demo refund (fictional)'
WHERE receipt_no = 'RCPT-2026-0002'
  AND payment_status = 'success';

-- Check affected rows in the application layer. If zero rows changed,
-- the application would ROLLBACK instead of COMMIT.
COMMIT;

-- ---------------------------------------------------------------------------
-- E. Read-committed / isolation demonstration outline (optional)
-- ---------------------------------------------------------------------------
-- SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- START TRANSACTION;
-- SELECT ... FOR UPDATE;  -- row-level lock during payment processing
-- COMMIT;

-- Note: MySQL DDL statements cause implicit commits; keep DDL out of
-- application transactions.
