/* 
- What are the top skills based on salary?
- look at average salary associated with each skill for data analyst position
- focuses on roles with specified salaries, regardless of location
- what are the top skills based on salary for my role
- how different skills impact salary levels for data analyst and identify the most finacially rewarding skills to acquire or improve
*/ 

SELECT 
    skills,
    ROUND (AVG (salary_year_avg), 0) as avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND
    salary_year_avg is NOT NULL AND
    job_work_from_home = True
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;

/*
Big data & distributed processing skills dominate the top: PySpark leads by a wide margin at $208K, while Databricks, Elasticsearch, and Kubernetes also appear high on the list. This suggests strong demand for skills that handle large-scale data and modern data infrastructure.
Data science skills command strong salaries: Python ecosystem tools such as Pandas ($152K), Jupyter ($153K), NumPy ($144K), and Scikit-learn ($126K) are consistently represented, showing that analytical and machine-learning capabilities remain valuable.
Cloud/DevOps skills are a recurring theme: Bitbucket, GitLab, Linux, Airflow, Jenkins, GCP, and Kubernetes all rank in the top 25. Overall, the highest-paying analyst roles appear to reward a combination of data analysis + engineering/infrastructure skills, rather than traditional analytics alone.
*/