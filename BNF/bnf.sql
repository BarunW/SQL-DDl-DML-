WITH CTE AS (
SELECT *
	,LAG(`Close`,1) OVER(ORDER BY `Date`) AS Previous_Day_Close
    ,dayname(`Date`) As Day_name
    ,ROUND((High-Low),2) AS Day_Range
    ,`Open` - LAG(`Close`,1) OVER(ORDER BY `Date`) AS Open_Gap_Up_Down #GAP POINT
FROM bnf_fut
ORDER BY `Date` 
),
CTE2 AS(
	SELECT * 
    ,ROUND((c.Day_Range/c.Close)*100,2) AS "Day_Range(%)"
    ,ROUND((c.`Open_Gap_Up_Down`/c.`Previous_Day_Close`) * 100,2) AS "Gap_Point(%)"
	,CASE 
		WHEN c.`Open_Gap_Up_Down` < 0 THEN ROUND(((c.`High` - c.`Open`)/c.`Open_Gap_Up_Down`) * -100,2) /*For Gapdown value will always x >= 0 */
		WHEN c.`Open_Gap_Up_Down` > 0 THEN ROUND(((c.`Low` - c.`Open`)/c.`Open_Gap_Up_Down`) * 100,2) /*value will always x <= 0 */
     END AS `Gap_Fill_Point%`
	,CASE 
		WHEN c.`Open_Gap_Up_Down` < 0 THEN ROUND((c.`High` - c.`Open`),2) 
		WHEN c.`Open_Gap_Up_Down` > 0 THEN ROUND((c.`Low` - c.`Open`),2) 
     END AS `Gap_Fill_Point`
FROM CTE c
),
CTE3 AS(
SELECT * 
	/*,CASE 
		WHEN c2.`Open_Gap_Up_Down` < 0 AND  c2.`Gap_Fill_Point%` >= 70 THEN "GAP FILL UP" 
        WHEN c2.`Open_Gap_Up_Down` > 0 AND  c2.`Gap_Fill_Point%` >= 70 THEN "GAP FILL DOWN" 
		ELSE "NOT FILL"
    END AS Remarks
    ,CASE 
		WHEN c2.`Gap_Point(%)` <= 0.32 AND c2.`Gap_Point(%)` >=-0.32  THEN 
				CASE
					WHEN c2.Open > c2.Previous_Day_Close  THEN "FLAT UP"
					WHEN c2.Open < c2.Previous_Day_Close  THEN "FLAT DOWN"
				END
        WHEN c2.`Gap_Point(%)` >= -0.70 AND c2.`Gap_Point(%)` <= -0.33  OR c2.`Gap_Point(%)` >= 0.33 AND c2.`Gap_Point(%)` < 0.70   THEN 
				CASE 
					WHEN c2.Open > c2.Previous_Day_Close and `Gap_Point(%)` >= 0.33 AND `Gap_Point(%)` <= 0.7 THEN "MEDIUM GAP UP"
					WHEN c2.Open < c2.Previous_Day_Close THEN "MEDIUM GAP DOWN"
				END
        WHEN c2.`Gap_Point(%)` >= 0.70 OR c2.`Gap_Point(%)` <= -0.70  THEN 
				CASE
					WHEN c2.Open > c2.Previous_Day_Close  THEN "BIG GAP UP"
					WHEN c2.Open < c2.Previous_Day_Close  THEN "BIG GAP DOWN"
				END
        ELSE "NOT DEFINED"
	END AS Opening_type
    */
    
FROM CTE2 c2
)
SELECT c.`Date`
	,c.`Day_name`
    ,ROUND(c.Open,2) AS Open
	,ROUND(c.`Open_Gap_Up_Down`,1) AS Gap_Point
	,c.`Gap_Point(%)`
    /*,c.`Opening_type` AS "Open_Gap_Type"
    ,c.`Remarks`*/
    ,c.`Gap_Fill_Point` 
	,c.`Gap_Fill_Point%`
    ,c.Low
    ,c.High
    ,c.Day_Range
    ,c.close
    ,c.`Day_Range(%)`
FROM CTE2 c
#WHERE c.Date > '2022-02-28' #!= '2017-04-03' AND c.DATE >= '2022-01-01' AND c.`Opening_type` like 'BIG GAP%'
where c.`Gap_Point(%)`=  -1.24
ORDER BY c.`Date` DESC

# Revised Gap point labeling
# Revised Gap fill

