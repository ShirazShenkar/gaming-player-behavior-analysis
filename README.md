# Gaming Player Behavior Analysis

**SQL Portfolio Project | MySQL | 40,034 Players**

## Executive Summary
Analyzed **40,034 player records** in MySQL to assess engagement, purchasing behavior, and player segments. Purchase rates remained near **20% across engagement levels**, indicating that activity alone does not meaningfully distinguish purchasers in this dataset. Identified two actionable, non-overlapping audiences: **3,607 USA-based medium-engagement non-buyers aged 21–40** for a controlled first-purchase experiment, and **8,202 high-engagement non-buyers** for research into purchase barriers.

## Objective
Analyze engagement and in-game purchasing behavior to identify actionable player segments and testable first-purchase conversion opportunities.

## Dataset & Method
- **Source:** Synthetic Kaggle gaming behavior dataset; one row per player (40,034 unique players).
- **Tools:** MySQL Workbench; CTEs, conditional aggregation, and window functions.
- **Purchases:** `InGamePurchases` is binary (ever purchased: yes/no), not revenue or transaction count.
- **Playtime:** `EstimatedWeeklyPlayTimeHours = SessionsPerWeek × AvgSessionDurationMinutes / 60`; an estimate, not observed hours.

## Analysis & Findings

### 01. Data Preparation
Validated unique player records and created estimated weekly playtime. Removed the original `PlayTimeHours` from the analytical table because it conflicted with session-based activity. Retained 1,967 players (4.91%) reporting zero weekly sessions but positive average session duration; measurement-period differences cannot be verified.

### 02. Data Exploration
The dataset covers four locations, five genres, and three difficulty levels. The largest age groups are **31–40 (11,611)** and **21–30 (11,438)**; **USA (16,000)** is the largest geographic segment. Population size provides context, not evidence of purchase propensity.

### 03. Player Overview
Player distributions across age, location, genre, and difficulty provide the baseline for segment sizing. Prioritization should consider purchase prevalence, not segment size alone.

### 04. Engagement Analysis
| Engagement | Players | Share | Avg. sessions/week | Est. hours/week |
|---|---:|---:|---:|---:|
| Low | 10,324 | 25.79% | 4.53 | 3.66 |
| Medium | 19,374 | 48.39% | 9.55 | 12.24 |
| High | 10,336 | 25.82% | 14.25 | 31.34 |

**Takeaway:** Medium engagement is the largest tier. Higher tiers have greater activity, but engagement labels may already incorporate activity metrics; this is not causal evidence.

### 05. Purchase Analysis
- **8,041 buyers (20.09%)** vs. **31,993 non-buyers (79.91%)**.
- Purchase rates by engagement: **Low 19.73%**, **Medium 19.98%**, **High 20.65%**.
- Purchase prevalence is broadly similar across the analyzed demographic and behavioral groups.

**Takeaway:** Engagement does not reliably distinguish buyers from non-buyers in this dataset.

### 06. Player Segmentation
| Segment | Players |
|---|---:|
| Medium-engagement non-buyers | **15,504** |
| High-engagement non-buyers | **8,202** |
| Low-engagement non-buyers | 8,287 |
| Medium-engagement buyers | 3,870 |
| High-engagement buyers | 2,134 |
| Low-engagement buyers | 2,037 |

Age, location, and genre breakdowns support practical audience definition; they do not explain why players have not purchased.

## Final Business Recommendations

**1. Test first-purchase conversion.**  
Run a randomized first-purchase offer test among **3,607 USA-based medium-engagement non-buyers aged 21–40**. Compare treatment and control groups on incremental first-purchase conversion; track offer exposure, transactions, and revenue to evaluate impact. This is a defined test audience, **not** a proven high-conversion segment.

**2. Investigate high-engagement non-buyers.**  
Study the **8,202 high-engagement non-buyers** through product-event analysis and player research. Identify purchase barriers before choosing an intervention; assess subsequent first-purchase conversion in a controlled test.

**Why these groups?** They are distinct by engagement level. The first supports a focused experiment; the second warrants investigation because of its high activity despite no recorded purchase.

## Limitations
- Synthetic, cross-sectional data; associations do not imply causation.
- No transaction amounts, frequency, dates, offer exposure, or historical progression.
- Purchase status means *ever purchased*, not purchase value or timing.
- Weekly hours are derived estimates, not direct observations.
- Engagement labels may overlap with the activity metrics used in analysis.
- Segment size does not predict conversion lift or revenue.

## SQL Project Structure
| File | Analysis |
|---|---|
| [`sql/01_data_preparation.sql`](sql/01_data_preparation.sql) | Data preparation |
| [`sql/02_data_exploration.sql`](sql/02_data_exploration.sql) | Data exploration |
| [`sql/03_player_overview.sql`](sql/03_player_overview.sql) | Player overview |
| [`sql/04_engagement_analysis.sql`](sql/04_engagement_analysis.sql) | Engagement |
| [`sql/05_purchase_analysis.sql`](sql/05_purchase_analysis.sql) | In-game purchases |
| [`sql/06_player_segmentation.sql`](sql/06_player_segmentation.sql) | Player segmentation |

## Reproduction
Import the source Kaggle CSV into MySQL as `basic_gaming_analytics.gaming_behavior`, then run scripts in order. The preparation script assumes the raw table exists and is intended to run once. The raw dataset is not redistributed; obtain it from Kaggle subject to its license.
