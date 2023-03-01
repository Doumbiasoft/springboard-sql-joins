-- 1. List the films where the yr is 1962 [Show id, title]

SELECT id, title
 FROM movie
 WHERE yr=1962

-- 2. Give year of 'Citizen Kane'.

SELECT m.yr
 FROM movie m
 WHERE m.title = 'Citizen Kane'

-- 3. List all of the Star Trek movies, include the id, title and yr 
-- (all of these movies include the words Star Trek in the title). Order results by year.

SELECT m.id,m.title, m.yr
 FROM movie m
 WHERE m.title LIKE '%Star Trek%'

-- 4. What id number does the actor 'Glenn Close' have?

SELECT id 
FROM actor 
WHERE name='Glenn Close'

-- 5. What is the id of the film 'Casablanca'

SELECT id 
FROM movie 
WHERE title='Casablanca'

-- 6. Obtain the cast list for 'Casablanca'.
-- what is a cast list?
-- The cast list is the names of the actors who were in the movie.
-- Use movieid=11768, (or whatever value you got from the previous question)

SELECT a.name FROM casting c
JOIN actor a ON c.actorid = a.id
JOIN movie m ON c.movieid = m.id
WHERE c.movieid = 27
GROUP BY a.id,a.name

-- 7. Obtain the cast list for the film 'Alien'

SELECT a.name FROM casting c
JOIN actor a ON c.actorid = a.id
JOIN movie m ON c.movieid = m.id
WHERE m.title = 'Alien'
GROUP BY a.id,a.name

-- 8. List the films in which 'Harrison Ford' has appeared

SELECT m.title FROM movie m
JOIN casting c ON m.id = c.movieid
JOIN actor a ON c.actorid = a.id
WHERE a.name = 'Harrison Ford'

-- 9. List the films where 'Harrison Ford' has appeared - but not in the starring role. 
-- [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]

SELECT m.title FROM movie m
JOIN casting c ON m.id = c.movieid
JOIN actor a ON c.actorid = a.id
WHERE a.name = 'Harrison Ford' AND c.ord !=1

-- 10. List the films together with the leading star for all 1962 films.

SELECT m.title, a.name FROM movie m
JOIN casting c ON m.id = c.movieid
JOIN actor a ON c.actorid = a.id
WHERE m.yr = 1962 AND c.ord = 1

-- 11. Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies.

SELECT m.yr, COUNT(m.title) as movie_number 
FROM movie m
 JOIN casting c ON m.id= c.movieid
 JOIN actor a  ON c.actorid = a.id
WHERE a.name ='Rock Hudson'
GROUP BY m.yr
HAVING COUNT(m.title) > 2


-- 12. List the film title and the leading actor for all of the films 'Julie Andrews' played in.
-- Did you get "Little Miss Marker twice"?
-- Julie Andrews starred in the 1980 remake of Little Miss Marker and not the original(1934).
-- Title is not a unique field, create a table of IDs in your subquery

SELECT m.title, a.name 
FROM movie m
JOIN casting c ON m.id = c.movieid
JOIN actor a ON a.id = c.actorid
WHERE c.ord = 1 AND c.movieid IN
(SELECT movieid FROM casting 
JOIN actor ON actor.id = actorid
WHERE name ='Julie Andrews')


-- 13. Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles.

SELECT a.name
FROM actor a
 JOIN casting c 
  ON (a.id = c.actorid 
  AND (SELECT COUNT(ord) FROM casting WHERE actorid = a.id AND ord=1) >= 15)
GROUP BY a.name

-- 14. List the films released in the year 1978 ordered by the number of actors in the cast, then by title.

SELECT m.title, COUNT(c.actorid) 
FROM movie m
JOIN casting c on m.id= c.movieid
WHERE m.yr = 1978
GROUP BY m.title
ORDER BY COUNT(c.actorid) desc 

-- 15. List all the people who have worked with 'Art Garfunkel'.

SELECT DISTINCT a.name
FROM actor a JOIN casting c ON a.id = c.actorid
WHERE c.movieid 
IN (SELECT movieid FROM casting JOIN actor ON (actorid = id AND name='Art Garfunkel')) 
AND a.name != 'Art Garfunkel'
GROUP BY a.name
