-- question 3.1
-- average grade of each chef
SELECT 
    CH_ID, 
    AVG(Grade) AS mean_grade
FROM 
    plays
GROUP BY 
    CH_ID;

-- average grade of each cuisine 
SELECT 
    Cuisine, 
    AVG(Grade) AS mean_grade
FROM 
    plays
GROUP BY 
    Cuisine;

-- question 3.2
-- Asuumption is that we want every chef from a certain cuisine that was assigned
-- a recipe from that cuisine in every season

SELECT DISTINCT ep.Season,p.Cuisine,cu.Name,p.CH_ID,c.First_Name,c.Last_Name
FROM plays p JOIN episodes ep ON p.EP_ID=ep.EP_ID JOIN Chefs c ON c.CH_id=p.CH_id JOIN ethnic_cuisine cu ON p.Cuisine=cu.CU_ID
ORDER BY ep.Season,p.Cuisine
;

-- Second query is just which Chef belongs to each cuisine
SELECT cu.Name,c.First_Name, c.Last_Name 
FROM chef_cu cc 
JOIN chefs c ON cc.CH_ID=c.CH_ID 
JOIN ethnic_cuisine cu ON cu.CU_ID=cc.CU_ID;
-- question 3.3
-- it doesnt specify how many chefs should i return so i said top 5
SELECT 
    c.CH_ID, 
    c.First_Name, 
    c.Last_Name, 
    c.Age,
    COUNT(r.REC_ID) AS Recipe_Count
FROM 
    chefs c
JOIN 
    rec_chef r ON c.CH_ID = r.CH_ID
WHERE 
    c.Age < 30
GROUP BY 
    c.CH_ID, c.First_Name, c.Last_Name, c.Age
ORDER BY 
    Recipe_Count DESC
LIMIT 5;

-- question 3.4
SELECT 
    c.CH_ID, 
    c.First_Name, 
    c.Last_Name
FROM 
    chefs c
LEFT JOIN 
    judges j ON c.CH_ID = j.CH_ID
WHERE 
    j.CH_ID IS NULL;

-- question 3.5
-- i reduced the appearences to more than 2 instead of three to not get empty result
WITH judge_appearances AS (
    SELECT 
        j.CH_ID,
        e.Season,
        COUNT(j.EP_ID) AS EpisodeCount
    FROM 
        judges j
    JOIN 
        episodes e ON j.EP_ID = e.EP_ID
    GROUP BY 
        j.CH_ID, e.Season
)
SELECT 
    j1.CH_ID AS Judge1_ID,
    j2.CH_ID AS Judge2_ID,
    j1.Season,
    j1.EpisodeCount
FROM 
    judge_appearances j1
JOIN 
    judge_appearances j2 
    ON j1.Season = j2.Season 
    AND j1.EpisodeCount = j2.EpisodeCount 
    AND j1.CH_ID < j2.CH_ID
WHERE 
    j1.EpisodeCount > 2
ORDER BY 
    j1.Season, j1.EpisodeCount;
    
-- question 3.6
-- basic version
EXPLAIN
WITH label_pairs AS (
    SELECT 
        r1.REC_ID,
        r1.LA_ID AS label1,
        r2.LA_ID AS label2
    FROM 
        rec_label r1
    JOIN 
        rec_label r2 ON r1.REC_ID = r2.REC_ID AND r1.LA_ID < r2.LA_ID
),


Pair_ep_count AS (
    SELECT 
        lp.label1,
        lp.label2,
        COUNT(DISTINCT p.EP_ID) AS EpCount
    FROM 
        label_pairs lp
        
    JOIN 
        plays p ON lp.REC_ID = p.recipe
    GROUP BY 
        lp.label1, lp.label2
)

SELECT 
    pc.label1,
    pc.label2,
    pc.EpCount
FROM 
    Pair_ep_count pc
ORDER BY 
    pc.EpCount DESC
LIMIT 3;

-- version with force index

EXPLAIN
WITH label_pairs AS (
    SELECT 
        r1.REC_ID,
        r1.LA_ID AS label1,
        r2.LA_ID AS label2
    FROM 
        rec_label r1 FORCE INDEX (PRIMARY,REC_idx)
    JOIN 
        rec_label r2 FORCE INDEX (PRIMARY,REC_idx)
        ON r1.REC_ID = r2.REC_ID AND r1.LA_ID < r2.LA_ID
),


Pair_ep_count AS (
    SELECT 
        lp.label1,
        lp.label2,
        COUNT(DISTINCT p.EP_ID) AS EpCount
    FROM 
        label_pairs lp
        
    JOIN 
        plays p FORCE INDEX (idx_ep_rec)
        ON lp.REC_ID = p.recipe
    GROUP BY 
        lp.label1, lp.label2
)

SELECT 
    pc.label1,
    pc.label2,
    pc.EpCount
FROM 
    Pair_ep_count pc
ORDER BY 
    pc.EpCount DESC
LIMIT 3;

-- question 3.7
WITH max1 AS (
SELECT COUNT(p.EP_ID) AS EpisodeCount 
FROM chefs c
JOIN plays p ON c.CH_ID=p.CH_ID
GROUP BY
p.CH_ID
ORDER BY
 COUNT(p.EP_ID) DESC
 LIMIT 1

) 

SELECT c.CH_ID, c.First_Name, c.Last_Name, COUNT(p.EP_ID) AS EpisodeCount
FROM chefs c
JOIN plays p ON c.CH_ID=p.CH_ID
GROUP BY c.CH_ID, c.First_Name, c.Last_Name
HAVING COUNT(p.EP_ID) <= (SELECT EpisodeCount FROM max1) - 5
ORDER BY EpisodeCount DESC;
;


-- question 3.8
-- without force index
EXPLAIN
WITH EpGearCount AS (
    SELECT 
        p.EP_ID,
        COUNT(rg.GR_ID) AS GearCount
    FROM 
        rec_gear rg
    JOIN 
        plays p ON rg.REC_ID = p.recipe
    GROUP BY 
        p.EP_ID
)
SELECT 
    ec.EP_ID,
    ec.GearCount
FROM 
    EpGearCount ec
ORDER BY 
    ec.GearCount DESC
LIMIT 1;


-- with force index
EXPLAIN
WITH EpGearCount AS (
    SELECT 
        p.EP_ID,
        COUNT(rg.GR_ID) AS GearCount
    FROM 
        rec_gear rg  FORCE INDEX (PRIMARY)
    JOIN 
        plays p FORCE INDEX (idx_ep_rec) ON rg.REC_ID = p.recipe
    GROUP BY 
        p.EP_ID
)
SELECT 
    ec.EP_ID,
    ec.GearCount
FROM 
    EpGearCount ec 
ORDER BY 
    ec.GearCount DESC
LIMIT 1;

-- question 3.9

WITH carbs AS(
SELECT DISTINCT e.Season,n.REC_ID, n.`Carbs per serving`
FROM nutrition_info n
JOIN plays p ON n.REC_ID = p.recipe
JOIN episodes e ON e.EP_ID =p.EP_ID
GROUP BY e.EP_ID, n.REC_ID
ORDER BY e.Season
)

SELECT DISTINCT n.Season,AVG(n.`Carbs per serving`)
FROM carbs n
GROUP BY n.Season;

-- question 3.10

WITH ParticipantCount AS (
    SELECT 
        p.Cuisine AS CU_ID,
        e.Season,
        COUNT(DISTINCT p.CH_ID) AS ParticipantCount
    FROM 
        plays p
    JOIN 
        episodes e ON p.EP_ID = e.EP_ID
    GROUP BY 
        p.Cuisine, e.Season
    HAVING 
        COUNT(DISTINCT p.CH_ID) >= 3
),
ConsecutiveSeasons AS (
    SELECT 
        p1.CU_ID,
        p1.Season AS S1,
        p2.Season AS S2,
        p1.ParticipantCount + p2.ParticipantCount AS TotalParticipants
    FROM 
        ParticipantCount p1
    JOIN 
        ParticipantCount p2 ON p1.CU_ID = p2.CU_ID AND p2.Season = p1.Season + 1
),
MatchingCuisines AS (
    SELECT 
        cs1.CU_ID AS CU_ID1,
        cs2.CU_ID AS CU_ID2,
        cs1.S1,
        cs1.S2,
        cs1.TotalParticipants
    FROM 
        ConsecutiveSeasons cs1
    JOIN 
        ConsecutiveSeasons cs2 ON cs1.TotalParticipants = cs2.TotalParticipants 
            AND cs1.CU_ID < cs2.CU_ID
            AND cs1.S1 = cs2.S1
            AND cs1.S2 = cs2.S2
)
SELECT 
    mc.CU_ID1,
    mc.CU_ID2,
    mc.S1,
    mc.S2,
    mc.TotalParticipants
FROM 
    MatchingCuisines mc
ORDER BY 
    mc.TotalParticipants DESC;

-- question3.11
WITH JudgeScores AS (
    SELECT 
        j.CH_ID AS Judge_ID,
        j.EP_ID,
        p.CH_ID AS Chef_ID,
        p.Score1 AS Score,
        1 AS count
    FROM 
        judges j
    JOIN 
        plays p ON j.EP_ID = p.EP_ID AND j.count = 1
    UNION ALL
    SELECT 
        j.CH_ID AS Judge_ID,
        j.EP_ID,
        p.CH_ID AS Chef_ID,
        p.Score2 AS Score,
        2 AS count
    FROM 
        judges j
    JOIN 
        plays p ON j.EP_ID = p.EP_ID AND j.count = 2
    UNION ALL
    SELECT 
        j.CH_ID AS Judge_ID,
        j.EP_ID,
        p.CH_ID AS Chef_ID,
        p.Score3 AS Score,
        3 AS count
    FROM 
        judges j
    JOIN 
        plays p ON j.EP_ID = p.EP_ID AND j.count = 3
)
SELECT 
    j.CH_ID AS Judge_ID, 
    c.CH_ID AS Chef_ID, 
    SUM(js.Score) AS TotalScore
FROM 
    JudgeScores js
JOIN 
    judges j ON js.Judge_ID = j.CH_ID
JOIN 
    chefs c ON js.Chef_ID = c.CH_ID
GROUP BY 
    j.CH_ID, c.CH_ID
ORDER BY 
    TotalScore DESC
LIMIT 5;



-- question 3.12

WITH ep_stats1 AS(
SELECT DISTINCT  e.Season, e.EP_Number, r.REC_ID, r.Difficulty
FROM episodes e 
JOIN plays p ON p.EP_ID=e.EP_ID
JOIN recipes r ON p.recipe=r.REC_ID
GROUP BY
p.EP_ID, r.REC_ID),

ep_stats2 AS(
SELECT DISTINCT e.Season, e.EP_Number, SUM(e.Difficulty) AS "Total Difficulty"
FROM ep_stats1 e
GROUP BY e.Season, e.EP_Number
HAVING SUM(e.Difficulty)= SUM(e.Difficulty)
ORDER BY e.Season, `Total Difficulty` DESC),

max_difficulty AS(
SELECT DISTINCT e.Season, MAX(e.`Total Difficulty`) AS "Highest Difficulty"
FROM ep_stats2 e
GROUP BY e.Season
)

SELECT m.Season, e.EP_Number, m.`Highest Difficulty`
FROM max_difficulty m JOIN ep_stats2 e ON e.Season=m.Season AND e.`Total Difficulty`= m.`Highest Difficulty`;

-- question 3.13
-- im doing max class count as 5 if the lowst and 1 the highest score
WITH PlayerClasses AS (
    SELECT
        e.EP_ID,
        SUM(c.Class) AS PlayerClassCount
    FROM
        episodes e
    LEFT JOIN
        plays p ON e.EP_ID = p.EP_ID
    LEFT JOIN
        chefs c ON p.CH_ID = c.CH_ID
    GROUP BY
        e.EP_ID
),
JudgeClasses AS (
    SELECT
        e.EP_ID,
        SUM(c.Class) AS JudgeClassCount
    FROM
        episodes e
    LEFT JOIN
        judges j ON e.EP_ID = j.EP_ID
    LEFT JOIN
        chefs c ON j.CH_ID = c.CH_ID
    GROUP BY
        e.EP_ID
),
TotalClasses AS (
    SELECT
        p.EP_ID,
        p.PlayerClassCount,
        j.JudgeClassCount,
        (p.PlayerClassCount + j.JudgeClassCount) AS TotalClassCount
    FROM
        PlayerClasses p
    JOIN
        JudgeClasses j ON p.EP_ID = j.EP_ID
)
SELECT
    t.EP_ID,
    t.TotalClassCount
FROM
    TotalClasses t
ORDER BY
    t.TotalClassCount DESC
LIMIT 1;
 
 -- question 3.14
 SELECT 
    r.THEME_ID,
    t.Name,
    COUNT(*) AS ParticipationCount
FROM 
    plays p
JOIN 
    recipes r ON p.recipe = r.REC_ID
JOIN 
    theme t ON r.THEME_ID = t.THEME_ID
GROUP BY 
    r.THEME_ID, t.Name
ORDER BY 
    COUNT(*) DESC
LIMIT 1;

-- question 3.15
WITH AllFoodGroups AS (
    SELECT FG_ID, Name
    FROM food_groups
),

ParticipatedFoodGroups AS (
    SELECT DISTINCT fg.FG_ID
    FROM recipes r
    JOIN ingredients i ON r.PRIM_ING_ID = i.ING_ID
    JOIN food_groups fg ON i.FG_ID = fg.FG_ID
    JOIN plays p ON r.REC_ID = p.recipe
)

SELECT afg.FG_ID, afg.Name
FROM AllFoodGroups afg
LEFT JOIN ParticipatedFoodGroups pfg ON afg.FG_ID = pfg.FG_ID
WHERE pfg.FG_ID IS NULL;


