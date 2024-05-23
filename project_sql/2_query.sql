/***Question: What are the top-paying data analyst jobs, and what skills are required?** 

- Identify the top 10 highest-paying Data Analyst jobs and the specific skills required for these roles.
- Filters for roles with specified salaries that are remote
- Why? It provides a detailed look at which high-paying jobs demand certain skills, helping job seekers understand which skills to develop that align with top salaries

**🖥️ Query:**

- CTE `top_paying_jobs` - Identifies the top 10 highest-paying Data Analyst jobs.
    - Gets `job_id`, `job_title`, and `salary_year_avg` in `SELECT` statement.
    - It filters jobs (in the `WHERE` clause) based on the following:
        - The job title is 'Data Analyst'   (`job_title = 'Data Analyst'`)
        - Location being remote (`job_location = 'Anywhere'`)
        - A salary exists for the job posting (`salary_year_avg IS NOT NULL`)
    - Orders by `salary_year_avg` in descending order from greatest → least (`ORDER BY`).
    - Only gets top 10 jobs (`LIMIT`).
- In the main query:
    - Returns in the `SELECT` statement the `job_id`, `job_title`, `salary_year_avg`  from `top_paying_jobs` CTE and the `skills` from `skills_dim`.
    - Use `FROM` to get the top_paying_jobs CTE. Then `INNER JOIN` this CTE with the **`skills_job_dim`** and **`skills_dim`** tables. This join allows us to list the skills associated with each of these top-paying jobs. We only want to include jobs where there’s a skill associated with it.
    - Ordered by **`salary_year_avg`** in descending order to ensure the highest-paying jobs are listed first, with their respective skills detailed alongside.*/


    WITH top_paying_jobs AS (
        SELECT 
    job_id,
    job_title,
    salary_year_avg,
    name AS company_name
FROM
    job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    salary_year_avg IS NOT NULL
    AND job_title ILIKE ('%analyst')
    AND job_location IN ('Anywhere')
Order BY salary_year_avg DESC 
LIMIT 10

    )

SELECT
top_paying_jobs.*
skills

FROM
top_paying_jobs
INNER JOIN skills_job_dim ON skills_job_dim.job_id = top_paying_jobs.job_id
INNER join skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
Order BY salary_year_avg DESC 

