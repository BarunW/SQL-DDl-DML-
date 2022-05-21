# Opening Prior to Previous Day range
# Closing For the day location
# Closing location prior to predious day range
           # Open close relationship
			
           # closing relationship
			
# Procedure For Following
	# First Disect the Range into Four Parts 
               # use mean method to disect
WITH disect As (
SELECT `Date`
	
	, ROUND(`High` - `Low`,2) as daily_Range
    , `High`
    , ROUND((((`High` + `Low`)/2) + (`High`)) / 2, 2) as top_mean
    , ROUND((`High` + `Low`)/2,2) as daily_Mean
    , ROUND((((`High` + `Low`)/2) + (`Low`)) / 2,2) as lower_mean
    , `Low`
    ,`Open`
    ,`close`
FROM bnf_fut
ORDER BY `Date` Desc
),
open_loc As (
SELECT d.`Date`
	,CASE 
		WHEN d.`Open` > LAG(High,1)OVER(ORDER BY DATE)  THEN "Extreme_High_Quartile" 
		WHEN d.`Open` <= LAG(High,1)OVER(ORDER BY DATE) AND d.`Open` >= LAG(d.top_mean,1)OVER(ORDER BY DATE) THEN "Top_Quartile" 
		WHEN d.`Open` <= LAG(d.top_mean,1)OVER(ORDER BY DATE) AND d.`Open` >= LAG(d.daily_mean,1)OVER(ORDER BY DATE) THEN "Second_Quartile" 
		WHEN d.`Open` <= LAG(d.daily_mean,1)OVER(ORDER BY DATE) AND d.`Open` >= LAG(d.lower_mean,1)OVER(ORDER BY DATE) THEN "Third_Quartile" 
        WHEN d.`Open` <= LAG(d.lower_mean,1)OVER(ORDER BY DATE) AND d.`Open` >= LAG(d.Low,1)OVER(ORDER BY DATE) THEN "Low_Quartile" 
		WHEN d.`Open` < LAG(Low,1)OVER(ORDER BY DATE)  THEN "Extreme_Low_Quartile" 
        ELSE "N/A"
    END As Opening_Loc,
    CASE WHEN d.`close` < LAG(d.High,1)OVER(ORDER BY DATE) THEN "CIYR"
		 WHEN d.`close` < LAG(d.Low,1)OVER(ORDER BY DATE) THEN "CBYR"
		ELSE "CAYR" ## cBYR
    END AS Closing_Loc
FROM disect d
)
SELECT * FROM 
open_loc


