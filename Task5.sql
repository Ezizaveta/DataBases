---5-1

---rewrite 1.3f:
-- SELECT Id FROM users WHERE(
--     users.Name IN (SELECT Author FROM tasks WHERE Author IS NOT NULL UNION
--                         SELECT Executor FROM tasks WHERE Executor IS NOT NULL));
with authors_and_executors as(
     select Author from tasks where Author is not NULL union
        select Executor from tasks where Executor is not NULL
)
select Id
from users
where (users.Name in (select * from authors_and_executors));

---rewrite 2.1
with max_priorities as (
    select title
    from tasks, users
    where (executor = users.Name)
    group by executor, title, priority
    order by priority desc limit 3
), min_priorities as (
    select title
    from tasks, users
    where (executor = users.Name)
    group by executor, title, priority
    order by priority asc limit 3
)

select distinct users.Name, tasks.title, tasks.priority
from users, tasks
where tasks.title in
    (
        select title from max_priorities
    )
union
select distinct users.Name, tasks.title, tasks.priority
from users, tasks
where tasks.title in
    (
        select title from min_priorities
    )
order by Name;

---rewrite 2.3.2 (with subselect)
with overwork as(
        select tasks.executor, (sum(tasks.spent_time - tasks.execution_time) +
                sum(abs(tasks.spent_time - tasks.execution_time)))/2 as "+"
        from tasks
        group by tasks.executor
 ),
    underwork as (
        select tasks.executor, (sum(tasks.execution_time - tasks.spent_time) +
                sum(abs(tasks.execution_time - tasks.spent_time)))/2 as "-"
        from tasks
        group by tasks.executor
 )

select users.id, underwork."-" as "-", overwork."+" as "+"
from users, overwork
    join underwork
    on overwork.executor = underwork.executor
where underwork.executor = users.Name
group by underwork."-", overwork."+", users.id;

---rewrite 2.10
with executors_among_users as(
    select distinct users.Name
			from users, tasks
			where users.Name = tasks.executor
)
select tasks.title, tasks.spent_time
from tasks
where tasks.executor in (select * from executors_among_users);
