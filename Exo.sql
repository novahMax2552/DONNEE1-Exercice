-- =========================
-- Création des tables
-- =========================

CREATE TABLE Team (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE Employee (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    contract_type VARCHAR(50),
    salary INT,
    team_id INT,
    FOREIGN KEY (team_id) REFERENCES Team(id)
);

CREATE TABLE Leave (
    id SERIAL PRIMARY KEY,
    start_date DATE,
    end_date DATE,
    employee_id INT NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES Employee(id)
);

-- =========================
-- Requêtes demandées
-- =========================

-- 1. Employés sans équipe
SELECT id, first_name, last_name
FROM Employee
WHERE team_id IS NULL;

-- 2. Employés n’ayant jamais pris de congé
SELECT e.id, e.first_name, e.last_name
FROM Employee e
LEFT JOIN Leave l ON e.id = l.employee_id
WHERE l.id IS NULL;

-- 3. Congés avec infos employé + équipe
SELECT l.id AS leave_id,
       l.start_date,
       l.end_date,
       e.first_name,
       e.last_name,
       t.name AS team_name
FROM Leave l
JOIN Employee e ON l.employee_id = e.id
LEFT JOIN Team t ON e.team_id = t.id;

-- 4. Nombre d’employés par type de contrat
SELECT contract_type, COUNT(*) AS employee_count
FROM Employee
GROUP BY contract_type;

-- 5. Nombre d’employés en congé aujourd’hui
SELECT COUNT(DISTINCT employee_id) AS employees_on_leave_today
FROM Leave
WHERE CURRENT_DATE BETWEEN start_date AND end_date;

-- 6. Détails des employés en congé aujourd’hui
SELECT e.id,
       e.first_name,
       e.last_name,
       t.name AS team_name
FROM Leave l
JOIN Employee e ON l.employee_id = e.id
LEFT JOIN Team t ON e.team_id = t.id
WHERE CURRENT_DATE BETWEEN l.start_date AND l.end_date;
