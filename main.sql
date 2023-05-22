# make the tables based on csv

DROP TABLE IF EXISTS departments CASCADE;
DROP TABLE IF EXISTS titles CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS dep_emp CASCADE;
DROP TABLE IF EXISTS dep_manager CASCADE;
DROP TABLE IF EXISTS salaries CASCADE;

CREATE TABLE employees
(
	emp_no INT PRIMARY KEY NOT NULL,
    emp_title_id VARCHAR NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	gender VARCHAR NOT NULL,
	hire_date DATE NOT NULL
);

SELECT * FROM public.employees

CREATE TABLE departments(
	dept_no VARCHAR PRIMARY KEY NOT NULL,
	dept_name VARCHAR NOT NULL
);

SELECT * FROM public.departments

CREATE TABLE dep_emp(
	emp_no INT NOT NULL,
	dept_no VARCHAR NOT NULL,
	PRIMARY KEY(emp_no, dept_no),
	FOREIGN KEY(emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

SELECT * FROM public.dep_emp

CREATE TABLE dept_manager(
    dept_no VARCHAR NOT NULL,
    emp_no INT NOT NULL,
    FOREIGN KEY(emp_no) REFERENCES employees (emp_no),
    FOREIGN KEY(dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY(dept_no, emp_no)
);

SELECT * FROM public.dept_manager

create table salaries (
    emp_no INT NOT NULL,
    salary INT NOT NULL,
    PRIMARY KEY (emp_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

SELECT * FROM public.salaries

create table titles (
    title_id VARCHAR  NOT NULL,
    title VARCHAR NOT NULL,
    PRIMARY KEY (title_id)
);

SELECT * FROM public.titles

## DATA ANALYSIS

# List the employee number, last name, first name, sex, and salary of each employee (2 points)

SELECT 
    employees.emp_no, employees.last_name,
    employees.first_name, employees.gender,
    salaries.salary
FROM 
    employees
LEFT JOIN 
    salaries
ON 
    employees.emp_no = salaries.emp_no
ORDER BY 
    emp_no

# List the first name, last name, and hire date for the employees who were hired in 1986 (2 points)

SELECT
    employees.last_name, employees.first_name,
    employees.hire_date
FROM
    employees
WHERE
    hire_date BETWEEN '1/1/1986' AND '12/31/1986'
ORDER BY
    hire_date
    
# List the manager of each department along with their department number, department name, employee number, last name, and first name (2 points)

SELECT employees.last_name,
    employees.first_name, dept_manager.emp_no,
    departments.dept_no, departments.dept_name
FROM 
    departments, employees
JOIN
    dept_manager
ON
    dept_manager.emp_no = employees.emp_no

# List the department number for each employee along with that employee’s employee number, last name, first name, and department name (2 points)

SELECT employees.emp_no, employees.last_name, 
	employees.first_name, departments.dept_name
FROM 
	departments
JOIN 
	dep_emp
ON 
	departments.dept_no = dep_emp.dept_no
JOIN 
	employees
ON 
	employees.emp_no = dep_emp.emp_nos

# List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B (2 points)

SELECT employees.first_name, employees.last_name,
    employees.gender
FROM
    employees
WHERE
    employees.first_name = 'Hercules'
AND
    employees.last_name LIKE 'B%'


# List each employee in the Sales department, including their employee number, last name, and first name (2 points)

SELECT employees.emp_no, employees.last_name,
    employees.first_name, departments.dept_name
FROM 
    departments, employees
WHERE
    departments.dept_name = 'Sales'


# List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name (4 points)

SELECT employees.emp_no, employees.last_name,
    employees.first_name, departments.dept_name
FROM 
    departments, employees
WHERE
    departments.dept_name = 'Sales' 
OR 
	departments.dept_name = 'Development'

# List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name) (4 points)

SELECT 
	employees.last_name, 
	COUNT(employees.last_name) AS "Frequency "
FROM 
	employees
GROUP BY 
	employees.last_name
ORDER BY 
	COUNT(employees.last_name) DESC;
