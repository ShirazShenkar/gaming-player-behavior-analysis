-- ============================================
-- 06. PLAYER SEGMENTATION ANALYSIS
-- ============================================

USE basic_gaming_analytics;

-- ============================================
-- 1. PLAYER SEGMENTS BY ENGAGEMENT AND PURCHASE STATUS
-- How are players distributed across engagement levels and purchase status?
-- ============================================
WITH player_segments AS (
    SELECT
        EngagementLevel,
        InGamePurchases,
        COUNT(DISTINCT PlayerID) AS num_of_players,
        CASE
            WHEN EngagementLevel = 'Low' AND InGamePurchases = 1 THEN 'Low Engagement Buyers'
            WHEN EngagementLevel = 'Medium' AND InGamePurchases = 1 THEN 'Moderately Engaged Buyers'
            WHEN EngagementLevel = 'High' AND InGamePurchases = 1 THEN 'Highly Engaged Buyers'
            WHEN EngagementLevel = 'Low' AND InGamePurchases = 0 THEN 'Low Engagement Non-Buyers'
            WHEN EngagementLevel = 'Medium' AND InGamePurchases = 0 THEN 'Moderately Engaged Non-Buyers'
            WHEN EngagementLevel = 'High' AND InGamePurchases = 0 THEN 'Highly Engaged Non-Buyers'
        END AS player_segment
    FROM gaming_behavior
    GROUP BY EngagementLevel, InGamePurchases
)
SELECT
    EngagementLevel,
    InGamePurchases,
    player_segment,
    num_of_players,
    ROUND(num_of_players * 100.0 / SUM(num_of_players) OVER (), 2) AS pct_of_total_players
FROM player_segments
ORDER BY FIELD(EngagementLevel, 'High', 'Medium', 'Low'), InGamePurchases;


-- ============================================
-- 2. BEHAVIORAL PROFILE BY PLAYER SEGMENT
-- How does player behavior differ across engagement and purchase segments?
-- ============================================
SELECT
    EngagementLevel,
    InGamePurchases,
    COUNT(DISTINCT PlayerID) AS num_of_players,
    ROUND(AVG(SessionsPerWeek), 2) AS avg_sessions_per_week,
    ROUND(AVG(AvgSessionDurationMinutes), 2) AS avg_session_duration,
    ROUND(AVG(EstimatedWeeklyPlayTimeHours), 2) AS avg_weekly_playtime,
    ROUND(AVG(PlayerLevel), 2) AS avg_player_level,
    ROUND(AVG(AchievementsUnlocked), 2) AS avg_achievements_unlocked
FROM gaming_behavior
GROUP BY EngagementLevel, InGamePurchases
ORDER BY FIELD(EngagementLevel, 'High', 'Medium', 'Low'), InGamePurchases;


-- ============================================
-- 3. PURCHASE AND NON-PURCHASE RATES BY ENGAGEMENT LEVEL AND GAME GENRE
-- How do purchase and non-purchase rates vary by game genre and engagement level?
-- ============================================
WITH genre_engagement AS (
    SELECT
        GameGenre,
        EngagementLevel,
        COUNT(DISTINCT PlayerID) AS num_of_players,
        SUM(CASE WHEN InGamePurchases = 1 THEN 1 ELSE 0 END) AS purchasing_players,
        SUM(CASE WHEN InGamePurchases = 0 THEN 1 ELSE 0 END) AS non_buying_players
    FROM gaming_behavior
    GROUP BY GameGenre, EngagementLevel
)
SELECT
    GameGenre,
    EngagementLevel,
    num_of_players,
    purchasing_players,
    non_buying_players,
    ROUND(purchasing_players * 100.0 / NULLIF(num_of_players, 0), 2) AS purchase_rate_pct,
    ROUND(non_buying_players * 100.0 / NULLIF(num_of_players, 0), 2) AS non_buyer_rate_pct
FROM genre_engagement
ORDER BY GameGenre, FIELD(EngagementLevel, 'High', 'Medium', 'Low');


-- ============================================
-- 4. PURCHASE AND NON-PURCHASE RATES BY AGE GROUP AND LOCATION
-- Which age groups and locations have the highest purchase and non-purchase rates?
-- ============================================
WITH age_location AS (
    SELECT
        Location,
        CASE
            WHEN Age <= 20 THEN '0-20'
            WHEN Age <= 30 THEN '21-30'
            WHEN Age <= 40 THEN '31-40'
            WHEN Age <= 50 THEN '41-50'
            ELSE '51+'
        END AS age_group,
        COUNT(DISTINCT PlayerID) AS num_of_players,
        SUM(CASE WHEN InGamePurchases = 1 THEN 1 ELSE 0 END) AS purchasing_players,
        SUM(CASE WHEN InGamePurchases = 0 THEN 1 ELSE 0 END) AS non_buying_players
    FROM gaming_behavior
    GROUP BY Location, age_group
)
SELECT
    Location,
    age_group,
    num_of_players,
    purchasing_players,
    non_buying_players,
    ROUND(purchasing_players * 100.0 / NULLIF(num_of_players, 0), 2) AS purchase_rate_pct,
    ROUND(non_buying_players * 100.0 / NULLIF(num_of_players, 0), 2) AS non_buyer_rate_pct
FROM age_location
ORDER BY purchase_rate_pct DESC, num_of_players DESC;


-- ============================================
-- 5. PURCHASE AND NON-PURCHASE RATES BY PLAYER LEVEL AND ENGAGEMENT LEVEL
-- How do purchase and non-purchase rates vary by player level and engagement?
-- ============================================
WITH level_engagement AS (
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
        EngagementLevel,
        COUNT(DISTINCT PlayerID) AS num_of_players,
        SUM(CASE WHEN InGamePurchases = 1 THEN 1 ELSE 0 END) AS purchasing_players,
        SUM(CASE WHEN InGamePurchases = 0 THEN 1 ELSE 0 END) AS non_buying_players
    FROM gaming_behavior
    GROUP BY player_level_group, EngagementLevel
)
SELECT
    player_level_group,
    EngagementLevel,
    num_of_players,
    purchasing_players,
    non_buying_players,
    ROUND(purchasing_players * 100.0 / NULLIF(num_of_players, 0), 2) AS purchase_rate_pct,
    ROUND(non_buying_players * 100.0 / NULLIF(num_of_players, 0), 2) AS non_buyer_rate_pct
FROM level_engagement
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
    FIELD(EngagementLevel, 'High', 'Medium', 'Low');


-- ============================================
-- 6. MEDIUM-ENGAGEMENT NON-BUYERS BY LOCATION AND AGE GROUP
-- Which locations and age groups contain the most medium-engagement non-buyers?
-- ============================================
WITH medium_non_buyers_by_location_age  AS (
    SELECT
        Location,
        CASE
            WHEN Age <= 20 THEN '0-20'
            WHEN Age <= 30 THEN '21-30'
            WHEN Age <= 40 THEN '31-40'
            WHEN Age <= 50 THEN '41-50'
            ELSE '51+'
        END AS age_group,
        COUNT(DISTINCT PlayerID) AS num_of_non_buyers
    FROM gaming_behavior
    WHERE InGamePurchases = 0 AND EngagementLevel = 'Medium'
    GROUP BY Location, age_group
)
SELECT
    Location,
    age_group,
    num_of_non_buyers,
    ROUND(num_of_non_buyers * 100.0 / SUM(num_of_non_buyers) OVER (), 2) AS pct_of_medium_non_buyers
FROM medium_non_buyers_by_location_age 
ORDER BY num_of_non_buyers DESC;


-- ============================================
-- 7. MEDIUM-ENGAGEMENT NON-BUYERS BY GAME GENRE AND AGE GROUP (USA)
-- Which game genres are most common among medium-engagement non-buyers in the USA, within each age group?
-- ============================================
WITH usa_medium_non_buyers_by_genre_age  AS (
    SELECT
        Location,
        GameGenre,
        CASE
            WHEN Age <= 20 THEN '0-20'
            WHEN Age <= 30 THEN '21-30'
            WHEN Age <= 40 THEN '31-40'
            WHEN Age <= 50 THEN '41-50'
            ELSE '51+'
        END AS age_group,
        COUNT(DISTINCT PlayerID) AS num_medium_engagement_non_buyers
    FROM gaming_behavior
    WHERE Location = 'USA' AND EngagementLevel = 'Medium' AND InGamePurchases = 0
    GROUP BY Location, GameGenre, age_group
)
SELECT
    Location,
    GameGenre,
    age_group,
    num_medium_engagement_non_buyers,
    ROUND(num_medium_engagement_non_buyers * 100.0 / SUM(num_medium_engagement_non_buyers) OVER (PARTITION BY age_group), 2) AS pct_within_age_group
FROM usa_medium_non_buyers_by_genre_age 
ORDER BY num_medium_engagement_non_buyers DESC;


