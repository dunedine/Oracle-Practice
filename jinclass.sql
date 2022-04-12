

select * from student;
select * from professor;
select * from department;
select * from salgrade; /--��������ü���� ctrl+A

select * from tab;

describe student; /--desc������ �Է��ص� ����

select studno, name, userid, birthdate
from student
where grade>=2;

select distinct deptno, grade
from student;

select studno st, deptno dt, userid id, name "Student", profno AS ������ȣ
from student; /-- Į���� ���� ���� �ο�

select name "�л� �̸�", deptno �μ���ȣ, profno as ��������
from student;

select studno|| name "student" /--�ռ�������
from student;

select name || '�� ������'|| position "title of professor"
from professor;

select 'ȫ�浿�� Ű��' || height ||  ', �����Դ�' || weight "Ű�� ������ ����"
/-- desc studeny; �ؼ� ���̺��� ���캻��  
from student;

select name, weight*2.2 as weight_pound /--"weight_pound" �� ����
from student;

select * from professor;

select name, sal*12+100 || '����'
from professor; 

select * from sal; /--���̺� �ִ��� ������ Ȯ���϶�� ������

insert into student(studno, birthdate)
values(999, '2022/03/17');

select*from student;               

select rowid, name from student;  

create table address
(id number(3),--�⺻Ű�� �ָ� ���߿� �ٸ� ���̺� �⺻Ű �ߺ��Ǽ� id ���� �Ұ���
name varchar2(50),
addr varchar2(100),
phone varchar2(30) default '000',
email varchar2(100));

select * from address;

insert into address
values(1,'ȫ�浿', '�ιε� 2��', '0103334567', 'abc@dau.ac.kr');

create table addr_second(id, name, addr, phone, email)--�÷����� �������
as select*from address;

select * from addr_second;

--drop table address; --table ���ְ� ���� ���

select * from tab;

desc address;

create table addr_third --���������� �̿��� ���̺� ����
as select id, name from address;

select * from addr_third;

create table addr_fourth --���̺� ���� ����
as select*from address where 1=2;

select*from addr_fourth;

desc addr_fourth; --���� �Ȱ����� Ȯ��

alter table address --���̺������� alter table ��ɹ�
add (birth date);

select * from address;

alter table student
add (phone varchar2(50) default '000');

select * from student;

alter table address
add(comment varchar2(30) default 'No Comment');

alter table address
drop column comment; -- ���̺� Į�� ����

alter table student
drop column phone;

alter table address
modify phone varchar2(50) default '111'; --���̺� Į�� ���� 

desc address;

rename address to new_address; --���̺� �̸� ����

alter table new_address
rename column phone to HP; --���̺� Į�� �̸� ����

desc new_address;

rename addr_second to client_address;

drop table addr_third;

truncate table client_address; --truncate ��ɹ�

insert into client_address
values (4, '�̼���', '�ַʵ�', '000', '000@dau.ac.kr'); --truncate ��ɹ��� ���̺����� �״�� �����ϴ°� Ȯ��

select * from client_address; 

comment on table student is '���� �����ϱ� ���� ���̺�'; --�ּ��߰�
comment on column student.name is '�л��̸�';

select * from user_tab_comments where table_name = 'STUDENT'; --�ּ�Ȯ��, ��� �ּ� �� ���� �׷��� where�� ���
select * from user_col_comments where table_name = 'STUDENT'; -- ���̺���� ��ųʸ����� �빮�ڷ� ����ȴ� !!

--12 ������ ���Ἲ ��������
create table subject
(subno number(5) constraint sub_no_pk primary key, 
subname varchar2(20) constraint sub_name_nn not null,
term varchar2(1) constraint sub_term_ck check(term in('1', '2')),
type varchar2 (4));

create table sugang
(studno number(5),
subno number constraint sugang_nu_fk references subject(subno), --fk �ִ¹� references
regdate date not null,
result number(3) not null,
constraint sugang_no_pk primary key(studno, subno));

select table_name, constraint_type, constraint_name --�⺻Ű �ɾ��� �������� Ȯ���ϴ� ��
from user_constraints
where table_name in ('SUBJECT', 'SUGANG');

select * from tab;

select * from user_cons_columns
where table_name in ('SUBJECT','SUGANG'); --������ �������� �� in ���

select * from user_constraints --����
where table_name in ('SUBJECT', 'SUGANG'); --�� ���̺� ���߿� �ƹ��� �ϳ��� ������ �ű⿡ �ִ� ��� �÷� �����޶� !

alter table salgrade --[�������̺� ���Ἲ �������� �߰�]
add constraint sal_grade_pk primary key(grade);--constraint �̸� ��

alter table salgrade
modify (losal not null, hisal not null); --null ���Ἲ �������� �߰�, constraint �̸� ����

select * from user_cons_columns
where table_name in ('SALGRADE'); 

select * from user_constraints 
where table_name in ('SALGRADE'); --Ű�� ���� Ȯ���ϰ� �˰���� ���

alter table student --[���Ἲ �������� �߰��ǽ� ��1]
add(constraint stud_userid_u unique(userid), constraint stud_id_u unique(idnum));

alter table student --�������� �Ʒ��� ������� �ؾ��Ѵ�. �⺻Ű������ �ȵǾ��ִ� ���¿��� �ܷ�Ű ���� �Ұ���
add(constraint stud_profno_fk foreign key(profno) references professor(profno));

--alter table professor
--add(constraint profe_profeno_pk primary key(profno));

select * from user_constraints 
where table_name in ('STUDENT');

alter table department --[���Ἲ �������� �߰��ǽ� ��2]
add primary key(deptno); --�ڱ� ���̺� deptno�� �⺻Ű �ְ� (�ܷ�Ű �ֱ� �� �⺻Ű �����)/�⺻Ű pk�� ����

alter table department --colledge fk�� ����/ fk�����Ҷ� ��� ���̺� � Į�� �����ϴ��� �� ���� �� �������*
add foreign key(colledge) references department(deptno); --colledge�� fk�ֵ�/ department���̺� deptno�� �����Ѵ�.
--�� ��2ó�� constraint �� ���ٶ��� ������� (�̸��� �����)

select * from user_constraints  --[���Ἲ �������ǿ� ���� DML ��ɹ��� ����]
where table_name in ('DEPARTMENT');

select * from subject; --��������ִ��� Ȯ��

insert into subject
values (1, '�����ͺ��̽�', '1', '��'); 

insert into subject
values(2, '�úм�', '1', '��'); --�⺻Ű ���� ����ũ�ؾ��ϴµ� �Ȱ��� 1�־ ����ȵȴ�. 

insert into subject
values(3,null, '2', '��'); --null ������ �� ����. 

insert into subject
values(4, '�����Ͱ���', '3', '��'); -- 1�Ǵ� 2�� ���� 3������ üũ���Ἲ��������

insert into sugang
values(101,2,sysdate,3);

desc sugang; 

select *  --�ʹ� ���� ������ *��
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
drop constraint sugang_no_fk; --sugang ���̺� subno�� �ɷ��ִ� �ܷ�Ű�� �����Ͽ���.

alter table sugang
drop constraint sugang_no_pk; --sugang ���̺� subno�� �ɷ��ִ� pk�����Ͽ���

select *   ---professor ���̺� profno�� �⺻Ű student ���̺� profno�� fk�� �ش�
from user_cons_columns
where table_name in ('STUDERNT', 'PROFESSOR');

alter table professor
drop constraint profe_profeno_pk cascade;

alter table subject
enable novalidate constraint sub_name_nn; --���Ἲ�������� Ȱ��ȭ �� ��Ȱ��ȭ

insert into subject
values(7, null, 2,'��');

desc subject;

--10�� 
desc student; --���̺��� �˱�, ������ �Է� ��

insert into student
values(103,'�̼���','aaa123', null,'9903151234567', '2000/03/01', '', 180,80, 101, 9903); --null,'' ->null�� �ִ� ���

select * from student;
