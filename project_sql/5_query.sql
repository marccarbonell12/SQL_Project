/***Answer: What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill) for a data analyst?** 

- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), offering strategic insights for career development in data analysis*/

--Skills with high salaries
WITH high_salaries AS (
SELECT
skills,
ROUND(AVG(salary_year_avg),2) AS avg_skill_salary
FROM
skills_job_dim
JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE salary_year_avg IS NOT NULL AND
    job_title ILIKE '%analyst'
GROUP BY skills
ORDER BY avg_skill_salary DESC
),
-- skills more demanded 
skills_demanded AS (
SELECT
        skills,
        COUNT (*) AS skill_count        
    FROM
        skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id
    INNER JOIN skills_dim ON skills_to_job.skill_id = skills_dim.skill_id
    WHERE
    salary_year_avg IS NOT NULL AND
    job_title ILIKE '%analyst'
    GROUP BY 
        skills
    ORDER BY skill_count DESC
)

SELECT 
high_salaries.skills,
skill_count,
avg_skill_salary

FROM
high_salaries
LEFT JOIN skills_demanded ON high_salaries.skills = skills_demanded.skills

ORDER BY skill_count DESC , avg_skill_salary DESC

LIMIT 25;



----- 

--Skills with high salaries
WITH high_salaries AS (
SELECT
    skills_dim.skill_id,
    skills,
    ROUND(AVG(salary_year_avg),2) AS avg_skill_salary
FROM
    skills_job_dim
INNER JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE salary_year_avg IS NOT NULL AND
    job_title ILIKE '%analyst'
GROUP BY skills_dim.skill_id
),
-- skills more demanded 
skills_demanded AS (
SELECT
        skills_dim.skill_id,
        skills,
        COUNT (skills_to_job.job_id) AS skill_count        
    FROM
        skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id
    INNER JOIN skills_dim ON skills_to_job.skill_id = skills_dim.skill_id
    WHERE
    salary_year_avg IS NOT NULL AND
    job_title ILIKE '%analyst'
    GROUP BY 
        skills_dim.skill_id
)

SELECT 
high_salaries.skill_id,
high_salaries.skills,
skill_count,
avg_skill_salary

FROM
high_salaries
INNER JOIN skills_demanded ON high_salaries.skills = skills_demanded.skills

ORDER BY skill_count DESC , avg_skill_salary DESC

LIMIT 25;