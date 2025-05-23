--
/*
    *DML(DAYA MANIPLATION LANGUAGE) : 데이터 조작 언어
     : 테이블의 값을 검색(SELECT), 삽입(INSERT), 수정(UPDATE), 삭제(DELETE)하는 구문
*/
--==============================================================================

/*
    1. INSERT
     : 테이블에 새로운 행을 추가하는 구문
     
    [표현식]
    1) INSERT INTO 테이블명 VALUES(값1, 값2, 값3, ....)
       테이블에 모든 컬럼에 대한 겂을 넣고자 할때
       컬럼의 순서를 지켜야 한다
       
       부족하게 값을 넣을 경우 -> not enough value오류
       값을 많이 넣을 경우 -> too many value 오류
*/
-- EMPLOYEE테이블에 한 행 추가
-- values(EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE, DEPT_CODE,
--          JOB_CODE, SALARY, BONUS, MANAGER_ID, HIRE_DATE, END_DATE, ENT_YN
INSERT INTO EMPLOYEE VALUES(300, '더조은',
                            '980924-1234567', 'tjoeun@or.kr', '01012345678',
                            'D2','J1',3500000,0.2,200, SYSDATE, null, default);
--==============================================================================
/*
    2) INSERT INTO 테이블명(컬럼명1, 컬럼명2, 컬럼명3, ...) VALUE(값1, 값2, 값3, ...)
     : 테이블에 내가 선택한 컬럼에 대한 값만 INSERT할 때
       그래도 한 행 단위로 추가됨.
      -> 선택이 안된 컬럼은 NULL이 들어감.
      -> DEFAULT가 지정되어 있으면 NULL이 아닌 DEFAULT값이 들어감.
      => 주의 : NOT NULL 제약조건이 들어있는 컬럼은 반드시 선택하여 값을 넣어야 됨
*/
-- NOT NULL(NO) : EMP_ID, EMP_NAME, EMP_NO, JOB_CODE
INSERT 
    INTO EMPLOYEE
        (
              EMP_ID
            , EMP_NAME
            , EMP_NO
            , JOB_CODE
            , HIRE_DATE
        )
    VALUES
        (
              301
            , '이고잉'
            , '091023-1298765'
            , 'J6'
            ,SYSDATE
        );
--==============================================================================
/*
    3) INSERT INTO 테이블명(서브쿼리)
     : 서브쿼리로 조회된 결과값을 모두 INSERT함(여러행 INSERT 가능)
*/
-- 새로운 테이블 생성
CREATE TABLE EMP_01 (
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(20),
    DEPT_CODE VARCHAR2(20)
);

INSERT INTO EMP_01 (
    SELECT EMP_ID, EMP_NAME, DEPT_CODE
    FROM EMPLOYEE  
);

CREATE TABLE EMP_02 (
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(20),
    DEPT_TITLE VARCHAR2(20)
);

INSERT INTO EMP_02(
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE
    FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
);

--==============================================================================
/*
    3) INSERT ALL
      : 두개 이상의 테이블에 각각 INSERT 할 때
        이때 사용되는 서브쿼리가 동일한 경우
*/
-- 2개 테이블 생성
CREATE TABLE EMP_DEPT
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
    FROM EMPLOYEE
    WHERE 1=0;
    
CREATE TABLE EMP_MANAGER
AS SELECT EMP_ID, EMP_NAME, MANAGER_ID
    FROM EMPLOYEE
    WHERE 1=0;
    
-- 부서코드가 D1인 사원들을 2테이블에 삽입
SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

INSERT ALL
INTO EMP_DEPT VALUES(EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
INTO EMP_MANAGER VALUES(EMP_ID, EMP_NAME, MANAGER_ID)
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID -- 서브쿼리 ()불필요
    FROM EMPLOYEE
    WHERE DEPT_CODE = 'D1';

--==============================================================================
/*
    * 조건을 사용하여 각 테이블에 값 INSERT가능
    
    [표현식]
    INSERT ALL
    WHEN 조건1 THEN
        INTO 테이블명1, VALUES(컬럼명, 컬럼명, ...)
    WHEN 조건2 THEN
        INTO 테이블명2, VALUEW(컬럼명, 컬럼명, ...)
    서브쿼리;
*/
-- 입사일이 2000년도 이전에 입사한 사원들의 정보 테이블
CREATE TABLE EMP_OLD
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMPLOYEE
    WHERE 1=0;
-- 입사일이 2000년도 이후에 입사한 시원들의 정보 테이블
CREATE TABLE EMP_NEW
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMPLOYEE
    WHERE 1=0;

INSERT ALL
WHEN HIRE_DATE < '2000/01/01' THEN
    INTO EMP_OLD VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
WHEN HIRE_DATE >= '2000/01/01' THEN
    INTO EMP_NEW VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
        SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
        FROM EMPLOYEE;

-- 급여가 3백만원보다 많이 받는 사람을 넣을 테이블, 적게받는 사람을 넣을 테이블
-- ID, NAME, SALARY, BONUS
-- 테이블 2개 생성

CREATE TABLE EMP_HIGH_SALARY
AS SELECT EMP_ID, EMP_NAME, SALARY, BONUS
    FROM EMPLOYEE
    WHERE 1=0;
CREATE TABLE EMP_LOW_SALARY
AS SELECT EMP_ID, EMP_NAME, SALARY, BONUS
    FROM EMPLOYEE
    WHERE 1=0;

INSERT ALL
WHEN SALARY > 3000000 THEN
    INTO EMP_HIGH_SALARY VALUES(EMP_ID, EMP_NAME, SALARY, BONUS)
WHEN SALARY <= 3000000  THEN
    INTO EMP_LOW_SALARY VALUES(EMP_ID, EMP_NAME, SALARY, BONUS)
        SELECT EMP_ID, EMP_NAME, SALARY, BONUS
        FROM EMPLOYEE;
--==============================================================================
/*
    2. UPDATE
      : 테이블의 값들을 수정하는 구문
      
    [표현식]
    UPDATE 테이블명
    SET 컬럼명 = 바꿀값,
        컬럼명 = 바꿀값,
        ...
    [WHERE조건];
        -> 주의 : WHERE절을 생략하면 테이블안의 전체 컬럼값이 바뀜
*/
-- 테이블 생성
CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;

UPDATE DEPT_COPY
SET DEPT_TITLE = '전략기획팀';
ROLLBACK;

-- 인사관리부는 전략기획팀으로 변경
UPDATE DEPT_COPY
SET DEPT_TITLE = '전략기획팀'
WHERE DEPT_ID = 'D1';


-- 급여를 넣을 테이블 생성
CREATE TABLE EMP_SALARY
AS SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE;

-- 지정보 사원의 급여를 2백만원으로 인상, 보너스 10%
UPDATE EMP_SALARY
SET SALARY = 2000000,
    BONUS = 0.1
-- WHERE EMP_NAME = '지정보'; --> 동명 이인 존재 가능성 있음
WHERE EMP_ID = '206'; -- PK(PRIMARY KEY) 값을 활용하는 것이 바람직

-- 전체 사원들의 급여를 10%인상
UPDATE EMP_SALARY
SET SALARY = emp_salary.salary*1.1;
--------------------------------------------------------------------------------
/*
    2. 서브쿼리를 이용한 UPDATE
    
    [표현식]
    UPDATE 테이블명
    SET 컬럼명 = (서브쿼리)
        ...
    [WHERE조건];
*/
-- 왕정보 사원의 급여와 보너스를 지정보사원과 동일하게 인상해줌
UPDATE EMP_SALARY
SET SALARY = (SELECT SALARY FROM EMP_SALARY WHERE EMP_ID = '206'),
    BONUS =  (SELECT BONUS FROM EMP_SALARY WHERE EMP_ID = '206')
WHERE EMP_ID = '214';
ROLLBACK;

UPDATE EMP_SALARY
SET (SALARY, BONUS) =
    (SELECT SALARY, BONUS FROM EMP_SALARY WHERE EMP_ID = '213')
WHERE EMP_ID = '214';

-- 조정연, 유하보, 강정보 직원들의 급여와 보너스를 문정보 사원과 동일하게 변경
UPDATE EMP_SALARY
SET (SALARY, BONUS) =
    (SELECT SALARY, BONUS FROM EMP_SALARY WHERE EMP_ID = '217')
WHERE EMP_ID IN ('204','215','209');

-- EMP_COPY 테이블의 ASIA 지역에서 근무하는 사원들의 보너스를 0.3으로 변경
CREATE TABLE EMP_COPY
AS SELECT * FROM EMPLOYEE;

UPDATE EMP_COPY
SET BONUS = 0.3
WHERE EMP_ID IN (SELECT EMP_ID
        FROM EMP_COPY
        JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
        JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
        WHERE LOCAL_NAME LIKE 'ASIA%');
--------------------------------------------------------------------------------
-- UPDATE시에도 제약 조건을 만족해야함
-- 200사원의 이름을 NULL로 변경
UPDATE EMP_COPY
SET EMP_NAME = null
WHERE EMP_ID = 200;

-- 제약조건 Foreign Key 생성 후 시도
UPDATE EMP_COPY
SET DEPT_CODE = 'D0'
WHERE EMP_ID = 200;

COMMIT;
--==============================================================================
/*
    3. DELETE
      : 테이블의 데이터를 행단위로 삭제
      
    [표현식]
    DELETE FROM 테이블명
    [WHERE 조건식];
    --> WHERE절이 없으면 모든 행 삭제
*/
-- 모든 데이터 삭제
DELETE FROM EMP_COPY;
ROLLBACK;

-- 301 이고잉 삭제
DELETE FROM EMP_COPY
WHERE EMP_ID = '301';

-- DEPT_CODE D8인 사원 삭제
DELETE FROM EMP_COPY
WHERE DEPT_CODE = 'D8';

/*
    * TRUNCATE : 테이블의 전체 행을 삭제하는 구문
            - DELETE 보다 속도가 빠르다
            - 별도의 조건 제시 불가, ROLLBACK 불가
*/
TRUNCATE TABLE EMP_SALARY;
--==============================================================================
--==============================================================================
--==============================================================================
--==============================================================================