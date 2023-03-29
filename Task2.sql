---TASK2
---1
select users.firstname, tasks.title, tasks.priority
from users, tasks
where tasks.title in (
    select title
    from tasks
    where (executor = users.firstname)
    group by executor, title, priority
    order by tasks.priority desc limit 3)
union all
select users.firstname, tasks.title, tasks.priority
from users, tasks
where tasks.title in (
    select title
    from tasks
    where executor = users.firstname
    group by executor, title, priority
    order by tasks.priority asc limit 3)
order by firstname, priority;
---2
select tasks.author, users.id, count(start_date) as tasks_per_months,
    extract(MONTH from start_date) as month,
    extract(YEAR  from start_date) as year
from tasks, users
where(tasks.author = users.firstname)
group by author, start_date, users.id;

---3.1 TODO: через мат. операцию
SELECT Id,
       sum(case when tasks.spent_time > tasks.execution_time then tasks.spent_time - tasks.execution_time else 0 end) as "+",
       sum(case when tasks.spent_time < tasks.execution_time then tasks.execution_time - tasks.spent_time else 0 end) as "-"
FROM users, tasks
WHERE(users.firstname = tasks.executor)
GROUP BY Id;

---3.2
SELECT Id, sum(underwork.under) as "-", sum(overwork.over) as "+"
FROM users,
     (SELECT (tasks.execution_time - tasks.spent_time) as under, executor
      FROM tasks
      WHERE tasks.execution_time > tasks.spent_time) as underwork,

     (SELECT (tasks.spent_time - tasks.execution_time) as over, executor
      FROM tasks
      WHERE tasks.spent_time > tasks.execution_time) as overwork
--WHERE users.firstname = overwork.executor and
--   overwork.executor = underwork.executor
GROUP BY Id;
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

---select Executor, max(Priority) as "max" from tasks

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
where users.firstname = tasks.executor;

select distinct users.email, users.firstname
from users
where users.firstname in (select distinct tasks.author from tasks);

select tasks.title, tasks.spent_time
from tasks
where tasks.executor in (select distinct users.firstname
			from users
			where users.firstname = tasks.executor);