--Criando a tabela students:

CREATE TABLE students (
    id serial PRIMARY KEY,
    name text,
    enrolled_at date,
    course_id text
);

-- Inserindo dados na tabela students:

INSERT INTO students (name, enrolled_at, course_id)
VALUES
    ('Gabriela', '2023-02-15', '101'),
    ('Éder', '2023-01-20', '102'),
    ('Kelvyn', '2023-03-10', '101'),
    ('Sérgio', '2023-02-28', '103'),
    ('Pedro', '2023-01-10', '104');

-- Criando a tabela courses:

CREATE TABLE courses (
    id text PRIMARY KEY,
    name text,
    price numeric,
    school_id text
);

-- Inserindo dados na tabela courses:

INSERT INTO courses (id, name, price, school_id)
VALUES
    ('101', 'Java', 250.00, 'A001'),
    ('102', 'Python', 200.00, 'A002'),
    ('103', 'Postgresql', 180.00, 'A001'),
    ('104', 'Big Data', 220.00, 'A003'),
    ('105', 'Javascript', 270.00, 'A002');

-- Criando tabela schools:

CREATE TABLE schools (
    id text PRIMARY KEY,
    name text
);

-- Inserindo dados na tabela schools: 

INSERT INTO schools (id, name)
VALUES
    ('A001', 'School A'),
    ('A002', 'School B'),
    ('A003', 'School C'),
    ('A004', 'School D');

-- Inserindo cursos que iniciam com Data

INSERT INTO courses (id, name, price, school_id)
VALUES
    ('106', 'Data Science Basics', 300.00, 'A004'),
    ('107', 'Data Analysis Fundamentals', 280.00, 'A002'),
    ('108', 'Data Visualization Techniques', 260.00, 'A001');

-- Inserindo mais alunos para associar com os cursos de Data:

INSERT INTO students (name, enrolled_at, course_id)
VALUES
    ('Rafael', '2023-03-20', '106'),
    ('Mariana', '2023-03-18', '107'),
    ('Marcela', '2023-03-22', '106'),
    ('Giovanna', '2023-03-25', '108'),
    ('Lonardo', '2023-03-24', '107');

-- RESPOSTAS:

-- A) 

SELECT TO_CHAR(DATE_TRUNC('week', s.enrolled_at), 'YYYY-MM-DD') AS semana, sc.name, COUNT(s.name), sum(co.price) FROM students s
JOIN courses co on s.course_id = co.id
JOIN schools sc on sc.id = co.school_id
WHERE co.name LIKE 'Data%'
GROUP BY sc.name, semana
ORDER by  semana

-- B)

WITH Subquery AS (
    SELECT TO_CHAR(DATE_TRUNC('week', s.enrolled_at), 'YYYY-MM-DD') AS semana, sc.name AS school_name, COUNT(s.name) AS aluno_count
    FROM students s
    JOIN courses co on s.course_id = co.id
    JOIN schools sc on sc.id = co.school_id
    WHERE co.name LIKE 'Data%'
    GROUP BY sc.name, semana
)

SELECT semana, school_name, aluno_count, RANK() OVER (PARTITION BY semana ORDER BY aluno_count DESC) AS ranking
FROM Subquery
ORDER BY semana, ranking;