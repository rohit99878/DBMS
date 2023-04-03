USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:


select count(m_id) from movie;

select count(movie_id) from genre;

select count(movie_id) from names;

select count(movie_id) from rating;

select count(movie_id) from role_mapping;

select 
  table_schema,
  table_name, 
  count_rows(table_schema, table_name)
from information_schema.tables
where
  table_schema in ('public');





-- Q2. Which columns in the movie table have null values?
-- Type your code below:

select * from movie where title = null or year = null or date_published = null or duration = null or country = null or 'movie.worldwide_groos_income' = null or languages = null or production_company = null;








-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

This query for year count
select year,count(id) as number_of_movies from movie group by year order by year;



This query for month count
select date_trunc('month', date_published)month_num,count(title) as number_of_movies from movie group by month_num order by month_num;

select extract(month from date_published)as month_num, count(id) as no_of_movies from movie group by month_num order by month_
num;











/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

select * from movie where year = '2019'and (country = 'USA' or country ='India');










/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

select distinct genre from genre ;










/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

select max(genre),count(genre) from genre group by genre order by count desc limit 5;
select count(title),g.genre from movie m full outer join genre g on m.id=g.movie_id group by g.genre order by count(title) desc








/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

select count(movie_id) from (select movie_id,count(genre) as count from genre group by movie_id having count(genre) = 1) A;

select count(*) from genre where movie_id in (select movie_id from genre group by movie_id having count(movie_id) = 1) ;









/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select avg(duration),g.genre from movie m full join genre g on m.id=g.movie_id group by genre order by avg(duration) desc; 







/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

select genre,count(genre) as movie_count ,rank() over (order by count(genre) desc) as genre_rank from genre group by genre;








/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

select min(avg_rating) as min_avg_rating,max(avg_rating) as max_avg_rating,min(total_votes) as min_total_votes,max(total_votes) as max_total_votes,min(median_rating) as min_median_rating,max(median_rating) as max_median_rating from ratings;






    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

select m.title,r.avg_rating,RANK() over (order by avg_rating desc) as movie_rank from movie m full outer join ratings r on m.id=r.movie_id limit 5;






/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

select rank() over (order by median_rating ),count(r.median_rating) as movie_count  from ratings r full outer join movie m on m.id=r.movie_id group by median_rating  order by median_rating asc;












/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.production_company, COUNT(r.movie_id) as movie_count,
RANK() OVER(
    ORDER BY 
    COUNT(r.movie_id) DESC
    ) prod_company_rank
FROM movie as m
full OUTER JOIN ratings as r
ON m.id = r.movie_id
WHERE r.avg_rating > 8 and production_company is not null
GROUP BY production_company;









-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:




select genre,count(genre) from genre g full outer join movie m on m.id=g.movie_id where m.country='USA' and data_turnc('date',date_published)=3 group by genre ;





-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

select m.title, r.avg_rating,g.genre from movie m full outer join genre g on m.id=g.movie_id join ratings r on g.movie_id=r.movie_id where m.title like 'The%' and r.avg_rating > 8 limit 10;










-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

select title, date_published,ratings.median_rating from movie full outer join ratings on movie.id=ratings.movie_id  where (date_published between '2018-04-01' and '2019-04-01') and ratings.median_rating =8 limit 10;






-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:


select movie.country, sum(ratings.total_votes) from movie full outer join ratings on movie.id=ratings.movie_id where movie.country ilike 'germany' or movie.country ilike 'italy' group by country;





-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


count(case when known_for_movies is null then 'ok' end) as count_known_for_movies from names;
count_names | count_height | date_of_birth_nulls | count_known_for_movies






/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


select n.name as director_name, count(m.title) as movie_count from names n full outer join director_mapping d on n.id=d.name_id full outer join movie m on d.movie_id=m.id full outer join ratings r on m.id=r.movie_id full outer join genre g on m.id=g.movie_id where r.avg_rating > 8 group by director_name order by movie_count desc limit 15;






/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


select n.name as actor, count(m.title)as movie_count from names n full outer join role_mapping rr on n.id=rr.name_id full outer join movie m on rr.movie_id=m.id full outer join ratings r on m.id=r.movie_id where median_rating >=8 group by n.name order by movie_count desc limit 15;





/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

select m.production_company,sum(r.total_votes) as vote_count,rank() over (order by sum(r.total_votes) desc) as prod_comp_rank from movie m join ratings r on m.id=r.movie_id group by m.production_company ORDER BY prod_comp_rank LIMIT 3;






/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT 
	name AS actor_name, total_votes,
    COUNT(m.id) as movie_count,
    ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) AS actor_avg_rating,
    RANK() OVER(ORDER BY avg_rating DESC) AS actor_rank
FROM 
	movie AS m 
INNER JOIN 
	ratings AS r 
ON 
	m.id = r.movie_id 
INNER JOIN 
	role_mapping AS rm 
ON 
	m.id=rm.movie_id 
INNER JOIN 
	names AS nm 
ON 
	rm.name_id=nm.id
WHERE 
	category='actor' AND country= 'india'
GROUP BY name
HAVING COUNT(m.id)>=5;







-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT 
	name AS actress_name, total_votes,
    COUNT(m.id) AS movie_count,
	ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actress_avg_rating,
	RANK() OVER(ORDER BY avg_rating DESC) AS actress_rank
FROM 
	movie AS m 
INNER JOIN
	ratings AS r 
ON 
	m.id = r.movie_id 
INNER JOIN
	role_mapping AS rm 
ON 
	m.id=rm.movie_id 
INNER JOIN
	names AS nm 
ON 
	rm.name_id=nm.id
WHERE
	category='actress' AND country='india' AND languages='hindi'
GROUP BY name
HAVING COUNT(m.id)>=3;








/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:



SELECT 
    title,
    CASE
        WHEN avg_rating > 8 THEN 'Superhit movies'
        WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
        WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
        WHEN avg_rating < 5 THEN 'Flop movies'
    END AS avg_rate_category
FROM
    movie AS m
        INNER JOIN
    genre AS g ON m.id = g.movie_id
        INNER JOIN
    ratings AS r ON m.id = r.movie_id
WHERE
    genre = 'thriller';






/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

WITH genre_summary AS
(
SELECT 
	g.genre,
	ROUND(AVG(m.duration),2) AS avg_duration,
	SUM(SUM(m.duration)) OVER(ORDER BY g.genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
	AVG(AVG(m.duration)) OVER(ORDER BY g.genre ROWS UNBOUNDED PRECEDING) AS moving_avg_duration
FROM 
	genre AS g
INNER JOIN 
	movie AS m
ON 
	g.movie_id=m.id
GROUP BY g.genre
)
SELECT 
	genre, avg_duration, running_total_duration,
	ROUND(moving_avg_duration,2) AS moving_avg_duration
FROM 
	genre_summary;







-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top3_genre_summary AS
( 	
	SELECT 
		genre, COUNT(DISTINCT movie_id) AS no_of_movies
    FROM 
		genre AS g
    INNER JOIN
		movie AS m
    ON 
		g.movie_id = m.id
    GROUP BY genre
    ORDER BY COUNT(movie_id) DESC
    LIMIT 3
),
top5_movie_summary AS
(
SELECT 
	g.genre,
	m.year,
	m.title AS movie_name,
	m.worlwide_gross_income,
	ROW_NUMBER() OVER(PARTITION BY year ORDER BY CONVERT(RIGHT(worlwide_gross_income,LENGTH(worlwide_gross_income)-2),SIGNED) DESC) 
    AS movie_rank
    FROM 
		movie AS m 
    INNER JOIN
		genre AS g 
    ON 
		m.id= g.movie_id
	WHERE
		genre IN (SELECT genre FROM top3_genre_summary)
    )
SELECT *
FROM top5_movie_summary
WHERE movie_rank<=5;








-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
		production_company,
		COUNT(m.id) AS movie_count,
        ROW_NUMBER() OVER(ORDER BY count(id) DESC) AS prod_comp_rank
FROM 
	movie AS m 
INNER JOIN
	ratings AS r 
ON 
	m.id=r.movie_id
WHERE
	median_rating >= 8 AND production_company IS NOT NULL AND POSITION(',' IN languages) > 0
GROUP BY production_company
LIMIT 2;







-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH top_actress_summary AS
(
SELECT 
	n.name AS actress_name,
	SUM(r.total_votes) AS total_votes,
	COUNT(rm.movie_id) AS movie_count,
	ROUND(SUM(avg_rating * total_votes) / SUM(total_votes),2) AS actress_avg_rating
FROM 
	role_mapping AS rm
INNER JOIN 
	names AS n
ON 
	rm.name_id=n.id
INNER JOIN
	genre g
ON 
	rm.movie_id=g.movie_id
INNER JOIN
	ratings AS r
ON 
	rm.movie_id=r.movie_id
WHERE
	rm.category = 'actress' AND r.avg_rating>8 AND g.genre='Drama'
GROUP BY n.id,n.name
ORDER BY movie_count DESC
),
superhit_actress_summary AS
(
SELECT *,
ROW_NUMBER() OVER(ORDER BY movie_count DESC) AS actress_rank
FROM
	top_actress_summary
)
SELECT * 
FROM
	superhit_actress_summary
WHERE 
	actress_rank<=3;







/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH movie_summary AS
(
	SELECT 
		d.name_id AS director_id,
		n.name AS director_name,
		d.movie_id,
		m.date_published,
		LEAD(m.date_published,1) OVER(PARTITION BY d.name_id ORDER BY m.date_published,d.movie_id) AS next_movie_date,
		r.avg_rating,
		r.total_votes,
		m.duration
	FROM 
		director_mapping AS d
	INNER JOIN 
		names AS n
	ON 
		d.name_id=n.id
	INNER JOIN
		movie AS m
	ON 
		d.movie_id=m.id
	INNER JOIN
		ratings AS r
	ON 
		d.movie_id=r.movie_id
),
inter_movie_days_summary AS
(
	SELECT
		director_id,
		ROUND(AVG(DATEDIFF(next_movie_date,date_published)),0) AS avg_inter_movie_days
	FROM
		movie_summary
	GROUP BY director_id
)
SELECT 
	mi.director_id,
	mi.director_name,
	COUNT(mi.movie_id) AS number_of_movies,
	ROUND(AVG(inm.avg_inter_movie_days),0) AS avg_inter_movie_days,
	ROUND(AVG(mi.avg_rating),2) AS avg_rating,
	SUM(mi.total_votes) AS total_votes,
	MIN(mi.avg_rating) AS min_rating,
	MAX(mi.avg_rating) AS max_rating,
	SUM(mi.duration) AS total_duration
FROM 
	movie_summary AS mi
INNER JOIN 
	inter_movie_days_summary AS inm
ON 
	mi.director_id=inm.director_id
GROUP BY mi.director_id, mi.director_name
ORDER BY number_of_movies DESC
LIMIT 9;






