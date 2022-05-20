WITH CTE AS (
SELECT s.`year`
	,REPLACE(g.`growth_rate(%)`,'%','') "growth_rate(%)"
    ,REPLACE(i.`inflation_rate`,'%','') "inflation_rate(%)"
    ,REPLACE(u.`unemployement_rate`,'%','') "unemployement_rate(%)"
FROM economyindicator.strength_index s
INNER JOIN gdp g
ON s.`year` = g.`year`
INNER JOIN inflation i
ON s.`year` = i.`year`
INNER JOIN unemployement u
ON s.`year` = u.`year`
ORDER BY s.`year` DESC 
)
SELECT c.`year`
    ,CAST(c.`growth_rate(%)` 		AS FLOAT)"growth_rate(%)"
    ,CAST(c.`inflation_rate(%)` 	AS FLOAT) "inflation_rate(%)"
    ,CAST(C.`unemployement_rate(%)`	AS FLOAT) "unemployement_rate(%)"
FROM CTE c