SET SERVEROUTPUT ON

/*

2. 치환변수(&)를 사용하면 숫자를 입력하면 해당 구구단이 출력되도록 하시오.
예) 2 입력시
2 * 1 = 2
2 * 2 = 4
2 * 3 = 6
2 * 4 = 8
2 * 5 = 10
2 * 6 = 12
2 * 7 = 14
2 * 8 = 16
2 * 9 = 18

입력 : 단
출력 : 특정 포맷 ( 단 * 곱하는 수 = 결과 ) 

=> 곱하는 수 : 1 에서 9 사이의 정수값 
*/

-- FOR LOOP
DECLARE
    v_dan NUMBER(1,0) := &단;
BEGIN
    FOR v_num IN 1..9 LOOP
        DBMS_OUTPUT.PUT_LINE(v_dan ||' * ' || v_num || ' = ' || (v_dan * v_num));
    END LOOP;
END;
/

-- 기본 LOOP
DECLARE
    -- 단 : 숫자타입, 치환변수로 입력
    v_dan NUMBER := &단;
    v_num NUMBER := 1;
BEGIN
   -- 반복문 시작
   LOOP
        -- 출력 : 단 * 곱하는 수 = (단 * 곱하는 수)
        DBMS_OUTPUT.PUT_LINE(v_dan||'*'||v_num||'='||(v_dan * v_num));
        -- 이때 곱하는 수는 1부터 9까지 1씩 증가 => 반복문으로 제어
        v_num := v_num + 1;
        EXIT WHEN v_num > 9;
   -- 반복문 종료
   END LOOP;
END;
/

-- WHILE LOOP
DECLARE
    -- 단 : 숫자타입, 치환변수로 입력
    v_dan NUMBER := &단;
    v_num NUMBER := 1;
BEGIN
   -- 반복문 시작
    WHILE v_num <= 9 LOOP
        -- 출력 : 단 * 곱하는 수 = (단 * 곱하는 수)
        DBMS_OUTPUT.PUT_LINE(v_dan||'*'||v_num||'='||(v_dan * v_num));
        -- 이때 곱하는 수는 1부터 9까지 1씩 증가 => 반복문으로 제어
        v_num := v_num + 1;

   -- 반복문 종료
   END LOOP;
END;
/

/*
3. 구구단 2~9단까지 출력되도록 하시오.
*/

-- FOR LOOP
BEGIN
    FOR v_dan IN 2..9 LOOP -- 특정 단을 2~9까지 반복하는 LOOP문
        FOR v_num IN 1..9 LOOP -- 특정 단의 1~9까지 곱하는 LOOP문
             DBMS_OUTPUT.PUT_LINE(v_dan || ' X ' || v_num || ' = ' || ( v_dan * v_num ));  
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/
-- WHILE LOOP
DECLARE
    v_dan NUMBER(2,0) := 2;
    v_num NUMBER(2,0) := 1;
    v_msg VARCHAR2(1000);
BEGIN
    WHILE v_num < 10 LOOP  -- 특정 단의 1~9까지 곱하는 LOOP문
        v_dan := 2;
        WHILE v_dan < 10 LOOP -- 특정 단을 2~9까지 반복하는 LOOP문
            v_msg := v_dan || ' X ' || v_num || ' = ' || ( v_dan * v_num ) || ' ';
            DBMS_OUTPUT.PUT(RPAD(v_msg, 12, ' '));
            v_dan := v_dan + 1;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
        v_num := v_num + 1;
    END LOOP;
END;
/

-- 기본 LOOP
DECLARE
    v_dan NUMBER(2,0) := 2;
    v_num NUMBER(2,0) := 1;
BEGIN
    LOOP -- 단
        v_num := 1;
        LOOP -- 곱하는 수
            DBMS_OUTPUT.PUT_LINE(v_dan || ' X ' || v_num || ' = ' || ( v_dan * v_num ));
            v_num := v_num + 1;
            EXIT WHEN v_num > 9;
        END LOOP;
        v_dan := v_dan + 1;
        EXIT WHEN v_dan > 9;
    END LOOP;    
END;
/

/*
4. 구구단 1~9단까지 출력되도록 하시오.
   (단, 홀수단 출력)
   
   MOD(가지고 있는 숫자, 나누는 수) => 나머지
*/

-- FOR LOOP + IF문
BEGIN
    FOR v_dan IN 1..9 LOOP -- 특정 단을 2~9까지 반복하는 LOOP문
        IF MOD(v_dan, 2) <> 0 THEN
            FOR v_num IN 1..9 LOOP -- 특정 단의 1~9까지 곱하는 LOOP문
                DBMS_OUTPUT.PUT_LINE(v_dan || ' X ' || v_num || ' = ' || ( v_dan * v_num ));  
            END LOOP;
            DBMS_OUTPUT.PUT_LINE('');
        END IF;
    END LOOP;
END;
/

-- FOR LOOP + IF문
BEGIN
    FOR v_dan IN 1..9 LOOP -- 특정 단을 2~9까지 반복하는 LOOP문
        IF MOD(v_dan, 2) = 0 THEN 
            CONTINUE;
        END IF;
        
        FOR v_num IN 1..9 LOOP -- 특정 단의 1~9까지 곱하는 LOOP문
            DBMS_OUTPUT.PUT_LINE(v_dan || ' X ' || v_num || ' = ' || ( v_dan * v_num ));  
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/

