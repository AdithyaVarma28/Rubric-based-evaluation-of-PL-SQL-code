create table Emp(eno int, ename varchar, sal numeric(7,2));
create table EMP_PROJ(eno int, pno int, prjt_hrs int,primary key(eno,pno));
--2(a)
CREATE OR REPLACE FUNCTION ProjectLoad(p_eno NUMBER)
RETURN NUMBER
IS
    total_hrs NUMBER;
BEGIN
    SELECT NVL(SUM(prjt_hrs),0)
    INTO total_hrs
    FROM EMP_PROJ
    WHERE eno = p_eno;

    RETURN total_hrs;
END;
/
--2(c)
DECLARE
    avg_sal NUMBER;
BEGIN
    SELECT AVG(sal) INTO avg_sal FROM Emp;

    UPDATE Emp
    SET sal = sal + (avg_sal - sal)
    WHERE sal < avg_sal;

    DBMS_OUTPUT.PUT_LINE('Salary updated for employees earning less than average');
END;
/
--3
create table Item(ino int primary key, iname varchar, unit_price numeric(6,2));
create table Transaction(tr_no int ,ino int,qty int,primary key(tr_no,ino));

CREATE OR REPLACE FUNCTION DeleteIfLowTransactions(p_ino NUMBER)
RETURN VARCHAR2
IS
    tran_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO tran_count
    FROM Transaction
    WHERE ino = p_ino;

    IF tran_count < 2 THEN
        DELETE FROM Item WHERE ino = p_ino;
        RETURN 'Item deleted – transaction count < 2';
    ELSE
        RETURN 'Item NOT deleted – at least 2 transactions exist';
    END IF;
END;
/
--4
create table ACCOUNTS(ac_no int primary key,br_no int references BRANCHES(br_no), cust_no int references CUSTOMER(cno),ac_type varchar,bal numeric(6,2));
create table BRANCHES(br_no int primary key, br_name varchar,loc varchar);
create table CUSTOMER(cno int primary key,cname varchar, c_type varchar);
--a
CREATE OR REPLACE FUNCTION UpdateCustomerClass(p_threshold NUMBER, p_cust_no NUMBER)
RETURN VARCHAR2
IS
    total_bal NUMBER;
BEGIN
    SELECT NVL(SUM(bal),0)
    INTO total_bal
    FROM ACCOUNTS
    WHERE cust_no = p_cust_no;

    IF total_bal > p_threshold THEN
        UPDATE CUSTOMER
        SET c_type = 'A'
        WHERE cno = p_cust_no;
        RETURN 'Customer class updated to A';
    ELSE
        UPDATE CUSTOMER
        SET c_type = 'B'
        WHERE cno = p_cust_no;
        RETURN 'Customer class updated to B';
    END IF;
END;
/

--b
CREATE OR REPLACE FUNCTION CloseBranch(p_old NUMBER, p_new NUMBER)
RETURN VARCHAR2
IS
BEGIN
    -- Transfer all accounts
    UPDATE ACCOUNTS
    SET br_no = p_new
    WHERE br_no = p_old;

    -- Delete old branch
    DELETE FROM BRANCHES
    WHERE br_no = p_old;

    RETURN 'Branch closed and accounts transferred.';
END;
/
--c
CREATE OR REPLACE FUNCTION SafeWithdraw(p_ac_no NUMBER, p_amount NUMBER)
RETURN VARCHAR2
IS
    curr_bal NUMBER;
BEGIN
    SELECT bal INTO curr_bal FROM ACCOUNTS WHERE ac_no = p_ac_no;

    IF curr_bal >= p_amount THEN
        UPDATE ACCOUNTS
        SET bal = bal - p_amount
        WHERE ac_no = p_ac_no;

        RETURN 'Withdrawal successful.';
    ELSE
        RETURN 'Insufficient funds. Withdrawal denied.';
    END IF;
END;
/






