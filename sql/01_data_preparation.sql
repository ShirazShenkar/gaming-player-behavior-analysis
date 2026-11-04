-- ============================================
-- 01. DATA PREPARATION
-- ============================================

USE basic_gaming_analytics;

-- Purpose:
-- Prepare the imported gaming dataset for analysis
-- while preserving the original source file.
--
-- The original PlayTimeHours field was inconsistent
-- with the available session frequency and duration
-- measures, so it was excluded from the analysis.
--
-- A new estimated weekly playtime metric was created
-- using the available session behavior data.

-- ============================================
-- 1. REMOVE ORIGINAL PLAYTIME FIELD
-- ============================================

ALTER TABLE gaming_behavior
DROP COLUMN PlayTimeHours;

-- ============================================
-- 2. CREATE ESTIMATED WEEKLY PLAYTIME
-- ============================================

ALTER TABLE gaming_behavior
ADD COLUMN EstimatedWeeklyPlayTimeHours
DECIMAL(10,2)
GENERATED ALWAYS AS (
    ROUND(
        SessionsPerWeek * AvgSessionDurationMinutes / 60.0,
        2
    )
) STORED;

-- ============================================
-- 3. VERIFY THE TRANSFORMATION
-- ============================================

SELECT
    PlayerID,
    SessionsPerWeek,
    AvgSessionDurationMinutes,
    EstimatedWeeklyPlayTimeHours
FROM gaming_behavior
LIMIT 20;
