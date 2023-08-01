DROP TABLE IF EXISTS users, projects, tasks;
SET datestyle = mdy;
CREATE TABLE users
(
    Id INTEGER NOT NULL,
    Name VARCHAR(30) PRIMARY KEY NOT NULL,
    Login VARCHAR(30),
    Email VARCHAR(30),
    Department VARCHAR(30)  CHECK (Department IN
        ('Производство', 'Поддержка пользователей', 'Бухгалтерия', 'Администрация')) NOT NULL
);

CREATE TABLE projects
(
    Name VARCHAR(30) PRIMARY KEY NOT NULL,
    Description VARCHAR(255) NULL,
    Start_Date DATE,
    End_Date DATE
);

CREATE TABLE tasks
(
    task_id integer,
    Title VARCHAR(30) NOT NULL,
	Project VARCHAR(30) NOT NULL,
    Priority INTEGER NOT NULL,
    Description VARCHAR(255) NULL,
    Status VARCHAR(30) CHECK (Status IN
        ('Новая', 'Переоткрыта', 'Закрыта', 'Выполняется')) NOT NULL,
    Execution_Time INTEGER,
	Spent_Time INTEGER,
	Author VARCHAR(30),
	Executor VARCHAR(30),
	Start_Date DATE,
	---AuthorId INTEGER NOT NULL,
	---ExecutorsId INTEGER,

	FOREIGN KEY (Project)  REFERENCES projects (Name),
	FOREIGN KEY (Author)  REFERENCES users (Name),
	FOREIGN KEY (Executor)  REFERENCES users (Name)
);

INSERT INTO users(Id, Name,Login,Email,Department) VALUES
(1, 'Касаткин Артём','a.kasatkin', 'a.kasatkin@mail.ru',N'Администрация'),
(2, 'Петрова София','s.petrova', 's.petrova@mail.ru',N'Бухгалтерия'),
(3, 'Дроздов Федр','f.drozdov', 'f.drozdov@mail.ru',N'Администрация'),
(4, 'Беркут Алексей','a.berkut', 'a.berkut@mail.ru',N'Поддержка пользователей'),
(5, 'Белова Вера','v.belova', 'v.belova@mail.ru',N'Производство'),
(6, 'Макенрой Алексей','a.makenroy', 'a.makenroy@mail.ru',N'Производство'),
(7, 'Иванова Василина', 'v.ivanova', 'v.ivanova@mail.ru', 'Бухгалтерия');

---show datestyle;
INSERT INTO projects(Name,Start_Date,End_Date) VALUES
('РТК',DATE'01/31/2022', NULL),
('СС.Коннект',DATE'02/23/2023',DATE'11/30/2023'),
('Демо-Сибирь',DATE'05/11/2022',DATE'02/28/2023'),
('МВД-Онлайн',DATE'05/22/2022',DATE'03/31/2023'),
('Сила воды',DATE'06/22/2022',DATE'03/31/2023'),
('Сила огня',DATE'07/22/2022',DATE'06/23/2023'),
('Сила нефти',DATE'08/22/2022',DATE'05/31/2023'),
('Поддержка',DATE'06/07/2022', NULL);

INSERT INTO tasks(task_id, Title,Project,Priority,Description,Status,
    Execution_Time,Spent_Time,Author,Executor,Start_Date) VALUES
        (1,'Task1', 'Поддержка', 1, NULL, 'Закрыта', 10, 9, 'Петрова София', NULL, DATE'01/01/2016' ),
        (2, 'Task2', 'РТК', 3, NULL, 'Выполняется', 12, 12, 'Петрова София', 'Касаткин Артём', DATE'01/01/2016'),
        (3, 'Task3', 'Демо-Сибирь',  8, '3 задача', 'Выполняется', 34, 21, 'Петрова София', NULL, DATE'01/01/2016'),
        (4, 'Task4', 'Поддержка', 5,  '4 задача', 'Новая', 15, 26, 'Дроздов Федр', 'Касаткин Артём', DATE'01/02/2016'),
        (5, 'Task5', 'СС.Коннект', 163,  NULL, 'Выполняется', 154, 45, 'Дроздов Федр', NULL, DATE'01/01/2016'),
        (6, 'Task6', 'СС.Коннект', 64,  NULL, 'Переоткрыта', 22, 33, 'Касаткин Артём', 'Касаткин Артём', DATE'01/03/2016'),
        (7, 'Task7', 'РТК', 10,  'очень сложная', 'Новая', 200, 139, 'Беркут Алексей', 'Дроздов Федр', DATE'01/01/2016'),
        (8, 'Task8', 'Демо-Сибирь', 2,  NULL, 'Новая', 100, 0, 'Макенрой Алексей', NULL, DATE'01/01/2016'),
        (9, 'Task9', 'МВД-Онлайн', 154,  'легчайшая', 'Выполняется', 111, 99, 'Макенрой Алексей', 'Белова Вера', DATE'01/01/2016'),
        (10, 'Task10', 'Демо-Сибирь', 6, 'средняя', 'Выполняется', 131, 100, 'Макенрой Алексей', 'Беркут Алексей', DATE'01/01/2016'),
        (11, 'Task11', 'МВД-Онлайн', 5,  NULL, 'Закрыта', 12, 22, 'Макенрой Алексей', 'Касаткин Артём', DATE'01/05/2017'),
        (12, 'Task12', 'РТК', 9,  NULL, 'Новая', 100, 0, 'Касаткин Артём', 'Иванова Василина', DATE'01/01/2016'),
        (13, 'Task13', 'Демо-Сибирь', 428,  NULL, 'Новая', 99, 2, 'Дроздов Федр', 'Беркут Алексей', DATE'01/01/2016'),
        (14, 'Task14', 'Демо-Сибирь', 12,  'ваще сложная', 'Закрыта', 34266, 24444, 'Петрова София', 'Иванова Василина', DATE'01/09/2017'),
        (15, 'Task15', 'СС.Коннект', 1,  NULL, 'Переоткрыта', NULL, NULL, 'Дроздов Федр', NULL, DATE'01/01/2016'),
        (16, 'Task16', 'СС.Коннект', 32,  NULL, 'Переоткрыта', 31, 31, 'Касаткин Артём', 'Петрова София', DATE'01/23/2023'),
        (17, 'Task17', 'СС.Коннект', 1,  NULL, 'Переоткрыта', 13, 14, 'Касаткин Артём', 'Петрова София', DATE'04/13/2022'),
        (18, 'Task18', 'СС.Коннект', 1,  NULL, 'Переоткрыта', 68, 7, 'Макенрой Алексей', 'Петрова София', DATE'01/01/2020');


---1-3

---a
SELECT * FROM tasks;
---b
SELECT Name, Department FROM users;
---c
SELECT Login, Email FROM users;
---d
SELECT Title FROM tasks WHERE (priority > 50);
---e
SELECT DISTINCT Executor FROM tasks WHERE (tasks.Executor IS NOT NULL);

---SELECT FirstName FROM users WHERE(Id = (SELECT DISTINCT ExecutorsId FROM tasks WHERE ExecutorsId is not NULL));---
---f переписать
SELECT DISTINCT Id FROM users, tasks WHERE(
    tasks.Executor = users.Name OR
    tasks.Author = users.Name);

SELECT Id FROM users WHERE(
    users.Name IN (SELECT Author FROM tasks WHERE Author IS NOT NULL UNION
                        SELECT Executor FROM tasks WHERE Executor IS NOT NULL)); ---  AND Executor IS NOT NULL
---k
SELECT Title FROM tasks WHERE(
    tasks.Author != 'Петрова София' AND
    tasks.Executor IN ('Иванова Василина', 'Сидоров Григорий', 'Беркут Алексей'));

---4
SELECT Title FROM tasks WHERE(
    (tasks.Executor LIKE '%Касаткин%') AND
    (Start_Date IN ('01/01/2016', '01/02/2016', '01/03/2016')));

---5
SELECT tasks.Title, users.Department  FROM tasks, users WHERE(
    (tasks.Executor LIKE '%Петрова%') AND
    (tasks.Author = users.Name) AND
    (users.Department) IN ('Администрация', 'Бухгалтерия', 'Производство'));

---6
SELECT Title FROM tasks WHERE(Executor IS NULL);

UPDATE tasks SET Executor = 'Петрова София' WHERE(Executor IS NULL);

---7
DROP TABLE IF EXISTS tasks2;
CREATE TABLE tasks2 AS (SELECT * FROM tasks);

---8
SELECT * FROM users WHERE(users.Name not like '%а %а');

SELECT * FROM users WHERE(
    users.Name like 'П%' and
    users.Name like '%р%');

