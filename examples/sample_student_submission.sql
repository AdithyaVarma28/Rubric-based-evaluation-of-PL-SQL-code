CREATE OR REPLACE PROCEDURE classify_customer (
    p_threshold IN NUMBER,
    p_customer_no IN NUMBER
) IS
    v_balance ACCOUNTS.bal%TYPE;
BEGIN
    SELECT bal
    INTO v_balance
    FROM accounts
    WHERE cust_no = p_customer_no
      AND ROWNUM = 1;

    IF v_balance > p_threshold THEN
        UPDATE customer
        SET c_type = 'A'
        WHERE cno = p_customer_no;
    ELSE
        UPDATE customer
        SET c_type = 'B'
        WHERE cno = p_customer_no;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Customer not found');
END;
/

CREATE OR REPLACE PROCEDURE safe_withdraw (
    p_account_no IN NUMBER,
    p_amount IN NUMBER
) IS
    v_balance ACCOUNTS.bal%TYPE;
BEGIN
    SELECT bal
    INTO v_balance
    FROM accounts
    WHERE ac_no = p_account_no
    FOR UPDATE;

    IF v_balance >= p_amount THEN
        UPDATE accounts
        SET bal = bal - p_amount
        WHERE ac_no = p_account_no;
        COMMIT;
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Insufficient funds');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/
