/***Answer: What are the top skills based on salary?** 

- Look at the average salary associated with each skill for Data Analyst positions.
- Focuses on roles with specified salaries, regardless of location.
- Why? It reveals how different skills impact salary levels for Data Analysts and helps identify the most financially rewarding skills to acquire or improve.*/

SELECT *
--skills,
--ROUND(AVG(salary_year_avg)) AS avg_skill_salary

FROM

skills_job_dim
JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

LIMIT 10





 WITH top_skills_needed AS (
    SELECT
        skills_dim.skills AS skill,
        COUNT (*) AS skill_count        
    FROM
        skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id
    INNER JOIN skills_dim ON skills_to_job.skill_id = skills_dim.skill_id
    WHERE
    salary_year_avg IS NOT NULL AND
    job_title ILIKE ('%analyst')
    GROUP BY 
        skill
    ORDER BY skill_count DESC
 )   

 SELECT *
 FROM top_skills_needed

