-- NETFLIX DATA ANALYSIS --
-- CREATE TABLE --

Drop Table if exists Netflix;
create table Netflix
	(
		show_id	varchar(6),
		type varchar(10),
		title varchar(150),
		director varchar(208),	
		casts varchar(1000),	
		country varchar(150),
		date_added varchar(50),
		release_year int,	
		rating varchar(10),
		duration varchar(15),	
		listed_in varchar(105),
		description varchar(250)
	);

-- EDA --

Select * from netflix;

Select Count(*) from netflix;

Select Distinct type from netflix;

-- Business Problems & Solutions --

-- 1. Count the Number of Movies vs TV Shows

Select * from netflix;

Select type, count(*) as Total_no
from netflix
group by 1
order by 2 desc;

-- 2. Find the Most Common Rating for Movies and TV Shows

Select * from netflix;
With cte as 
(Select 
	type,
	rating,
	count(rating),
	rank() over (partition by type order by count(*) desc)
from netflix
group by 1, 2
order by 3 desc
)
Select type, rating from cte
where rank = 1;

-- 3. List All Movies Released in a Specific Year (e.g., 2020)

Select * from netflix;

Select title, release_year from netflix 
where type = 'Movie' and release_year = 2020;

Select title, release_year from netflix 
where type = 'Movie' and release_year = 2021;

-- 4. Find the Top 5 Countries with the Most Content on Netflix

Select * from netflix;

Select TRIM(UNNEST(STRING_TO_ARRAY(Country,','))) as splited_country, count(*) as Most_content from netflix
group by splited_country
order by 2 desc
limit 5;

-- 5. Identify the Longest Movie

Select * from netflix;

select * from 
 (select distinct title as movie,
  split_part(duration,' ',1):: numeric as duration 
  from netflix
  where type ='Movie') as t1
where duration = (select max(split_part(duration,' ',1):: numeric ) from netflix);

-- 6. Find Content Added in the Last 5 Years

Select * from netflix;

Select * from netflix
where TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 YEARS';

-- 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

Select * from netflix;

select * from netflix
where director ilike '%Rajiv Chilaka%';

--8. List All TV Shows with More Than 5 Seasons

Select * from netflix;

select * from 
 (select distinct title as tv_shows,
  split_part(duration,' ',1):: numeric as duration 
  from netflix
  where type ='TV Show') as t1
where duration > 5
order by tv_shows;

-- 9. Count the Number of Content Items in Each Genre

Select * from netflix;

Select Trim(Unnest(string_to_array(listed_in, ','))) as genre, count(show_id) as count_no from netflix
group by  1
order by 2 desc;

-- 10. Find each year and the average numbers of content release in India on netflix. 

Select * from netflix;

SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC;

-- 11. List All Movies that are Documentaries

Select * from Netflix;

Select * from netflix
where listed_in ilike '%Documentaries%'

-- 12. Find All Content Without a Director

Select * from Netflix;

SELECT * 
FROM netflix
WHERE director IS NULL;

-- 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

Select * from Netflix;

SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

-- 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

Select * from netflix;

Select 
Trim(Unnest(string_to_array(casts,','))) as sep_act, count(*) High_no from netflix
where country ilike '%India%'
group by sep_act
order by 2 desc
limit 10;

-- 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

Select * from netflix;

SELECT 
    show_id, type, title, category
FROM (
    SELECT *,
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content;
--
SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;


	
















 






