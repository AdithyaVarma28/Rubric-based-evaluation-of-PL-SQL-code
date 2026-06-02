# Bank Evaluation Schema

## Schema Validation
- Status: PASS

## Generated DDL
```sql
CREATE TABLE CUSTOMER (
    cno NUMBER NOT NULL,
    cname VARCHAR2(100) NOT NULL,
    c_type VARCHAR2(10) NOT NULL,
    PRIMARY KEY (cno)
);

CREATE TABLE BRANCHES (
    br_no NUMBER NOT NULL,
    br_name VARCHAR2(100) NOT NULL,
    loc VARCHAR2(80) NOT NULL,
    PRIMARY KEY (br_no)
);

CREATE TABLE ACCOUNTS (
    ac_no NUMBER NOT NULL,
    br_no NUMBER NOT NULL,
    cust_no NUMBER NOT NULL,
    ac_type VARCHAR2(30) NOT NULL,
    bal NUMBER(10,2) NOT NULL,
    PRIMARY KEY (ac_no),
    CONSTRAINT chk_positive_balance CHECK (bal >= 0)
);

ALTER TABLE ACCOUNTS
ADD CONSTRAINT fk_accounts_branches
FOREIGN KEY (br_no)
REFERENCES BRANCHES (br_no);

ALTER TABLE ACCOUNTS
ADD CONSTRAINT fk_accounts_customer
FOREIGN KEY (cust_no)
REFERENCES CUSTOMER (cno);
```

## Retrieved Mutations
- MUT-N002: Close Branch Orphan Accounts (transaction)
- MUT-037: Column Reference Mutation (sql)
- MUT-003: Anchor-Type Narrowing (declaration)
- MUT-007: Default Parameter Change (parameter)

## Test Cases
- normal_customer: Normal data load for CUSTOMER [normal]
- normal_branches: Normal data load for BRANCHES [normal]
- normal_accounts: Normal data load for ACCOUNTS [normal]
- boundary_zero_customer: Zero boundary for CUSTOMER.cno [boundary]
- negative_null_customer: NULL rejection for CUSTOMER.cno [negative]
- boundary_zero_branches: Zero boundary for BRANCHES.br_no [boundary]
- negative_null_branches: NULL rejection for BRANCHES.br_no [negative]
- boundary_zero_accounts: Zero boundary for ACCOUNTS.ac_no [boundary]
- negative_null_accounts: NULL rejection for ACCOUNTS.ac_no [negative]
- boundary_empty_state: Empty table state [boundary]
- mutation_01: Close Branch Orphan Accounts [mutation]
- mutation_02: Column Reference Mutation [mutation]

## Rubric Score
- Total: 42.75/100.0
- normal_cases: 8.75
- boundary_cases: 7.0
- mutation_cases: 7.0
- procedural_logic: 20.0

## Feedback
- normal_cases: execution was skipped, so a conservative partial score was assigned.
- boundary_cases: execution was skipped, so a conservative partial score was assigned.
- mutation_cases: execution was skipped, so a conservative partial score was assigned.