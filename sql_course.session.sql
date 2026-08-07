CREATE TABLE job_applied (
    job_id INT,
    application_sent_date DATE,
    custom_resume BOOLEAN,
    resume_file_name VARCHAR (255),
    cover_letter_sent BOOLEAN,
    cover_letter_file_name VARCHAR (255),
    status VARCHAR (50)
);


INSERT INTO job_applied 
    (job_id,
    application_sent_date,
    custom_resume,
    resume_file_name,
    cover_letter_sent,
    cover_letter_file_name,
    status)

VALUES (1,
    '2024-02-01',
    true,
    'resume_01.pdf',
    true,
    'cover_letter_01.pdf',
    'submitted'),
    (2,
    '2024-02-02',
    false,
    'resume_02.pdf',
    false,
    NULL, 
    'interview scheduled'),
    (3,
    '2024-02-03',
    true,
    'resume_03.pdf',
    true,
    'cover_letter_03.pdf',
    'ghosted'),
    (4,
    '2024-02-04',
    true,
    'resume_04.pdf',
    false,
    NULL,
    'submitted'),
    (5,
    '2024-02-05',
    false,
    'resume_05.pdf',
    true,
    'cover_letter_05.pdf',
    'rejected');

SELECT*
FROM job_applied;

ALTER TABLE job_applied
ADD contact VARCHAR (50);

UPDATE  job_applied
SET     contact = 'Erlich Bachman'
WHERE   job_id = 1;

UPDATE  job_applied
SET     contact = 'Dinesh Chugtai'
WHERE   job_id = 2;

UPDATE  job_applied
SET     contact = 'Bertram Gilfoyle'
WHERE   job_id = 3;

UPDATE  job_applied
SET     contact = 'Jian Yang'
WHERE   job_id = 4;

UPDATE  job_applied
SET     contact = 'Big Head'
WHERE   job_id = 5;

ALTER TABLE job_applied
RENAME COLUMN contact TO contact_name;

ALTER TABLE job_applied
ALTER COLUMN contact_name TYPE TEXT;

ALTER TABLE job_applied
DROP COLUMN contact_name;

SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date::DATE AS date

FROM job_postings_fact;

-- the ::DATE here help derive only dates if we want only dates, not with time. the ori date has time in it.

SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time,
    EXTRACT (MONTH FROM job_posted_date) AS date_month,
    EXTRACT (YEAR FROM job_posted_date) AS date_year 

FROM job_postings_fact
LIMIT 5;

-- extract is good use on group by com, this could do larger trend analysis; exp; how job postings are trending from month to month

SELECT 
    COUNT (job_id) AS job_posted_count,
    EXTRACT (MONTH FROM job_posted_date) AS month

FROM job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    MONTH
ORDER BY
    job_posted_count DESC;


-- total amount of job postings per month ^

--EX 2.37.01 timestamp vid

--next is ques 1

SELECT
    Job_schedule_type, COUNT (*) AS job_type,
    '2023-06-01' :: DATE,
    AVG (salary_year_avg) AS total_year_avg,
    AVG (salary_hour_avg) AS total_hour_avg
FROM
    job_postings_fact

GROUP BY
    job_schedule_type

ORDER BY
job_type DESC;

SELECT
    Job_schedule_type, COUNT (*) AS job_type,
    '2023-06-01' :: DATE,
    AVG (salary_year_avg) AS total_year_avg,
    AVG (salary_hour_avg) AS total_hour_avg
FROM
    job_postings_fact

GROUP BY
    job_schedule_type

ORDER BY
job_type DESC;

-- Ques 2

SELECT
    COUNT (job_id) AS job_posted,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time,
    EXTRACT (MONTH FROM job_posted_date) AS month
    

FROM
    job_postings_fact

GROUP BY
    job_posted_date

ORDER BY
MONTH ASC,
date_time;

/*SELECT 
    COUNT (job_id) AS job_posted_count,
    EXTRACT (MONTH FROM job_posted_date) AS month

FROM job_postings_fact

GROUP BY
    MONTH
ORDER BY
    job_posted_count DESC;

    THIS QUERY BASE ON EXP USED PRIOR ABOVE. JUST IT IS WITHOUT TIME.
*/

--QUEST 3

SELECT
    job_posting.company_id,
    job_posting.job_health_insurance,
    company_info.company_id

    
FROM job_postings_fact AS job_posting

LEFT JOIN 
    company_dim AS company_info ON job_posting.company_id = company_info.company_id;

limit 5

SELECT
    job_posting.company_id,
    job_posting.job_health_insurance,
    company_info.name,
    EXTRACT (MONTH FROM job_posting.job_posted_date) AS second_quarter


    
FROM job_postings_fact AS job_posting

LEFT JOIN 
    company_dim AS company_info 
    ON job_posting.company_id = company_info.company_id

WHERE
    EXTRACT (MONTH FROM job_posting.job_posted_date) IN (4, 5, 6) 
    AND job_posting.job_health_insurance = true;




CREATE TABLE january_jobs AS
    SELECT *
    FROM 
    job_postings_fact
    WHERE
    EXTRACT (MONTH FROM job_posted_date) = 1;

CREATE TABLE february_jobs AS
    SELECT *
    FROM 
    job_postings_fact
    WHERE
    EXTRACT (MONTH FROM job_posted_date) = 2;

CREATE TABLE march_jobs AS
    SELECT *
    FROM 
    job_postings_fact
    WHERE
    EXTRACT (MONTH FROM job_posted_date) = 3;    


select
    job_title_short,
    job_location,
    CASE
    WHEN job_location = 'Anywhere' THEN 'Remote'
    WHEN job_location = 'New York, NY' THEN 'Local'
    ELSE 'Onsite'
    END AS location_category
FROM 
    job_postings_fact

/*
above, label new column:
- 'Anywhere' jobs as 'Remote'
- 'New York, NY' jobs as 'Local'
- Otherwise 'Onsite'

Below is more detail.
*/

select
    COUNT (job_id) AS number_of_jobs,
    CASE
    WHEN job_location = 'Anywhere' THEN 'Remote'
    WHEN job_location = 'New York, NY' THEN 'Local'
    ELSE 'Onsite'
    END AS location_category
FROM 
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    location_category;

-- practice prb 1

SELECT
    job_id,
    job_title_short,
    salary_year_avg,
    CASE
    WHEN salary_year_avg IS NULL THEN 'Salary Not Listed'
    WHEN salary_year_avg < 50000 THEN 'Low (< $50K)'
    WHEN salary_year_avg BETWEEN 50000 AND 99999 THEN 'Medium ($50K - $99K)'
    WHEN salary_year_avg BETWEEN 100000 AND 149999 THEN 'HIGH (< $100K - $149K)'
    ELSE 'Very High ($150K+)'
    END AS salary_category
    

FROM
job_postings_fact

WHERE 
    salary_year_avg IS NOT NULL AND
    job_title_short = 'Data Analyst'

Order BY
    salary_year_avg DESC;

/*
categorize salary from each job posting to see desired salary range.
- put salary into different bucket
- high, standard or low with our own condition
- data analyst
- order from highest to lowest
*/

-- SUBQUERIES AND CTE
SELECT *

FROM ( 
    SELECT*
    FROM job_postings_fact
    WHERE EXTRACT (MONTH FROM job_posted_date) = 1
) AS january_jobs;

WHERE 
    salary_year_avg IS NOT NULL AND
    job_title_short = 'Data Analyst'

-- when subquerry has seperate table and need info from that (like join)

SELECT  
    company_id,
    job_no_degree_mention
FROM
    job_postings_fact
WHERE
    job_no_degree_mention = true

-- below, if write with order by it will output multiple job id, ie not diplicate
SELECT 
    company_id,
    name AS company_name
FROM 
    company_dim
WHERE company_id IN ( 
    SELECT  
        company_id
    FROM
        job_postings_fact
    WHERE
        job_no_degree_mention = true
)


-- CTE

WITH january_jobs AS (
    SELECT*
    FROM job_postings_fact
    WHERE EXTRACT (MONTH FROM job_posted_date) = 1
)
SELECT *
FROM january_jobs;

--

/*
companies with most job openings
- total number of job postings per company id (job posting facts)
- return total number of jobs with company name (company_dim)
- to combine these two table, left join. company dim is a, job posting fact is b
- the reason why, maybe some companies does not have job posting we agregrate from job posting facts, so we want everything lsited, so if there isnt, there's 0 ascociated with it.
*/

WITH company_job_count AS (
    SELECT  
        company_id, COUNT (*) AS total_jobs
    FROM
        job_postings_fact
    GROUP BY
        company_id
)

SELECT 
    company_dim.name AS company_name,
    company_job_count.total_jobs

FROM company_dim
LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id
ORDER BY 
    total_jobs DESC

/* PRACTICE PROBLEM
Find the count of the number of remote job postings per skill 
- display top 5 skills by their demand in remote jobs
- include skill id, name, and count of postings requiring the skills
- extra; data analyst job
*/

WITH remote_jobs_skills AS (
    select
        skill_id, COUNT (*) AS skill_count
    FROM 
        skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id
    WHERE   
    job_postings.job_work_from_home = TRUE AND
    job_postings.job_title_short = 'Data Analyst'
    GROUP BY
        skill_id
)

SELECT
    skills.skill_id,
    skills as skill_name,
    skill_count
FROM remote_jobs_skills
INNER JOIN skills_dim AS skills ON skills.skill_id = remote_jobs_skills.skill_id
ORDER BY    
    skill_count DESC
limit 5;

--prac 1
/* top 5 skill frequently mentioned in job postings. 
- Use subquery to find skill id (highest count) in skills_job_dim
-join skills_dim (to get skill names) */

SELECT 
    skill_id, COUNT (*) AS skill_count
FROM   
    skills_job_dim
GROUP BY skill_id
ORDER BY skill_count DESC
LIMIT 5

--chatgpt result>>

SELECT
    sd.skills,
    skill_counts.skill_count
FROM skills_dim AS sd

-- Subquery: Count how many times each skill appears
JOIN (
    SELECT
        skill_id,
        COUNT(*) AS skill_count
    FROM skills_job_dim
    GROUP BY skill_id
    ORDER BY skill_count DESC
    LIMIT 5
) AS skill_counts
ON sd.skill_id = skill_counts.skill_id

-- Display the most frequent skills first
ORDER BY skill_counts.skill_count DESC;

--below cte way

WITH top_skills AS (
    select
        skill_id, COUNT (*) AS skill_count
    FROM 
        skills_job_dim AS skills_to_job
    GROUP BY
        skill_id
    ORDER BY skill_count DESC
    LIMIT 5
)

SELECT
    skills_dim.skills,
    skills as skill_name,
    skill_count
FROM top_skills 
INNER JOIN skills_dim AS skills ON top_skills.skill_id = skills.skill_id
ORDER BY    
    skill_count DESC
limit 5;

SELECT*
FROM
job_postings_fact

-- below chatgpt for solving above.

WITH top_skills AS (
    SELECT
        skill_id,
        COUNT(*) AS skill_count
    FROM skills_job_dim
    GROUP BY skill_id
    ORDER BY skill_count DESC
    LIMIT 5
)

-- Step 2: Join the CTE with skills_dim to get skill names
SELECT
    sd.skills,
    ts.skill_count
FROM top_skills AS ts
JOIN skills_dim AS sd
    ON ts.skill_id = sd.skill_id

-- Display the skills from most to least frequent
ORDER BY ts.skill_count DESC;

-- prob 2
/*
total job postings for each company
-small <10
- medium between 10 and 50
- large >50
*/

with company_postings AS (
    SELECT
        company_id,
        COUNT(job_id) AS total_postings
    FROM
        job_postings_fact
    GROUP BY company_id
)

SELECT
    company_id,
    total_postings,
    CASE
        WHEN total_postings < 10 THEN 'SMALL'
        WHEN total_postings BETWEEN 10 AND 50 THEN 'MEDIUM'
        ELSE 'LARGE'
    END AS company_size

FROM company_postings
ORDER BY total_postings DESC;

--if i want to add name as well

with company_postings AS (
    SELECT
        company_id,
        COUNT(job_id) AS total_postings
    FROM
        job_postings_fact
    GROUP BY company_id
)

SELECT
    company_postings.company_id,
    company_dim.name,
    company_postings.total_postings,
    CASE
        WHEN total_postings < 10 THEN 'SMALL'
        WHEN total_postings BETWEEN 10 AND 50 THEN 'MEDIUM'
        ELSE 'LARGE'
    END AS company_size

FROM company_postings

JOIN company_dim ON company_postings.company_id = company_dim.company_id
ORDER BY company_postings.total_postings DESC;

-- UNION

select*
FROM skills_dim;

select *
FROM february_jobs;

select *
FROM march_jobs;

-- get job and companies from january

SELECT
    job_title_short,
    company_id,
    job_location
FROM    
    january_jobs

UNION

SELECT
    job_title_short,
    company_id,
    job_location
FROM    
    february_jobs

UNION

SELECT
    job_title_short,
    company_id,
    job_location
FROM    
    march_jobs

-- UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location
FROM    
    january_jobs

UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location
FROM    
    february_jobs

UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location
FROM    
    march_jobs

/* practice prob 1
corresponding skill and skill type for each job postings in q1 (jan feb mar)
-include without skill
- look at the skill and type for each job in first quarter that has a salary> 70000
*/

With Q1_job AS (
     SELECT * 
     FROM january_jobs
    UNION ALL
    SELECT * 
    FROM february_jobs
    UNION ALL
    SELECT * 
    FROM march_jobs
)

SELECT
    Q1_job.job_id,
    Q1_job.job_title,
    Q1_job.salary_year_avg,
    Q1_job.job_posted_date :: date,
    skills_dim.skills,
    skills_dim.type

FROM Q1_job

LEFT JOIN skills_job_dim ON Q1_job.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id

WHERE
    Q1_job.salary_year_avg > 70000
ORDER BY
    Q1_job.salary_year_avg;
   
-- below is chatgpt 

-- Step 1: Combine January, February, and March job postings
WITH q1_jobs AS (
    SELECT * FROM january_jobs
    UNION ALL
    SELECT * FROM february_jobs
    UNION ALL
    SELECT * FROM march_jobs
)

-- Step 2: Get skills for each Q1 job
SELECT
    q.job_id,
    q.job_title,
    q.salary_year_avg,
    q.job_posted_date :: date,
    sd.skills,
    sd.type
FROM q1_jobs AS q

-- Include jobs even if they don't have skills
LEFT JOIN skills_job_dim AS sj
    ON q.job_id = sj.job_id

LEFT JOIN skills_dim AS sd
    ON sj.skill_id = sd.skill_id

WHERE q.salary_year_avg > 70000
ORDER BY q.job_id;

/*practice prob from vid based on above
find job postings from first quarter that have a salary greater than 70k
-combine job posting table from first quarter of 2023
- get job posting w an average yearly salary > 70 000*/

SELECT
    job_title_short,
    job_location,
    job_via,
    job_posted_date::date,
    salary_year_avg
FROM ( 
SELECT *
FROM    
    january_jobs

UNION ALL

SELECT*
FROM    
    february_jobs

UNION ALL

SELECT*
FROM    
    march_jobs
) AS Q1_job_postings

WHERE
    salary_year_avg > 70000 AND
    job_title_short = 'Data Analyst'
ORDER BY
    salary_year_avg DESC