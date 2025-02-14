-- 1.
CREATE TABLE TB_CATEGORY (
    NAME VARCHAR2(10),
    USE_YN CHAR(1) DEFAULT 'Y'
    );

-- 2.
CREATE TABLE TB_CLASS_TYPE(
    NO VARCHAR2(5) PRIMARY KEY,
    NAME VARCHAR2(10) );

-- 3.
ALTER TABLE TB_CATEGORY ADD PRIMARY KEY(NAME);

-- 4.
ALTER TABLE TB_CLASS_TYPE
    MODIFY NAME NOT NULL;

-- 5.
ALTER TABLE TB_CLASS_TYPE
    MODIFY NO VARCHAR2(10)
    MODIFY NAME VARCHAR2(20);
    
-- 6.
ALTER TABLE TB_CATEGORY
    RENAME COLUMN NAME TO CATEGORY_NAME;
ALTER TABLE TB_CATEGORY    
    RENAME COLUMN USE_YN TO CATEGORY_USE_YN;
ALTER TABLE TB_CLASS_TYPE
    RENAME COLUMN NAME TO CLASS_TYPE_NAME;
ALTER TABLE TB_CLASS_TYPE
    RENAME COLUMN NO TO CLASS_TYPE_NO;

-- 7.
ALTER TABLE TB_CATEGORY
    RENAME COLUMN CATEGORY_NAME TO PK_CATEGORY_NAME;
ALTER TABLE TB_CLASS_TYPE
    RENAME COLUMN CLASS_TYPE_NO TO PK_CLASS_TYPE_NO;

-- 8.
ALTER TABLE TB_CATEGORY
    MODIFY PK_CATEGORY_NAME VARCHAR2(12);
    
INSERT INTO  TB_CATEGORY VALUES ('공학', 'Y');
INSERT INTO  TB_CATEGORY VALUES ('자연과학', 'Y');
INSERT INTO  TB_CATEGORY VALUES ('의학', 'Y');
INSERT INTO  TB_CATEGORY VALUES ('예체능', 'Y');
INSERT INTO  TB_CATEGORY VALUES ('인문사회', 'Y');
COMMIT;

-- 9.
ALTER TABLE TB_DEPARTMENT 
    ADD FOREIGN KEY(CATEGORY) REFERENCES TB_CATEGORY;
ALTER TABLE TB_DEPARTMENT     
    RENAME CONSTRAINT SYS_C007457 TO FK_DEPARTMENT_CATEGORY;



-- 10.

-- 11.

-- 12.
