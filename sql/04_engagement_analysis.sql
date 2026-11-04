-- ============================================
-- 04. PLAYER ENGAGEMENT ANALYSIS
-- ============================================

USE basic_gaming_analytics;

-- ============================================
-- 1. ENGAGEMENT OVERVIEW
-- ============================================

SELECT
    EngagementLevel,
    COUNT(*) AS num_of_players,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM gaming_behavior),
        2
    ) AS pct_of_players,
    ROUND(SUM(EstimatedWeeklyPlayTimeHours), 2) AS estimated_total_weekly_hours,
    SUM(SessionsPerWeek) AS total_weekly_sessions

FROM gaming_behavior

GROUP BY EngagementLevel

ORDER BY
    CASE EngagementLevel
        WHEN 'Low' THEN 1
        WHEN 'Medium' THEN 2
        WHEN 'High' THEN 3
    END;


-- ============================================
-- 2. GAMING ACTIVITY BY ENGAGEMENT LEVEL
-- ============================================

SELECT
    EngagementLevel,
    COUNT(*) AS num_of_players,

    ROUND(AVG(SessionsPerWeek), 2) AS avg_sessions_per_week,
    ROUND(AVG(AvgSessionDurationMinutes), 2) AS avg_session_duration_minutes,
    ROUND(AVG(EstimatedWeeklyPlayTimeHours), 2) AS avg_estimated_weekly_hours

FROM gaming_behavior

GROUP BY EngagementLevel

ORDER BY
    CASE EngagementLevel
        WHEN 'Low' THEN 1
        WHEN 'Medium' THEN 2
        WHEN 'High' THEN 3
    END;


-- ============================================
-- 3. ACHIEVEMENTS DISTRIBUTION
-- How are players distributed across achievement groups?
-- ============================================

SELECT
    CASE
        WHEN AchievementsUnlocked <= 10 THEN '0-10'
        WHEN AchievementsUnlocked <= 20 THEN '11-20'
        WHEN AchievementsUnlocked <= 30 THEN '21-30'
        WHEN AchievementsUnlocked <= 40 THEN '31-40'
        WHEN AchievementsUnlocked <= 50 THEN '41-50'
        ELSE '51+'
    END AS achievement_group,

    COUNT(DISTINCT PlayerID) AS num_of_players

FROM gaming_behavior

GROUP BY achievement_group

ORDER BY
    CASE achievement_group
        WHEN '0-10' THEN 1
        WHEN '11-20' THEN 2
        WHEN '21-30' THEN 3
        WHEN '31-40' THEN 4
        WHEN '41-50' THEN 5
        WHEN '51+' THEN 6
        ELSE 7
    END;


-- ============================================
-- 4. PLAYER LEVEL & ENGAGEMENT DISTRIBUTION
-- How does engagement distribution vary across player levels?
-- ============================================

WITH player_engagement AS (
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
        END AS PlayerLevel_range,

        COUNT(*) AS num_of_players,
        EngagementLevel

    FROM gaming_behavior

    GROUP BY PlayerLevel_range, EngagementLevel
)

SELECT
    PlayerLevel_range,
    num_of_players,

    ROUND(
        num_of_players * 100.0 /
        SUM(num_of_players) OVER (PARTITION BY PlayerLevel_range),
        2
    ) AS pct_of_level_group,

    EngagementLevel

FROM player_engagement

ORDER BY
    CASE PlayerLevel_range
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

    CASE EngagementLevel
        WHEN 'Low' THEN 1
        WHEN 'Medium' THEN 2
        WHEN 'High' THEN 3
    END;


-- ============================================
-- 5. ACHIEVEMENTS & ENGAGEMENT DISTRIBUTION
-- How does engagement distribution vary across achievement groups?
-- ============================================

WITH achievements_engagement AS (
    SELECT
        CASE
            WHEN AchievementsUnlocked <= 10 THEN '0-10'
            WHEN AchievementsUnlocked <= 20 THEN '11-20'
            WHEN AchievementsUnlocked <= 30 THEN '21-30'
            WHEN AchievementsUnlocked <= 40 THEN '31-40'
            WHEN AchievementsUnlocked <= 50 THEN '41-50'
            ELSE '51+'
        END AS achievement_group,

        EngagementLevel,
        COUNT(DISTINCT PlayerID) AS num_of_players

    FROM gaming_behavior

    GROUP BY achievement_group, EngagementLevel
)

SELECT
    achievement_group,
    num_of_players,

    ROUND(
        num_of_players * 100.0 /
        SUM(num_of_players) OVER (PARTITION BY achievement_group),
        2
    ) AS pct_of_achievement_group,

    EngagementLevel

FROM achievements_engagement

ORDER BY
    CASE achievement_group
        WHEN '0-10' THEN 1
        WHEN '11-20' THEN 2
        WHEN '21-30' THEN 3
        WHEN '31-40' THEN 4
        WHEN '41-50' THEN 5
        WHEN '51+' THEN 6
        ELSE 7
    END,

    CASE EngagementLevel
        WHEN 'Low' THEN 1
        WHEN 'Medium' THEN 2
        WHEN 'High' THEN 3
    END;


-- ============================================
-- 6. PLAYER LEVEL & ACHIEVEMENTS
-- How does the average number of achievements vary by player level?
-- ============================================

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
    END AS PlayerLevel_range,

    COUNT(*) AS num_of_players,
    ROUND(AVG(AchievementsUnlocked), 2) AS avg_achievements_unlocked

FROM gaming_behavior

GROUP BY PlayerLevel_range

ORDER BY
    CASE PlayerLevel_range
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
    END;
