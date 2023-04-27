---3.1
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

---3.1
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


--3-3-1
create table auditorium_participants
(
    id integer not null,
    number_of_seats integer,
    participants varchar(1000)
);

insert into auditorium_participants values
    (1, 53, 'Пупкин Вася, Иванов Саша'),
    (2, 10, 'Иванов Кирилл, Медведев Иван, Куролесников Петр'),
    (3, 15, 'Кривозайцева Мария, Лешина Екатерина, Заморский Иван, Дубов Алексей, Чернов Валерий'),
    (4, 20, 'Скоровойтов Дмитрий'),
    (5, 30, 'Кто-то-тамов Сергей, Чья-то-тамова Александра'),
    (6, 35, 'Сырников Михаил');
--try select all participants id by its names
--3-3-2
drop table if exists winners, participants;
create table participants
(
    id integer primary key,
    participant varchar(100)
);
create table winners
(
    id integer primary key,
    winner varchar(100),
    winner_id integer,
    discipline varchar(100),
    organizer varchar(100),

    foreign key (winner_id) references participants(id)
);

---аномалия вставки: в результате появился новый организатор
insert into participants values
    (1, 'Петров Виктор'),
    (2, 'Красова Алина'),
    (3, 'Красноухов Алексей'),
    (4, 'Кизилов Максим'),
    (5, 'Киргизов Батыр');

insert into winners values
    (1, 'Петров Виктор', 1, 'Python', 'Комаров Василий'),
    (2, 'Красова Алина', 2, 'Нейронные сети', 'Бибкин Александр'),
    (3, 'Красноухов Алексей', 3, 'Нефтехим', 'Чуркин Александр'),
    (4, 'Кизилов Максим', 4, 'Python', 'Чудаков Павел'),
    (5, 'Киргизов Батыр', 5, 'Java', 'Олежин Олег');

---аномалия модификации: данные таблиц participants и winners неконсистентны
-- update participants set id = 10
-- where id = 1;
update participants set participant = 'Колесников Александр'
where id = 1;
---аномалия удаления: теряем данные о направлении
delete from winners where winner = 'Красова Алина';

--3-4
drop table if exists banks_clients;
create table banks_clients
(
    bank varchar(100),
    office_num varchar(100),
    clients varchar(100)
);

insert into banks_clients values
    ('Сбер', '900', 'Петров Виктор, Красова Алина, Красноухов Алексей'),
    ('Тинькофф', '338-400', 'Красноухов Алексей, Киргизов Батыр'),
    ('Райффайзен', '312-321', 'Петров Виктор, Красноухов Алексей'),
    ('ВТБ', '12-222', 'Киргизов Батыр, Колесников Александр'),
    ('Левобережный', '5555', 'Кизилов Максим');

---приведение к 1НФ

delete from banks_clients;
--для демонстрации следующего приведения:
alter table banks_clients add column account_number integer;
alter table banks_clients add column office_street varchar(100);
alter table banks_clients add column office_housenum integer;

--1НФ:
insert into banks_clients values
    ('Сбер', '900','Петров Виктор', 5999, 'Пушкина', 9),
    ('Сбер', '900', 'Красова Алина', 6000, 'Пушкина', 9),
    ('Сбер', '900-3', 'Красноухов Алексей', 56, 'Вавилова', 12),
    ('Тинькофф', '338-400-1','Красноухов Алексей', 600, 'Ленина', 12),
    ('Тинькофф', '338-400-2','Киргизов Батыр', 700, 'Жукова', 66),
    ('Райффайзен', '312-321','Петров Виктор', 800, 'Ильича', 17),
    ('Райффайзен', '312-321','Красноухов Алексей', 790, 'Ильича', 17),
    ('ВТБ', '12-222', 'Киргизов Батыр', 900, 'Высоцкого', 45),
    ('ВТБ', '12-222', 'Колесников Александр', 1000, 'Высоцкого', 45),
    ('Левобережный', '5555', 'Кизилов Максим', 400, 'Троцкого', 10);

--приведение к 2НФ: зависимость номера счета от клиента

drop table if exists client_office_account, office_bank_address;

create table client_office_account as (
    select clients, office_num, account_number from banks_clients);

create table office_bank_address as (
    select office_num, bank, office_street, office_housenum from banks_clients);


--для 3НФ:
alter table client_office_account add column sum integer;
---приведение к 3НФ:

create table account_sum as (
    select account_number, sum from client_office_account );
alter table client_office_account drop column sum;

---приведение к 4НФ:
--Пусть есть таблица с данными (bank, address, clients) со множественными зависимостями
--Разбиваем на 2 таблицы, убирая множественность: (bank, clients), (bank,address)