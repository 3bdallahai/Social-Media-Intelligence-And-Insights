/* ============================================================
   SOCIAL MEDIA INTELLIGENCE PROJECT
   DATA QUALITY VALIDATION QUERIES
   ============================================================

   Purpose:
   This file contains SQL validation queries used to verify
   the quality, consistency, and correctness of the data
   loaded into the final analytical table:

       social_media_posts

   These checks help ensure:
   - Successful ETL execution
   - Correct transformations
   - Reliable dashboard metrics
   - Detection of invalid or inconsistent data

   ============================================================ */


/* ============================================================
   1. TOTAL ROW COUNT VALIDATION
   ============================================================

   Purpose:
   Verify that all rows from the ETL pipeline
   were inserted into the table successfully.

   Compare this result with:
   len(final_df) in Python
*/

SELECT COUNT(*) AS total_rows
FROM social_media_posts;



/* ============================================================
   2. NULL CHECK FOR CRITICAL COLUMNS
   ============================================================

   Purpose:
   Detect missing values in important business columns.

   Expected:
   Critical fields should contain very few or no NULL values.
*/

SELECT
    SUM(CASE WHEN post_id IS NULL THEN 1 ELSE 0 END) AS null_post_id,
    SUM(CASE WHEN platform IS NULL THEN 1 ELSE 0 END) AS null_platform,
    SUM(CASE WHEN post_datetime IS NULL THEN 1 ELSE 0 END) AS null_post_datetime,
    SUM(CASE WHEN engagement_rate IS NULL THEN 1 ELSE 0 END) AS null_engagement_rate
FROM social_media_posts;



/* ============================================================
   3. DUPLICATE POST DETECTION
   ============================================================

   Purpose:
   Identify duplicated post_ids that may indicate:
   - ETL duplication
   - Multiple inserts
   - Source data duplication
*/

SELECT
    post_id,
    COUNT(*) AS duplicate_count
FROM social_media_posts
GROUP BY post_id
HAVING COUNT(*) > 1;



/* ============================================================
   4. ENGAGEMENT RATE RANGE VALIDATION
   ============================================================

   Purpose:
   Ensure engagement_rate values are normalized correctly.

   Business Rule:
   engagement_rate must be between 0 and 1.
*/

SELECT *
FROM social_media_posts
WHERE engagement_rate < 0
   OR engagement_rate > 1;



/* ============================================================
   5. IMPRESSION VALIDATION
   ============================================================

   Purpose:
   Detect unrealistic impression values.

   Business Rule:
   impressions should generally be greater than or equal to:
       likes + comments + shares
*/

SELECT TOP 20
    post_id,
    likes,
    comments,
    shares,
    impressions,
    engagement_rate
FROM social_media_posts
WHERE impressions IS NOT NULL
  AND impressions < (likes + comments + shares);



/* ============================================================
   6. DATE RANGE VALIDATION
   ============================================================

   Purpose:
   Verify that post dates are within expected ranges.
*/

SELECT
    MIN(post_datetime) AS earliest_post,
    MAX(post_datetime) AS latest_post
FROM social_media_posts;



/* ============================================================
   7. COUNTRY DISTRIBUTION CHECK
   ============================================================

   Purpose:
   Validate country extraction from location fields.

   This query helps identify:
   - Parsing problems
   - Unexpected country values
   - Empty locations
*/

SELECT
    country,
    COUNT(*) AS total_posts
FROM social_media_posts
GROUP BY country
ORDER BY total_posts DESC;



/* ============================================================
   8. SOURCE COLUMN VALIDATION
   ============================================================

   Purpose:
   Ensure that source values are loaded correctly.

   Expected Values:
   - marketing
   - general
*/

SELECT
    source,
    COUNT(*) AS total_posts
FROM social_media_posts
GROUP BY source;



/* ============================================================
   9. PLATFORM STANDARDIZATION CHECK
   ============================================================

   Purpose:
   Detect inconsistent platform naming.

   Example Problems:
   - Instagram
   - instagram
   - INSTAGRAM
*/

SELECT DISTINCT platform
FROM social_media_posts
ORDER BY platform;



/* ============================================================
   10. SENTIMENT SCORE VALIDATION
   ============================================================

   Purpose:
   Ensure sentiment_score values are within valid bounds.

   Expected Range:
   -1 to 1
*/

SELECT *
FROM social_media_posts
WHERE sentiment_score < -1
   OR sentiment_score > 1;



/* ============================================================
   11. ENGAGEMENT OUTLIER DETECTION
   ============================================================

   Purpose:
   Identify unusually high engagement rates
   that may indicate:
   - Incorrect normalization
   - Data quality issues
*/

SELECT TOP 20
    post_id,
    platform,
    engagement_rate,
    likes,
    comments,
    shares
FROM social_media_posts
ORDER BY engagement_rate DESC;



/* ============================================================
   12. MARKETING VS GENERAL DATA COMPLETENESS
   ============================================================

   Purpose:
   Verify that source-specific columns are populated correctly.

   Expected:
   - marketing rows contain campaign fields
   - general rows contain viral fields
*/

SELECT
    source,
    COUNT(campaign_name) AS populated_campaign_rows,
    COUNT(is_viral) AS populated_viral_rows
FROM social_media_posts
GROUP BY source;



/* ============================================================
   13. DATA PROFILING SUMMARY
   ============================================================

   Purpose:
   Generate a quick overview of the dataset.

   Useful For:
   - Sanity checking
   - Dashboard KPIs
   - Understanding dataset scale
*/

SELECT
    COUNT(*) AS total_rows,

    COUNT(DISTINCT platform) AS total_platforms,
    COUNT(DISTINCT country) AS total_countries,
    COUNT(DISTINCT language) AS total_languages,

    AVG(engagement_rate) AS avg_engagement_rate,
    AVG(likes) AS avg_likes,
    AVG(comments) AS avg_comments,
    AVG(shares) AS avg_shares
FROM social_media_posts;



/* ============================================================
   14. VIRAL POST ANALYSIS
   ============================================================

   Purpose:
   Compare engagement between viral and non-viral posts.

   Expected:
   Viral posts should generally have higher engagement.
*/

SELECT
    is_viral,
    AVG(engagement_rate) AS avg_engagement_rate,
    AVG(likes) AS avg_likes,
    AVG(comments) AS avg_comments,
    AVG(shares) AS avg_shares
FROM social_media_posts
GROUP BY is_viral;



/* ============================================================
   15. HASHTAG ANALYSIS
   ============================================================

   Purpose:
   Analyze relationship between hashtag usage and engagement.
*/

SELECT
    hashtag_count,
    AVG(engagement_rate) AS avg_engagement_rate,
    COUNT(*) AS total_posts
FROM social_media_posts
GROUP BY hashtag_count
ORDER BY hashtag_count;



/* ============================================================
   16. PLATFORM PERFORMANCE ANALYSIS
   ============================================================

   Purpose:
   Compare average engagement across platforms.
*/

SELECT
    platform,
    COUNT(*) AS total_posts,
    AVG(engagement_rate) AS avg_engagement_rate,
    AVG(likes) AS avg_likes,
    AVG(comments) AS avg_comments,
    AVG(shares) AS avg_shares
FROM social_media_posts
GROUP BY platform
ORDER BY avg_engagement_rate DESC;



/* ============================================================
   END OF DATA VALIDATION FILE
   ============================================================ */