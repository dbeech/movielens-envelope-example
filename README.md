# MovieLens Envelope RBAC Example

This example shows a simple ETL pipeline developed using Cloudera Labs' 
[Envelope](https://github.com/cloudera-labs/envelope) framework, taking CSV files 
containing movie information and rating scores from the publicly accessible 
[MovieLens 20m dataset](https://grouplens.org/datasets/movielens/20m/) and ingesting
into the Cloudera cluster as Parquet-formatted Hive tables. 

## Data Classification Scenario

For a data security / RBAC PoC, classifications of "red", "amber" and "green" are being 
considered (with "red" being most sensitive, "green" being least sensitive). For this
example, we're imagining that the movie watcher's ID and the rating they gave are 
classed as personal information, and we've classified the fields as follows:

| Data Column | Classification |
|----- |---- |
| `uuid` | Green |
| `movieId` | Green |
| `title` | Green |
| `genres` | Green |
| `userId` | Red |
| `rating` | Amber |
| `ts` | Green |


## ETL Pipeline

There are several possible approaches for building the different classified datasets. Here are two examples:

### Approach 1: Duplicate and sanitise

The Envelope job (specified in `movielens.conf`) performs the following actions:

1. Reads CSV files containing movies and ratings
2. Loads each of these into a Spark SQL Dataset
3. Joins the two Datasets together to give a denormalised copy, and adds a UUID to each row
4. Creates three Hive tables at different classification levels:
  - Red table (contains all columns)
  - Amber table (contains all columns, except `userId`)
  - Green table (contains all columns, except `userId` and `rating`)
5. Converts and writes to Hive tables in Snappy-compressed Parquet format

The access to the three versions of the tables can now be separately controlled using
a combination of Sentry (for Hive and Impala access) and HDFS ACLs (for Spark).

```
$ spark2-submit envelope-0.7.1.jar movielens.conf
```

### Approach 2: Split out sensitive columns, reconstruct in views

The Envelope job (specified in `movielens_sliced.conf`) is identical to Approach 1 except for Step 4, 
where we still create three Hive tables, but now each contains only the subset of columns at each 
classification level along with the common join key `uuid`.

The accompanying SQL script `movielens_sliced.sql` defines three views which reconstruct the full
versions of each dataset by joining the tables back together. 




