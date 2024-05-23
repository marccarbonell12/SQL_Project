/***Question: What are the most in-demand skills for data analysts?**

- Identify the top 5 in-demand skills for a data analyst.
- Focus on all job postings.
- Why? Retrieves the top 5 skills with the highest demand in the job market, providing insights into the most valuable skills for job seekers.*/

SELECT
        skills_dim.skills AS skill,
        COUNT (*) AS skill_count        
    FROM
        skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id
    INNER JOIN skills_dim ON skills_to_job.skill_id = skills_dim.skill_id
    WHERE
    -- salary_year_avg IS NOT NULL AND
    job_title ILIKE ('%analyst')
    GROUP BY 
        skill
    ORDER BY skill_count DESC
    LIMIT 5;

