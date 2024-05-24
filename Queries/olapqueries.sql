--Part A (i)
--Drill Down for tweets by country => by city
SELECT country, SUM(Reach) AS TotalReach, SUM(likes) AS TotalLikes, SUM(retweetcount) AS TotalRetweets, SUM(klout) AS TotalKlout
FROM tweet_metrics.fact_table_final
JOIN tweet_metrics.users ON fact_table_final.userid = users.userid
GROUP BY country;

SELECT city, SUM(Reach) AS TotalReach, SUM(likes) AS TotalLikes, SUM(retweetcount) AS TotalRetweets, SUM(klout) AS TotalKlout
FROM tweet_metrics.fact_table_final
JOIN tweet_metrics.users ON fact_table_final.userid = users.userid
WHERE country = 'Indonesia'
GROUP BY city;

--Roll up for tweets by day
SELECT date.weekday, SUM(fact_table_final.Reach) AS TotalReach, SUM(likes) AS TotalLikes, SUM(retweetcount) AS TotalRetweets, SUM(klout) AS TotalKlout
FROM tweet_metrics.fact_table_final
JOIN tweet_metrics.date ON fact_table_final.dateid = date.dateid
GROUP BY date.weekday;

--Slice by country
SELECT city, gender, SUM(Reach) AS TotalReach, SUM(likes) AS TotalLikes, SUM(retweetcount) AS TotalRetweets, SUM(klout) AS TotalKlout
FROM tweet_metrics.fact_table_final
JOIN tweet_metrics.users ON fact_table_final.userid = users.userid
WHERE country = 'Indonesia'
GROUP BY city,gender;

--Dice operation by country and language
SELECT country, lang, SUM(Reach) AS TotalReach, SUM(likes) AS TotalLikes, SUM(retweetcount) AS TotalRetweets, SUM(klout) AS TotalKlout
FROM tweet_metrics.fact_table_final
JOIN tweet_metrics.users ON fact_table_final.userid = users.userid
JOIN tweet_metrics.language ON fact_table_final.languageid = language.languageid
WHERE country = 'Germany' AND lang = 'en'
GROUP BY country, lang;

--Dice operation by country and gender
SELECT gender, country, SUM(Reach) AS TotalReach, SUM(likes) AS TotalLikes, SUM(retweetcount) AS TotalRetweets, SUM(klout) AS TotalKlout
FROM tweet_metrics.fact_table_final
JOIN tweet_metrics.users ON fact_table_final.userid = users.userid
WHERE gender = 'Male' AND country = 'Germany'
GROUP BY gender, country;

--Combining OLAP operations
--1.Drill down and dice
SELECT city, gender, SUM(Reach) AS TotalReach, SUM(likes) AS TotalLikes, SUM(retweetcount) AS TotalRetweets, SUM(klout) AS TotalKlout
FROM tweet_metrics.fact_table_final
JOIN tweet_metrics.users ON fact_table_final.userid = users.userid
WHERE gender = 'Male' AND country = 'Indonesia'
GROUP BY city, gender;

--2.Roll up and slice
SELECT country, SUM(Reach) AS TotalReach, SUM(likes) AS TotalLikes, SUM(retweetcount) AS TotalRetweets, SUM(klout) AS TotalKlout
FROM tweet_metrics.fact_table_final
JOIN tweet_metrics.users ON fact_table_final.userid = users.userid
GROUP BY ROLLUP(country)
HAVING country = 'Indonesia';

--3.Slice and Drill down
SELECT city, gender, SUM(Reach) AS TotalReach, SUM(likes) AS TotalLikes, SUM(retweetcount) AS TotalRetweets, SUM(klout) AS TotalKlout
FROM tweet_metrics.fact_table_final
JOIN tweet_metrics.users ON fact_table_final.userid = users.userid
WHERE country = 'Indonesia'
GROUP BY city, gender;

--4.Roll up and Dice
SELECT country, SUM(Reach) AS TotalReach, SUM(likes) AS TotalLikes, SUM(retweetcount) AS TotalRetweets, SUM(klout) AS TotalKlout
FROM tweet_metrics.fact_table_final
JOIN tweet_metrics.users ON fact_table_final.userid = users.userid
WHERE country IN ('Indonesia', 'Germany')
GROUP BY ROLLUP(country);

--Display userid,gender,location of Top 10 highest reach
SELECT f.userid, f.Reach, u.gender, u.locationID, u.city, u.statecode, u.country
FROM tweet_metrics.fact_table_final f
JOIN tweet_metrics.users u ON f.userid = u.userid
ORDER BY f.Reach DESC
LIMIT 10;

--Part A (ii)
--windowing query the ranking of countries in terms of retweet count, reported per gender

WITH ranked_countries AS (
    SELECT
        u.gender,
        u.country,
        COUNT(*) AS retweet_count,
        RANK() OVER (PARTITION BY u.gender ORDER BY COUNT(*) DESC) AS country_rank
    FROM
        tweet_metrics.users u
    JOIN
        tweet_metrics.fact_table_final f ON u.userid = f.userid
    GROUP BY
        u.gender, u.country
)
SELECT
    gender,
    country,
    retweet_count,
    country_rank
FROM
    ranked_countries;

--window clause to compare the reach of Canada,france and germany
WITH country_reach AS (
    SELECT
        u.country,
        SUM(f.Reach) AS total_reach,
        RANK() OVER (ORDER BY SUM(f.Reach) DESC) AS reach_rank
    FROM
        tweet_metrics.users u
    JOIN
        tweet_metrics.fact_table_final f ON u.userid = f.userid
    WHERE
        u.country IN ('Canada', 'France', 'Germany')
    GROUP BY
        u.country
)
SELECT
    country,
    total_reach,
    reach_rank
FROM
    country_reach;


