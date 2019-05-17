CREATE DATABASE IF NOT EXISTS ${hivevar:database_name};

USE ${hivevar:database_name};

DROP TABLE IF EXISTS movie_ratings_red;
DROP TABLE IF EXISTS movie_ratings_amber;
DROP TABLE IF EXISTS movie_ratings_green;

CREATE EXTERNAL TABLE movie_ratings_red (
  `uuid` string, 
  `movieId` string, 
  `title` string, 
  `genres` string,
  `userId` string,  
  `rating` string, 
  `ts` string
)
STORED AS PARQUET
LOCATION '${hivevar:database_path}/movie_ratings_red';

CREATE EXTERNAL TABLE movie_ratings_amber (
  `uuid` string, 
  `movieId` string, 
  `title` string, 
  `genres` string,  
  `rating` string, 
  `ts` string
)
STORED AS PARQUET
LOCATION '${hivevar:database_path}/movie_ratings_amber';

CREATE EXTERNAL TABLE movie_ratings_green (
  `uuid` string, 
  `movieId` string, 
  `title` string, 
  `genres` string, 
  `ts` string
)
STORED AS PARQUET
LOCATION '${hivevar:database_path}/movie_ratings_green';

