--6-1

drop table if exists a, b;

create table a
(
    id  integer,
    val varchar(10)
);

create table b
(
    id  integer,
    val varchar(10)
);
insert into a values
                  (1, 'a1'),
                  (2, 'a2');

insert into b values
                  (1, 'b1'),
                  (2, 'b2');

--6-1--
--deadlock demonstration
begin;
lock table a in exclusive mode;
lock table b in exclusive mode;
commit;

--paste this code below in other query console
--start
begin;
lock table b in exclusive mode;
lock table a in exclusive mode;
commit;
-- end


-- 6-2:
-- procedure
drop table if exists client_accounts;

create table client_accounts
(
    name varchar(100) primary key,
    id int not null,
    balance int not null
);

insert into client_accounts values
    ('Петров Виктор', 1, 5999),
    ('Красова Алина', 2, 6000),
    ('Красноухов Алексей', 3, 56),
    ('Колесников Александр', 4, 600),
    ('Киргизов Батыр', 5, 700);


drop function if exists transfer;

create or replace procedure transfer(in sender_id int, recipient_id int, sum int)
language plpgsql
 as
$$
begin
	update client_accounts
    set balance = balance - sum
    where id = sender_id;

	update client_accounts
	set balance = balance + sum
	where id = recipient_id;

	if (select balance
		from client_accounts
		where id = sender_id) < 0
	then
		rollback;
	end if;
	return;
exception
    when others then
		return;
end;
$$;

call transfer(1, 2, 10);

---savepoint, rollback
begin;
	insert into a values (1);
	savepoint sp;
	insert into a values (2);
	rollback to savepoint sp;
	insert into a values (3);
commit;

select * from a;


---part2
drop trigger if exists update_a_trigger on a;
drop trigger if exists update_b_trigger on b;

create or replace function update_a_func()
returns trigger as
$$
begin
	update b
	set val = new.val
	where val = old.val;
	return new;
end;
$$ language 'plpgsql';

create or replace function update_b_func()
returns trigger as
$$
begin
	update a
	set val = new.val
	where val = old.val;
	return new;
end;
$$ language 'plpgsql';

create trigger update_a_trigger
before update
on a
for each row
execute function update_a_func();

create trigger update_b_trigger
before update
on b
for each row
execute function update_b_func();

insert into a (id, val)
values (4, '4'),
	   (5, '5'),
	   (6, '6');

insert into b (id, val)
values (5, '5');

update a
set id = id + 10
where val = '2';



--6-3

with recursive r as (
    select start_date
	from tasks
    where start_date = DATE'01/01/2016'

    union

	select start_date
    from r
    where start_date <= DATE'01/01/2020'
--     where (start_date + interval '1' day)::timestamp::date <= DATE'01/01/2020'
--     limit 1
)

select * from r;


---6-5

drop table if exists tasks_history;
create table tasks_history
(
    history_id      serial,
    time_change     timestamp,
    operation       varchar(30) check (operation in ('insert', 'delete', 'update')),
    exists          boolean,
    -- data from tasks
    task_id integer,
    title varchar(30),
	project varchar(30),
    priority integer,
    description varchar(255) null,
    status varchar(30) check (Status in
        ('Новая', 'Переоткрыта', 'Закрыта', 'Выполняется')),
    execution_time integer,
	spent_time integer,
	author varchar(30),
	executor varchar(30),
	start_date date,

	FOREIGN KEY (Project)  REFERENCES projects (Name),
	FOREIGN KEY (Author)  REFERENCES users (Name),
	FOREIGN KEY (Executor)  REFERENCES users (Name),
    primary key (history_id)
);
--
-- drop trigger if exists changes_trigger on tasks;
-- drop function if exists changes_trigger_foo() cascade;
--
-- create or replace function changes_trigger_foo()
-- returns trigger as
-- $$
-- begin
--
--     if tg_op = 'insert' or tg_op = 'update' then
--         insert into tasks_history (time_change, exists, task_id, title, project, author, executor,
--                                    priority, status, execution_time, spent_time, start_date)
--         values (now(), true, new.task_id, new.title, new.project, new.creator, new.executor,
--                 new.priority, new.status, new.execution_time, new.spent_time, new.start_date);
--     end if;
--
--     if tg_op = 'delete' then
--         insert into tasks_history (time_change, exists, task_id, title, project, author, executor,
--                                    priority, status, execution_time, spent_time, start_date)
--         values (now(), false, old.task_id, old.title, old.project, old.author, old.executor,
--                 old.priority, old.status, old.execution_time, old.spent_time, old.start_date);
--     end if;
--
--     return new;
-- end;
-- $$ language plpgsql;
--
-- create trigger changes_trigger
-- after insert or update or delete
-- on tasks
-- for each row
-- execute function changes_trigger_foo();

drop trigger if exists insert_trigger on tasks;
drop trigger if exists update_trigger on tasks;
drop function if exists insert_function() cascade;
drop function if exists delete_function() cascade;
drop function if exists update_function() cascade;

create or replace function insert_function()
returns trigger as
$$
begin
    insert into tasks_history (time_change, operation, exists, task_id, title, project, author, executor,
                                   priority, status, execution_time, spent_time, start_date)
        values (now(), 'insert', true, new.task_id, new.title, new.project, new.author, new.executor,
                new.priority, new.status, new.execution_time, new.spent_time, new.start_date);
    return new;
end;
$$ language plpgsql;

create or replace procedure delete_function(title_to_del varchar(30))
language plpgsql as
$$
declare
    task_id_tmp integer;
begin
    select task_id into task_id_tmp from tasks where title = title_to_del;

    insert into tasks_history (time_change, operation, exists, task_id)
    values (now(), 'delete', false, task_id_tmp);
--         values (now(), 'delete', false, old.task_id, old.title, old.project, old.author, old.executor,
--                 old.priority, old.status, old.execution_time, old.spent_time, old.start_date);
    delete from tasks
        where title = title_to_del;
end;
$$ ;


create or replace function update_function()
returns trigger as
$$
begin
    insert into tasks_history (time_change, operation, exists, task_id, title, project, author, executor,
                                   priority, status, execution_time, spent_time, start_date)
        values (now(), 'update', true, new.task_id, new.title, new.project, new.author, new.executor,
                new.priority, new.status, new.execution_time, new.spent_time, new.start_date);
    return new;
end;
$$ language plpgsql;

create or replace trigger insert_trigger
after insert on tasks
for each row
execute procedure insert_function();

create or replace trigger update_trigger
after update on tasks
for each row
execute procedure update_function();


INSERT INTO tasks(task_id, Title,Project,Priority,Description,Status,
    Execution_Time,Spent_Time,Author,Executor,Start_Date) VALUES
        (1,'Task1', 'Поддержка', 1, NULL, 'Закрыта', 10, 9, 'Петрова София', NULL, DATE'01/01/2016' );

call delete_function('NewTask3');
INSERT INTO tasks(task_id, Title,Project,Priority,Description,Status,
    Execution_Time,Spent_Time,Author,Executor,Start_Date) VALUES
        (1,'Task1', 'Поддержка', 1, NULL, 'Закрыта', 10, 9, 'Петрова София', NULL, DATE'01/01/2016' );

update tasks
set title = 'NewTask3'
where task_id = 5;

-- 6-5.c
create or replace  function get_tasks()
returns table (
    task_id integer,
    title varchar(30),
	project varchar(30),
    priority integer,
    description varchar(100),
    status varchar(30),
    execution_time integer,
	spent_time integer,
	author varchar(30),
	executor varchar(30),
	start_date date)
language plpgsql as
$$
begin
return query
select th.task_id, th.Title, th.Project, th.Priority, th.Description, th.Status,
    th.Execution_Time, th.Spent_Time, th.Author, th.Executor, th.Start_Date from tasks_history th
where exists = true;
end
$$;

select * from get_tasks();



