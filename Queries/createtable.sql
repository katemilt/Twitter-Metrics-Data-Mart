CREATE TABLE tweet_metrics.users (
                         userid int NOT NULL,
                         surrogate_key int NOT NULL,
                         gender varchar(20) NULL DEFAULT ''::character varying,
                         locationID varchar(20) NULL DEFAULT ''::character varying,
                         city varchar(40) NULL DEFAULT ''::character varying,

                         statecode varchar(25) NULL DEFAULT ''::character varying,
                         country varchar(40) NULL DEFAULT ''::character varying,

                         PRIMARY KEY (userid));
CREATE TABLE tweet_metrics.tweet (
                     tweetid int NOT NULL,
                     surrogate_key int NOT NULL,
                     isreshare varchar(20) NULL DEFAULT ''::character varying,
                     
                     
                     
                     PRIMARY KEY (tweetid));
CREATE TABLE tweet_metrics.date (
                     dateid int NOT NULL,
                     surrogate_key int NOT NULL,
                     day int NOT NULL,
                     hour int NOT NULL,
                     weekday varchar(20) NULL DEFAULT ''::character varying,
                     weekdayindicator varchar(20) NULL DEFAULT ''::character varying,
                     PRIMARY KEY (dateid));
CREATE TABLE tweet_metrics.language (
                     languageid int NOT NULL,
                     surrogate_key int NOT NULL,
                     sentiment real NOT NULL,
                    
                     lang varchar(20) NULL DEFAULT ''::character varying,
                     text varchar(25000) NULL DEFAULT ''::character varying,
                     PRIMARY KEY (languageid));


CREATE TABLE tweet_metrics.fact_table (
                    surrogate_key INT,
                    
                     Reach INT,
                    RetweetCount INT,
                    Likes INT,
                    Klout INT,
                    TweetLength INT);


CREATE TABLE tweet_metrics.fact_table_final (
                    surrogate_key INT,
                    
                     Reach INT,
                    RetweetCount INT,
                    Likes INT,
                    Klout INT,
	TweetLength INT,
                    userid INT,
                    tweetid int,
                    languageid INT,
                    dateid INT,
	
                    FOREIGN KEY (userid) REFERENCES tweet_metrics.users (userid),
                    FOREIGN KEY (tweetid) REFERENCES tweet_metrics.tweet (tweetid),
                    FOREIGN KEY (languageid) REFERENCES tweet_metrics.language (languageid),
                    FOREIGN KEY (dateid) REFERENCES tweet_metrics.date (dateid));