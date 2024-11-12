# Netflix Movies and TV Shows Data Analysis using SQL P4 - Intermediate Level

![](https://github.com/bhuvaneshkofficial/Netflix_Data_Analysis/blob/main/Netflix%20Logo.jpeg)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
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
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
Select * from netflix;

Select type, count(*) as Total_no
from netflix
group by 1
order by 2 desc;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
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
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
Select * from netflix;

Select title, release_year from netflix 
where type = 'Movie' and release_year = 2020;

Select title, release_year from netflix 
where type = 'Movie' and release_year = 2021;
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
Select * from netflix;

Select TRIM(UNNEST(STRING_TO_ARRAY(Country,','))) as splited_country, count(*) as Most_content from netflix
group by splited_country
order by 2 desc
limit 5;
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
Select * from netflix;

select * from 
 (select distinct title as movie,
  split_part(duration,' ',1):: numeric as duration 
  from netflix
  where type ='Movie') as t1
where duration = (select max(split_part(duration,' ',1):: numeric ) from netflix);
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
Select * from netflix;

Select * from netflix
where TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 YEARS';
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
Select * from netflix;

select * from netflix
where director ilike '%Rajiv Chilaka%';
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
Select * from netflix;

select * from 
 (select distinct title as tv_shows,
  split_part(duration,' ',1):: numeric as duration 
  from netflix
  where type ='TV Show') as t1
where duration > 5
order by tv_shows;
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
Select * from netflix;

Select Trim(Unnest(string_to_array(listed_in, ','))) as genre, count(show_id) as count_no from netflix
group by  1
order by 2 desc;
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
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
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
Select * from Netflix;

Select * from netflix
where listed_in ilike '%Documentaries%'
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
SELECT * 
FROM netflix
WHERE director IS NULL;
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
Select * from netflix;

Select 
Trim(Unnest(string_to_array(casts,','))) as sep_act, count(*) High_no from netflix
where country ilike '%India%'
group by sep_act
order by 2 desc
limit 10;

```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
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
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.



## Author - Bhuvanesh K

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!
