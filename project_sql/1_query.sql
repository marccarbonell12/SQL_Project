/***Question: What are the top-paying data analyst jobs?**

- Identify the top 10 highest-paying Data Analyst roles that are available remotely.
- Focuses on job postings with specified salaries.
- Why? Aims to highlight the top-paying opportunities for Data Analysts, offering insights into employment options and location flexibility.

- Gets the following columns in the `SELECT` statement: `job_id`, `job_title`, `job_location`, `job_schedule_type`, `salary_year_avg`, `job_posted_date`.
- Filters in the `WHERE` clause for:
    - 'Data Analyst' jobs only (`job_title = 'Data Analyst'`)
    - A salary exists (`salary_year_avg IS NOT NULL`)
    - Only includes remote jobs (`job_location = 'Anywhere'`)
- Orders the results by `salary_year_avg` in descending order (using `ORDER BY`).
- Only include the top 10 jobs (`LIMIT`).*/


-- top paying jobs
SELECT 
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    salary_year_avg IS NOT NULL
    AND job_title ILIKE ('%analyst')
    AND job_location IN ('Anywhere')
Order BY salary_year_avg DESC 
LIMIT 10;

