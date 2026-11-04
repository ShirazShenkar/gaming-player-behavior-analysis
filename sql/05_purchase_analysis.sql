-- ============================================
-- 05. IN-GAME PURCHASE ANALYSIS
-- ============================================

USE basic_gaming_analytics;

-- 1.
-- InGamePurchases is a binary indicator (0 = no purchase, 1 = purchase).
-- This analysis measures purchaser prevalence, not transaction volume or revenue.

-- 2. 
-- Within-group percentages measure purchase prevalence in each segment.
-- Percentages of all purchasers/non-purchasers show how each segment
-- contributes to the respective population and are affected by segment size.


-- ============================================
-- 1. OVERALL PURCHASE DISTRIBUTION
-- What percentage of players have made an in-game purchase?
-- ============================================
WITH purchases_table AS (
    SELECT
        CASE
            WHEN InGamePurchases = 0 THEN 'no purchases'
            WHEN InGamePurchases = 1 THEN 'purchases'
        END AS purchases,
        COUNT(DISTINCT PlayerID) AS num_of_players
    FROM gaming_behavior
    GROUP BY purchases
)
SELECT
    purchases,
    num_of_players,
    ROUND(num_of_players * 100.0 / SUM(num_of_players) OVER (), 2) AS pct_of_total_players
FROM purchases_table
ORDER BY purchases;


-- ============================================
-- 2. PURCHASE DISTRIBUTION BY AGE GROUP
-- How do purchase rates and purchaser distributions vary across age groups?
-- ============================================
WITH age_purchases AS (
    SELECT
        CASE
            WHEN Age <= 20 THEN '0-20'
            WHEN Age <= 30 THEN '21-30'
            WHEN Age <= 40 THEN '31-40'
            WHEN Age <= 50 THEN '41-50'
            ELSE '51+'
        END AS age_group,
        CASE
            WHEN InGamePurchases = 0 THEN 'no purchases'
            WHEN InGamePurchases = 1 THEN 'purchases'
        END AS purchases,
        COUNT(DISTINCT PlayerID) AS num_of_players
    FROM gaming_behavior
    GROUP BY age_group, purchases
)
SELECT
    age_group,
    purchases,
    num_of_players,
    ROUND(num_of_players * 100.0 / SUM(num_of_players) OVER (PARTITION BY age_group), 2) AS pct_within_age_group,
    CASE
        WHEN purchases = 'purchases' THEN ROUND(num_of_players * 100.0 / SUM(CASE WHEN purchases = 'purchases' THEN num_of_players ELSE 0 END) OVER (), 2)
        ELSE NULL
    END AS pct_of_all_purchasers,
    CASE
        WHEN purchases = 'no purchases' THEN ROUND(num_of_players * 100.0 / SUM(CASE WHEN purchases = 'no purchases' THEN num_of_players ELSE 0 END) OVER (), 2)
        ELSE NULL
    END AS pct_of_all_non_purchasers
FROM age_purchases
ORDER BY
    CASE age_group
        WHEN '0-20' THEN 1
        WHEN '21-30' THEN 2
        WHEN '31-40' THEN 3
        WHEN '41-50' THEN 4
        ELSE 5
    END,
    CASE purchases
        WHEN 'no purchases' THEN 1
        WHEN 'purchases' THEN 2
    END;


-- ============================================
-- 3. PURCHASE DISTRIBUTION BY GENDER
-- How do purchase rates and purchaser distributions differ by gender?
-- ============================================
WITH gender_purchases AS (
    SELECT
        Gender,
        CASE
            WHEN InGamePurchases = 0 THEN 'no purchases'
            WHEN InGamePurchases = 1 THEN 'purchases'
        END AS purchases,
        COUNT(DISTINCT PlayerID) AS num_of_players
    FROM gaming_behavior
    GROUP BY Gender, purchases
)
SELECT
    Gender,
    purchases,
    num_of_players,
    ROUND(num_of_players * 100.0 / SUM(num_of_players) OVER (PARTITION BY Gender), 2) AS pct_within_gender,
    CASE
        WHEN purchases = 'purchases' THEN ROUND(num_of_players * 100.0 / SUM(CASE WHEN purchases = 'purchases' THEN num_of_players ELSE 0 END) OVER (), 2)
        ELSE NULL
    END AS pct_of_all_purchasers,
    CASE
        WHEN purchases = 'no purchases' THEN ROUND(num_of_players * 100.0 / SUM(CASE WHEN purchases = 'no purchases' THEN num_of_players ELSE 0 END) OVER (), 2)
        ELSE NULL
    END AS pct_of_all_non_purchasers
FROM gender_purchases
ORDER BY
    Gender,
    CASE purchases
        WHEN 'no purchases' THEN 1
        WHEN 'purchases' THEN 2
    END;


-- ============================================
-- 4. PURCHASE DISTRIBUTION BY LOCATION
-- How do purchase rates and purchaser distributions vary by location?
-- ============================================
WITH location_purchases AS (
    SELECT
        Location,
        CASE
            WHEN InGamePurchases = 0 THEN 'no purchases'
            WHEN InGamePurchases = 1 THEN 'purchases'
        END AS purchases,
        COUNT(DISTINCT PlayerID) AS num_of_players
    FROM gaming_behavior
    GROUP BY Location, purchases
)
SELECT
    Location,
    purchases,
    num_of_players,
    ROUND(num_of_players * 100.0 / SUM(num_of_players) OVER (PARTITION BY Location), 2) AS pct_within_location,
    CASE
        WHEN purchases = 'purchases' THEN ROUND(num_of_players * 100.0 / SUM(CASE WHEN purchases = 'purchases' THEN num_of_players ELSE 0 END) OVER (), 2)
        ELSE NULL
    END AS pct_of_all_purchasers,
    CASE
        WHEN purchases = 'no purchases' THEN ROUND(num_of_players * 100.0 / SUM(CASE WHEN purchases = 'no purchases' THEN num_of_players ELSE 0 END) OVER (), 2)
        ELSE NULL
    END AS pct_of_all_non_purchasers
FROM location_purchases
ORDER BY
    CASE Location
        WHEN 'Asia' THEN 1
        WHEN 'Europe' THEN 2
        WHEN 'USA' THEN 3
        WHEN 'Other' THEN 4
        ELSE 5
    END,
    purchases;


-- ============================================
-- 5. PURCHASE DISTRIBUTION BY GAME GENRE
-- How do purchase rates and purchaser distributions differ across game genres?
-- ============================================
WITH genre_purchases AS (
    SELECT
        GameGenre,
        CASE
            WHEN InGamePurchases = 0 THEN 'no purchases'
            WHEN InGamePurchases = 1 THEN 'purchases'
        END AS purchases,
        COUNT(DISTINCT PlayerID) AS num_of_players
    FROM gaming_behavior
    GROUP BY GameGenre, purchases
)
SELECT
    GameGenre,
    purchases,
    num_of_players,
    ROUND(num_of_players * 100.0 / SUM(num_of_players) OVER (PARTITION BY GameGenre), 2) AS pct_within_game_genre,
    CASE
        WHEN purchases = 'purchases' THEN ROUND(num_of_players * 100.0 / SUM(CASE WHEN purchases = 'purchases' THEN num_of_players ELSE 0 END) OVER (), 2)
        ELSE NULL
    END AS pct_of_all_purchasers,
    CASE
        WHEN purchases = 'no purchases' THEN ROUND(num_of_players * 100.0 / SUM(CASE WHEN purchases = 'no purchases' THEN num_of_players ELSE 0 END) OVER (), 2)
        ELSE NULL
    END AS pct_of_all_non_purchasers
FROM genre_purchases
ORDER BY
    CASE GameGenre
        WHEN 'Action' THEN 1
        WHEN 'Simulation' THEN 2
        WHEN 'Sports' THEN 3
        WHEN 'Strategy' THEN 4
        WHEN 'RPG' THEN 5
        ELSE 6
    END,
    purchases;


-- ============================================
-- 6. PURCHASE DISTRIBUTION BY GAME DIFFICULTY
-- How do purchase rates and purchaser distributions vary by game difficulty?
-- ============================================
WITH difficulty_purchases AS (
    SELECT
        GameDifficulty,
        CASE
            WHEN InGamePurchases = 0 THEN 'no purchases'
            WHEN InGamePurchases = 1 THEN 'purchases'
        END AS purchases,
        COUNT(DISTINCT PlayerID) AS num_of_players
    FROM gaming_behavior
    GROUP BY GameDifficulty, purchases
)
SELECT
    GameDifficulty,
    purchases,
    num_of_players,
    ROUND(num_of_players * 100.0 / SUM(num_of_players) OVER (PARTITION BY GameDifficulty), 2) AS pct_within_game_difficulty,
    CASE
        WHEN purchases = 'purchases' THEN ROUND(num_of_players * 100.0 / SUM(CASE WHEN purchases = 'purchases' THEN num_of_players ELSE 0 END) OVER (), 2)
        ELSE NULL
    END AS pct_of_all_purchasers,
    CASE
        WHEN purchases = 'no purchases' THEN ROUND(num_of_players * 100.0 / SUM(CASE WHEN purchases = 'no purchases' THEN num_of_players ELSE 0 END) OVER (), 2)
        ELSE NULL
    END AS pct_of_all_non_purchasers
FROM difficulty_purchases
ORDER BY
    CASE GameDifficulty
        WHEN 'Easy' THEN 1
        WHEN 'Medium' THEN 2
        WHEN 'Hard' THEN 3
        ELSE 4
    END,
    purchases;


-- ============================================
-- 7. PURCHASE DISTRIBUTION BY PLAYER LEVEL
-- How do purchase rates and purchaser distributions vary by player level?
-- ============================================
WITH level_purchases AS (
    SELECT
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
        END AS player_level_group,
        CASE
            WHEN InGamePurchases = 0 THEN 'no purchases'
            WHEN InGamePurchases = 1 THEN 'purchases'
        END AS purchases,
        COUNT(DISTINCT PlayerID) AS num_of_players
    FROM gaming_behavior
    GROUP BY player_level_group, purchases
)
SELECT
    player_level_group,
    purchases,
    num_of_players,
    ROUND(num_of_players * 100.0 / SUM(num_of_players) OVER (PARTITION BY player_level_group), 2) AS pct_within_player_level_group,
    CASE
        WHEN purchases = 'purchases' THEN ROUND(num_of_players * 100.0 / SUM(CASE WHEN purchases = 'purchases' THEN num_of_players ELSE 0 END) OVER (), 2)
        ELSE NULL
    END AS pct_of_all_purchasers,
    CASE
        WHEN purchases = 'no purchases' THEN ROUND(num_of_players * 100.0 / SUM(CASE WHEN purchases = 'no purchases' THEN num_of_players ELSE 0 END) OVER (), 2)
        ELSE NULL
    END AS pct_of_all_non_purchasers
FROM level_purchases
ORDER BY
    CASE player_level_group
        WHEN '0-10' THEN 1
        WHEN '11-20' THEN 2
        WHEN '21-30' THEN 3
        WHEN '31-40' THEN 4
        WHEN '41-50' THEN 5
        WHEN '51-60' THEN 6
        WHEN '61-70' THEN 7
        WHEN '71-80' THEN 8
        WHEN '81-90' THEN 9
        WHEN '91-100' THEN 10
        ELSE 11
    END,
    purchases;


-- ============================================
-- 8. PURCHASE DISTRIBUTION BY ACHIEVEMENTS UNLOCKED
-- How do purchase rates and purchaser distributions vary by achievements unlocked?
-- ============================================
WITH achievement_purchases AS (
    SELECT
        CASE
            WHEN AchievementsUnlocked <= 10 THEN '0-10'
            WHEN AchievementsUnlocked <= 20 THEN '11-20'
            WHEN AchievementsUnlocked <= 30 THEN '21-30'
            WHEN AchievementsUnlocked <= 40 THEN '31-40'
            WHEN AchievementsUnlocked <= 50 THEN '41-50'
            ELSE '51+'
        END AS achievement_group,
        CASE
            WHEN InGamePurchases = 0 THEN 'no purchases'
            WHEN InGamePurchases = 1 THEN 'purchases'
        END AS purchases,
        COUNT(DISTINCT PlayerID) AS num_of_players
    FROM gaming_behavior
    GROUP BY achievement_group, purchases
)
SELECT
    achievement_group,
    purchases,
    num_of_players,
    ROUND(num_of_players * 100.0 / SUM(num_of_players) OVER (PARTITION BY achievement_group), 2) AS pct_within_achievement_group,
    CASE
        WHEN purchases = 'purchases' THEN ROUND(num_of_players * 100.0 / SUM(CASE WHEN purchases = 'purchases' THEN num_of_players ELSE 0 END) OVER (), 2)
        ELSE NULL
    END AS pct_of_all_purchasers,
    CASE
        WHEN purchases = 'no purchases' THEN ROUND(num_of_players * 100.0 / SUM(CASE WHEN purchases = 'no purchases' THEN num_of_players ELSE 0 END) OVER (), 2)
        ELSE NULL
    END AS pct_of_all_non_purchasers
FROM achievement_purchases
ORDER BY
    CASE achievement_group
        WHEN '0-10' THEN 1
        WHEN '11-20' THEN 2
        WHEN '21-30' THEN 3
        WHEN '31-40' THEN 4
        WHEN '41-50' THEN 5
        ELSE 6
    END,
    purchases;


-- ============================================
-- 9. PURCHASE DISTRIBUTION BY ENGAGEMENT LEVEL
-- How do purchase rates and purchaser distributions differ by engagement level?
-- ============================================
WITH engagement_purchases AS (
    SELECT
        EngagementLevel,
        CASE
            WHEN InGamePurchases = 0 THEN 'no purchases'
            WHEN InGamePurchases = 1 THEN 'purchases'
        END AS purchases,
        COUNT(DISTINCT PlayerID) AS num_of_players
    FROM gaming_behavior
    GROUP BY EngagementLevel, purchases
)
SELECT
    EngagementLevel,
    purchases,
    num_of_players,
    ROUND(num_of_players * 100.0 / SUM(num_of_players) OVER (PARTITION BY EngagementLevel), 2) AS pct_within_engagement_level,
    CASE
        WHEN purchases = 'purchases' THEN ROUND(num_of_players * 100.0 / SUM(CASE WHEN purchases = 'purchases' THEN num_of_players ELSE 0 END) OVER (), 2)
        ELSE NULL
    END AS pct_of_all_purchasers,
    CASE
        WHEN purchases = 'no purchases' THEN ROUND(num_of_players * 100.0 / SUM(CASE WHEN purchases = 'no purchases' THEN num_of_players ELSE 0 END) OVER (), 2)
        ELSE NULL
    END AS pct_of_all_non_purchasers
FROM engagement_purchases
ORDER BY
    CASE EngagementLevel
        WHEN 'Low' THEN 1
        WHEN 'Medium' THEN 2
        WHEN 'High' THEN 3
        ELSE 4
    END,
    purchases;


-- ============================================
-- 10. PURCHASE DISTRIBUTION BY SESSIONS PER WEEK
-- How do purchase rates and purchaser distributions vary by weekly session frequency?
-- ============================================
WITH sessions_purchases AS (
    SELECT
        CASE
            WHEN SessionsPerWeek <= 5 THEN '0-5'
            WHEN SessionsPerWeek <= 10 THEN '6-10'
            WHEN SessionsPerWeek <= 15 THEN '11-15'
            WHEN SessionsPerWeek <= 20 THEN '16-20'
            ELSE '21+'
        END AS sessions_group,
        CASE
            WHEN InGamePurchases = 0 THEN 'no purchases'
            WHEN InGamePurchases = 1 THEN 'purchases'
        END AS purchases,
        COUNT(DISTINCT PlayerID) AS num_of_players
    FROM gaming_behavior
    GROUP BY sessions_group, purchases
)
SELECT
    sessions_group,
    purchases,
    num_of_players,
    ROUND(num_of_players * 100.0 / SUM(num_of_players) OVER (PARTITION BY sessions_group), 2) AS pct_within_sessions_group,
    CASE
        WHEN purchases = 'purchases' THEN ROUND(num_of_players * 100.0 / SUM(CASE WHEN purchases = 'purchases' THEN num_of_players ELSE 0 END) OVER (), 2)
        ELSE NULL
    END AS pct_of_all_purchasers,
    CASE
        WHEN purchases = 'no purchases' THEN ROUND(num_of_players * 100.0 / SUM(CASE WHEN purchases = 'no purchases' THEN num_of_players ELSE 0 END) OVER (), 2)
        ELSE NULL
    END AS pct_of_all_non_purchasers
FROM sessions_purchases
ORDER BY
    CASE sessions_group
        WHEN '0-5' THEN 1
        WHEN '6-10' THEN 2
        WHEN '11-15' THEN 3
        WHEN '16-20' THEN 4
        ELSE 5
    END,
    purchases;


-- ============================================
-- 11. PURCHASE DISTRIBUTION BY ESTIMATED WEEKLY PLAYTIME (HOURS)
-- How do purchase rates and purchaser distributions vary by estimated weekly playtime?
-- ============================================
WITH playtime_purchases AS (
    SELECT
        CASE
            WHEN EstimatedWeeklyPlayTimeHours <= 5 THEN '0-5'
            WHEN EstimatedWeeklyPlayTimeHours <= 10 THEN '>5-10'
            WHEN EstimatedWeeklyPlayTimeHours <= 20 THEN '>10-20'
            WHEN EstimatedWeeklyPlayTimeHours <= 30 THEN '>20-30'
            WHEN EstimatedWeeklyPlayTimeHours <= 40 THEN '>30-40'
            ELSE '>40'
        END AS playtime_group,
        CASE
            WHEN InGamePurchases = 0 THEN 'no purchases'
            WHEN InGamePurchases = 1 THEN 'purchases'
        END AS purchases,
        COUNT(DISTINCT PlayerID) AS num_of_players
    FROM gaming_behavior
    GROUP BY playtime_group, purchases
)
SELECT
    playtime_group,
    purchases,
    num_of_players,
    ROUND(num_of_players * 100.0 / SUM(num_of_players) OVER (PARTITION BY playtime_group), 2) AS pct_within_playtime_group,
    CASE
        WHEN purchases = 'purchases' THEN ROUND(num_of_players * 100.0 / SUM(CASE WHEN purchases = 'purchases' THEN num_of_players ELSE 0 END) OVER (), 2)
        ELSE NULL
    END AS pct_of_all_purchasers,
    CASE
        WHEN purchases = 'no purchases' THEN ROUND(num_of_players * 100.0 / SUM(CASE WHEN purchases = 'no purchases' THEN num_of_players ELSE 0 END) OVER (), 2)
        ELSE NULL
    END AS pct_of_all_non_purchasers
FROM playtime_purchases
ORDER BY
    CASE playtime_group
        WHEN '0-5' THEN 1
        WHEN '>5-10' THEN 2
        WHEN '>10-20' THEN 3
        WHEN '>20-30' THEN 4
        WHEN '>30-40' THEN 5
        ELSE 6
    END,
    purchases;

