create table department(
deptid number(10) primary key not null,
deptname varchar2(10),
location varchar2(10),
tel varchar2(15)
);

create table employee(
empid number(10) not null primary key,
empname VARCHAR2(10),
hiredate date,
addr varchar2(12),
tel varchar2(15),
deptid number(10) 
);
-- deptid number(10),
-- constraint emp_dept_FK foreign key(deptid) references department(deptid)

-- 7.
alter table employee add birthday date;
-- alter table employee drop column birthday --로도 쓸 수 있음. 명확하게 컬럼명을 지정해줘야함.

drop table employee;
select * from department;
select * from employee;

-- 8.
insert into department  values (1001, '총무팀', '본101호','053-777-8777');
insert into department  values (1002, '회계팀', '본102호','053-888-9999');
insert into department  values (1003, '영업팀', '본103호','053-222-3333');

insert into employee(empid, empname, hiredate, addr, tel, deptid) values 
(20121945, '박민수', to_date('2012/03/02','yyyy/MM/dd'), '대구', '010-1111-1234', 1001);  -- 버전이 안맞을 수 있기때문에 날짜는 항상 to_date를 사용해줘야한다.
insert into employee(empid, empname, hiredate, addr, tel, deptid) values (20101817, '박준식', to_date('20100901','yyyy/MM/dd'),'경산','010-2222-1234', 1003);
insert into employee(empid, empname, hiredate, addr, tel, deptid) values (20122245, '선아라', to_date('20120302','yyyy/MM/dd'),'대구','010-3333-1222', 1002);
insert into employee(empid, empname, hiredate, addr, tel, deptid) values (20121729, '이범수', to_date('20110302','yyyy/MM/dd'),'서울','010-3333-4444', 1001);
insert into employee(empid, empname, hiredate, addr, tel, deptid) values (20121646, '이융희', to_date('20120901','yyyy/MM/dd'),'부산','010-1234-2222', 1003);

desc department;
desc employee;

-- 9. not null 제약조건은 modify 만 가능하다.
alter table employee modify empname varchar2(10) not null;

-- 10. =대신 like로 해도됨. inner join(조건을 만족하는 데이터만 출력할때, 필요에따라 데이터 누락도 될 수 있음.)
--1) 오라클 방식
select e.empname, e.hiredate, d.deptname from department d , employee e where d.deptid = e.deptid and d.deptname='총무팀';
-- 2) 표준 sql 방식
select e.empname, e.hiredate, d.deptname from department d join employee e on (d.deptid = e.deptid) where d.deptname='총무팀';

--모든 부서의 부서정보 추출(department_name 의 값이 null인 값도 추출됨)
select employee_id, first_name, department_name
from employees e left outer join departments d on (e.department_id = d.department_id);


-- 11.
delete from employee where addr like '대구';

--12. . 필연적인 서브쿼리... update 절은 join 이 들어갈 수 없음. 영업팀에서 회계팀으로 변경.
update employee
set deptid = (select deptid from department where deptname='회계팀') where deptid = (select deptid from department where deptname='영업팀');

--13. 
select e.empid, e.empname, e.birthday, d.deptname from employee e  join department d on(d.deptid = e.deptid) where e.hiredate > (select hiredate from employee where empid = 20121729);

-- 상호연관 서브쿼리 : 메인쿼리의 값을 사용하는 서브쿼리형태
select empid, empname, ( select deptname from department where deptid = e.deptid) as deptname from employee e;
--14. 
grant create view to hr;
create or replace view emp_vu
as
select e.empname, e.addr, d.deptname from employee e join department d on (d.deptid = e.deptid) where d.deptname='총무팀';
