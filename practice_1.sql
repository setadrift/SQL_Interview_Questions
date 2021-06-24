# Create schema for Q1
CREATE DATABASE IF NOT EXISTS practice;
# TABLE STRUCTURE FOR: salary
CREATE TABLE IF NOT EXISTS `salary` (
  `id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `employee_id` int(9) unsigned NOT NULL,
  `amount` int(9) unsigned NOT NULL,
  `pay_date` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO salary (id, employee_id, amount, pay_date)
VALUES ( 1  , 1 , 9000   , 2017-03-31), (2 , 2 , 6000, '2017-03-31'), (3, 3,10000,'2017-03-31'),  (4,   1 , 7000   , '2017-02-28'), (5  , 2 , 6000   , '2017-02-28'), (6  , 3 , 8000   , '2017-02-28');
## employee table
CREATE TABLE IF NOT EXISTS `employee` (
  `employee_id` varchar(255) NOT NULL,
  `department_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO employee (employee_id, department_id)
VALUES ( 1 , 1  ), (2 , 2 ), (3 , 2 );
SELECT * FROM employee;
## Let's begin Q1 ##
#### Thought Process ####
# 1. Let's do initial joins needed
SELECT * 
FROM salary 
JOIN employee USING (employee_id);
# 2. Consider intermediary columns needed for final table. Select / engineer those.
SELECT DATE_FORMAT(pay_date, "%Y-%m") AS pay_month, department_id,
    AVG(amount) OVER(PARTITION BY DATE_FORMAT(pay_date, "%m"), department_id) AS dept_avg,
    AVG(amount) OVER(PARTITION BY DATE_FORMAT(pay_date, "%m")) AS comp_avg
FROM salary JOIN employee
USING (employee_id);
# 3. Convert to sub-query & pipe into a blank final query
With t1 AS 
(
	SELECT DATE_FORMAT(pay_date, "%Y-%m") AS pay_month, department_id,
    AVG(amount) OVER(PARTITION BY DATE_FORMAT(pay_date, "%m"), department_id) AS dept_avg,
    AVG(amount) OVER(PARTITION BY DATE_FORMAT(pay_date, "%m")) AS comp_avg
	FROM salary JOIN employee
	USING (employee_id)
) 
SELECT * FROM t1;
# 4. Do relevant selections & feature engineering for final display 
With t1 AS 
(
	SELECT DATE_FORMAT(pay_date, "%Y-%m") AS pay_month, department_id,
    AVG(amount) OVER(PARTITION BY DATE_FORMAT(pay_date, "%m"), department_id) AS dept_avg,
    AVG(amount) OVER(PARTITION BY DATE_FORMAT(pay_date, "%m")) AS comp_avg
	FROM salary JOIN employee
	USING (employee_id)
) 
SELECT DISTINCT pay_month, department_id,
	CASE 
		WHEN dept_avg > comp_avg THEN 'higher'
        WHEN dept_avg = comp_avg THEN 'same'
    ELSE 'lower' END AS comparison
FROM t1;