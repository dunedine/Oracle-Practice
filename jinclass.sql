

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
