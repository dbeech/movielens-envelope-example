CREATE DATABASE IF NOT EXISTS ${hivevar:database_name};

USE ${hivevar:database_name};

DROP TABLE IF EXISTS movie_ratings_red_partial;
DROP TABLE IF EXISTS movie_ratings_amber_partial;
DROP TABLE IF EXISTS movie_ratings_green_partial;

DROP VIEW IF EXISTS movie_ratings_red_reconstructed;
DROP VIEW IF EXISTS movie_ratings_amber_reconstructed;
DROP VIEW IF EXISTS movie_ratings_green_reconstructed;

CREATE EXTERNAL TABLE movie_ratings_red_partial (
  `uuid` string, 
  `userId` string  
)
STORED AS PARQUET
LOCATION '${hivevar:database_path}/movie_ratings_red_partial';

CREATE EXTERNAL TABLE movie_ratings_amber_partial (
  `uuid` string,  
  `rating` string 
)
STORED AS PARQUET
LOCATION '${hivevar:database_path}/movie_ratings_amber_partial';

CREATE EXTERNAL TABLE movie_ratings_green_partial (
  `uuid` string, 
  `movieId` string, 
  `title` string, 
  `genres` string, 
  `ts` string
)
STORED AS PARQUET
LOCATION '${hivevar:database_path}/movie_ratings_green_partial';

CREATE VIEW movie_ratings_red_reconstructed
AS
SELECT 
 green.*,
 amber.rating,
 red.userid
FROM movie_ratings_green_partial green
INNER JOIN movie_ratings_amber_partial amber 
  ON green.uuid = amber.uuid
INNER JOIN movie_ratings_red_partial red 
  ON amber.uuid = red.uuid;

CREATE VIEW movie_ratings_amber_reconstructed
AS
SELECT 
 green.*,
 amber.rating
FROM movie_ratings_green_partial green
INNER JOIN movie_ratings_amber_partial amber 
  ON green.uuid = amber.uuid;

CREATE VIEW movie_ratings_green_reconstructed
AS
SELECT 
 green.*
FROM movie_ratings_green_partial green;