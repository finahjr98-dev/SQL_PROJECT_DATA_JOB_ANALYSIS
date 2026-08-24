/* What are the most in demand skills for data analysts?
- join job postings to inner table similar to query 2
- identify top 5 in demand skills for a data analyst
- focus on all job postings.
-why? retrieve top 5 skills w highest demand in job market, providing insights into the most valuable skills for job seekers.
*/ 

SELECT 
    skills,
    COUNT (skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_work_from_home = True
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;

