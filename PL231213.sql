SET SERVEROUTPUT ON

-- 커서 for 루프 예제
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id, last_name, job_id
        FROM employees
        WHERE department_id = &부서번호;

BEGIN
    FOR emp_rec IN emp_cursor LOOP
        DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT); -- 몇번째 행인지 출력해볼 수 있음, NOTFOUND, ISOPEND 등이 굳이 필요가없어짐
        --END LOOP; 뒤에 실행이 된다면 커서가 종료된 이후라서 아무런 접근을 할 수 없어 INVALID CURSOR 에러뜸 / 데이터가 확실하게 있다는 보장이 없다면 커서 FOR 루프는 아무런 값이 나오지 않는다.
        DBMS_OUTPUT.PUT(' , ' || emp_rec.employee_id);
        DBMS_OUTPUT.PUT(' , ' || emp_rec.last_name);
        DBMS_OUTPUT.PUT_LINE(' , ' || emp_rec.job_id);
    END LOOP;
END;
/

-- 아래의 형태는 커서의 속성을 사용할 수 없다. 서브쿼리는 SELECT 문 1번밖에 사용이 안된다
DECLARE
    
BEGIN
    FOR emp_rec IN(SELECT employee_id, last_name
                   FROM employees
                   WHERE department_id = &부서번호) LOOP
      DBMS_OUTPUT.PUT(' , ' || emp_rec.employee_id);
      DBMS_OUTPUT.PUT_LINE(' , ' || emp_rec.last_name);
    END LOOP;
END;
/

/*
1) 모든 사원의 사원번호, 이름, 부서이름을 출력

2) 부서번호가 50이거나 80인 사원들의 사원이름, 급여, 연봉 출력
-- 연봉 : (급여 * 12 + NVL(급여,0) * NVL(커미션,0) * 12)
*/

SELECT e.employee_id, e.last_name, d.department_name
FROM employees e LEFT JOIN departments d on (e.department_id = d.department_id)
ORDER BY e.employee_id DESC;
    
    
-- 1)   
DECLARE        
    CURSOR emp_list_cursor IS 
    SELECT e.employee_id, e.last_name, d.department_name
        FROM employees e LEFT JOIN departments d on (e.department_id = d.department_id)
        ORDER BY e.employee_id;
BEGIN
   FOR emp_rec IN emp_list_cursor LOOP
            DBMS_OUTPUT.PUT(emp_rec.employee_id || ' , ');
            DBMS_OUTPUT.PUT(emp_rec.last_name || ' , ');
            DBMS_OUTPUT.PUT_LINE(emp_rec.department_name);
        END LOOP;  
END;
/


-- 2)
DECLARE
    CURSOR emp_sal_cursor IS
        SELECT department_id, last_name, salary, (salary * 12 + (NVL(salary,0) * NVL(commission_pct,0) * 12))as annual
        FROM employees
        WHERE department_id in (50,80)
        ORDER BY department_id;
BEGIN
    FOR emp_rec IN emp_sal_cursor LOOP
            DBMS_OUTPUT.PUT('부서번호 : '|| emp_rec.department_id || ' , ');
            DBMS_OUTPUT.PUT('이름 : '|| emp_rec.last_name || ' , ');
            DBMS_OUTPUT.PUT('급여 : '|| emp_rec.salary || ' , ');
            DBMS_OUTPUT.PUT_LINE('부서번호 : '|| emp_rec.annual);
    END LOOP;
END;
/

-- 매개변수(PARAMETER) 사용 커서 (현재 아래 코드 결과는 루프문을 돌리지 않았기때문에 SELECT 했을때 가장 먼저오는 값만 출력됨)
DECLARE 
    CURSOR emp_cursor
            (p_deptno NUMBER)IS
            SELECT last_name, hire_date
            FROM employees
            WHERE department_id = p_deptno;
            
        emp_info emp_cursor%ROWTYPE;
BEGIN
    OPEN emp_cursor(60);
    
    FETCH emp_cursor INTO emp_info;
    DBMS_OUTPUT.PUT_LINE(emp_info.last_name);
    
    -- OPEN emp_cursor(80);  // "PL/SQL: cursor already open" 오류남
    
    CLOSE emp_cursor;
END;
/

-- 현재 존재하는 모든 부서의 각 소속사원을 출력하고 없는 경우 현재 소속사원이 없습니다 출력
-- format
/*
    === 부서명 : 부서 풀네임
    1) 사원번호, 사원이름, 입사일, 업무
    2) 사원번호, 사원이름, 입사일, 업무
    루프문 2개, 커서 2개 사용
*/
DECLARE
    CURSOR dept_cursor IS
        SELECT department_id, department_name
        FROM departments;
        
     CURSOR emp_cursor(p_deptno NUMBER) IS   
            SELECT last_name, hire_date, job_id
            FROM employees
            where department_id = p_deptno;
            
        emp_rec emp_cursor%ROWTYPE;
BEGIN
        FOR dept_rec IN dept_cursor LOOP
            DBMS_OUTPUT.PUT_LINE('======= 부서명  ' || dept_rec.department_name);
            OPEN emp_cursor(dept_rec.department_id);
            LOOP
                FETCH emp_cursor INTO emp_rec;
                EXIT WHEN emp_cursor%NOTFOUND;
                DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT);
                DBMS_OUTPUT.PUT(' , ' || emp_rec.last_name);
                DBMS_OUTPUT.PUT(' , ' || emp_rec.hire_date);
                DBMS_OUTPUT.PUT_LINE(' , ' || emp_rec.job_id);
            END LOOP;
            IF emp_cursor%ROWCOUNT = 0 THEN
                DBMS_OUTPUT.PUT_LINE('현재 소속사원이 없습니다.');
            END IF;
            CLOSE emp_cursor;
        END LOOP;
END;
/

-- 예외처리
-- 1) 이미 정의되어있고 이름도 존재하는 예외사항
DECLARE
    v_ename employees.last_name%TYPE;
BEGIN
    SELECT last_name
    INTO v_ename
    FROM employees
    WHERE department_id = &부서번호;
    
    DBMS_OUTPUT.PUT_LINE('v_ename');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에 속한 사원이 없습니다');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에는 여러명의 사원이 존재합니다');
        DBMS_OUTPUT.PUT_LINE('예외처리가 끝났습니다.');
END;
/

--2) 이미 정의는 되어있지만 고유의 이름이 존재하지 않는 예외사항
DECLARE
    e_emps_remaining EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_emps_remaining, -02292);
BEGIN
    DELETE FROM departments
    WHERE department_id = &부서번호;
EXCEPTION
    WHEN e_emps_remaining THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서에 속한 사원이 존재합니다.');
END;
/

--3) 사용자 정의 예외사항
DECLARE 
    e_no_deptno EXCEPTION;
    v_ex_code NUMBER;
    v_ex_msg VARCHAR2(1000);
BEGIN
    DELETE FROM departments
    WHERE department_id = &부서번호;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_no_deptno;
        DBMS_OUTPUT.PUT_LINE('해당 부서번호는 존재하지 않습니다.');
    END IF;
    DBMS_OUTPUT.PUT_LINE('해당 부서번호가 삭제되었습니다.'); --rowcount가 0이 아닐때 실행되어야하는 문
    -- exception 처리를 하게되면 else 문이 필요함.
EXCEPTION 
    WHEN e_no_deptno THEN
        DBMS_OUTPUT.PUT_LINE('해당 부서번호는 존재하지 않습니다.');
        
    WHEN OTHERS THEN
        v_ex_code := SQLCODE;
        v_ex_msg := SQLERRM;
        DBMS_OUTPUT.PUT_LINE(v_ex_code);
        DBMS_OUTPUT.PUT_LINE(v_ex_msg);
END;
/

-- 테이블 생성 (not null 제약조건을 피하기 위해서)
CREATE TABLE test_employee
AS 
    SELECT *
    FROM employees;
    
-- test_employee 테이블을 사용하여 특정 사원을 삭제하는 PL/SQL 작성
-- 입력처리는 치환변수를 사용
-- 해당 사원이 없는 경우를 확인해서 '해당 사원이 존재하지 않습니다.' 메세지 출력

DECLARE
    v_eid employees.employee_id%TYPE := &사원번호;
    e_no_emp EXCEPTION; -- 예외처리 이름은 헷갈릴 수 있어서 잘 짓기
BEGIN
    DELETE FROM test_employee
    WHERE employee_id = v_eid;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_no_emp; 
    END IF;
        DBMS_OUTPUT.PUT(v_eid || ',' );
        DBMS_OUTPUT.PUT_LINE('삭제되었습니다.');
    EXCEPTION
        WHEN e_no_emp THEN
            DBMS_OUTPUT.PUT('입력한 : ' || v_eid || ',' );
        DBMS_OUTPUT.PUT_LINE('현재 테이블에 존재하지 않습니다.');
END;
/


-- 프로시저
CREATE OR REPLACE PROCEDURE test_pro
    --()  : 생략 가능함
    
IS --IS 와 BEGIN 사이가 DECLARE 절이 명시적으로 선언이 되기때문에 굳이 적어주지 않아도됨. 문법상 생략이나 공간은 살아있음
--DECLARE : 선언부
-- 지역변수, 레코드, 커서, EXCEPTION 
BEGIN
    DBMS_OUTPUT.PUT_LINE('First Procedure');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('예외처리');
END;
/

BEGIN
    test_pro;
END;
/

-- 1) 블록 내부에서 호출
BEGIN
    test_pro;
END;
/
-- 2) execute 명령어 사용 1번 코드문을 간략하게 1줄로 줄인게 2번
EXECUTE test_pro;

-- 객체를 삭제하는 명령어는 DROP
DROP PROCEDURE test_pro;

DROP PROCEDURE raise_salary;

-- IN 프로시저
CREATE PROCEDURE raise_salary
(p_eid IN NUMBER)
IS
    
BEGIN
    -- p_eid := 100; --할당연산자는 in모드 앞에 올 수 없음.
    UPDATE employees
    SET salary = salary * 1.1
    WHERE employee_id = p_eid;
END;
/

-- 호출하는 방식

DECLARE
    v_id employees.employee_id%TYPE := &사원번호;
    v_num CONSTANT NUMBER := v_id;
BEGIN 
    RAISE_SALARY(v_id);
    RAISE_SALARY(v_num);
    RAISE_SALARY(v_num + 100);
    RAISE_SALARY(200);
END;
/

EXECUTE RAIS_SALARY(100);

DROP PROCEDURE pro_plus;
CREATE OR REPLACE PROCEDURE pro_plus
(p_x IN NUMBER,
p_y IN NUMBER,
p_result OUT NUMBER) --실제로 종료된다고 하진 않았으나 보이지 않음. 실제 값은 null
IS
    v_sum NUMBER;
BEGIN
    DBMS_OUTPUT.PUT(p_x);
    DBMS_OUTPUT.PUT(' + ' || p_y);
    DBMS_OUTPUT.PUT_LINE(' = ' || p_result);
    p_result := p_x + p_y;
    --v_sum := p_x + p_y + p_result; -->10+12+null = null 이라서 값이 출력이 되지않음. 아웃모드는 값을 받는 용도로만 사용
    --DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/

DECLARE
    v_first NUMBER := 10;
    v_second NUMBER := 12;
    v_result NUMBER := 100;
BEGIN
    DBMS_OUTPUT.PUT_LINE('before ' || v_result);
    pro_plus(v_first, v_second , v_result);
    DBMS_OUTPUT.PUT_LINE('after ' || v_result);
END;
/

-- IN OUT
-- 01012341234 => 010-1234-1234 형식으로 바꿀때 사용

CREATE or replace PROCEDURE format_phone
(p_phone_no IN OUT VARCHAR2 )--VARCHAR 형식은 바뀐 포맷을 기준으로 하는것이 아니라 왼쪽에서 0도 출력을 해야하기 때문에 VARCHAR형식으로 함. 매개변수는 사이즈가 없음
IS
    
BEGIN
    p_phone_no := SUBSTR(p_phone_no, 1, 3)
                    || ' - ' || SUBSTR(p_phone_no, 4, 4)
                    || ' - ' || SUBSTR(p_phone_no, 8);
END;
/

DECLARE
    v_no VARCHAR2(50) := '01012341234';
BEGIN
    DBMS_OUTPUT.PUT_LINE('before ' || v_no);
    format_phone(v_no);
    DBMS_OUTPUT.PUT_LINE('after ' || v_no);
END;
/

/*
1. 주민등록번호를 입력하면 다음과 같이 출력되도록 yedam_ju 프로시저를 작성하시오
EXECUTE yedam_ju(9501011667777) 홀따옴표를 사용하지 않을 경우 00년생의 주민번호가 달라짐.
EXECUTE yedam_ju(0511013689977)

--> 950101-*******
추가) 해당 주민등록번호를 기준으로 실제 생년월일을 출력하는 부분도 추가
 9501011667777 => 1995년01월01일
 1511013689977 => 2015년11월01일
*/


-- in 모드 교수님 정답지
CREATE OR REPLACE PROCEDURE yedam_ju
(p_ssn IN VARCHAR2)
IS 
 v_result varchar2(100);
 v_birth varchar2(11 char);
 v_gender char;
BEGIN
   v_result := substr(p_ssn, 1, 6) || '-' || RPAD(SUBSTR(p_ssn, 7, 1), 7, '*');
   DBMS_OUTPUT.PUT_LINE(v_result);
   
   -- 추가문제 1900년대인지 2000년대인지 구분하려면 뒤의 성별을 식별하는 숫자로 알 수 있음.
   v_gender := SUBSTR(p_ssn, 7,1);
   
   IF v_gender IN ('1', '2', '5', '6') THEN
        v_birth := '19' || SUBSTR (p_ssn, 1, 2)|| '년'
                        || SUBSTR (p_ssn, 3, 2)|| '월'
                        || SUBSTR (p_ssn, 5, 2)|| '일';
    ELSIF v_gender IN ('3', '4', '7', '8') THEN
        v_birth := '20' || SUBSTR (p_ssn, 1, 2)|| '년'
                        || SUBSTR (p_ssn, 3, 2)|| '월'
                        || SUBSTR (p_ssn, 5, 2)|| '일';
    END IF;
   DBMS_OUTPUT.PUT_LINE(v_birth);
END;
/

EXECUTE yedam_ju('9501011667777');
EXECUTE yedam_ju('0511013689977');

/*
2.
사원번호를 입력할 경우
삭제하는 TEST_PRO 프로시저를 생성하시오.
단, 해당사원이 없는 경우 "해당사원이 없습니다." 출력
-- 입력 : 사원번호
-- 출력 : 없음
-- 연산 : 입력받은 사원번호 삭제 => in 모드 사용 out 은 필요없음
예) EXECUTE TEST_PRO(176)
*/
CREATE OR REPLACE PROCEDURE TEST_PRO
(v_eid IN test_employee.employee_id%TYPE)
IS
    e_no_emp EXCEPTION;
BEGIN
    delete from test_employee
    where employee_id = v_eid;
    
    IF SQL%ROWCOUNT = 0 THEN
    RAISE e_no_emp;
    --DBMS_OUTPUT.PUT_LINE('해당사원이 없습니다.');
    END IF;
    EXCEPTION
        WHEN e_no_emp THEN
        DBMS_OUTPUT.PUT_LINE('해당사원이 없습니다.');
END;
/

EXECUTE TEST_PRO(176);


/*
3.
다음과 같이 PL/SQL 블록을 실행할 경우 
사원번호를 입력할 경우 사원의 이름(last_name)의 첫번째 글자를 제외하고는
'*'가 출력되도록 yedam_emp 프로시저를 생성하시오.
-- 입력 : 사원번호 => in
--연산 : 1) select, 사원이름
        2) 해당이름의 포맷 변경 : SUBSTR, LENGTH, RPAD(기준이 왼쪽인지, 오른쪽인지 보고 RPAD 혹은 LPAD 로 정하면됨)
실행) EXECUTE yedam_emp(176)
실행결과) TAYLOR -> T*****  <- 이름 크기만큼 별표(*) 출력
*/
CREATE OR REPLACE PROCEDURE yedam_emp
(v_eid IN test_employee.employee_id%TYPE)
IS 
    v_ename test_employee.last_name%TYPE;  --매개변수로 사용되는 접두어이기 때문에 is 와 begin 사이에 적어줘야함.
    v_result v_ename%TYPE;
BEGIN
    select last_name
    INTO v_ename
    from test_employee 
    where employee_id = v_eid;
    v_result := RPAD(SUBSTR(v_ename, 1,1), length(v_ename), '*');
   DBMS_OUTPUT.PUT_LINE(v_ename || '->' || v_result);
END;
/

EXECUTE yedam_emp(176);

/*
4.
직원들의 사번, 급여 증가치만 입력하면 Employees테이블에 쉽게 사원의 급여를 갱신할 수 있는 y_update 프로시저를 작성하세요. 
만약 입력한 사원이 없는 경우에는 ‘No search employee!!’라는 메시지를 출력하세요.(예외처리)
-- 입력 : 사번, 급여 증가치(비율)
-- 연산 : 급여 갱신 => 급여 증가치(비율) update
    1) update employees
    set salary = salary + ( 급여증가치/100); -- 급여증가치가 정수일때
    2) set salary = salary + (salary * 급여증가치); -- 급여증가치가 소수일때
-- 예외처리
실행) EXECUTE y_update(200, 10)
*/
CREATE OR REPLACE PROCEDURE y_update
(v_eid IN employees.employee_id%TYPE, p_raise IN NUMBER)
IS
p_eid_emp EXCEPTION; 
BEGIN
    update employees
    set salary = salary + (salary * p_raise/100);
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE p_eid_emp;
    END IF;
    EXCEPTION
    WHEN p_eid_emp THEN
        DBMS_OUTPUT.PUT_LINE('No search employee!!');
END;
/

EXECUTE y_update(200, 10);

select salary from employees where employee_id=200;


CREATE OR REPLACE PROCEDURE y_update
(v_eid IN employees.employee_id%TYPE, p_raise IN NUMBER)
IS
 p_eid_emp EXCEPTION;
BEGIN
    
    update employees
    set salary = salary *( 1 + (p_raise/100))
    where employee_id = v_eid; 
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE p_eid_emp;
    END IF;
    
    EXCEPTION
    WHEN p_eid_emp THEN
        DBMS_OUTPUT.PUT_LINE('No search employee!!');
END;
/

select * from employees where employee_id = 200;

EXECUTE y_update(200, 10);


/*
5.
다음과 같이 테이블을 생성하시오.
create table yedam01
(y_id number(10),
 y_name varchar2(20));

create table yedam02
(y_id number(10),
 y_name varchar2(20));
5-1.
부서번호를 입력하면 사원들 중에서 입사년도가 2005년 이전 입사한 사원은 yedam01 테이블에 입력하고,
입사년도가 2005년(포함) 이후 입사한 사원은 yedam02 테이블에 입력하는 y_proc 프로시저를 생성하시오.
-- 입력 : 부서번호
-- 연산 : 해당사원 -> 앞서 만든 테이블에 insert
            1) select => cursor
            2) IF 문 , 입사년도,
                2-1) 입사년도가 2005년 이전이면 yedam01 테이블에 insert
                2-2) 입사년도가 >= 2005년 이면 yedam02 테이블에 insert


5-2.
1. 단, 부서번호가 없을 경우 "해당부서가 없습니다" 예외처리
2. 단, 해당하는 부서에 사원이 없을 경우 "해당부서에 사원이 없습니다" 예외처리
*/
create table yedam01
    (y_id number(10),
    y_name varchar2(20));
create table yedam02
    (y_id number(10),
    y_name varchar2(20));
--5-1)
CREATE OR REPLACE PROCEDURE y_proc
(p_deptno IN departments.department_id%TYPE)
IS
    CURSOR emp_cursor IS
    SELECT employee_id, last_name, hire_date
    FROM employees
    WHERE department_id = p_deptno;
    
    emp_rec emp_cursor%ROWTYPE;
    v_deptno departments.department_id%TYPE;
    
    e_no_emp EXCEPTION;
BEGIN
-- 첫번째 예외처리를 위해 select 문 필요
    SELECT department_id
    INTO v_deptno
    FROM departments
    WHERE department_id = p_deptno;
    
    OPEN emp_cursor;
    LOOP
    FETCH emp_cursor INTO emp_rec;
    EXIT WHEN emp_cursor%NOTFOUND;
    
    --IF hire_date < TO_DATE('05-01-01', 'yy-MM-dd') THEN
    IF TO_CHAR(emp_rec.hire_date,'yyyy') < '2005' THEN
        INSERT INTO yedam01
        VALUES(emp_rec.employee_id, emp_rec.last_name);
    ELSE
        INSERT INTO yedam02
        VALUES(emp_rec.employee_id, emp_rec.last_name);
    END IF; 
    
    END LOOP;
    
    IF emp_cursor%ROWCOUNT = 0 THEN
        RAISE e_no_emp;
    END IF;
    
    CLOSE emp_cursor;
    EXCEPTION 
    when e_no_emp then
        DBMS_OUTPUT.PUT_LINE('해당 부서에는 사원이 없습니다.');
    when NO_DATA_FOUND then
        DBMS_OUTPUT.PUT_LINE('해당 부서는 존재하지않습니다.');
END;
/

EXECUTE y_proc(80);

select * from yedam01;