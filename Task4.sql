---4-1
--inner join
select *
from tasks
    inner join projects p
        on tasks.project = p.name;

--full outer
select *
from projects full outer join tasks t
    on projects.name = t.project;

select *
from projects full outer join tasks t
    on projects.name = t.project
where projects.name is null or t.project is null;

--left
select *
from users left outer join tasks t
    on users.name = t.author;

select *
from users left outer join tasks t
    on users.name = t.author
where t.author is not null;

--right
select *
from tasks right outer join users
    on tasks.author = users.name;

select *
from tasks right outer join users
    on tasks.author = users.name
where tasks.author is not null;

---4-2
-- SELECT идентификатор задачи, название задачи FROM Задачи As out
-- WHERE Приоритет = (SELECT MAX(Приоритет) FROM Задачи As int WHERE int.Автор = out.Автор)
select out.id, out.title
from tasks as out, tasks as inp
where inp.author = out.author
group by out.id, out.title, out.priority
having max(inp.priority) = out.priority;


--4-3
select users.login
from users
where users.name in (select distinct tasks.executor from tasks);

select distinct users.login
from users, tasks
where users.name = tasks.executor;

select distinct users.login
from users
left outer join tasks
on users.name = tasks.executor
where tasks.executor is not null;
--4-4
select start_date from projects union
                        select end_date from projects;

--4-5
select p.name, t.title from tasks as t, projects as p;
select p.name, t.title from tasks as t cross join projects as p;