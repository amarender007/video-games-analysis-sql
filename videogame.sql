
-- Top 10 Games with Highest user Rating overall
select top 10 title, year(release_date) as year, user_score from all_video_games
where Release_Date is not null
order by user_score desc

-- Games with Highest user rating each year
with highest_reating(rank,title, [year], user_score)
as(
select rank() over(partition by year(release_date) order by user_score desc) as rank,
title, user_score , YEAR(release_date) as [year] from all_video_games
where Release_Date is not null
)
select title, [year], user_score from highest_reating
where rank = 1

 
--Games with Highest user score in each genre
with genre_rating([rank],title,user_score,genres)
as(
select rank() over(partition by genres order by user_score desc) as [rank],
title, user_score, genres from all_video_games
where Release_Date is not null and genres is not null)
select * from genre_rating 
where rank = 1



--Games with highest user score in each genre every year
with highest_reating(rank,title, [year], user_score,genres)
as(
select rank() over(partition by year(release_date) order by user_score desc) as rank,
title, user_score , YEAR(release_date) as [year], Genres from all_video_games
where Release_Date is not null
)
select title, [year], user_score,genres from highest_reating
where rank = 1

--Highest rating games from each developer
select Developer, Title,user_score from all_video_games
where User_Score >= 8 
order by User_Score desc

--The number of games each developer has with a user score of 8 or higher
select developer , count(title) [count] from all_video_games
where User_Score >= 8 and Developer is not null
group by Developer
order by [count] desc

--The highest-rated game by each developer each year
with higest_rated([year], developer,title,user_score,[rank])
as(
select year(Release_Date) as [year],Developer,Title,User_Score,
rank() over(partition by year(release_date),developer order by user_score desc) [rank]
from all_video_games
where User_Score is not null
)
select [year], developer,title,user_score from higest_rated
where [rank] = 1
order by [year] asc

--Number of titles in each genre with a user score of 8 or higher.
select Genres,count(title) as [count] from all_video_games
where User_Score >= 8 and Genres is not null
group by Genres
order by [count] desc