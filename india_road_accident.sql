USE [Indian Road accident Analysis];

SELECT * FROM indian_roads_dataset;

--Explore the data

--total row
select count(*) from indian_roads_dataset;           ---20000

--chack null value
 DECLARE @SQL NVARCHAR(MAX);
                       SELECT @SQL = STRING_AGG(
    'SELECT ''' + COLUMN_NAME + ''' AS ColumnName,
     COUNT(*) AS NullCount
     FROM dbo.indian_roads_dataset
     WHERE ' + COLUMN_NAME + ' IS NULL',
    ' UNION ALL '                                             -- no null value 
)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'indian_roads_dataset';

EXEC sp_executesql @SQL;
SELECT * FROM indian_roads_dataset
-----------analysis------------
/*Q1. Whish state has the most accidents? (High risk states for government action)*/
select 
      state,
	  SUM([casualties])       AS total_casualties
from indian_roads_dataset
GROUP BY state
ORDER BY 2 DESC;

/*What is the most common cause of accidents?*/
select 
      cause,
	  count(*)                  AS total_accidents,
	  ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM indian_roads_dataset),2) AS percentage
from indian_roads_dataset
group by cause
order by 2 desc ;

/*Weather vs Severity - dangerous combinations*/
select 
     accident_severity,
	 weather,
	 count(*)            as total_aciident,
	 DENSE_RANK() over (partition by accident_severity order by count(*) desc ) as rn
from indian_roads_dataset
group by accident_severity,weather


--time Analysis
/*Which hour of the day is most dangerious?*/
select 
      hour               as time,
	  count(*)           as total_accident,
	  sum(casualties)    as total_casualties
from indian_roads_dataset
group by hour 
order by 2 desc

/*Weekend vs Weekday accidents*/
select 
	 CASE
	     WHEN is_weekend = 1 THEN 'Weekend'
		 ELSE 'Weekday'
	END DAY_TYPE,
	 count(*)      as total_accidents,
	 sum(casualties)    as total_casualties
from indian_roads_dataset
group by is_weekend;

/*Does festival increase accidents?*/
SELECT 
     festival,
     count(*)      as total_accidents,
	 sum(casualties)    as total_casualties,
	 count(case when cause = 'drunk driving' then 1 end) as dunk_driving_count
FROM indian_roads_dataset
group by festival
order by 2 desc;

/*Rank cities by fatal acccidents*/
select 
      city,
	  state,
	  count(*) as total_accident,
	  DENSE_RANK() over (order by count(*) desc) as rn
from indian_roads_dataset
where accident_severity = 'fatal'
group by city,state;

/*Running total of casualties by date*/
select 
      date,
	  count(*)    as daily_accidents,
	  sum(casualties) as daily_casualties,
	  sum(sum(casualties))over (order by date  rows unbounded preceding) as running_total
from indian_roads_dataset
group by date;

---Multi-factor risk profilling 
with cte as (
select 
     road_type,
	 weather,
	 visibility,
	 traffic_density,
	 cause,
	 count(*)    as total_accident,
	 sum(casualties)   as total_casualties,
	 count(case when accident_severity = 'fatal' then 1 end) as total_fatal,
	 avg(risk_score) as avg_risk_score
from indian_roads_dataset
group by 
     road_type,
	 weather,
	 visibility,
	 traffic_density,
	 cause
),
rank_profiles as(
select 
        *,
		RANK()over(order by total_fatal desc,avg_risk_score desc) as danger_rank
from cte
)
select top 20                                       ----top 20 data
      *
from rank_profiles                         
order by danger_rank;


/*Find the deadliest combination of hour + road type + weather*/

select
     hour,
	 road_type,
	 weather,
	 count(*)    as total_accident,
	 sum(casualties)   as total_casualties,
	 count(case when accident_severity = 'fatal' then 1 end) as total_fatal,
	 round(avg(risk_score),4) as avg_risk_score
from indian_roads_dataset
group by 
     hour,
	 road_type,
	 weather
order by 
     total_fatal desc,
	 total_casualties desc;

/*Accident trend monthly comparison*/

	WITH monthly_data AS (
SELECT 
    YEAR(date) AS year,
    MONTH(date) AS month,
    COUNT(*) AS total_accident,
    SUM(casualties) AS total_casualties
FROM indian_roads_dataset
GROUP BY YEAR(date), MONTH(date)
)
SELECT 
    year,
    month,
    total_accident,
    total_casualties,
    LAG(total_accident) OVER (ORDER BY year, month) AS pre_month_accident,
    total_accident - LAG(total_accident) OVER (ORDER BY year, month) AS monthly_change
FROM monthly_data;
-------------------------------------***----------------------------------------------------