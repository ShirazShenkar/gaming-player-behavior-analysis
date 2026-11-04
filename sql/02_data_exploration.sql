-- ============================================
-- 02. DATA EXPLORATION & QUALITY CHECKS
-- ============================================

USE basic_gaming_analytics;

-- ============================================
-- 1. PREVIEW THE DATA
-- ============================================

SELECT *
FROM gaming_behavior
LIMIT 100;


-- ============================================
-- 2. RECORD COUNT & PLAYER ID VALIDATION
-- ============================================

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT PlayerID) AS unique_players,
    COUNT(*) - COUNT(PlayerID) AS null_player_ids,
    COUNT(PlayerID) - COUNT(DISTINCT PlayerID) AS duplicate_player_ids
FROM gaming_behavior;


-- ============================================
-- 3. AGE
-- ============================================

SELECT
    MIN(Age) AS min_age,
    MAX(Age) AS max_age
FROM gaming_behavior;

SELECT COUNT(*) AS count_age_null
FROM gaming_behavior
WHERE Age IS NULL;


-- ============================================
-- 4. GENDER
-- ============================================

SELECT DISTINCT Gender
FROM gaming_behavior;

SELECT COUNT(*) AS count_gender_null
FROM gaming_behavior
WHERE Gender IS NULL;


-- ============================================
-- 5. LOCATION
-- ============================================

SELECT DISTINCT Location
FROM gaming_behavior;

SELECT COUNT(*) AS count_location_null
FROM gaming_behavior
WHERE Location IS NULL;


-- ============================================
-- 6. GAME GENRE
-- ============================================

SELECT DISTINCT GameGenre
FROM gaming_behavior;

SELECT COUNT(*) AS count_GameGenre_null
FROM gaming_behavior
WHERE GameGenre IS NULL;


-- ============================================
-- 7. IN-GAME PURCHASES
-- ============================================

SELECT DISTINCT InGamePurchases
FROM gaming_behavior;

SELECT COUNT(*) AS count_InGamePurchases_null
FROM gaming_behavior
WHERE InGamePurchases IS NULL;


-- ============================================
-- 8. GAME DIFFICULTY
-- ============================================

SELECT DISTINCT GameDifficulty
FROM gaming_behavior;

SELECT COUNT(*) AS count_GameDifficulty_null
FROM gaming_behavior
WHERE GameDifficulty IS NULL;


-- ============================================
-- 9. PLAYER LEVEL
-- ============================================

SELECT
    MIN(PlayerLevel) AS min_PlayerLevel,
    MAX(PlayerLevel) AS max_PlayerLevel
FROM gaming_behavior;

SELECT COUNT(*) AS count_PlayerLevel_null
FROM gaming_behavior
WHERE PlayerLevel IS NULL;


-- ============================================
-- 10. ACHIEVEMENTS UNLOCKED
-- ============================================

SELECT
    MIN(AchievementsUnlocked) AS min_AchievementsUnlocked,
    MAX(AchievementsUnlocked) AS max_AchievementsUnlocked
FROM gaming_behavior;

SELECT COUNT(*) AS count_AchievementsUnlocked_null
FROM gaming_behavior
WHERE AchievementsUnlocked IS NULL;


-- ============================================
-- 11. ENGAGEMENT LEVEL
-- ============================================

SELECT DISTINCT EngagementLevel
FROM gaming_behavior;

SELECT COUNT(*) AS count_EngagementLevel_null
FROM gaming_behavior
WHERE EngagementLevel IS NULL;


-- ============================================
-- 12. SESSIONS PER WEEK
-- ============================================

SELECT
    MIN(SessionsPerWeek) AS min_SessionsPerWeek,
    MAX(SessionsPerWeek) AS max_SessionsPerWeek
FROM gaming_behavior;

SELECT COUNT(*) AS count_SessionsPerWeek_null
FROM gaming_behavior
WHERE SessionsPerWeek IS NULL;


-- ============================================
-- 13. AVERAGE SESSION DURATION (MINUTES)
-- ============================================

SELECT
    MIN(AvgSessionDurationMinutes) AS min_AvgSessionDurationMinutes,
    MAX(AvgSessionDurationMinutes) AS max_AvgSessionDurationMinutes
FROM gaming_behavior;

SELECT COUNT(*) AS count_AvgSessionDurationMinutes_null
FROM gaming_behavior
WHERE AvgSessionDurationMinutes IS NULL;


-- ============================================
-- 14. ESTIMATED WEEKLY PLAY TIME (HOURS)
-- ============================================

SELECT
    MIN(EstimatedWeeklyPlayTimeHours) AS min_WeeklyPlayTime,
    MAX(EstimatedWeeklyPlayTimeHours) AS max_WeeklyPlayTime,
    ROUND(AVG(EstimatedWeeklyPlayTimeHours), 2) AS avg_WeeklyPlayTime
FROM gaming_behavior;

SELECT COUNT(*) AS count_WeeklyPlayTime_null
FROM gaming_behavior
WHERE EstimatedWeeklyPlayTimeHours IS NULL;

-- Check for players with zero weekly sessions
-- but a positive average session duration.
SELECT
    COUNT(*) AS zero_sessions_with_duration
FROM gaming_behavior
WHERE SessionsPerWeek = 0 AND AvgSessionDurationMinutes > 0;

-- Finding: 1,967 players (4.91%) meet this condition.
-- Hypothesis: Average session duration may reflect historical activity,
-- while weekly sessions may reflect a different observation period.
-- These records were retained, as the measurement periods are unverified.

-- ============================================
-- 15. VERIFY CALCULATED WEEKLY PLAY TIME
-- ============================================

-- Preview the calculation for 20 players
SELECT
    PlayerID,
    SessionsPerWeek,
    AvgSessionDurationMinutes,
    EstimatedWeeklyPlayTimeHours,
    ROUND(
        SessionsPerWeek * AvgSessionDurationMinutes / 60.0,
        2
    ) AS recalculated_WeeklyPlayTime
FROM gaming_behavior
LIMIT 20;

-- Check for calculation mismatches across all records
SELECT
    COUNT(*) AS mismatched_records
FROM gaming_behavior
WHERE NOT (
    EstimatedWeeklyPlayTimeHours <=>
    ROUND(
        SessionsPerWeek * AvgSessionDurationMinutes / 60.0,
        2
    )
);



