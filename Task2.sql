---TASK2
---1

select distinct users.Name, tasks.title, tasks.priority
from users, tasks
where tasks.title in
    (
    select title
    from tasks
    where (executor = users.Name)
    group by executor, title, priority
    order by priority desc limit 3
    )
union
select distinct users.Name, tasks.title, tasks.priority
from users, tasks
where tasks.title in
    (
    select title
    from tasks
    where (executor = users.Name)
    group by executor, title, priority
    order by priority asc limit 3
    )
order by Name;

---2
select
 	distinct
    concat(count(title),
	extract (month from start_date),
	extract(year from start_date),
	users.Name)
from users, tasks
where users.Name = tasks.author
group by users.Name, tasks.start_date;

---3.1
SELECT users.Id,
       (sum(tasks.spent_time - tasks.execution_time) + sum(abs(tasks.spent_time - tasks.execution_time)))/2 as "+",
       (sum(tasks.execution_time - tasks.spent_time) + sum(abs(tasks.execution_time - tasks.spent_time)))/2 as "-"
FROM users, tasks
WHERE(users.Name = tasks.executor)
GROUP BY users.Id;

---3.2

select users.id, underwork."-" as "-", overwork."+" as "+"
from users,
     (
        select tasks.executor, (sum(tasks.spent_time - tasks.execution_time) +
                sum(abs(tasks.spent_time - tasks.execution_time)))/2 as "+"
        from tasks
        group by tasks.executor
     ) as overwork
    join
     (
        select tasks.executor, (sum(tasks.execution_time - tasks.spent_time) +
                sum(abs(tasks.execution_time - tasks.spent_time)))/2 as "-"
        from tasks
        group by tasks.executor
     ) as underwork
    on overwork.executor = underwork.executor
where underwork.executor = users.Name
group by underwork."-", overwork."+", users.id;

---4
SELECT Author, Executor FROM tasks WHERE Author > Executor
UNION
    SELECT Executor, Author FROM tasks WHERE Executor >= Author;
---5
SELECT Login, LENGTH(Login) as size  FROM users ORDER BY LENGTH(Login) DESC LIMIT 1;

---6
drop table if exists table1, table2;
create table table1
(
    str char(32)
);

create table table2
(
    str varchar(32)
);

insert into table1
values ('1234567');

insert into table2
values ('1234567');

select sum(pg_column_size(table1.str)) "char", sum(pg_column_size(table2.str)) "varchar"
from table1, table2;

---7
select Executor, max(Priority) as "max", min(Priority) as "min"
from tasks
group by tasks.Executor
having tasks.Executor is not NULL;

---8
select executor, sum(execution_time)
from tasks
group by executor, execution_time
having (execution_time > avg(case when status != 'Закрыта' then execution_time else 0 end));

---9
drop view executors;
create view executors as
    select executor,
       count(executor) as tasks_number,
       count(case when spent_time >= tasks.execution_time then 1 else 0 end) as tasks_on_time,
       count(case when spent_time < tasks.execution_time then 1 else 0 end) as delayed_tasks,
       count(case when status = 'Новая' or status = 'Переоткрыта' then 1 else 0 end) as opened,
       count(case when status = 'Закрыта' then 1 else 0 end) as closed,
       count(case when status = 'Выполняется' then 1 else 0 end) as in_process,
       sum(spent_time) as spent_time,
       sum(case when spent_time > execution_time then spent_time - execution_time else 0 end) as sum_underwork,
       sum(case when spent_time < execution_time then execution_time - spent_time else 0 end) as sum_overwork,
        count(case when author = 'Петрова София' then 1 else 0 end) as author_Petrova,
        avg(case when spent_time > 10 then spent_time else 0 end) as spent_more_10
    from tasks
    group by  executor
    having executor is not NULL;

-- 2.10
select distinct users.email, tasks.executor
from users, tasks
where users.Name = tasks.executor;

select distinct users.email, users.Name
from users
where users.Name in (select distinct tasks.author from tasks);

select tasks.title, tasks.spent_time
from tasks
where tasks.executor in (select distinct users.Name
			from users
			where users.Name = tasks.executor);