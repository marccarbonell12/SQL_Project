/*Create a table named data_science_jobs that will hold information about job postings.
Include the following columns: job_id (integer and primary key), job_title (text), company_name (text), and post_date (date).*/

CREATE TABLE  data_science_jobs (job_id INT,
                                job_title text,
                                company_name TEXT,
                                post_date DATE
                                );

DROP TABLE data_science_jobs;



CREATE TABLE  data_science_jobs (job_id INT PRIMARY KEY,
                                job_title text,
                                company_name TEXT,
                                post_date DATE
                                );

/*Insert three job postings into the data_science_jobs table. Make sure each job posting has a unique job_id, a job_title, a company_name, and a post_date.*/ 

INSERT INTO data_science_jobs (job_id, job_title, company_name, post_date)
    VALUES (1 , 'ASBICB' , 'DIBFCID' , '01-01-2000'),
              (2 , 'IWSDFO' , 'SADJFBIF' , '05-05-2001'),
              (3 , 'DFFG' , 'SADJFDFGBIF' , '05-05-2001');

SELECT *
FROM data_science_jobs;

/*Alter the data_science_jobs table to add a new Boolean column (uses True or False values) named remote.*/

ALTER TABLE data_science_jobs
ADD data_science_jobs BOOLEAN;

ALTER TABLE data_science_jobs
RENAME column data_science_jobs TO REMOTE;

/*Rename the post_date column to posted_on from the data_science_job table.*/

ALTER TABLE data_science_jobs
RENAME column post_date TO posted_on;

/*Modify the remote column so that it defaults to FALSE in the data_science_job table .*/

ALTER TABLE data_science_jobs 
ALTER COLUMN remote SET DEFAULT FALSE;

SELECT *
FROM data_science_jobs;

/*Drop the company_name column from the data_science_jobs table.*/

ALTER TABLE data_science_jobs
DROP COLUMN company_name;

/*Update the job posting with the job_id = 2 . Update the remote column for this job posting to TRUE in data_science_jobs.*/

UPDATE data_science_jobs SET remote = TRUE WHERE job_id = 2;

SELECT *
FROM data_science_jobs;

/*Drop the data_science_jobs table.*/

DROP TABLE data_science_jobs;

/*Find the average salary both yearly (salary_year_avg) and hourly (salary_hour_avg) for job postings using the job_postings_fact table that were posted after June 1, 2023.
Group the results by job schedule type. Order by the job_schedule_type in ascending order.*/

SELECT *
FROM job_postings_fact
LIMIT 5;

SELECT 
        job_schedule_type,
        AVG(salary_year_avg),
        AVG(salary_hour_avg)
FROM job_postings_fact
WHERE job_posted_date::DATE > '2023-06-01'
GROUP BY job_schedule_type;


/* Count the number of job postings for each month in 2023, adjusting the job_posted_date to be in 'America/New_York' time zone before extracting the month.
Assume the job_posted_date is stored in UTC. Group by and order by the month.*/

SELECT 
    COUNT(*) AS Total_job_posts,
    EXTRACT( MONTH FROM job_posted_date AT Time zone 'UTC' AT time zone 'EST') as Month_posted
FROM job_postings_fact    
WHERE
 job_posted_date >= '2023-01-01'     
GROUP BY
    Month_posted
order BY
    Month_posted;


/*Find companies (include company name) that have posted jobs offering health insurance, where these postings were made in the second quarter of 2023.
Use date extraction to filter by quarter.
And order by the job postings count from highest to lowest.*/

SELECT 
    c.name AS company_name,
    COUNT(j.job_id) AS jobs_posted

from job_postings_fact AS j
    join company_dim AS c ON j.company_id = c.company_id

WHERE
  j.job_health_insurance = TRUE
  AND
  EXTRACT(QUARTER FROM j.job_posted_date) = 2

GROUP BY company_name
HAVING
COUNT(j.job_id) > 0

ORDER BY jobs_posted DESC;

/* Problem video 6 */
/***Question:** 

- Create three tables:
    - Jan 2023 jobs
    - Feb 2023 jobs
    - Mar 2023 jobs
- **Foreshadowing:** This will be used in another practice problem below.*/

CREATE TABLE jan_2023 AS
SELECT *
FROM job_postings_fact
WHERE
EXTRACT(MONTH FROM job_posted_date) = 1;


CREATE TABLE feb_2023 AS
SELECT *
FROM job_postings_fact
WHERE
EXTRACT(MONTH FROM job_posted_date) = 2;


CREATE TABLE mar_2023 AS
SELECT *
FROM job_postings_fact
WHERE
EXTRACT(MONTH FROM job_posted_date) = 3;

/*From the job_postings_fact table, categorize the salaries from job postings that are data analyst jobs and who have a yearly salary information.
Put salary into 3 different categories:

If the salary_year_avg is greater than $100,000 then return ‘high salary’.
If the salary_year_avg is between $60,000 and $99,999 return ‘Standard salary’.
If the salary_year_avg is below $60,000 return ‘Low salary’.
Also order from the highest to lowest salaries.*/

SELECT 
        job_id,
        job_title,
       salary_year_avg, 
        CASE
            when salary_year_avg > 100000 THEN 'high salary'
            when salary_year_avg between 60000 and 99999 THEN 'standard salary'
            when salary_year_avg <60000 THEN 'low salary'
        END AS salary_info
FROM job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
    AND
    salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC;

/* Count the number of unique companies that offer work from home (WFH) versus those requiring work to be on-site.
Use the job_postings_fact table to count and compare the distinct companies based on their WFH policy (job_work_from_home).*/


SELECT 
    COUNT(DISTINCT CASE WHEN job_work_from_home = TRUE THEN company_id END) AS wfh_companies,
    COUNT(DISTINCT CASE WHEN job_work_from_home = FALSE THEN company_id END) AS non_wfh_companies
FROM job_postings_fact;

/* Write a query that lists all job postings with their job_id, salary_year_avg, and two additional columns using CASE WHEN statements called: experience_level and remote_option.
Use the job_postings_fact table.

For experience_level, categorize jobs based on keywords found in their titles (job_title) as 'Senior', 'Lead/Manager', 'Junior/Entry', or 'Not Specified'.
Assume that certain keywords in job titles (like "Senior", "Manager", "Lead", "Junior", or "Entry") can indicate the level of experience required.
ILIKE should be used in place of LIKE for this.

NOTE: Use ILIKE in place of how you would normally use LIKE ; ILIKE is a command in SQL, specifically used in PostgreSQL.
It performs a case-insensitive search, similar to the LIKE command but without sensitivity to case.

For remote_option, specify whether a job offers a remote option as either 'Yes' or 'No', based on job_work_from_home column.*/ 

SELECT
    job_id,
    job_title,
    salary_year_avg,
    CASE
        when job_work_from_home = TRUE Then 'Yes'
        when job_work_from_home = False Then 'No'
    END AS remote_option,
    CASE
        when job_title ILIKE '%Senior%' THEN 'Senior'
        when job_title ILIKE '%Lead%' THEN 'Lead/Manager'
        when job_title ILIKE '%Manager%' THEN 'Lead/Manager'
        WHEN job_title ILIKE '%Junior%' OR job_title ILIKE '%Entry%' THEN 'Junior/Entry'
        Else 'Not specified'
    END AS  experience_level
FROM job_postings_fact
WHERE 
  salary_year_avg IS NOT NULL 
ORDER BY 
  job_id;

/* Identify the top 5 skills that are most frequently mentioned in job postings.
Use a subquery to find the skill IDs with the highest counts in the skills_job_dim table and then join this result with the skills_dim table to get the skill names.*/



WITH top_skills AS (
    SELECT 
        skill_id,
        count(skill_id) as skill_count
    FROM skills_job_dim
    GROUP BY skill_id
    order by skill_count DESC
    )
SELECT
    skills_dim.skills AS Skill,
    skill_count
FROM skills_dim
    LEFT JOIN top_skills ON skills_dim.skill_id = top_skills.skill_id
order BY   
    skill_count DESC
LIMIT 5;


/* Determine the size category ('Small', 'Medium', or 'Large') for each company by first identifying the number of job postings they have.
Use a subquery to calculate the total job postings per company.
A company is considered 'Small' if it has less than 10 job postings, 'Medium' if the number of job postings is between 10 and 50, and 'Large' if it has more than 50 job postings.
Implement a subquery to aggregate job counts per company before classifying them based on size.*/


WITH company_postings AS (
                SELECT
                company_id,
                count(company_id) as n_offers
                from job_postings_fact 
                GROUP BY company_id
                ORDER BY n_offers DESC
                    )
SELECT
    company_postings.company_id,
    company_dim.name,
    CASE 
        WHEN n_offers > 60 THEN 'Large'
        WHEN n_offers between 10 and 59 THEN 'Medium'
        WHEN n_offers < 10 THEN 'Small'
    END AS Company_size
FROM company_dim
JOIN company_postings ON company_dim.company_id = company_postings.company_id
ORDER BY company_postings.company_id
LIMIT 11;
 

-- Solución curso
SELECT 
	company_id,
  name,
	-- Categorize companies
  CASE
	  WHEN job_count < 10 THEN 'Small'
    WHEN job_count BETWEEN 10 AND 50 THEN 'Medium'
    ELSE 'Large'
  END AS company_size

FROM 
-- Subquery to calculate number of job postings per company 
(
  SELECT 
		company_dim.company_id, 
		company_dim.name, 
		COUNT(job_postings_fact.job_id) as job_count
  FROM 
		company_dim
  INNER JOIN job_postings_fact ON company_dim.company_id = job_postings_fact.company_id
  GROUP BY 
		company_dim.company_id, 
		company_dim.name
) AS company_job_count;


/* Find companies that offer an average salary above the overall average yearly salary of all job postings.
Use subqueries to select companies with an average salary higher than the overall average salary (which is another subquery).*/


 -- avg salary for all comapnies
SELECT
    AVG(salary_year_avg)
FROM job_postings_fact
where salary_year_avg IS NOT NULL;


 -- avg salary per company

SELECT
    c.name,
    AVG(j.salary_year_avg) AS avg_per_company 
FROM job_postings_fact j 
    JOIN company_dim c ON j.company_id = c.company_id
where j.salary_year_avg IS NOT NULL
GROUP BY c.name
ORDER BY avg_per_company DESC  ;

--

SELECT
    c.name,
    AVG(j.salary_year_avg) AS avg_per_company 
FROM job_postings_fact j 
    JOIN company_dim c ON j.company_id = c.company_id
where j.salary_year_avg IS NOT NULL
GROUP BY c.name
ORDER BY avg_per_company DESC  ;


-- solución

SELECT 
    company_dim.name,
    company_salaries.avg_salary
FROM 
    company_dim
INNER JOIN (
    -- Subquery to calculate average salary per company
    SELECT 
			company_id, 
			AVG(salary_year_avg) AS avg_salary
    FROM job_postings_fact
    GROUP BY company_id
    ) AS company_salaries ON company_dim.company_id = company_salaries.company_id
-- Filter for companies with an average salary greater than the overall average
WHERE company_salaries.avg_salary > (
    -- Subquery to calculate the overall average salary
    SELECT AVG(salary_year_avg)
    FROM job_postings_fact
)
ORDER BY company_salaries.avg_salary DESC ;


/*problem 7 */

/* - Find the count of the number of remote job postings per skill
    - Display the top 5 skills in descending order by their demand in remote jobs
    - Include skill ID, name, and count of postings requiring the skill
    - Why? Identify the top 5 skills in demand for remote jobs */

WITH remote_job_skills AS (
    SELECT
        skill_id,
        COUNT (*) AS skill_count        
    FROM
        skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id
    WHERE 
        job_postings.job_work_from_home = TRUE
    GROUP BY 
        skill_id
        ) 

SELECT 
    skills.skill_id,
    skills AS skill_name,
    skill_count
    FROM remote_job_skills
    INNER JOIN skills_dim AS skills ON remote_job_skills.skill_id = skills.skill_id
ORDER BY
    skill_count DESC
LIMIT 5;


/* adding jobs for data analyst*/

WITH remote_job_skills AS (
    SELECT
        skill_id,
        COUNT (*) AS skill_count        
    FROM
        skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id
    WHERE 
        job_postings.job_work_from_home = TRUE
        AND
        job_postings.job_title_short = 'Data Analyst'
    GROUP BY 
        skill_id
        ) 

SELECT 
    skills.skill_id,
    skills AS skill_name,
    skill_count
    FROM remote_job_skills
    INNER JOIN skills_dim AS skills ON remote_job_skills.skill_id = skills.skill_id
ORDER BY
    skill_count DESC
LIMIT 5;

/* Identify companies with the most diverse (unique) job titles.
Use a CTE to count the number of unique job titles per company, then select companies with the highest diversity in job titles.*/

WITH total_jobs AS
    (SELECT
        company_id,
        COUNT (DISTINCT job_title) AS total_jobs_posted
    FROM job_postings_fact
    GROUP BY company_id)

SELECT 
    company_dim.name AS company_name,
    total_jobs_posted

FROM total_jobs
    JOIN company_dim ON total_jobs.company_id = company_dim.company_id

order BY total_jobs_posted DESC
LIMIT 10;


/*Explore job postings by listing job id, job titles, company names, and their average salary rates, while categorizing these salaries
relative to the average in their respective countries.
Include the month of the job posted date. Use CTEs, conditional logic, and date functions, to compare individual salaries with national averages.*/

SELECT
job_id,
job_title,
company_id,
job_country,
salary_year_avg,
job_country,
EXTRACT(MONTH FROM job_posted_date::DATE) AS month_posted

FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL AND job_country IS NOT NULL


-- avg salary per conuntry
SELECT

job_country,
AVG (salary_year_avg) AS country_avg_salary

FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL AND job_country IS NOT NULL
GROUP BY job_country
ORDER BY country_avg_salary DESC

-- 

-- Propuesta final -- 

WITH country_avg_salary AS ( SELECT
                    job_country,
                    AVG (salary_year_avg) AS avg_count
                FROM job_postings_fact
                WHERE salary_year_avg IS NOT NULL AND job_country IS NOT NULL
                GROUP BY job_country)
SELECT
    job_id,
    job_title_short,
    job_title,
    company_dim.name AS company_name,
    salary_year_avg,
    job_postings_fact.job_country,
    -- country_avg_salary.avg_count,
    CASE 
        WHEN job_postings_fact.salary_year_avg < country_avg_salary.avg_count THEN 'Below average'
        WHEN job_postings_fact.salary_year_avg > country_avg_salary.avg_count THEN 'Above average'
    END AS Salary_avg_vs_country,

    EXTRACT(MONTH FROM job_posted_date) AS month_posted

FROM job_postings_fact
        INNER JOIN country_avg_salary ON job_postings_fact.job_country = country_avg_salary.job_country
        INNER JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id

WHERE job_postings_fact.salary_year_avg IS NOT NULL AND job_postings_fact.job_country IS NOT NULL

ORDER BY month_posted DESC;


/* Calculate the number of unique skills required by each company.
Aim to quantify the unique skills required per company and identify which of these companies offer the highest average salary for positions necessitating at least one skill.
For entities without skill-related job postings, list it as a zero skill requirement and a null salary.
Use CTEs to separately assess the unique skill count and the maximum average salary offered by these companies.*/


-- unique skills per company required
WITH unique_skills AS (
        SELECT
        company_id,
        COUNT (DISTINCT skdm.skills) AS Total_skills
        FROM
            skills_job_dim skdmj 
                LEFT JOIN job_postings_fact j ON skdmj.job_id = j.job_id
                LEFT JOIN skills_dim skdm ON  skdmj.skill_id = skdm.skill_id   
        GROUP BY company_id
            ),

-- max  avg salaries per company
 max_salaries AS (
        SELECT
            company_id,
            MAX(salary_year_avg) AS max_salary
        from
            job_postings_fact
        WHERE job_postings_fact.job_id IN (SELECT job_id FROM skills_job_dim)    -- Esta linea no queda clara 
        AND salary_year_avg IS NOT NULL
        GROUP BY company_id
        )

-- Joins 2 CTEs with table to get the query
SELECT
    company_dim.name,
    unique_skills.Total_skills,
    max_salaries.max_salary
FROM
  company_dim 
LEFT JOIN unique_skills ON company_dim.company_id = unique_skills.company_id
LEFT JOIN max_salaries ON company_dim.company_id = max_salaries.company_id
ORDER BY
	company_dim.name;

-- UNIONS -- 

/* Create a unified query that categorizes job postings into two groups: those with salary information (salary_year_avg or salary_hour_avg is not null) and those without it.
Each job posting should be listed with its job_id, job_title, and an indicator of whether salary information is provided.*/


WITH with_salary_info AS (
        SELECT
            job_id,
            job_title,
            --salary_hour_avg,
            --salary_year_avg,
            CASE
                WHEN salary_hour_avg is not null then 'Has salary info'
                WHEN salary_year_avg IS NOT NULL THEN 'Has salary info'
            END AS salary_information
        FROM
            job_postings_fact
        where salary_hour_avg is not null or salary_year_avg is not null
) ,

no_salary_info AS (
        SELECT
            job_id,
            job_title,
            --salary_hour_avg,
            --salary_year_avg,
            CASE
                WHEN salary_hour_avg is  null then 'No salary info'
                WHEN salary_year_avg IS  NULL THEN 'No salary info'
            END AS salary_information
        FROM
            job_postings_fact
        where salary_hour_avg is null AND salary_year_avg is null
)


SELECT *
FROM with_salary_info

UNION all

SELECT *
FROM no_salary_info

-- MANERA CORRECTA 

(SELECT
            job_id,
            job_title,
            CASE
                WHEN salary_hour_avg is not null then 'Has salary info'
                WHEN salary_year_avg IS NOT NULL THEN 'Has salary info'
            END AS salary_information
        FROM
            job_postings_fact
        where salary_hour_avg is not null or salary_year_avg is not null)

UNION all

(SELECT
            job_id,
            job_title,
            CASE
                WHEN salary_hour_avg is  null then 'No salary info'
                WHEN salary_year_avg IS  NULL THEN 'No salary info'
            END AS salary_information
        FROM
            job_postings_fact
        where salary_hour_avg is null AND salary_year_avg is null)
ORDER BY 
	salary_information DESC, 
	job_id; 



/* Retrieve the job id, job title short, job location, job via, skill and skill type for each job posting from the first quarter (January to March).
Using a subquery to combine job postings from the first quarter (these tables were created in the Advanced Section - Practice Problem 6 [include timestamp of Youtube video]) 
Only include postings with an average yearly salary greater than $70,000.*/

SELECT
    j.job_id,
    j.job_title_short,
    j.job_location,
    j.job_via,
    j.salary_year_avg,
    s.skills,
    s.type
FROM
    skills_job_dim sd 
        LEFT JOIN job_postings_fact j ON sd.job_id = j.job_id
        LEFT JOIN skills_dim s ON sd.skill_id = s.skill_id
WHERE
    j.salary_year_avg > 70000
    AND
    EXTRACT(QUARTER FROM j.job_posted_date) = 1
ORDER BY
    j.job_id


-- solucion curso
SELECT
    job_postings_q1.job_id,
    job_postings_q1.job_title_short,
    job_postings_q1.job_location,
    job_postings_q1.job_via,
    job_postings_q1.salary_year_avg,
    skills_dim.skills,
    skills_dim.type
FROM
-- Get job postings from the first quarter of 2023
    (
        SELECT *
        FROM jan_2023
            UNION ALL
            SELECT *
            FROM feb_2023
				UNION ALL
				SELECT *
				FROM mar_2023
    ) as job_postings_q1
LEFT JOIN skills_job_dim ON job_postings_q1.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_q1.salary_year_avg > 70000
ORDER BY
	job_postings_q1.job_id;


/* Analyze the monthly demand for skills by counting the number of job postings for each skill in the first quarter (January to March),
utilizing data from separate tables for each month.
Ensure to include skills from all job postings across these months.
The tables for the first quarter job postings were created in the Advanced Section - Practice Problem 6 [include timestamp of Youtube video].*/

-- CTE for combining job postings from January, February, and March
WITH combined_job_postings AS (
  SELECT job_id, job_posted_date
  FROM jan_2023
  UNION ALL
  SELECT job_id, job_posted_date
  FROM feb_2023
  UNION ALL
  SELECT job_id, job_posted_date
  FROM mar_2023
),
-- CTE for calculating monthly skill demand based on the combined postings
monthly_skill_demand AS (
  SELECT
    skills_dim.skills,  
    EXTRACT(YEAR FROM combined_job_postings.job_posted_date) AS year,  
    EXTRACT(MONTH FROM combined_job_postings.job_posted_date) AS month,  
    COUNT(combined_job_postings.job_id) AS postings_count 
  FROM
    combined_job_postings
	  INNER JOIN skills_job_dim ON combined_job_postings.job_id = skills_job_dim.job_id  
	  INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id  
  GROUP BY
    skills_dim.skills, year, month
)
-- Main query to display the demand for each skill during the first quarter
SELECT
  skills,  
  year,  
  month,  
  postings_count 
FROM
  monthly_skill_demand
ORDER BY
  skills, year, month;  

  /* Problem 8*/

  SELECT
	quarter1_job_postings.job_title_short,
	quarter1_job_postings.job_location,
	quarter1_job_postings.job_via,
	quarter1_job_postings.job_posted_date::DATE
FROM
-- Gets all rows from January, February, and March job postings 
	(
		SELECT *
		FROM jan_2023
		UNION ALL
		SELECT *
		FROM feb_2023
		UNION ALL 
		SELECT *
		FROM mar_2023
	) AS quarter1_job_postings 
WHERE
	quarter1_job_postings.salary_year_avg > 70000
	--AND job_postings.job_title_short = 'Data Analyst'
ORDER BY
	quarter1_job_postings.salary_year_avg DESC;

    