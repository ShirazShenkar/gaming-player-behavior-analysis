-- ============================================
-- 03. PLAYER OVERVIEW
-- ============================================

USE basic_gaming_analytics;

-- ============================================
-- 1. NUMBER OF PLAYERS BY AGE GROUP
-- ============================================

SELECT IF(GROUPING(age_group) = 1, 'Total', age_group) AS age_group,
       COUNT(DISTINCT PlayerID) AS num_of_players
FROM (
    SELECT
        PlayerID,
        CASE
            WHEN Age <= 20 THEN '0-20'
            WHEN Age <= 30 THEN '21-30'
            WHEN Age <= 40 THEN '31-40'
            WHEN Age <= 50 THEN '41-50'
            ELSE '51+'
        END AS age_group
    FROM gaming_behavior
) AS age_groups_table
GROUP BY age_group WITH ROLLUP
ORDER BY
    GROUPING(age_group),
    CASE
        WHEN age_group = '0-20' THEN 1
        WHEN age_group = '21-30' THEN 2
        WHEN age_group = '31-40' THEN 3
        WHEN age_group = '41-50' THEN 4
        WHEN age_group = '51+' THEN 5
        ELSE 6
    END;


-- ============================================
-- 2. NUMBER OF PLAYERS BY LOCATION
-- ============================================

SELECT
    IF(GROUPING(Location) = 1, 'Total', Location) AS Location,
    COUNT(DISTINCT PlayerID) AS num_of_players
FROM gaming_behavior
GROUP BY Location WITH ROLLUP
ORDER BY
    GROUPING(Location),
    COUNT(DISTINCT PlayerID) DESC;


-- ============================================
-- 3. NUMBER OF PLAYERS BY GAME GENRE
-- ============================================

SELECT
    IF(GROUPING(GameGenre) = 1, 'Total', GameGenre) AS GameGenre,
    FORMAT(COUNT(DISTINCT PlayerID), 0) AS num_of_players
FROM gaming_behavior
GROUP BY GameGenre WITH ROLLUP
ORDER BY
    GROUPING(GameGenre),
    COUNT(DISTINCT PlayerID) DESC;

-- ============================================
-- 4. NUMBER OF PLAYERS BY GAME DIFFICULTY
-- ============================================

SELECT
    IF(GROUPING(GameDifficulty) = 1, 'Total', GameDifficulty) AS GameDifficulty,
    COUNT(DISTINCT PlayerID) AS num_of_players
FROM gaming_behavior
GROUP BY GameDifficulty WITH ROLLUP
ORDER BY GROUPING(GameDifficulty),
    CASE
        WHEN GameDifficulty = 'Easy' THEN 1
        WHEN GameDifficulty = 'Medium' THEN 2
        WHEN GameDifficulty = 'Hard' THEN 3
        ELSE 4
    END;

-- ============================================
-- 5. NUMBER OF PLAYERS BY PLAYER LEVEL GROUP
-- ============================================

SELECT
    IF(
        GROUPING(PlayerLevel_group) = 1,
        'Total',
        PlayerLevel_group
    ) AS PlayerLevel_group,

    COUNT(DISTINCT PlayerID) AS num_of_players

FROM (
    SELECT
        PlayerID,
        CASE
            WHEN PlayerLevel <= 10 THEN '0-10'
            WHEN PlayerLevel <= 20 THEN '11-20'
            WHEN PlayerLevel <= 30 THEN '21-30'
            WHEN PlayerLevel <= 40 THEN '31-40'
            WHEN PlayerLevel <= 50 THEN '41-50'
            WHEN PlayerLevel <= 60 THEN '51-60'
            WHEN PlayerLevel <= 70 THEN '61-70'
            WHEN PlayerLevel <= 80 THEN '71-80'
            WHEN PlayerLevel <= 90 THEN '81-90'
            WHEN PlayerLevel <= 100 THEN '91-100'
            ELSE '100+'
        END AS PlayerLevel_group
    FROM gaming_behavior
) AS player_groups

GROUP BY PlayerLevel_group WITH ROLLUP

ORDER BY
    GROUPING(PlayerLevel_group),
    CASE
        WHEN PlayerLevel_group = '0-10' THEN 1
        WHEN PlayerLevel_group = '11-20' THEN 2
        WHEN PlayerLevel_group = '21-30' THEN 3
        WHEN PlayerLevel_group = '31-40' THEN 4
        WHEN PlayerLevel_group = '41-50' THEN 5
        WHEN PlayerLevel_group = '51-60' THEN 6
        WHEN PlayerLevel_group = '61-70' THEN 7
        WHEN PlayerLevel_group = '71-80' THEN 8
        WHEN PlayerLevel_group = '81-90' THEN 9
        WHEN PlayerLevel_group = '91-100' THEN 10
        ELSE 11
    END;
