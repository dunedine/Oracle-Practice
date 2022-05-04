

select * from student;
select * from professor;
select * from department;
select * from salgrade; /--데이터전체선택 ctrl+A

select * from tab;

describe student; /--desc까지만 입력해도 ㅇㅋ

select studno, name, userid, birthdate
from student
where grade>=2;

select distinct deptno, grade
from student;

select studno st, deptno dt, userid id, name "Student", profno AS 교수번호
from student; /-- 칼럼에 대한 별명 부여

select name "학생 이름", deptno 부서번호, profno as 지도교수
from student;

select studno|| name "student" /--합성연산자
from student;

select name || '의 직급은'|| position "title of professor"
from professor;

select '홍길동의 키는' || height ||  ', 몸무게는' || weight "키와 몸무게 정보"
/-- desc studeny; 해서 테이블구조 살펴본다  
from student;

select name, weight*2.2 as weight_pound /--"weight_pound" 도 가능
from student;

select * from professor;

select name, sal*12+100 || '만원'
from professor; 

select * from sal; /--테이블 있는지 없는지 확인하라는 오류뜸

insert into student(studno, birthdate)
values(999, '2022/03/17');

select*from student;               

select rowid, name from student;  

create table address
(id number(3),--기본키를 주면 나중에 다른 테이블에 기본키 중복되서 id 생성 불가능
name varchar2(50),
addr varchar2(100),
phone varchar2(30) default '000',
email varchar2(100));

select * from address;

insert into address
values(1,'홍길동', '부민동 2가', '0103334567', 'abc@dau.ac.kr');

create table addr_second(id, name, addr, phone, email)--컬럼개수 맞춰야함
as select*from address;

select * from addr_second;

--drop table address; --table 없애고 싶은 경우

select * from tab;

desc address;

create table addr_third --서브쿼리를 이용한 테이블 생성
as select id, name from address;

select * from addr_third;

create table addr_fourth --테이블 구조 복사
as select*from address where 1=2;

select*from addr_fourth;

desc addr_fourth; --구조 똑같은지 확인

alter table address --테이블구조변경 alter table 명령문
add (birth date);

select * from address;

alter table student
add (phone varchar2(50) default '000');

select * from student;

alter table address
add(comment varchar2(30) default 'No Comment');

alter table address
drop column comment; -- 테이블 칼럼 삭제

alter table student
drop column phone;

alter table address
modify phone varchar2(50) default '111'; --테이블 칼럼 변경 

desc address;

rename address to new_address; --테이블 이름 변경

alter table new_address
rename column phone to HP; --테이블 칼럼 이름 변경

desc new_address;

rename addr_second to client_address;

drop table addr_third;

truncate table client_address; --truncate 명령문

insert into client_address
values (4, '이순신', '주례동', '000', '000@dau.ac.kr'); --truncate 명령문이 테이블구조를 그대로 유지하는가 확인

select * from client_address; 

comment on table student is '고객을 관리하기 위한 테이블'; --주석추가
comment on column student.name is '학생이름';

select * from user_tab_comments where table_name = 'STUDENT'; --주석확인, 모든 주석 다 나옴 그래서 where절 사용
select * from user_col_comments where table_name = 'STUDENT'; -- 테이블명은 딕셔너리에서 대문자로 저장된다 !!

--12 데이터 무결성 제약조건
create table subject
(subno number(5) constraint sub_no_pk primary key, 
subname varchar2(20) constraint sub_name_nn not null,
term varchar2(1) constraint sub_term_ck check(term in('1', '2')),
type varchar2 (4));

create table sugang
(studno number(5),
subno number constraint sugang_nu_fk references subject(subno), --fk 주는법 references
regdate date not null,
result number(3) not null,
constraint sugang_no_pk primary key(studno, subno));

select table_name, constraint_type, constraint_name --기본키 걸었나 제약조건 확인하는 법
from user_constraints
where table_name in ('SUBJECT', 'SUGANG');

select * from tab;

select * from user_cons_columns
where table_name in ('SUBJECT','SUGANG'); --데이터 여러개일 때 in 사용

select * from user_constraints --에서
where table_name in ('SUBJECT', 'SUGANG'); --이 테이블 둘중에 아무나 하나가 있으면 거기에 있는 모든 컬럼 보여달라 !

alter table salgrade --[기존테이블에 무결성 제약조건 추가]
add constraint sal_grade_pk primary key(grade);--constraint 이름 줌

alter table salgrade
modify (losal not null, hisal not null); --null 무결성 제약조건 추가, constraint 이름 안줌

select * from user_cons_columns
where table_name in ('SALGRADE'); 

select * from user_constraints 
where table_name in ('SALGRADE'); --키가 뭔지 확실하게 알고싶을 경우

alter table student --[무결성 제약조건 추가실습 예1]
add(constraint stud_userid_u unique(userid), constraint stud_id_u unique(idnum));

alter table student --오류난다 아래의 방법으로 해야한다. 기본키설정이 안되어있는 상태에서 외래키 설정 불가능
add(constraint stud_profno_fk foreign key(profno) references professor(profno));

--alter table professor
--add(constraint profe_profeno_pk primary key(profno));

select * from user_constraints 
where table_name in ('STUDENT');

alter table department --[무결성 제약조건 추가실습 예2]
add primary key(deptno); --자기 테이블 deptno에 기본키 주고 (외래키 주기 전 기본키 줘야함)/기본키 pk로 설정

alter table department --colledge fk로 설정/ fk설정할땐 어느 테이블에 어떤 칼럼 참조하는지 이 구문 꼭 써줘야함*
add foreign key(colledge) references department(deptno); --colledge에 fk주되/ department테이블에 deptno를 참조한다.
--위 예2처럼 constraint 명 안줄때는 없어야함 (이름을 줘야함)

select * from user_constraints  --[무결성 제약조건에 의한 DML 명령문의 영향]
where table_name in ('DEPARTMENT');

select * from subject; --어떤데이터있는지 확인

insert into subject
values (1, '데이터베이스', '1', '필'); 

insert into subject
values(2, '시분설', '1', '선'); --기본키 값은 유니크해야하는데 똑같은 1넣어서 실행안된다. 

insert into subject
values(3,null, '2', '필'); --null 삽입할 수 없다. 

insert into subject
values(4, '빅데이터개론', '3', '필'); -- 1또는 2만 가능 3넣으면 체크무결성제약조건

insert into sugang
values(101,2,sysdate,3);

desc sugang; 

select *  --너무 많기 때문에 *로
from user_cons_columns
where table_name='SUGANG';

select * from subject;
select * from sugang;

select * from constraint_name, constraint_type
from user_constraints 
where table_name='SUBJECT';

alter table subject
drop constraint su_term_ck;

alter table sugang
drop constraint sugang_no_fk; --sugang 테이블에 subno에 걸려있는 외래키를 삭제하여라.

alter table sugang
drop constraint sugang_no_pk; --sugang 테이블에 subno에 걸려있는 pk삭제하여라

select *   ---professor 테이블에 profno에 기본키 student 테이블에 profno에 fk를 준다
from user_cons_columns
where table_name in ('STUDERNT', 'PROFESSOR');

alter table professor
drop constraint profe_profeno_pk cascade;

alter table subject
enable novalidate constraint sub_name_nn; --무결성제약조건 활성화 및 비활성화

insert into subject
values(7, null, 2,'필');

desc subject;

--10장 
desc student; --테이블구조 알기, 단일행 입력 예

insert into student
values(103,'이순신','aaa123', null,'9903151234567', '2000/03/01', '', 180,80, 101, 9903); --null,'' ->null값 넣는 방법

select * from student;

insert into department(deptno, dname, college, loc) --테이블의 컬럼명 다 적어줄땐 생략가능, 부분적으로 적어줄 때 생략한 값에는 null이 들어간다. 
values (400, '도시공학과',10, '5호관');

insert into department(deptno, dname) --묵시적인 방법의 null 값 입력
values (500, null); --null 넣은건 명시적인 방법

select * from department;

insert into student(studno, birthdate)
values (10000, to_date('1988/08/08', 'yyyy/mm/dd'));

select constraint_name, constraint_type
from user_constraints
where table_name='STUDENT';

select * from student;

insert into professor --다중행 입력: subquery 사용예
select *
from professor
where profno > 9905; --오류예시

select* from professor;

/*rollback; 취소시키고 싶을 시*/

create table height_info
(studno number(5),
name varchar2(10),
height number(5, 2));

create table weight_info
(studno number(5),
name varchar2(10),
height number(5, 2));

insert all
into height_info values(studno, name, height)
into weight_info values(studno, name, weight)
select studno, name, height, weight
from student
where grade >= '2';

select * from height_info;
select * from weight_info;

select*from height_info;
delete height_info; --truncate(롤백 못함)하고 똑같/(delete는 롤백가능)
delete weight_info;
commit; --이제 롤백 못함. truncate와 같아짐

insert all --conditional
when height > 170 then
into height_info values(studno,name,height)
when weight > 70 then
into weight_info values(studno,name,weight)
select studno, name, height, weight
from student
where grade >= '2';

select * from height_info;
select * from weight_info;

rollback;--취소

insert first
when height > 170 then
into height_info values(studno,name,height)
when weight > 70 then
into weight_info values(studno,name,weight)
select studno, name, height, weight
from student
where grade >= '2';

update student --데이터수정 예
set birthdate='81/10/13', idnum='8110132157498' --다 변경되어짐 특정튜플만 변경해주려면 where절 넣어줘야함
where studno=10108;

select * from student;
desc student;

select * from professor;

update professor
set (sal,comm) = (select sal,comm from professor where name='성연희')
where name = '이재우';

dalete student;
rollback;
--하드디스크에 저장시키려면 commit 시켜주면 된다.

delete student
where studno= 10110;

delete from professor
where deptno = (select deptno from department where dname='전자공학과');
rollback;

select * from department;

create table professor_temp --CTS구문
as select*from professor;

update professor_temp
set position='명예교수'
where position = '교수';

insert into professor_temp 
values(9998, '이순신', 'aaa123', '전임강사', 400, '89/10/25', '', 101);

commit;

select * from professor;
select * from professor_temp;

merge into professor p
using professor_temp f
on (p.profno=f.profno)
when matched then
update set p.position=f.position --교수값에서 명예교수값으로
when not matched then
insert values (f.profno, f.name, f.userid, f.position, f.sal, f.hiredate, f.comm, f.deptno); --이순신에 관한 레코드 업데이트, 교수->명예교수로 업데이트

update professor
set comm=50
where name='김도훈';
commit;

select studno, name, deptno
from student
where grade ='1';

select studno, name, grade, deptno, weight
from student
where weight <= 70;

select name, grade, deptno
from student
where grade='1'
and weight >=70;

select name, studno, grade, weight, deptno
from student
where grade='1' 
or weight >=70;

select studno, name, weight
from student
where weight between 50 and 70; --weight>=50 and weight<=70; 와 같음

select name, grade, deptno
from student
where deptno in (102,201);

select profno, name, position, deptno
from professor
where position in ('조교수', '전임강사'); -- position='조교수' or position='전임강사' 랑 같음

select name, grade, deptno
from student
where name like'김%'; --김씨가 아닌 사람은 not like '김%'
--참고로 not in(,,,,)도 있다 !

select name, grade, deptno
from student
where name like'김_영';

insert into student(studno, name)
values (33333,'황보_정호'); --묵시적으로 null값 입력 (안적은 값 null 들어감)

alter table student
modify (name varchar2(15)); --name 데이터 타입 크게 늘려줌

select name
from student
where name like '황보\_%' escape '\'; --'황보^_%' escape '^';

select name, position, comm
from professor
where comm is null; -- is not null로 응용가능 

select name, sal
from professor
where comm is not null and comm>=0; --교수테이블에서 보직수당을 받는 교수의 이름, 급여

select name, sal, comm, sal+comm sal_com
from professor ;

select name, grade, deptno
from student
where deptno =102
and (grade ='1' 
or grade='4');

select name, grade, deptno
from student
where deptno = 102 
and grade = '4'
or grade = '1';

create table stud_heavy
as select *
from student where grade='1' and weight>=70; --집합 A

create table stud_101
as select * from student where grade = '1' and deptno=101; -- 집합 B  

select * from stud_heavy --집합A
minus
select * from stud_101;--집합B
--union all하면서재진이 2번나옴 중복, 서재진이 교집합이다

select name, grade, tel
from student
order by name asc; --이름 가나다 순으로 정렬, 오름차순, null값 맨 마지막에 !!

select name, grade, idnum
from student
order by grade desc; --내림차순, null 맨처음에 

select name, grade, deptno, birthdate
from student
where deptno=101
order by birthdate asc;

select studno, name, grade, deptno, userid
from student
order by 5 asc, 2 desc; --다중칼럼을 이용한 정렬, 컬럼위치번호 칼럼의 위치를 이용한 정렬방법

--소속교수는 있으나 소속학생이 없는 학과번호 
select deptno
from professor 

intersect
select deptno
from department

minus
select deptno
from  student;

--6장 sql 함수
select  name, userid, initcap(userid)
from student
where name='김영균'; --initcap 함수

select userid, lower(userid), upper(userid)
from student
where studno='20101'; --lower/upper 함수

select dname LENGTH(dname), LENGTHB(dname)
from department; --length/ lenghtb

select name, idnum, birthdate, substr(idnum, 3,2) 태어난달
from student
where grade='1'; --substr

select * from department;

select dname, instr(dname, '과', 1, 1)
from department; --instr 함수예1

select name,substr(tel, 1, instr(tel,')')-1) tel_loc
from student;

select position, lpad(position, 10, '*') , rpad(position, 12, '+')
from professor;
