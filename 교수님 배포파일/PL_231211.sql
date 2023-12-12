SET SERVEROUTPUT ON

DECLARE
    v_eid NUMBER;
    v_ename employees.first_name%TYPE;
    v_job VARCHAR2(1000);
BEGIN

    SELECT employee_id, first_name, job_id
    INTO v_eid, v_ename, v_job
    FROM employees
    WHERE employee_id = 0;
    
    DBMS_OUTPUT.PUT_LINE('�����ȣ : ' || v_eid);
    DBMS_OUTPUT.PUT_LINE('����̸� : ' || v_ename);
    DBMS_OUTPUT.PUT_LINE('���� : ' || v_job);
END;
/

DECLARE
    v_eid employees.employee_id%TYPE := &�����ȣ;
    v_ename employees.last_name%TYPE;
BEGIN
    SELECT first_name || ', ' || last_name
    INTO v_ename
    FROM employees
    WHERE employee_id = v_eid;
    
    DBMS_OUTPUT.PUT_LINE('�����ȣ : ' || v_eid);
    DBMS_OUTPUT.PUT_LINE('����̸� : ' || v_ename);
END;
/

-- 1) Ư�� ����� �Ŵ����� �ش��ϴ� �����ȣ�� ��� ( Ư�� ����� ġȯ������ ����ؼ� �Է�)
--)
SELECT manager_id
FROM employees
WHERE employee_id = 200;
--)
DECLARE
    v_mgr employees.manager_id%TYPE;
BEGIN
    SELECT manager_id
    INTO v_mgr
    FROM employees
    WHERE employee_id = &�����ȣ;
    
    DBMS_OUTPUT.PUT_LINE('����ȣ : ' || v_mgr);
END;
/

-- INSERT, UPDATE
DECLARE
    v_deptno departments.department_id%TYPE;
    v_comm employees.commission_pct%TYPE := 0.1;
BEGIN
    SELECT department_id
    INTO v_deptno
    FROM employees
    WHERE employee_id = &�����ȣ;
    
    INSERT INTO employees(employee_id, last_name, email, hire_date, job_id, department_id)
    VALUES (1000, 'Hong', 'hkd@google.com', sysdate, 'IT_PROG', v_deptno);
    
    DBMS_OUTPUT.PUT_LINE('��� ��� : ' || SQL%ROWCOUNT);
    
    UPDATE employees
    SET salary = (NVL(salary,0) + 10000) * v_comm
    WHERE employee_id = 1000;
    
    DBMS_OUTPUT.PUT_LINE('���� ��� : ' || SQL%ROWCOUNT);
END;
/

SELECT * FROM employees WHERE employee_id = 1000;

BEGIN
    DELETE FROM employees
    WHERE employee_id = &�����ȣ;
    
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('�ش� ����� �������� �ʽ��ϴ�.');
    END IF;
END;
/


/*
    1. �����ȣ�� �Է��� ���
    �����ȣ, ����̸�, �μ��̸���
    ����ϴ� PL/SQL�� �ۼ��Ͻÿ�.
    �����ȣ�� ġȯ������ ���� �Է¹޽��ϴ�.

// �Է� : �����ȣ                    -> ���̺� : employees    
// ��� : �����ȣ, ����̸�, �μ��̸�  -> ���̺� : employees + departments 
                                    => ���� : department_id
*/

SELECT employee_id, last_name, department_name
FROM employees JOIN departments 
    ON( employees.department_id = departments.department_id)
WHERE employee_id = 100;
-- 1) JOIN
DECLARE
    v_empid employees.employee_id%TYPE;
    v_ename employees.first_name%TYPE;
    v_deptname departments.department_name%TYPE;
BEGIN
    SELECT employee_id, last_name, department_name
    INTO v_empid, v_ename, v_deptname
    FROM employees JOIN departments 
        ON( employees.department_id = departments.department_id)
    WHERE employee_id = &�����ȣ;
    
    DBMS_OUTPUT.PUT_LINE('�����ȣ : ' || v_empid);
    DBMS_OUTPUT.PUT_LINE('����̸� : ' || v_ename);
    DBMS_OUTPUT.PUT_LINE('�μ��̸� : ' || v_deptname);
END;
/

-- 2) �ΰ��� SELECT��
DECLARE
    v_empid employees.employee_id%TYPE;
    v_ename employees.first_name%TYPE;
    v_deptid employees.department_id%TYPE;
    v_deptname departments.department_name%TYPE;
BEGIN
    SELECT employee_id, first_name, department_id
    INTO v_empid, v_ename, v_deptid 
    FROM employees
    WHERE employee_id = &�����ȣ;
    
    SELECT department_name
    INTO v_deptname
    FROM departments
    WHERE department_id = v_deptid;
    
    DBMS_OUTPUT.PUT_LINE('�����ȣ : ' || v_empid);
    DBMS_OUTPUT.PUT_LINE('����̸� : ' || v_ename);
    DBMS_OUTPUT.PUT_LINE('�μ��̸� : ' || v_deptname);    
END;
/
/*
    2. �����ȣ�� �Է��� ���
    ����̸�, �޿�, ������
    ����ϴ� PL/SQL�� �ۼ��Ͻÿ�.
    �����ȣ�� ġȯ������ ����ϰ�
    ������ �Ʒ��� ������ ������� �����Ͻÿ�.
    (�޿� * 12 + ( NVL(�޿�, 0) * NVL(Ŀ�̼�, 0) * 12 ))
    
// �Է� : �����ȣ               => ���̺� : employees
// ��� : ����̸�, �޿�, ����    => �÷� : ����̸�, �޿�, Ŀ�̼�

*/
SELECT last_name, salary,(salary * 12 + ( NVL(salary, 0) * NVL(commission_pct, 0) * 12 ))
FROM employees
WHERE employee_id = 100;

DECLARE
    v_ename employees.last_name%TYPE;
    v_sal employees.salary%TYPE;
    v_annual v_sal%TYPE;
BEGIN
    SELECT last_name, 
            salary,
            (salary * 12 + ( NVL(salary, 0) * NVL(commission_pct, 0) * 12 ))
    INTO v_ename, v_sal, v_annual
    FROM employees
    WHERE employee_id = &�����ȣ;
    
    DBMS_OUTPUT.PUT_LINE('����̸� : ' || v_ename);
    DBMS_OUTPUT.PUT_LINE('�޿� : ' || v_sal);
    DBMS_OUTPUT.PUT_LINE('���� : ' || v_annual);  
END;
/
-- 2) ���� ����
DECLARE
    v_ename employees.first_name%TYPE;
    v_sal employees.salary%TYPE;
    v_comm employees.commission_pct%TYPE;
    v_annual v_sal%TYPE;
BEGIN
    SELECT first_name, salary, commission_pct
    INTO v_ename, v_sal, v_comm
    FROM employees
    WHERE employee_id = &�����ȣ;
    
    v_annual := v_sal * 12 + NVL(v_sal, 0) * NVL(v_comm, 0) * 12;
    
    DBMS_OUTPUT.PUT_LINE('����̸� : ' || v_ename);
    DBMS_OUTPUT.PUT_LINE('�޿� : ' || v_sal);
    DBMS_OUTPUT.PUT_LINE('���� : ' || v_annual);
END;
/

-- �⺻ IF ��
BEGIN
    DELETE FROM employees
    WHERE employee_id = &�����ȣ;
    
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('���������� ������� �ʾҽ��ϴ�.');
        DBMS_OUTPUT.PUT_LINE('�ش� ����� �������� �ʽ��ϴ�.');
    END IF;
    
END;
/

-- IF ~ ELSE �� : �����
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(employee_id)
    INTO v_count
    FROM employees
    WHERE manager_id = &eid;
    
    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('�Ϲ� ����Դϴ�.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('�����Դϴ�.');
    END IF;
END;
/

-- IF ~ ELSIF ~ ELSE �� : ����
DECLARE
    v_hdate NUMBER;
BEGIN
    SELECT TRUNC(MONTHS_BETWEEN(sysdate, hire_date)/12)
    INTO v_hdate
    FROM employees
    WHERE employee_id = &�����ȣ;
    
    IF v_hdate < 5 THEN -- �Ի��� �� 5�� �̸�
        DBMS_OUTPUT.PUT_LINE('�Ի��� �� 5�� �̸��Դϴ�.');
    ELSIF v_hdate < 10 THEN -- �Ի��� �� 5�� �̻� 10�� �̸�
        DBMS_OUTPUT.PUT_LINE('�Ի��� �� 10�� �̸��Դϴ�.');
    ELSIF v_hdate < 15 THEN -- �Ի��� �� 10�� �̻� 15�� �̸�
        DBMS_OUTPUT.PUT_LINE('�Ի��� �� 15�� �̸��Դϴ�.');
    ELSIF v_hdate < 20 THEN -- �Ի��� �� 15�� �̻� 20�� �̸�
        DBMS_OUTPUT.PUT_LINE('�Ի��� �� 20�� �̸��Դϴ�.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('�Ի��� �� 20�� �̻��Դϴ�.');
    END IF;
END;
/

SELECT employee_id, 
        TRUNC(MONTHS_BETWEEN(sysdate, hire_date)/12),
        TRUNC((sysdate-hire_date)/365)
FROM employees
ORDER BY 2 DESC;

/*
3-1.
�����ȣ�� �Է�(ġȯ�������&)�� ���
�Ի����� 2005�� ����(2005�� ����)�̸� 'New employee' ���
      2005�� �����̸� 'Career employee' ���
// �Է� : �����ȣ
// ��� : �Ի��� 

// ���ǹ�(IF��) -> �Ի��� >= 2005�� 'New employee' ���
                   �ƴϸ�  'Career employee' ���
 */
-- 1) ��¥ �״�� ��
DECLARE
    v_hdate DATE;
BEGIN
    SELECT hire_date
    INTO v_hdate
    FROM employees
    WHERE employee_id = &�����ȣ;
    
    IF v_hdate >= TO_DATE('2005-01-01', 'yyyy-MM-dd') THEN
        DBMS_OUTPUT.PUT_LINE('New employee');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Career employee');
    END IF;
END;
/
-- 2) �⵵�� �� 
SELECT TO_CHAR(hire_date, 'yyyy')
FROM employees;

DECLARE
    v_year CHAR(4 char);
BEGIN
    SELECT TO_CHAR(hire_date, 'yyyy')
    INTO v_year
    FROM employees
    WHERE employee_id = &�����ȣ;
    
    IF v_year >= '2005' THEN
        DBMS_OUTPUT.PUT_LINE('New employee');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Career employee');
    END IF;
END;
/
/*
3-2.
�����ȣ�� �Է�(ġȯ�������&)�� ���
�Ի����� 2005�� ����(2005�� ����)�̸� 'New employee' ���
      2005�� �����̸� 'Career employee' ���
��, DBMS_OUTPUT.PUT_LINE()�� �ڵ� �� �ѹ��� �ۼ�
 */

DECLARE
    v_year CHAR(4 char);
    v_msg VARCHAR2(1000) := 'Career employee';
BEGIN
    SELECT TO_CHAR(hire_date, 'yyyy')
    INTO v_year
    FROM employees
    WHERE employee_id = &�����ȣ;
    /*
    IF v_year >= '2005' THEN
        v_msg := 'New employee';
    ELSE
        v_msg := 'Career employee';
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_msg);
    */
    IF v_year >= '2005' THEN
        v_msg := 'New employee';
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_msg);
END;
/
/*
4.
�޿���  5000�����̸� 20% �λ�� �޿�
�޿��� 10000�����̸� 15% �λ�� �޿�
�޿��� 15000�����̸� 10% �λ�� �޿�
�޿��� 15001�̻��̸� �޿� �λ����

�����ȣ�� �Է�(ġȯ����)�ϸ� ����̸�, �޿�, �λ�� �޿��� ��µǵ��� PL/SQL ����� �����Ͻÿ�

�Է� : �����ȣ
��� : ����̸�, �޿�

���ǹ�(IF��)�� ��� => �λ�� �޿�
*/
DECLARE
    v_ename employees.last_name%TYPE;
    v_sal employees.salary%TYPE;
    v_raise NUMBER := 0;
BEGIN
    SELECT last_name, salary
    INTO v_ename, v_sal
    FROM employees
    WHERE employee_id = &�����ȣ;
    
    IF v_sal <= 5000 THEN
        v_raise := 20;
    ELSIF v_sal <= 10000 THEN
        v_raise := 15;
    ELSIF v_sal <= 15000 THEN
        v_raise := 10;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('����̸� : ' || v_ename);
    DBMS_OUTPUT.PUT_LINE('�޿� : ' || v_sal);
    DBMS_OUTPUT.PUT_LINE('�λ�� �޿� : ' || (v_sal * (1 + v_raise/100)));
END;
/


-- 1���� 10���� �������� ���� ����� ���
-- �⺻ LOOP
DECLARE
    v_num NUMBER(2,0) := 1; -- 1 ~ 10
    v_sum NUMBER(2,0) := 0;      -- ���
BEGIN
    LOOP
        v_sum := v_sum + v_num;
        
        v_num := v_num + 1;
        EXIT WHEN v_num > 10;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/

-- WHILE LOOP
DECLARE
    v_num NUMBER(2,0) := 1; -- 1 ~ 10
    v_sum NUMBER(2,0) := 0;      -- ���
BEGIN
    WHILE v_num <= 10 LOOP
        v_sum := v_sum + v_num;
        
        v_num := v_num + 1;        
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/

-- FOR LOOP

-- 1) FOR LOOP�� �ӽú��� => DECLARE ���� ���ǵ� �����̸��� ������ �ȵ�
-- 2) FOR LOOP�� �⺻������ �������� ����, 
--     ���� �������� ������������ ���� �޾ƿ����� �Ѵٸ� REVERSE �߰�

DECLARE
    v_n NUMBER(2,0) := 99;
BEGIN
    -- FOR v_n IN REVERSE 1..10 LOOP
    FOR v_n IN 10..1 LOOP
        DBMS_OUTPUT.PUT_LINE(v_n);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_n);
END;
/

DECLARE
    v_sum NUMBER(2,0) := 0;

BEGIN
    FOR num IN 1..10 LOOP
        v_sum := v_sum + num;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/

/*
1. ������ ���� ��µǵ��� �Ͻÿ�.
*       -- ù��° ��, *�� �ϳ�
**      -- �ι�° ��, *�� �ΰ�
***     -- ����° ��, *�� ����
****    -- �׹�° ��, *�� �װ�
*****   -- �ټ���° ��, *�� �ټ���

||
*/
DBMS_OUTPUT.PUT();
DBMS_OUTPUT.PUT_LINE();

-- �⺻ LOOP
DECLARE
    v_tree VARCHAR2(6 char) := '';
    v_line NUMBER(1, 0) := 1;
BEGIN
     LOOP
        v_tree := v_tree || '*';
        DBMS_OUTPUT.PUT_LINE(v_tree);
        
        v_line := v_line + 1;
        EXIT WHEN v_line > 5; 
    END LOOP;     
END;
/

-- WHILE LOOP
DECLARE
    v_tree VARCHAR2(6 char) := '';
    v_line NUMBER(1, 0) := 1;
BEGIN
    WHILE v_line <= 5 LOOP
        v_tree := v_tree || '*';
        DBMS_OUTPUT.PUT_LINE(v_tree);
        
        v_line := v_line + 1;        
    END LOOP;     
END;
/

DECLARE
    v_tree VARCHAR2(6 char) := '*';
BEGIN
    WHILE LENGTH(v_tree) <= 5 LOOP
        DBMS_OUTPUT.PUT_LINE(v_tree);
        v_tree := v_tree || '*';              
    END LOOP;     
END;
/

-- FOR LOOP
DECLARE
    v_tree VARCHAR2(6 char) := '';
BEGIN
    FOR num in 1..5 LOOP
        v_tree := v_tree || '*';   
        DBMS_OUTPUT.PUT_LINE(v_tree);
    END LOOP;     
END;
/

-- ���� �ݺ��� ���
BEGIN
    FOR line IN 1..5 LOOP  -- ����, ��
        FOR star IN 1..line LOOP -- *
            DBMS_OUTPUT.PUT('*');
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/
DECLARE
    v_line NUMBER(1,0) := 1;
    v_star NUMBER(1,0) := 1;
BEGIN
    LOOP
        v_star := 1;
        LOOP
            DBMS_OUTPUT.PUT('*');
            v_star := v_star + 1;
            EXIT WHEN v_star > v_line;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');    
        v_line := v_line + 1;
        EXIT WHEN v_line > 5;
    END LOOP;
END;
/







