show user;

-- >> jsp & Servlet (MyMVC)
-- [181105]

select *
from jsp_member
order by idx desc;

-- 1. MVC패턴으로 한 줄 메모장 만들기
-- #테이블 생성
create table jsp_memo
(idx         number(8)     not null        -- 글번호(시퀀스로 입력)
,fk_userid   varchar2(20)  not null        -- 회원아이디
,name        varchar2(20)  not null        -- 작성자이름
,msg         varchar2(100)                 -- 메모내용
,writedate   date default sysdate          -- 작성일자
,cip         varchar2(20)                  -- 클라이언트 IP 주소
,status      number(1) default 1 not null  -- 글삭제유무
,constraint  PK_jsp_memo_idx primary key(idx)
,constraint  FK_jsp_memo_userid foreign key(fk_userid)
                                  references jsp_member(userid)
,constraint  CK_jsp_memo_status check(status in(0,1) )  
);

-- #시퀀스 생성(메모번호)
create sequence jsp_memo_idx
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

String sql = "select idx, fk_userid, name, msg\n"+
"        , to_char(writedate, 'yyyy-mm-dd hh24:mi:ss') as writedate\n"+
"        , cip\n"+
"from jsp_memo\n"+
"where status = 1\n"+
"order by idx desc";


select *
from jsp_memo
order by idx desc;

-- [181107]
select *
from jsp_member
order by idx desc;

update jsp_member set coin=50000000, point=30000
where userid ='leess';

commit;


-- [181108]
insert into jsp_member(idx, userid, name, pwd, email, HP1, HP2, HP3)
values(seq_jsp_member.nextval, 'admin', '관리자', '9695b88a59a1610320897fa84cb7e144cc51f2984520efb77111d94b402a8382', 'j2LiNyRA76BOstW3lQeu6Wax626gcHY8Hmqi9TjccVU', '010', 'N+pZjKf5DA7KkI0SjOj9ww==','mxRR0DkoS5JSAKOeT/wWzg==');

commit;

delete from jsp_member where userid='admin';




String sql = "select idx, fk_userid, name, msg\n"+
"        , to_char(writedate, 'yyyy-mm-dd hh24:mi:ss') as writedate\n"+
"        , cip\n"+
"from jsp_memo\n"+
"where status = 1\n"+
"order by idx desc";


select rno, idx, fk_userid, name, msg,  writedate, cip
from
    (
    select rownum as rno, idx, fk_userid, name, msg,  writedate, cip
    from
        (
        select idx, fk_userid, name, msg,  to_char(writedate, 'yyyy-mm-dd hh24:mi:ss') as writedate, cip
        from jsp_memo
        where status =1
        order by idx desc
        ) V
    )T
where T.rno between 1 and 10;



String sql = "select rno, idx, fk_userid, name, msg,  writedate, cip\n"+
"from\n"+
"    (\n"+
"    select rownum as rno, idx, fk_userid, name, msg,  writedate, cip\n"+
"    from\n"+
"        (\n"+
"        select idx, fk_userid, name, msg,  to_char(writedate, 'yyyy-mm-dd hh24:mi:ss') as writedate, cip\n"+
"        from jsp_memo\n"+
"        where status =1\n"+
"        order by idx desc\n"+
"        ) V\n"+
"    )T\n"+
"where T.rno between ? and ?";

select *
from jsp_memo
where name like '홍길동';


-- [181109] 
-- 한줄메모장 삭제한 글을 백업하는 테이블
create table jsp_memo_delete
(idx         number(8)     not null                 -- 글번호(시퀀스로 입력)
,userid   varchar2(20)  not null              -- 회원아이디
,name        varchar2(20)  not null             -- 작성자이름
,msg         varchar2(100)                           -- 메모내용
,writedate   date                                       -- 작성일자
,cip         varchar2(20)                               -- 클라이언트 IP 주소
,status      number(1)  not null                    -- 글삭제유무
,deletedate date default sysdate  not null    -- 글삭제한 시간
,constraint  PK_jsp_memo_delete_idx primary key(idx)
);

-- #시퀀스 생성(메모번호)
create sequence jsp_memo_delete_idx
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

select *
from jsp_memo_delete;

drop sequence jsp_memo_delete_idx;

-- 휴면계정 전환; 마지막 로그인 일시, 마지막 비밀번호 변경 날짜 컬럼 추가
select *
from jsp_member;

alter table jsp_member
add  lastlogindate date default sysdate;

alter table jsp_member
add lastpwdchangedate date default sysdate;

update jsp_member set lastpwdchangedate = add_months(lastpwdchangedate, -7)
where userid='leess';

commit;

select *
from jsp_member
where userid='leess';


select idx, userid, name, coin, point
from jsp_member
where status=1 and
lastpwdchangedate > add_months(sysdate, -6) and 
userid='leess' ;

-- [181112]
select idx, userid, name, coin, point
        , trunc( months_between(sysdate, lastpwdchangedate) ) as pwdchangegap
        , trunc( months_between(add_months(sysdate, -6), lastlogindate) ) as lastlogingap
from jsp_member
order by idx asc;
-- months_between(add_months(sysdate, -6) , lastpwdchangedate)의 값이 0 이상인 경우 ==> -6개월 이후
-- months_between(add_months(sysdate, -6) , lastpwdchangedate)의 값이 0 이하인 경우 ==> -6개월 미만

String sql = "select idx, userid, name, coin, point\n"+
"        , trunc( months_between(add_months(sysdate, -6), lastpwdchangedate) ) as pwdchangegap\n"+
"        , trunc( months_between(add_months(sysdate, -6), lastlogindate) ) as lastlogingap\n"+
"from jsp_member\n"+
"order by idx asc";

-- to_yminterval('년-월') 년-월 설정값 만큼 sysdate로부터 이전 값을 출력
update jsp_member set lastlogindate = lastlogindate - to_yminterval('01-01')
where userid ='hongkd';

commit;

select idx, userid, to_char(lastlogindate, 'yyyy-mm-dd hh24:mi:ss') as lastlogindate
        , to_char(lastpwdchangedate, 'yyyy-mm-dd hh24:mi:ss') as lastpwdchangedate
        , name, coin, point
from jsp_member
where userid ='hongkd'
order by idx asc;


update jsp_member set status=1;

commit;

 ---------------------------------------------------------------------------
-- [181115]

                 ---- *** 쇼핑몰 *** ----
/*
   카테고리 테이블명 : jsp_category

   컬럼정의 
     -- 카테고리 대분류 번호  : 시퀀스(seq_jsp_category_cnum)로 증가함.(Primary Key)
     -- 카테고리 코드(unique) : ex) 전자제품  '100000'
                                  의류      '200000'
                                  도서      '300000' 
     -- 카테고리명(not null)  : 전자제품, 의류, 도서           
  
*/ 
 
create table jsp_category
(cnum    number(8)     not null  -- 카테고리 대분류 번호
,code    varchar2(20)  not null  -- 카테고리 코드
,cname   varchar2(100) not null  -- 카테고리명
,constraint PK_jsp_category_cnum primary key(cnum)
,constraint UQ_jsp_category_code unique(code)
);

create sequence seq_jsp_category_cnum
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

insert into jsp_category values(seq_jsp_category_cnum.nextval, '100000', '전자제품');
insert into jsp_category values(seq_jsp_category_cnum.nextval, '200000', '의류');
insert into jsp_category values(seq_jsp_category_cnum.nextval, '300000', '도서');
insert into jsp_category values(seq_jsp_category_cnum.nextval, '400000', '식품');
commit;

select cnum, code, cname
from jsp_category;

String sql = "select cnum, code, cname\n"+
"from jsp_category";

-- spec 테이블 만들기
create table jsp_spec
(snum    number(8)     not null  -- 스펙 대분류 번호
,sname   varchar2(100) not null  -- 스펙명
,constraint PK_jsp_spec_snum primary key(snum)
,constraint UQ_jsp_spec_sname unique(sname)
);

create sequence seq_jsp_spec_snum
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;


insert into jsp_spec values(seq_jsp_spec_snum.nextval, 'HIT');
insert into jsp_spec values(seq_jsp_spec_snum.nextval, 'NEW');
insert into jsp_spec values(seq_jsp_spec_snum.nextval, 'BEST');

commit;


select snum, sname
from jsp_spec;

String sql = "select snum, sname\n"+
"from jsp_spec";



---- *** 제품 테이블 : jsp_product *** ----
create table jsp_product
(pnum           number(8) not null       -- 제품번호(Primary Key)
,pname          varchar2(100) not null   -- 제품명
,pcategory_fk   varchar2(20)             -- 카테고리코드(Foreign Key)
,pcompany       varchar2(50)             -- 제조회사명
,pimage1        varchar2(100) default 'noimage.png' -- 제품이미지1   이미지파일명
,pimage2        varchar2(100) default 'noimage.png' -- 제품이미지2   이미지파일명 
,pqty           number(8) default 0      -- 제품 재고량
,price          number(8) default 0      -- 제품 정가
,saleprice      number(8) default 0      -- 제품 판매가(할인해서 팔 것이므로)
,pspec          varchar2(20)             -- 'HIT', 'BEST', 'NEW' 등의 값을 가짐.
,pcontent       clob                     -- 제품설명  varchar2는 varchar2(4000) 최대값이므로
                                         --          4000 byte 를 초과하는 경우 clob 를 사용한다.
                                         --          clob 는 최대 4GB 까지 지원한다.
                                         
,point          number(8) default 0      -- 포인트 점수                                         
,pinputdate     date default sysdate     -- 제품입고일자
,constraint  PK_jsp_product_pnum primary key(pnum)
,constraint  FK_jsp_product_pcategory_fk foreign key(pcategory_fk)
                                         references jsp_category(code)
);

create sequence seq_jsp_product_pnum
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '스마트TV', '100000', '삼성',
       'tv_samsung_h450_1.png','tv_samsung_h450_2.png',
       100,1200000,800000,'HIT','42인치 스마트 TV. 기능 짱!!', 50);


insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북', '100000', '엘지',
       'notebook_lg_gt50k_1.png','notebook_lg_gt50k_2.png',
       150,900000,750000,'HIT','노트북. 기능 짱!!', 30);  
       

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '바지', '200000', 'S사',
       'cloth_canmart_1.png','cloth_canmart_2.png',
       20,12000,10000,'HIT','예뻐요!!', 5);       
       

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '남방', '200000', '버카루',
       'cloth_buckaroo_1.png','cloth_buckaroo_2.png',
       50,15000,13000,'HIT','멋져요!!', 10);       
       

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '세계탐험보물찾기시리즈', '300000', '아이세움',
       'book_bomul_1.png','book_bomul_2.png',
       100,35000,33000,'HIT','만화로 보는 세계여행', 20);       
       
       
insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '만화한국사', '300000', '녹색지팡이',
       'book_koreahistory_1.png','book_koreahistory_2.png',
       80,130000,120000,'HIT','만화로 보는 이야기 한국사 전집', 60);
       
commit;       

select * from jsp_product; 

select pnum, pname, pcategory_fk, pcompany, 
          pimage1, pimage2, pqty, price, saleprice,
          pspec, pcontent, point, to_char(pinputdate, 'yyyy-mm-dd') as pinputdate
from jsp_product
where pspec = 'HIT'
order by pnum desc;

String sql = "select pnum, pname, pcategory_fk, pcompany,  "+
"          pimage1, pimage2, pqty, price, saleprice, "+
"          pspec, pcontent, point, to_char(pinputdate, 'yyyy-mm-dd') as pinputdate "+
"from jsp_product "+
"where pspec = ? "+
"order by pnum desc";

-- [181116]
-- #제품마다 이미지파일 여러개 넣기
create table jsp_product_imagefile
(imgfileno           number               not null    -- 이미지 파일 번호; 시퀀스
,fk_pnum            number(8)            not null    -- 제품번호(fk)
,imgfilename       varchar2(100)        not null    -- 제품이미지 파일명
,constraint PK_jsp_product_imagefile primary key(imgfileno)
,constraint FK_jsp_product_imagefile foreign key(fk_pnum)
                                         references jsp_product(pnum)
);

create sequence seq_imgfileno
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

select imgfileno, fk_pnum, imgfilename
from jsp_product_imagefile;

String sql = "insert into jsp_product(pnum, pname, pcategory_fk, pcompany, \n"+
"                        pimage1, pimage2, pqty, price, saleprice,\n"+
"                        pspec, pcontent, point)\n"+
"values(seq_jsp_product_pnum.nextval, ?, ?, ?,\n"+
"       ?, ?,\n"+
"       ?, ?, ?, ?, ?, ?)";

String sql = "insert into jsp_product_imagefile(imgfileno, fk_pnum, imgfilename)\n"+
"values(seq_imgfileno.nextval, ?, ?)";


update jsp_product set pspec='HIT' where pnum = 7;

commit;



-- [181119]
select pnum, pname, pcategory_fk, pcompany, 
          pimage1, pimage2, pqty, price, saleprice,
          pspec, pcontent, point, to_char(pinputdate, 'yyyy-mm-dd') as pinputdate,
          c.cname
from jsp_product P join jsp_category C
on p.pcategory_fk = c.code
where pcategory_fk = 464646
order by pnum desc;

String sql = "select pnum, pname, pcategory_fk, pcompany, \n"+
"          pimage1, pimage2, pqty, price, saleprice,\n"+
"          pspec, pcontent, point, to_char(pinputdate, 'yyyy-mm-dd') as pinputdate,\n"+
"          c.cname\n"+
"from jsp_product P join jsp_category C\n"+
"on p.pcategory_fk = c.code\n"+
"where pcategory_fk = code\n"+
"order by pnum desc";


-------- **** 장바구니 테이블 생성하기 **** ----------

 desc jsp_member;
 desc jsp_product;

 create table jsp_cart
 (cartno  number               not null   --  장바구니 번호
 ,fk_userid  varchar2(20)         not null   --  사용자ID
 ,fk_pnum    number(8)            not null   --  제품번호 
 ,oqty    number(8) default 0  not null   --  주문량
 ,status  number(1) default 1             --  삭제유무
 ,constraint PK_jsp_cart_cartno primary key(cartno)
 ,constraint FK_jsp_cart_fk_userid foreign key(fk_userid)
                                references jsp_member(userid) 
 ,constraint FK_jsp_cart_fk_pnum foreign key(fk_pnum)
                                references jsp_product(pnum)
 ,constraint CK_jsp_cart_status check( status in(0,1) ) 
 );

 create sequence seq_jsp_cart_cartno
 start with 1
 increment by 1
 nomaxvalue
 nominvalue
 nocycle
 nocache;

 comment on table jsp_cart
 is '장바구니 테이블';

 comment on column jsp_cart.cartno
 is '장바구니번호(시퀀스명 : seq_jsp_cart_cartno)';

 comment on column jsp_cart.fk_userid
 is '회원ID  jsp_member 테이블의 userid 컬럼을 참조한다.';

 comment on column jsp_cart.fk_pnum
 is '제품번호 jsp_product 테이블의 pnum 컬럼을 참조한다.';

 comment on column jsp_cart.oqty
 is '장바구니에 담을 제품의 주문량';

 comment on column jsp_cart.status
 is '장바구니에 담겨져 있으면 1, 장바구니에서 비우면 0';

 select *
 from user_tab_comments;

 select column_name, comments
 from user_col_comments
 where table_name = 'JSP_CART';
 
 select cartno, fk_userid, fk_pnum, oqty, status
 from jsp_cart;
 
-- 181120
-- 장바구니 목록 보는 join 쿼리
select A.cartno, A.fk_userid, A.fk_pnum, A.oqty, A.status,
           B.pname, B.pcategory_fk, B.pcompany, 
           B.pimage1, B.pimage2, B.pqty, B. price, B.saleprice,
           B.pspec, B.point
 from jsp_cart A inner join jsp_product B
 on A.fk_pnum = B.pnum
 where A.status =1 and A.fk_userid = 'leess'
 order by A.cartno desc;
 
String sql = "select A.cartno, A.fk_userid, A.fk_pnum, A.oqty, A.status,\n"+
"           B.pname, B.pcategory_fk, B.pcompany, \n"+
"           B.pimage1, B.pimage2, B.pqty, B. price, B.saleprice,\n"+
"           B.pspec, B.point\n"+
"from jsp_cart A inner join jsp_product B\n"+
"on A.fk_pnum = B.pnum\n"+
"where A.status =1 and A.fk_userid = 'ssum'\n"+
"order by A.cartno desc";


-- [181121]
--- >>> 주문관련 테이블 <<< -----------------------------
-- [1] 주문 개요 테이블 : jsp_order
-- [2] 주문 상세 테이블 : jsp_order_detail


-- *** "주문 개요" 테이블 *** --
create table jsp_order
(odrcode        varchar2(20) not null          -- 주문코드(명세서번호)  주문코드 형식 : s(회사코드)+날짜+sequence ==> s20180430-1 , s20180430-2 , s20180430-3
                                               --                                                      s20180501-4 , s20180501-5 , s20180501-6
,fk_userid      varchar2(20) not null          -- 사용자ID
,odrtotalPrice  number       not null          -- 주문총액
,odrtotalPoint  number       not null          -- 주문총포인트
,odrdate        date default sysdate not null  -- 주문일자
,constraint PK_jsp_order_odrcode primary key(odrcode)
,constraint FK_jsp_order_fk_userid foreign key(fk_userid)
                                    references jsp_member(userid)
);


-- "주문코드(명세서번호) 시퀀스" 생성
create sequence seq_jsp_order
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;


select odrcode, fk_userid, 
       odrtotalPrice, odrtotalPoint,
       to_char(odrdate, 'yyyy-mm-dd hh24:mi:ss') as odrdate
from jsp_order
order by odrcode desc;


-- *** "주문 상세" 테이블 *** --
create table jsp_order_detail
(odrseqnum      number               not null   -- 주문상세 일련번호
,fk_odrcode     varchar2(20)         not null   -- 주문코드(명세서번호)
,fk_pnum        number(8)            not null   -- 제품번호
,oqty           number               not null   -- 주문량
,odrprice       number               not null   -- "주문할 그때 그당시의 실제 판매가격" ==> insert 시 jsp_product 테이블에서 해당제품의 saleprice 컬럼값을 읽어다가 넣어주어야 한다.
,deliverStatus  number(1) default 1  not null   -- 배송상태( 1 : 주문만 받음,  2 : 배송시작,  3 : 배송완료)
,deliverDate    date                            -- 배송완료일자  default 는 null 로 함.
,constraint PK_jsp_order_detail_odrseqnum  primary key(odrseqnum)
,constraint FK_jsp_order_detail_fk_odrcode foreign key(fk_odrcode)
                                            references jsp_order(odrcode) on delete cascade
,constraint FK_jsp_order_detail_fk_pnum foreign key(fk_pnum)
                                         references jsp_product(pnum)
,constraint CK_jsp_order_detail check( deliverStatus in(1, 2, 3) )
);


-- "주문상세 일련번호 시퀀스" 생성
create sequence seq_jsp_order_detail
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;


select odrseqnum, fk_odrcode, fk_pnum, oqty, 
       odrprice, deliverStatus, 
       to_char(deliverDate, 'yyyy-mm-dd hh24:mi:ss') as deliverDate 
from jsp_order_detail
order by odrseqnum desc;

update jsp_member set coin = 50000000 where userid ='ssum';

commit;


update jsp_order_detail set deliverStatus=1 where deliverStatus=2;
commit;
-- Multi join
select A.odrcode, A.fk_userid, to_char(A.odrdate, 'yyyy-mm-dd hh24:mi:ss') as odrdate
        , B.odrseqnum, B.fk_pnum, B.oqty, B.odrprice
        , case b.deliverstatus when 1 then '주문완료' when 2 then '배송시작' when 3 then '배송완료' end as deliverstatus
        , c.pname, c.pimage1, c.price, c.saleprice, c.point
from jsp_order A join jsp_order_detail B
on A.odrcode = B.fk_odrcode
join jsp_product C
on B.fk_pnum = C.pnum
where 1=1
and A.fk_userid = 'ssum';

String sql = "select A.odrcode, A.fk_userid, to_char(A.odrdate, 'yyyy-mm-dd hh24:mi:ss') as odrdate\n"+
"        , B.odrseqnum, B.fk_pnum, B.oqty, B.odrprice\n"+
"        , case b.deliverstatus when 1 then '주문완료' when 2 then '배송시작' when 3 then '배송완료' end as deliverstatus\n"+
"        , c.pname, c.pimage1, c.price, c.saleprice, c.point\n"+
"from jsp_order A join jsp_order_detail B\n"+
"on A.odrcode = B.fk_odrcode\n"+
"join jsp_product C\n"+
"on B.fk_pnum = C.pnum\n"+
"where 1=1\n"+
"and A.fk_userid = 'ssum'";


-- 전표(영수증번호; odrcode)로 유저의 정보 알아오기 --> 서브쿼리 사용
select *
from jsp_member
where userid = ( select fk_userid
                        from jsp_order
                        where odrcode = 's20181122-4');
                        
                        
String sql = "select *\n"+
"from jsp_member\n"+
"where userid = ( select fk_userid\n"+
"                        from jsp_order\n"+
"                        where odrcode = 's20181122-4')";


select A.odrcode, A.fk_userid, to_char(A.odrdate, 'yyyy-mm-dd hh24:mi:ss') as odrdate
        , B.odrseqnum, B.fk_pnum, B.oqty, B.odrprice, B.deliverstatus
        , c.pname, c.pimage1,  c.pimage2, c.saleprice, c.point
from jsp_order A join jsp_order_detail B
on A.odrcode = B.fk_odrcode
join jsp_product C
on B.fk_pnum = C.pnum
where (fk_odrcode||'/'||fk_pnum) in(odrcodePnum);


select A.odrcode, to_char(A.odrdate, 'yyyy-mm-dd hh24:mi:ss') as odrdate
        , B.odrseqnum, B.fk_pnum, B.oqty, B.odrprice, B.deliverstatus
        , c.pname, c.pimage1,  c.pimage2, c.saleprice, c.point
        , D.userid, D.email
from jsp_member D 
    inner join jsp_order A 
    on A.fk_userid = D.userid
    inner join jsp_order_detail B
    on A.odrcode = B.fk_odrcode
    inner join jsp_product C
    on B.fk_pnum = C.pnum
where (fk_odrcode||'/'||fk_pnum) in('s20181122-1/4');

String sql = "select A.odrcode, to_char(A.odrdate, 'yyyy-mm-dd hh24:mi:ss') as odrdate\n"+
"        , B.odrseqnum, B.fk_pnum, B.oqty, B.odrprice, B.deliverstatus\n"+
"        , c.pname, c.pimage1,  c.pimage2, c.saleprice, c.point\n"+
"        , D.userid, D.email\n"+
"from jsp_member D \n"+
"    inner join jsp_order A \n"+
"    on A.fk_userid = D.userid\n"+
"    inner join jsp_order_detail B\n"+
"    on A.odrcode = B.fk_odrcode\n"+
"    inner join jsp_product C\n"+
"    on B.fk_pnum = C.pnum\n"+
"where (fk_odrcode||'/'||fk_pnum) in(odrcodePnum)";


-- [181127]
--- Google Map API 관련 ---

create table jsp_storemap
(storeno     number  not null  -- 점포no 
,storeName   varchar2(100)     -- 점포명
,latitude    number            -- 위도
,longitude   number            -- 경도
,zindex      number            -- 우선순위(z-index) 점포no로 사용됨.
,tel         varchar2(20)      -- 전화번호
,addr        varchar2(200)     -- 주소
,transport   varchar2(1000)    -- 오시는길 
,constraint PK_jsp_storemap_storeno primary key(storeno)
);

create sequence seq_storemap
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

insert into jsp_storemap(storeno, storeName, latitude, longitude, zindex, tel, addr, transport) 
values(seq_storemap.nextval, 'KH 종로점', 37.567957, 126.983134, seq_storemap.currval
      ,'02-1234-5678', '서울특별시 중구 남대문로 120 대일빌딩 2F, 3F', '지하철 2호선 을지로입구역 3번출구 100M / 1호선 종각역 4번, 5번 출구 200M');

insert into jsp_storemap(storeno, storeName, latitude, longitude, zindex, tel, addr, transport)  
values(seq_storemap.nextval, '롯데백화점 본점', 37.564728, 126.981641, seq_storemap.currval
      ,'02-771-2500', '서울특별시 중구 소공동 남대문로 81', '지하철 2호선 을지로입구역 8번출구');

insert into jsp_storemap(storeno, storeName, latitude, longitude, zindex, tel, addr, transport)  
values(seq_storemap.nextval, '신세계백화점 본점', 37.560227, 126.980773, seq_storemap.currval
      ,'1588-1234', '서울특별시 중구 명동 소공로 63', '지하철 4호선 회현역 7번출구');

commit;

select storeno, storeName, latitude, longitude, zindex, tel, addr, transport 
from jsp_storemap
order by storeno;

String sql = "select storeno, storeName, latitude, longitude, zindex, tel, addr, transport \n"+
"from jsp_storemap\n"+
"order by storeno";


create table jsp_storedetailImg
(seq         number not null    -- 일련번호
,fk_storeno  number not null    -- 점포no
,img         varchar2(500)      -- 매장이미지
,constraint PK_jsp_storedetailImg_seq primary key(seq)
,constraint FK_jsp_storedetailImg foreign key(fk_storeno)
                                  references jsp_storemap(storeno)
                                  on delete cascade
);

create sequence seq_storedetailImg
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

insert into jsp_storedetailImg(seq, fk_storeno, img)
values(seq_storedetailImg.nextval, 1, 'kh01.png');

insert into jsp_storedetailImg(seq, fk_storeno, img)
values(seq_storedetailImg.nextval, 1, 'kh02.png');

insert into jsp_storedetailImg(seq, fk_storeno, img)
values(seq_storedetailImg.nextval, 1, 'kh03.png');

insert into jsp_storedetailImg(seq, fk_storeno, img)
values(seq_storedetailImg.nextval, 2, 'lotte01.png');

insert into jsp_storedetailImg(seq, fk_storeno, img)
values(seq_storedetailImg.nextval, 2, 'lotte02.png');

insert into jsp_storedetailImg(seq, fk_storeno, img)
values(seq_storedetailImg.nextval, 3, 'newworld01.png');
 
commit; 
 

select storeno, storeName, tel, addr, transport  
from jsp_storemap 
where storeno = 1;

select seq, fk_storeno, img
from jsp_storedetailImg;

select img
from jsp_storedetailImg
where fk_storeno = 1;

select storeno, storeName, latitude, longitude, zindex, tel, addr, transport, img 
from jsp_storemap a join jsp_storedetailImg b
on storeno = fk_storeno
where storeno = 1;



-- [181129]
--------------- *** Ajax Study *** --------------------
create table tbl_ajaxnews
(seqtitleno   number not null
,title        varchar2(200) not null
,registerday  date default sysdate not null
,constraint PK_tbl_ajaxnews_seqtitleno primary key(seqtitleno)
);

create sequence seq_tbl_ajaxnews_seqtitleno
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

insert into tbl_ajaxnews(seqtitleno, title) values(seq_tbl_ajaxnews_seqtitleno.nextval, '''남달라'' 박성현 LPGA 투어 텍사스 클래식 우승, 시즌 첫 승' );
insert into tbl_ajaxnews(seqtitleno, title) values(seq_tbl_ajaxnews_seqtitleno.nextval, '뼈아픈 연패-전패, 아직 한번도 못 이겼다고?' );
insert into tbl_ajaxnews(seqtitleno, title) values(seq_tbl_ajaxnews_seqtitleno.nextval, '전설들과 어깨 나란히 한 김해림 "4연패도 노려봐야죠"');
insert into tbl_ajaxnews(seqtitleno, title) values(seq_tbl_ajaxnews_seqtitleno.nextval, '삼성·현대차 들쑤신 엘리엇, 이번엔 伊 최대통신사 삼켰다');
insert into tbl_ajaxnews(seqtitleno, title) values(seq_tbl_ajaxnews_seqtitleno.nextval, '"야구장, 어떤 음악으로 채우나" 응원단장들도 괴롭다');
insert into tbl_ajaxnews(seqtitleno, title) values(seq_tbl_ajaxnews_seqtitleno.nextval, '"공부 후 10분의 휴식, 기억력 높인다"');
insert into tbl_ajaxnews(seqtitleno, title) values(seq_tbl_ajaxnews_seqtitleno.nextval, '현대차, 쏘나타 ''익스트림 셀렉션'' 트림 출시… 사양과 가격은?');
insert into tbl_ajaxnews(seqtitleno, title) values(seq_tbl_ajaxnews_seqtitleno.nextval, '날씨무더위 계속…곳곳 강한 소나기');

commit;

select *
from tbl_ajaxnews;

update tbl_ajaxnews set registerday = registerday - 1
where seqtitleno in (1,2);

commit;

select seqtitleno
     , case when length(title) > 22 then substr(title, 1, 20)||'..'
       else title end as title
     , to_char(registerday, 'yyyy-mm-dd') as registerday
from tbl_ajaxnews
where to_char(registerday, 'yyyy-mm-dd') = to_char(sysdate, 'yyyy-mm-dd');


insert into tbl_ajaxnews(seqtitleno, title) values(seq_tbl_ajaxnews_seqtitleno.nextval, '서울에 첫 폭염경보…수도권과 영서도 경보로 강화');
commit;

insert into tbl_ajaxnews(seqtitleno, title) values(seq_tbl_ajaxnews_seqtitleno.nextval, '코스피, 외국인·기관 동반 매도에 1,990선 ''털썩''');
commit;


insert into tbl_ajaxnews(seqtitleno, title) values(seq_tbl_ajaxnews_seqtitleno.nextval, '테스트하는 신문기사글');
commit;

insert into tbl_ajaxnews(seqtitleno, title) values(seq_tbl_ajaxnews_seqtitleno.nextval, '테스트하는 신문기사글2');
commit;


create table tbl_images
(userid varchar2(20) not null
,name   varchar2(20) not null
,img    varchar2(50) not null
,constraint PK_tbl_images_userid primary key(userid)
);

insert into tbl_images(userid, name, img) values('iyou','아이유','iyou.jpg');
insert into tbl_images(userid, name, img) values('kimth','김태희','kimth.jpg');
insert into tbl_images(userid, name, img) values('parkby','박보영','parkby.jpg');

commit;

select *
from tbl_images;

select *
from jsp_member
where name like '%'||''||'%';

-- [181130]
create table tbl_books
(subject        varchar2(200) not null
,title          varchar2(200) not null
,author         varchar2(200) not null
,registerday    date default sysdate
);

insert into tbl_books(subject, title, author) values('소설','해질무렵','황석영');
insert into tbl_books(subject, title, author) values('소설','마션','앤디위어');
insert into tbl_books(subject, title, author) values('소설','어린왕자','생텍쥐페리');
insert into tbl_books(subject, title, author) values('소설','당신','박범신');
insert into tbl_books(subject, title, author) values('소설','삼국지','이문열');
insert into tbl_books(subject, title, author) values('프로그래밍','ORACLE','이순신');
insert into tbl_books(subject, title, author) values('프로그래밍','자바','안중근');
insert into tbl_books(subject, title, author) values('프로그래밍','JSP Servlet','똘똘이');
insert into tbl_books(subject, title, author) values('프로그래밍','스프링','윤봉길');

commit;

select subject, title, author, registerday
from tbl_books;



-- [181203]
------------ ***** ajax 를 사용하여 자동글완성하기 ***** ------------
create table tbl_wordLargeCategory 
(seq              number not null
,lgcategorycode   varchar2(20) not null
,codename         varchar2(50) not null
,constraint PK_tbl_wordLargeCategory primary key(seq)
,constraint UQ_tbl_wordLargeCategory_code unique(lgcategorycode)
);

create sequence seq_wordLargeCategory 
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

insert into tbl_wordLargeCategory(seq, lgcategorycode, codename)
values(seq_wordLargeCategory.nextval, 'A', '국어');

insert into tbl_wordLargeCategory(seq, lgcategorycode, codename)
values(seq_wordLargeCategory.nextval, 'B', '영어');

insert into tbl_wordLargeCategory(seq, lgcategorycode, codename)
values(seq_wordLargeCategory.nextval, 'C', '수학');

insert into tbl_wordLargeCategory(seq, lgcategorycode, codename)
values(seq_wordLargeCategory.nextval, 'D', 'IT');

commit;

select seq, lgcategorycode, codename
from tbl_wordLargeCategory
order by seq asc;


create table tbl_wordMiddleCategory 
(seq                number not null
,mdcategorycode     varchar2(20) not null
,fk_lgcategorycode  varchar2(20) not null
,codename           varchar2(50) not null
,constraint PK_tbl_wordMiddleCategory primary key(seq)
,constraint UQ_tbl_wordMiddleCategory unique(mdcategorycode)
,constraint FK_tbl_wordMiddleCategory foreign key(fk_lgcategorycode)
                                        references tbl_wordLargeCategory(lgcategorycode)
);

create sequence seq_wordMiddleCategory 
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

insert into tbl_wordMiddleCategory(seq, mdcategorycode, fk_lgcategorycode, codename)
values(seq_wordMiddleCategory.nextval, 'A1', 'A', '수필');

insert into tbl_wordMiddleCategory(seq, mdcategorycode, fk_lgcategorycode, codename)
values(seq_wordMiddleCategory.nextval, 'A2', 'A', '고전문학');

insert into tbl_wordMiddleCategory(seq, mdcategorycode, fk_lgcategorycode, codename)
values(seq_wordMiddleCategory.nextval, 'A3', 'A', '현대문학');

insert into tbl_wordMiddleCategory(seq, mdcategorycode, fk_lgcategorycode, codename)
values(seq_wordMiddleCategory.nextval, 'B1', 'B', '문법');

insert into tbl_wordMiddleCategory(seq, mdcategorycode, fk_lgcategorycode, codename)
values(seq_wordMiddleCategory.nextval, 'B2', 'B', '독해');

insert into tbl_wordMiddleCategory(seq, mdcategorycode, fk_lgcategorycode, codename)
values(seq_wordMiddleCategory.nextval, 'B3', 'B', '영작');

insert into tbl_wordMiddleCategory(seq, mdcategorycode, fk_lgcategorycode, codename)
values(seq_wordMiddleCategory.nextval, 'C1', 'C', '미적분');

insert into tbl_wordMiddleCategory(seq, mdcategorycode, fk_lgcategorycode, codename)
values(seq_wordMiddleCategory.nextval, 'C2', 'C', '통계');

insert into tbl_wordMiddleCategory(seq, mdcategorycode, fk_lgcategorycode, codename)
values(seq_wordMiddleCategory.nextval, 'D1', 'D', 'java');

insert into tbl_wordMiddleCategory(seq, mdcategorycode, fk_lgcategorycode, codename)
values(seq_wordMiddleCategory.nextval, 'D2', 'D', 'oracle');

insert into tbl_wordMiddleCategory(seq, mdcategorycode, fk_lgcategorycode, codename)
values(seq_wordMiddleCategory.nextval, 'D3', 'D', 'ajax');

commit;

select seq, mdcategorycode, fk_lgcategorycode, codename
from tbl_wordMiddleCategory 
order by seq asc;


create table tbl_wordContents 
(seq                   number not null
,fk_mdcategorycode     varchar2(20) not null
,title                 varchar2(100) not null
,content               varchar2(4000) not null
,constraint PK_tbl_wordContentst primary key(seq)
,constraint FK_tbl_wordContents foreign key(fk_mdcategorycode)
                                  references tbl_wordMiddleCategory(mdcategorycode)
);

create sequence seq_wordContents 
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

insert into tbl_wordContents(seq, fk_mdcategorycode, title, content) 
values(seq_wordContents.nextval, 'D3', 'AJAX', 'Ajax(Asynchronous JavaScript and XML)');

insert into tbl_wordContents(seq, fk_mdcategorycode, title, content) 
values(seq_wordContents.nextval, 'D3', 'ajax 프로그래밍', '비동기식 자바스크립트 XML 프로그래밍');

insert into tbl_wordContents(seq, fk_mdcategorycode, title, content) 
values(seq_wordContents.nextval, 'D1', 'Java 프로그래밍', '자바는 재미가 있나요?');

insert into tbl_wordContents(seq, fk_mdcategorycode, title, content) 
values(seq_wordContents.nextval, 'D1', 'Java 프로그래밍 기초1', '자바기초1은 재미가 있나요?');

insert into tbl_wordContents(seq, fk_mdcategorycode, title, content) 
values(seq_wordContents.nextval, 'D1', 'Java 프로그래밍 기초2', '자바기초2는 재미가 있나요?');

insert into tbl_wordContents(seq, fk_mdcategorycode, title, content) 
values(seq_wordContents.nextval, 'D1', 'Java 프로그래밍 기초3', '자바기초3은 재미가 있나요?');

insert into tbl_wordContents(seq, fk_mdcategorycode, title, content) 
values(seq_wordContents.nextval, 'D1', 'Java 프로그래밍 중급1', '자바중급1은 재미가 있나요?');

insert into tbl_wordContents(seq, fk_mdcategorycode, title, content) 
values(seq_wordContents.nextval, 'D1', 'Java 프로그래밍 중급2', '자바중급2는 재미가 있나요?');

insert into tbl_wordContents(seq, fk_mdcategorycode, title, content) 
values(seq_wordContents.nextval, 'D1', 'Java 프로그래밍 중급3', '자바중급3은 재미가 있나요?');

insert into tbl_wordContents(seq, fk_mdcategorycode, title, content) 
values(seq_wordContents.nextval, 'D1', 'Java 프로그래밍 고급1', '자바고급1은 재미가 있나요?');

insert into tbl_wordContents(seq, fk_mdcategorycode, title, content) 
values(seq_wordContents.nextval, 'D1', 'Java 프로그래밍 고급2', '자바고급2는 재미가 있나요?');

insert into tbl_wordContents(seq, fk_mdcategorycode, title, content) 
values(seq_wordContents.nextval, 'D1', 'Java 프로그래밍 고급3', '자바고급3은 재미가 있나요?');

insert into tbl_wordContents(seq, fk_mdcategorycode, title, content) 
values(seq_wordContents.nextval, 'D1', 'JAVA Programing', '자바는 재미있습니다.');

insert into tbl_wordContents(seq, fk_mdcategorycode, title, content) 
values(seq_wordContents.nextval, 'A1', '수필이란', '형식에 얽매이지 않고 작가 생각대로 자유롭게 쓴 글');

insert into tbl_wordContents(seq, fk_mdcategorycode, title, content) 
values(seq_wordContents.nextval, 'B1', '영문법 100일 완성', '100일만 공부하면 영문법이 내것으로 완성된다');

insert into tbl_wordContents(seq, fk_mdcategorycode, title, content) 
values(seq_wordContents.nextval, 'A2', '고려가요', '작자 미상이 많은 구전가요');

insert into tbl_wordContents(seq, fk_mdcategorycode, title, content) 
values(seq_wordContents.nextval, 'A2', '시조', '조선시대에 만들어진 고전문학');

insert into tbl_wordContents(seq, fk_mdcategorycode, title, content) 
values(seq_wordContents.nextval, 'A3', '시나리오', '연극,영화대본에 쓰이는 현대문학');

insert into tbl_wordContents(seq, fk_mdcategorycode, title, content) 
values(seq_wordContents.nextval, 'B1', '기초영문법', '영문법 기초다지기에 필요한 지침서');

insert into tbl_wordContents(seq, fk_mdcategorycode, title, content) 
values(seq_wordContents.nextval, 'B1', '기초영문법', '기초영문의 지침서 성문기초영어');

insert into tbl_wordContents(seq, fk_mdcategorycode, title, content) 
values(seq_wordContents.nextval, 'B1', '기초영문법', '영문법 기초에 적합한 맨투맨 영어');

insert into tbl_wordContents(seq, fk_mdcategorycode, title, content) 
values(seq_wordContents.nextval, 'B2', '영문독해', '영자 신문을 많이 읽으면 실력이 향상 됩니다');

insert into tbl_wordContents(seq, fk_mdcategorycode, title, content) 
values(seq_wordContents.nextval, 'B3', '영문편지쓰기', '해외 친구에게 영어로 편지를 쓰세요');

insert into tbl_wordContents(seq, fk_mdcategorycode, title, content) 
values(seq_wordContents.nextval, 'D2', '오라클기초', '데이터베이스중 가장 많이 사용되는 ORACLE에 대해 알아봅니다');

insert into tbl_wordContents(seq, fk_mdcategorycode, title, content) 
values(seq_wordContents.nextval, 'D2', '오라클기초', '기초부터 탄탄히 배우는 오라클 기초과정');

insert into tbl_wordContents(seq, fk_mdcategorycode, title, content) 
values(seq_wordContents.nextval, 'D2', '오라클기초', '오라클을 처음 접하는 초보자용 오라클 기초과정 입니다');

insert into tbl_wordContents(seq, fk_mdcategorycode, title, content) 
values(seq_wordContents.nextval, 'C1', '미적분이란', '수학정석이나 해법수학을 보시면 다 나옵니다');

insert into tbl_wordContents(seq, fk_mdcategorycode, title, content) 
values(seq_wordContents.nextval, 'C2', '통계학', '경영상 의사결정에 도움이 되는 학문입니다');

commit;
 
select distinct TITLE
from  
( 
select  case when length(title) > 15 then substr(title,1,15) 
        else title end as TITLE 
from tbl_wordContents 
where lower(title) like '%'|| lower('오라클기초') || '%' 
order by seq desc 
);                       
 
select A.seq, C.codename AS lgcodename, B.codename AS mdcodename, A.title, A.content 
from tbl_wordContents A join tbl_wordMiddleCategory B 
on A.fk_mdcategorycode = B.mdcategorycode  
join tbl_wordLargeCategory C 
on B.fk_lgcategorycode = C.lgcategorycode 
where lower(A.title) like '%'|| lower('') || '%' 
order by seq desc; 


select rno, seq, lgcodename, mdcodename, title, content
from 
(
    select rownum AS RNO, 
           seq, lgcodename, mdcodename, title, content
    from
    (
        select A.seq, C.codename AS lgcodename, B.codename AS mdcodename, A.title, A.content 
        from tbl_wordContents A join tbl_wordMiddleCategory B 
        on A.fk_mdcategorycode = B.mdcategorycode  
        join tbl_wordLargeCategory C 
        on B.fk_lgcategorycode = C.lgcategorycode 
        where lower(A.title) like '%'|| lower('') || '%' 
        order by seq desc
    ) V
) T
where T.RNO between 1 and 3;


select rno, seq, lgcodename, mdcodename, title, content
from 
(
    select rownum AS RNO, 
           seq, lgcodename, mdcodename, title, content
    from
    (
        select A.seq, C.codename AS lgcodename, B.codename AS mdcodename, A.title, A.content 
        from tbl_wordContents A join tbl_wordMiddleCategory B 
        on A.fk_mdcategorycode = B.mdcategorycode  
        join tbl_wordLargeCategory C 
        on B.fk_lgcategorycode = C.lgcategorycode 
        where lower(A.title) like '%'|| lower('') || '%' 
        order by seq desc
    ) V
) T
where T.RNO between 4 and 6;


String sql = "select rno, seq, lgcodename, mdcodename, title, content\n"+
"from \n"+
"(\n"+
"    select rownum AS RNO, \n"+
"           seq, lgcodename, mdcodename, title, content\n"+
"    from\n"+
"    (\n"+
"        select A.seq, C.codename AS lgcodename, B.codename AS mdcodename, A.title, A.content \n"+
"        from tbl_wordContents A join tbl_wordMiddleCategory B \n"+
"        on A.fk_mdcategorycode = B.mdcategorycode  \n"+
"        join tbl_wordLargeCategory C \n"+
"        on B.fk_lgcategorycode = C.lgcategorycode \n"+
"        where lower(A.title) like '%'|| lower('') || '%' \n"+
"        order by seq desc\n"+
"    ) V\n"+
") T\n"+
"where T.RNO between 4 and 6";
 
 
select A.seq, C.codename AS lgcodename, B.codename AS mdcodename, A.title, A.content
from tbl_wordContents A join tbl_wordMiddleCategory B
on A.fk_mdcategorycode = B.mdcategorycode 
join tbl_wordLargeCategory C
on B.fk_lgcategorycode = C.lgcategorycode
where 1=1
and A.fk_mdcategorycode = 'A1'
order by seq desc; 

-------------------------------------------------------
select min(lgcategorycode) AS lgcategorycode
from tbl_wordLargeCategory;


select lgcategorycode, codename
from tbl_wordLargeCategory
order by seq asc;

select mdcategorycode, codename
from tbl_wordMiddleCategory
where fk_lgcategorycode = 'A'
order by seq asc;



-- [181204]
insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북1', '100000', 'DELL',
       '1.jpg','2.jpg',
       100,1200000,1000000,'HIT','1번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북2', '100000', '에이서',
       '3.jpg','4.jpg',
       100,1200000,1000000,'HIT','2번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북3', '100000', 'LG전자',
       '5.jpg','6.jpg',
       100,1200000,1000000,'HIT','3번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북4', '100000', '레노버',
       '7.jpg','8.jpg',
       100,1200000,1000000,'HIT','4번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북5', '100000', '삼성전자',
       '9.jpg','10.jpg',
       100,1200000,1000000,'HIT','5번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북6', '100000', 'HP',
       '11.jpg','12.jpg',
       100,1200000,1000000,'HIT','6번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북7', '100000', '레노버',
       '13.jpg','14.jpg',
       100,1200000,1000000,'HIT','7번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북8', '100000', 'LG전자',
       '15.jpg','16.jpg',
       100,1200000,1000000,'HIT','8번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북9', '100000', '한성컴퓨터',
       '17.jpg','18.jpg',
       100,1200000,1000000,'HIT','9번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북10', '100000', 'MSI',
       '19.jpg','20.jpg',
       100,1200000,1000000,'HIT','10번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북11', '100000', 'LG전자',
       '21.jpg','22.jpg',
       100,1200000,1000000,'HIT','11번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북12', '100000', 'HP',
       '23.jpg','24.jpg',
       100,1200000,1000000,'HIT','12번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북13', '100000', '레노버',
       '25.jpg','26.jpg',
       100,1200000,1000000,'HIT','13번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북14', '100000', '레노버',
       '27.jpg','28.jpg',
       100,1200000,1000000,'HIT','14번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북15', '100000', '한성컴퓨터',
       '29.jpg','30.jpg',
       100,1200000,1000000,'HIT','15번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북16', '100000', '한성컴퓨터',
       '31.jpg','32.jpg',
       100,1200000,1000000,'HIT','16번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북17', '100000', '레노버',
       '33.jpg','34.jpg',
       100,1200000,1000000,'HIT','17번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북18', '100000', '레노버',
       '35.jpg','36.jpg',
       100,1200000,1000000,'HIT','18번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북19', '100000', 'LG전자',
       '37.jpg','38.jpg',
       100,1200000,1000000,'HIT','19번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북20', '100000', 'LG전자',
       '39.jpg','40.jpg',
       100,1200000,1000000,'HIT','20번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북21', '100000', '한성컴퓨터',
       '41.jpg','42.jpg',
       100,1200000,1000000,'HIT','21번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북22', '100000', '에이서',
       '43.jpg','44.jpg',
       100,1200000,1000000,'HIT','22번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북23', '100000', 'DELL',
       '45.jpg','46.jpg',
       100,1200000,1000000,'HIT','23번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북24', '100000', '한성컴퓨터',
       '47.jpg','48.jpg',
       100,1200000,1000000,'HIT','24번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북25', '100000', '삼성전자',
       '49.jpg','50.jpg',
       100,1200000,1000000,'HIT','25번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북26', '100000', 'MSI',
       '51.jpg','52.jpg',
       100,1200000,1000000,'HIT','26번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북27', '100000', '애플',
       '53.jpg','54.jpg',
       100,1200000,1000000,'HIT','27번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북28', '100000', '아수스',
       '55.jpg','56.jpg',
       100,1200000,1000000,'HIT','28번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북29', '100000', '레노버',
       '57.jpg','58.jpg',
       100,1200000,1000000,'HIT','29번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북30', '100000', '삼성전자',
       '59.jpg','60.jpg',
       100,1200000,1000000,'HIT','30번 노트북', 60);

update jsp_product set pimage2='60.png' where pname='노트북30';

commit;

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북31', '100000', 'MSI',
       '61.jpg','62.jpg',
       100,1200000,1000000,'NEW','31번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북32', '100000', '삼성전자',
       '63.jpg','64.jpg',
       100,1200000,1000000,'NEW','32번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북33', '100000', '한성컴퓨터',
       '65.jpg','66.jpg',
       100,1200000,1000000,'NEW','33번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북34', '100000', 'HP',
       '67.jpg','68.jpg',
       100,1200000,1000000,'NEW','34번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북35', '100000', 'LG전자',
       '69.jpg','70.jpg',
       100,1200000,1000000,'NEW','35번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북36', '100000', '한성컴퓨터',
       '71.jpg','72.jpg',
       100,1200000,1000000,'NEW','36번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북37', '100000', '삼성전자',
       '73.jpg','74.jpg',
       100,1200000,1000000,'NEW','37번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북38', '100000', '레노버',
       '75.jpg','76.jpg',
       100,1200000,1000000,'NEW','38번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북39', '100000', 'MSI',
       '77.jpg','78.jpg',
       100,1200000,1000000,'NEW','39번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북40', '100000', '레노버',
       '79.jpg','80.jpg',
       100,1200000,1000000,'NEW','40번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북41', '100000', '레노버',
       '81.jpg','82.jpg',
       100,1200000,1000000,'NEW','41번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북42', '100000', '레노버',
       '83.jpg','84.jpg',
       100,1200000,1000000,'NEW','42번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북43', '100000', 'MSI',
       '85.jpg','86.jpg',
       100,1200000,1000000,'NEW','43번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북44', '100000', '한성컴퓨터',
       '87.jpg','88.jpg',
       100,1200000,1000000,'NEW','44번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북45', '100000', '애플',
       '89.jpg','90.jpg',
       100,1200000,1000000,'NEW','45번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북46', '100000', '아수스',
       '91.jpg','92.jpg',
       100,1200000,1000000,'NEW','46번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북47', '100000', '삼성전자',
       '93.jpg','94.jpg',
       100,1200000,1000000,'NEW','47번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북48', '100000', 'LG전자',
       '95.jpg','96.jpg',
       100,1200000,1000000,'NEW','48번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북49', '100000', '한성컴퓨터',
       '97.jpg','98.jpg',
       100,1200000,1000000,'NEW','49번 노트북', 60);

insert into jsp_product(pnum, pname, pcategory_fk, pcompany, 
                        pimage1, pimage2, pqty, price, saleprice,
                        pspec, pcontent, point)
values(seq_jsp_product_pnum.nextval, '노트북50', '100000', '레노버',
       '99.jpg','100.jpg',
       100,1200000,1000000,'NEW','50번 노트북', 60);

commit;

select pspec, count(*)
from jsp_product
where pspec = 'HIT'
group by pspec ;

String sql = "select pspec, count(*)\n"+
"from jsp_product\n"+
"where pspec = 'HIT'\n"+
"group by pspec";



-- ajax를 이용한 '더보기' 페이징 처리 쿼리
select pnum, pname, pcategory_fk, pcompany, pimage1, pimage2, pqty, price, saleprice, pspec, pcontent, point, pinputdate
from
(
select rownum as RNO, pnum, pname, pcategory_fk, pcompany, pimage1, pimage2, pqty, price, saleprice, pspec, pcontent, point, pinputdate
from
        (
        select pnum, pname, pcategory_fk, pcompany, pimage1, pimage2, pqty, price, saleprice, pspec, pcontent, point
                , to_char(pinputdate, 'yyyy-mm-dd') as pinputdate
        from jsp_product
        where pspec='HIT'
        order by pnum desc
        )V
)T
where T.RNO between 1 and 8;

-- row_number() over(order by 정렬기준) as rno 사용
select rno, pnum, pname, pcategory_fk, pcompany, pimage1, pimage2, pqty, price, saleprice, pspec, pcontent, point, pinputdate
from
        (
        select row_number() over(order by pnum desc) as rno,  pnum, pname, pcategory_fk, pcompany, pimage1, pimage2, pqty, price, saleprice, pspec, pcontent, point
                        , to_char(pinputdate, 'yyyy-mm-dd') as pinputdate
        from jsp_product
        where pspec='NEW'
        ) v
where v.rno between 1 and 8;

String sql = "select rno, pnum, pname, pcategory_fk, pcompany, pimage1, pimage2, pqty, price, saleprice, pspec, pcontent, point, pinputdate\n"+
"from\n"+
"        (\n"+
"        select row_number() over(order by pnum desc) as rno,  pnum, pname, pcategory_fk, pcompany, pimage1, pimage2, pqty, price, saleprice, pspec, pcontent, point\n"+
"                        , to_char(pinputdate, 'yyyy-mm-dd') as pinputdate\n"+
"        from jsp_product\n"+
"        where pspec=?\n"+
"        ) v\n"+
"where v.rno between ? and ?";

select pnum, pspec
from jsp_product
order by pnum asc;

update jsp_product set pspec = 'NEW'
where pnum >= 38;
commit;