SET SERVEROUTPUT ON

BEGIN
    DBMS_OUTPUT.PUT_LINE('Hi!');
END;
/

DECLARE
    v_today DATE;
    v_literal CONSTANT NUMBER(2,0) := 10;
    v_count NUMBER := v_literal + 100;
    v_msg VARCHAR2(100 byte) NOT NULL := 'Hello, PL/SQL';
BEGIN
    DBMS_OUTPUT.PUT_LINE(v_count);
END;
/



BEGIN
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(sysdate, 'yyyy"��"MM"��"dd"��"'));
    COUNT(1);
END;
/

BEGIN 
    INSERT INTO employee (empid, empname)
    VALUES (1000, 'Hong');
END;
/

ROLLBACK;


DECLARE
    v_sal NUMBER := 1000;
    v_comm NUMBER := v_sal * 0.1;
    v_msg VARCHAR2(1000) := '�ʱ�ȭ || ';
BEGIN
     INSERT INTO employee (empid, empname)
     VALUES (1000, 'Hong');
     COMMIT;
     
    DECLARE
        v_sal NUMBER := 9999;
        v_comm NUMBER := v_sal * 0.2;
        v_annual NUMBER;
    BEGIN
         INSERT INTO employee (empid, empname)
         VALUES (1001, 'Hong');
         COMMIT;
         
        v_annual := (v_sal + v_comm) * 12;
        v_msg := v_msg || '���� ��� || ';
        DBMS_OUTPUT.PUT_LINE('���� : ' || v_annual);
    END;
       -- v_annual := v_annual + 1000;
        v_msg := v_msg || '�ٱ� ��� ';
        DBMS_OUTPUT.PUT_LINE(v_msg);
END;
/





