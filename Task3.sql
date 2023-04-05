---3.1 целостность на уровне таблиц:
drop table if exists a, b;
create table a
(
    id integer primary key not null,
    data varchar(30)
);

create table b
(
    id integer primary key not null,
    aid integer,
    data varchar(30),
    foreign key(aid) references a (id)
);

---insert:
insert into b values
    (1, 1, '1.1'),
    (2, 2, '2.2');

insert into a values
    (1, '1'),
    (2, '2'),
    (3, '3'),
    (4, '4');

insert into b values
    (3, 3, '3.3'),
    (4, 4, '4.4');

---delete:
delete from a where id = 1;
delete from a where id = 4;

---update:

update a
set id = 33
where id = 3;

update a
set id = 44
where id = 4;

update b
set aid = 44
where id = 4;

---3.1 целостность на уровне запросов:
drop table if exists b, a;
create table a
(
	id integer primary key,
	data varchar(100)
);

create table b
(
	id integer primary key,
	aid	integer,
	data varchar(100),

	foreign key (aid) references a (id) on delete cascade on update cascade
);

---insert:
insert into b (id, aid, data)
select 1, a.id, 'value'
from a
where a.id = 1;

insert into a (id, data)
select 1, 'value';

insert into b (id, aid, data)
select 1, a.id, a.data
from a
where a.id = 1;

---delete:
delete
from a
where data like 'value';

---update:
update a
set id = 2
where id = 1;


---3.2
---один к одному
drop table if exists account, clients;
create table clients
(
    id integer primary key not null,
    name varchar(30)
);

create table account
(
    id integer primary key,
    uid integer unique,
    currency varchar(30),
    balance integer,

    foreign key (uid) references clients(id),
    check (currency in ('рубль', 'доллар', 'евро', 'юань'))
);

insert into clients values
    (1, 'Иванов Александр'),
    (2, 'Петров Василий'),
    (3, 'Первый Петр'),
    (4, 'Пельман Оксана'),
    (5, 'Бабулин Геннадий');

insert into account values
    (1, 2, 'рубль', 2134),
    (2, 3, 'рубль', 5465),
    (3, 4, 'юань', 556),
    (4, 5, 'доллар', 655),
    (5, 1, 'евро', 4135);

---один к многим
---пользователь может иметь много карт, но у каждой карты один пользователь
drop table if exists account, clients, cards;
create table cards
(
    id integer primary key,
    date integer
);

create table clients
(
    id integer,
    name varchar(30),
    card_id integer,

    primary key (id, card_id),
    foreign key (card_id) references cards (id)
);

insert into cards values
    (1, 2020),
    (2, 2016),
    (3, 2021),
    (4, 2035),
    (5, 2023);

insert into clients(id, name, card_id) values
    (1, 'Иванов Александр', 1),
    (2, 'Петров Василий', 2),
    (1, 'Иванов Александр', 3),
    (1, 'Иванов Александр', 4),
    (2, 'Петров Василий', 5);

---многие ко многим:
drop table if exists clients, banks, bank_client;
create table clients
(
    id integer primary key,
    name varchar(30)
);

create table banks
(
    id integer primary key,
    name varchar(30)
);

create table bank_client
(
    id integer primary key,
    client_id integer,
    bank_id integer,

    foreign key (client_id) references clients(id),
    foreign key (bank_id) references banks (id),
    unique (client_id, bank_id)
);

insert into clients values
    (1, 'Иванов Александр'),
    (2, 'Петров Василий'),
    (3, 'Первый Петр'),
    (4, 'Пельман Оксана'),
    (5, 'Бабулин Геннадий');

insert into banks values
    (1, 'Сбер'),
    (2, 'Тинькофф'),
    (3, 'Райффайзен'),
    (4, 'ВТБ'),
    (5, 'Левобережный');

insert into bank_client(id, bank_id, client_id) values
    (1, 1, 1),
    (2, 1, 3),
    (3, 2, 2),
    (4, 2, 3),
    (5, 2, 4),
    (6, 3, 1),
    (7, 3, 4);
