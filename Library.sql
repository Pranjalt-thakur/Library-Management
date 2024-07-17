create database library;
show databases;
use library;

create table readers
(
 reader_id varchar(6),
 first_name varchar(20),
 last_name varchar(20),
 city varchar(20),
 mobile varchar(10),
 occupation varchar(10),
 dob Date,
 constraint readers_pk primary key(reader_id)
 );
 
insert into readers values('C00001','Pranjal','Thakur','Chandigarh','897839434','student','2003-11-21');
insert into readers values('C00002','Aditya','Sood','Shimla','8972229434','student','2002-10-29');
insert into readers values('C00003','Arpit','Sangrai','Chandigarh','123839434','student','2003-10-24');
insert into readers values('C00004','Shruti','Kadyan','Kurukshetra','897839366','student','2003-06-21');
insert into readers values('C00005','Shagun','Sharma','Hamirpur','123439434','student','2003-03-01');
insert into readers values('C00006','Pragya','Sharma','Chandigarh','897333434','student','2003-08-03');

select * from readers;

create table book
( Book_name varchar(30),
  Book_id varchar(6),
  Book_domain varchar(20),
  constraint book_pk primary key(Book_id)
  );
  
  insert into book values('Rich Dad Poor Dad','B00001','Motivation');
  insert into book values('Think and become Rich','B00002','Motivation');
  insert into book values('The jungle book','B00003','Kids');
  insert into book values('50 Shades Of Grey','B00004','Romantic');
  insert into book values('Ramayan','B00005','Religious');
  insert into book values('Indian Historic','B00006','History');

  select * from book;

update book
set Book_domain ='Story'
where Book_id='B00003';
  
  create table active_readers
  (  account_id varchar(6),
     reader_id varchar(6),
     Book_id varchar(6),
     account_type varchar(10),
     account_status varchar(10),
     constraint active_readers_pk primary key(account_id),
	 constraint active_readers_fk foreign key (reader_id) references readers(reader_id),
	 constraint account_bookid_fk foreign key (Book_id) references book(Book_id)

	);
  insert into  active_readers values('A00001','C00001','B00001','Premium','Active');
  insert into  active_readers values('A00002','C00002','B00002','Premium','Active');
  insert into  active_readers values('A00003','C00003','B00003','Regular','Active');
  insert into  active_readers values('A00004','C00004','B00004','Regular','Active');
    select * from active_readers;
    
create table bookissue_details
(
 issue_no varchar(6),
 account_id varchar(6),
 Book_id varchar(6),
 Book_name varchar(30),
 no_of_issued_books varchar(10),
 constraint bookissue_pk primary key(issue_no),
 constraint bookissue_fk foreign key(account_id) references active_readers(account_id)
  );
  insert into  bookissue_details values('I00001','A00001','B00001','Rich Dad Poor Dad','2');
  insert into  bookissue_details values('I00002','A00002','B00002','Think and become Rich','1');
  insert into  bookissue_details values('I00003','A00003','B00003','The jungle book','4');
  insert into  bookissue_details values('I00004','A00004','B00004','50 Shades Of Grey','5');
  select * from bookissue_details;
  
 --  QUES Names of readers who have Premium account type
  select r.first_name, r.last_name
  from readers r
  join active_readers ar on r.reader_id = ar.reader_id
  where account_type='Premium';
  
  -- QUES Details of active readers with a "Regular" account typs
  select r.first_name,ar.account_id
  from active_readers ar
  join readers r on ar.reader_id=r.reader_id
  where account_type='Regular';
  
 --  QUES Number of books issued by each reader
SELECT r.first_name, r.last_name, COUNT(bd.issue_no) AS books_issued
FROM readers r
JOIN active_readers ar ON r.reader_id = ar.reader_id
JOIN bookissue_details bd ON ar.account_id = bd.account_id
GROUP BY r.reader_id;

-- Details of all books issued more than 3 times
SELECT bd.issue_no, bd.Book_id, bd.Book_name, bd.no_of_issued_books
FROM bookissue_details bd
WHERE CAST(bd.no_of_issued_books AS UNSIGNED) > 3;

-- QUES Names of readers who have issued "Rich Dad Poor Dad"
SELECT r.first_name,r.last_name
FROM readers r
JOIN active_readers ar ON r.reader_id = ar.reader_id
JOIN  bookissue_details bd ON ar.account_id = bd.account_id
WHERE Book_name='Rich Dad Poor Dad';

-- To check if "The Jungle Book" is available
SELECT b.Book_name, 
       CASE WHEN bd.issue_no IS NULL THEN 'Available' ELSE 'Issued' END AS status
FROM book b
LEFT JOIN bookissue_details bd ON b.Book_id = bd.Book_id
WHERE b.Book_name = 'The jungle book';
