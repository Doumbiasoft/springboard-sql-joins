-- 1. The first example shows the goal scored by a player with the last name 'Bender'. The * says to list all the columns in the table - a shorter way of saying matchid, teamid, player, gtime
-- Modify it to show the matchid and player name for all goals scored by Germany. To identify German players, check for: teamid = 'GER'

SELECT matchid, player FROM goal 
  WHERE teamid = 'GER'

-- 2. From the previous query you can see that Lars Bender's scored a goal in game 1012. Now we want to know what teams were playing in that match.
-- Notice in the that the column matchid in the goal table corresponds to the id column in the game table. 
-- We can look up information about game 1012 by finding that row in the game table.
-- Show id, stadium, team1, team2 for just game 1012

SELECT id,stadium,team1,team2
  FROM game  
WHERE id= 1012

-- 3. You can combine the two steps into a single query with a JOIN.
-- SELECT * FROM game JOIN goal ON (id=matchid)
-- The FROM clause says to merge data from the goal table with that from the game table. 
-- The ON says how to figure out which rows in game go with which rows in goal - the matchid from goal must match id from game. 
-- (If we wanted to be more clear/specific we could say
-- ON (game.id=goal.matchid)
-- The code below shows the player (from the goal) and stadium name (from the game table) for every goal scored.
-- Modify it to show the player, teamid, stadium and mdate for every German goal.

SELECT s.player,s.teamid, g.stadium, g. mdate
  FROM game g JOIN goal s ON (g.id = s.matchid)
WHERE s.teamid='GER'

-- 4. Use the same JOIN as in the previous question.
-- Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'

SELECT  g.team1, g.team2, s.player
  FROM game g JOIN goal s ON (g.id = s.matchid)
WHERE s.player LIKE 'Mario%'

-- 5. The table eteam gives details of every national team including the coach. You can JOIN goal to eteam using the phrase goal JOIN eteam on teamid=id
-- Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10

SELECT g.player, g.teamid, e.coach, g.gtime
  FROM goal g JOIN eteam e ON g.teamid = e.id  
 WHERE gtime <= 10

-- 6. To JOIN game with eteam you could use either
-- game JOIN eteam ON (team1=eteam.id) or game JOIN eteam ON (team2=eteam.id)
-- Notice that because id is a column name in both game and eteam you must specify eteam.id instead of just id
-- List the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach. 

SELECT g.mdate, t.teamname 
FROM game g
JOIN eteam t
ON g.team1 = t.id
WHERE t.coach ='Fernando Santos'

-- 7. List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'

SELECT go.player
  FROM goal go
  JOIN game gm 
  ON (go.matchid = gm.id)
WHERE gm.stadium = 'National Stadium, Warsaw'

-- 8. The example query shows all goals scored in the Germany-Greece quarterfinal.
-- Instead show the name of all players who scored a goal against Germany.
-- HINT
-- Select goals scored only by non-German players in matches where GER was the id of either team1 or team2.
-- You can use teamid!='GER' to prevent listing German players.
-- You can use DISTINCT to stop players being listed twice.

SELECT DISTINCT go.player 
FROM goal go
JOIN game gm ON go.matchid = gm.id
WHERE go.teamid !='GER' AND (gm.team1='GER' OR gm.team2='GER')

-- 9. Show teamname and the total number of goals scored.
-- COUNT and GROUP BY
-- You should COUNT(*) in the SELECT line and GROUP BY teamname

SELECT teamname,COUNT(*) AS total
  FROM eteam JOIN goal ON id = teamid
 GROUP BY teamname
 ORDER BY teamname

-- 10. Show the stadium and the number of goals scored in each stadium.

SELECT gm.stadium,COUNT(*) FROM game gm 
JOIN goal go ON gm.id = go.matchid
GROUP BY gm.stadium

-- 11. For every match involving 'POL', show the matchid, date and the number of goals scored.

SELECT go.matchid,gm.mdate, COUNT(*) as number_of_goal
  FROM game gm JOIN goal go ON go.matchid = gm.id 
 WHERE (team1 = 'POL' OR team2 = 'POL')
GROUP BY go.matchid,gm.mdate

-- 12. For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'

SELECT go.matchid,gm.mdate, COUNT(*) as number_of_goal
  FROM game gm JOIN goal go ON go.matchid = gm.id 
 WHERE go.teamid = 'GER' 
GROUP BY go.matchid,gm.mdate

-- 13. List every match with the goals scored by each team as shown. 
-- This will use "CASE WHEN" which has not been explained in any previous exercises.

SELECT gm.mdate,
  gm.team1,
  SUM(CASE WHEN go.teamid = gm.team1 THEN 1 ELSE 0 END) score1,
  gm.team2,
  SUM(CASE WHEN go.teamid = gm.team2 THEN 1 ELSE 0 END) score2
  FROM game gm JOIN goal go ON go.matchid = gm.id
  GROUP BY gm.mdate, go.matchid, gm.team1, gm.team2
  ORDER BY gm.mdate, go.matchid, gm.team1, gm.team2

  