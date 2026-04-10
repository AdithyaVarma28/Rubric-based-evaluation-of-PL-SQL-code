---class questions---------------------------------
-- Create tables
CREATE TABLE Dept1(
    dept_no INT PRIMARY KEY,
    dname VARCHAR(100)
);

CREATE TABLE EMP1(
    eno INT PRIMARY KEY,
    ename VARCHAR(100),
    sal NUMERIC(6,2),
    dno INT REFERENCES Dept1(dept_no)
);

-- Function 1: Accepts employee number and returns salary of that employee
CREATE OR REPLACE FUNCTION emp_sal(emp_no EMP1.eno%TYPE)
RETURNS EMP1.sal%TYPE AS
$$
DECLARE  
    salary EMP1.sal%TYPE;
BEGIN
    SELECT sal INTO salary FROM EMP1 WHERE eno = emp_no;
    RETURN salary;
END;
$$
LANGUAGE 'plpgsql';

-- Function 2: Accepts a dept no and finds the number of employees in that dept
CREATE OR REPLACE FUNCTION no_of_emp(dept_no EMP1.dno%TYPE)
RETURNS INT AS
$$ 
DECLARE
    cn INT;
BEGIN
    SELECT COUNT(eno) INTO cn FROM EMP1 WHERE dno = dept_no;
    RETURN cn;
END;
$$
LANGUAGE 'plpgsql';

-- Function 3: Takes eno and gives the employee 10% hike in salary 
-- if average salary of the corresponding dept is greater than employee's current salary
CREATE OR REPLACE FUNCTION fn1(emp_no EMP1.eno%TYPE)
RETURNS VOID AS 
$$
DECLARE
    salary EMP1.sal%TYPE;
BEGIN
    SELECT sal INTO salary FROM EMP1 WHERE eno = emp_no;
    
    IF salary < (SELECT AVG(sal) FROM EMP1 WHERE dno = (SELECT dno FROM EMP1 WHERE eno = emp_no)) THEN
        UPDATE EMP1 SET sal = sal * 1.1 WHERE eno = emp_no;
    END IF;
END;
$$
LANGUAGE 'plpgsql';

INSERT INTO Dept1 (dept_no, dname) VALUES
(10, 'Sales'),
(20, 'IT'),
(30, 'HR'),
(40, 'Finance');

-- Insert employees
INSERT INTO EMP1 (eno, ename, sal, dno) VALUES
(101, 'John Smith', 5000.00, 10),
(102, 'Sarah Johnson', 6500.00, 10),
(103, 'Mike Brown', 4500.00, 10),
(104, 'Emily Davis', 7000.00, 20),
(105, 'David Wilson', 8500.00, 20),
(106, 'Lisa Anderson', 7500.00, 20),
(107, 'Tom Martinez', 5500.00, 30),
(108, 'Anna Taylor', 6000.00, 30),
(109, 'Chris Lee', 9000.00, 40),
(110, 'Jessica White', 8000.00, 40);
SELECT emp_sal(101);
SELECT no_of_emp(20);
SELECT fn1(103);

----2--------------------------
CREATE TABLE Emp(
    eno INT PRIMARY KEY,
    ename VARCHAR(100),
    sal NUMERIC(8,2)
);

CREATE TABLE EMP_PROJ(
    eno INT REFERENCES Emp(eno),
    pno INT,
    prjt_hrs INT,
    PRIMARY KEY(eno, pno)
);

-- a) Function ProjectLoad: Returns total project working hours for given eno
CREATE OR REPLACE FUNCTION ProjectLoad(emp_no Emp.eno%TYPE)
RETURNS INT AS
$$
DECLARE
    total_hours INT;
BEGIN
    SELECT COALESCE(SUM(prjt_hrs), 0) INTO total_hours FROM EMP_PROJ WHERE eno = emp_no;
    RETURN total_hours;
END;
$$
LANGUAGE plpgsql;

-- c) PL/SQL code to update salary if employee earns less than average
-- New salary = current sal + (average sal - current sal)
CREATE OR REPLACE FUNCTION update_salary_below_avg(emp_no Emp.eno%TYPE)
RETURNS VOID AS
$$
DECLARE
    current_sal Emp.sal%TYPE;avg_sal Emp.sal%TYPE;
    salary_diff NUMERIC(8,2);
BEGIN
    -- Get current salary
    SELECT sal INTO current_sal FROM Emp WHERE eno = emp_no;
    
    -- Get average salary
    SELECT AVG(sal) INTO avg_sal FROM Emp;
    
    -- Check if current salary is less than average
    IF current_sal < avg_sal THEN
        salary_diff := avg_sal - current_sal;
        UPDATE Emp SET sal = sal + salary_diff WHERE eno = emp_no;
        RAISE NOTICE 'Employee % salary updated from % to %', emp_no, current_sal, current_sal + salary_diff;
    ELSE
        RAISE NOTICE 'Employee % salary (%) is already at or above average (%)', emp_no, current_sal, avg_sal;
    END IF;
END;
$$
LANGUAGE plpgsql;

-----3-------------------------------

-- Create tables
CREATE TABLE Item(
    ino INT PRIMARY KEY,
    iname VARCHAR(100),
    unit_price NUMERIC(8,2)
);

CREATE TABLE Transaction(
    tr_no INT PRIMARY KEY,
    ino INT REFERENCES Item(ino),
    qty INT
);

-- Function to delete item if transactions < 2
CREATE OR REPLACE FUNCTION delete_low_transaction_item(item_no Item.ino%TYPE)
RETURNS VARCHAR AS
$$
DECLARE
    transaction_count INT;
    item_name VARCHAR(100);
BEGIN
    SELECT iname INTO item_name FROM Item WHERE ino = item_no;
    
    IF item_name IS NULL THEN
        RETURN 'Error: Item number ' || item_no || ' does not exist';
    END IF;
    
    SELECT COUNT(*) INTO transaction_count FROM Transaction WHERE ino = item_no; 
    IF transaction_count < 2 THEN
        DELETE FROM Transaction WHERE ino = item_no;
        DELETE FROM Item WHERE ino = item_no;
    END IF;
END;
$$
LANGUAGE plpgsql;

----4----
CREATE TABLE BRANCHES(
    br_no INT PRIMARY KEY,
    br_name VARCHAR(100),
    loc VARCHAR(100)
);

CREATE TABLE CUSTOMER(
    cno INT PRIMARY KEY,
    cname VARCHAR(100),
    c_type CHAR(1) CHECK (c_type IN ('A', 'B'))
);

CREATE TABLE ACCOUNTS(
    ac_no INT PRIMARY KEY,
    br_no INT REFERENCES BRANCHES(br_no),
    cust_no INT REFERENCES CUSTOMER(cno),
    ac_type VARCHAR(20),
    bal NUMERIC(12,2)
);

-- a) Function to update customer type based on threshold
CREATE OR REPLACE FUNCTION update_customer_type(
    threshold_value NUMERIC(12,2),
    customer_number CUSTOMER.cno%TYPE
)
RETURNS VOID AS
$$
DECLARE
    total_balance NUMERIC(12,2);
BEGIN
    SELECT COALESCE(SUM(bal), 0) INTO total_balanceFROM ACCOUNTS WHERE cust_no = customer_number;
    
    IF total_balance > threshold_value THEN
        UPDATE CUSTOMER SET c_type = 'A' WHERE cno = customer_number;
    ELSE
        UPDATE CUSTOMER SET c_type = 'B' WHERE cno = customer_number;
    END IF;
END;
$$
LANGUAGE 'plpgsql';

-- b) Function to close a branch and transfer accounts to another branch
CREATE OR REPLACE FUNCTION CloseBranch(
    closing_branch INT,
    takeover_branch INT
)
RETURNS VOID AS
$$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM BRANCHES WHERE br_no = takeover_branch) THEN
        RAISE EXCEPTION 'Takeover branch % does not exist', takeover_branch;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM BRANCHES WHERE br_no = closing_branch) THEN
        RAISE EXCEPTION 'Closing branch % does not exist', closing_branch;
    END IF;
    
    UPDATE ACCOUNTS SET br_no = takeover_branch WHERE br_no = closing_branch;
    
    DELETE FROM BRANCHES WHERE br_no = closing_branch;
    
END;
$$
LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION safe_withdrawal(
    account_number ACCOUNTS.ac_no%TYPE,
    withdrawal_amount NUMERIC(12,2)
)
RETURNS VARCHAR AS
$$
DECLARE
    current_balance NUMERIC(12,2);
BEGIN
    SELECT bal INTO current_balance FROM ACCOUNTS WHERE ac_no = account_number;
    
    IF current_balance IS NULL THEN
        RETURN 'ERROR: Account ' || account_number || ' does not exist';
    END IF;
    
    IF withdrawal_amount <= 0 THEN
        RETURN 'ERROR: Withdrawal amount must be positive';
    END IF;
    
    IF current_balance >= withdrawal_amount THEN
        UPDATE ACCOUNTS SET bal = bal - withdrawal_amount WHERE ac_no = account_number;
    END IF;
END;
$$
LANGUAGE 'plpgsql';