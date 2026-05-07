/* ============================================================
   SOCIAL MEDIA INTELLIGENCE PROJECT
   ANALYTICAL SQL QUERIES
   ============================================================

   Purpose:
   This file contains analytical SQL queries used to explore
   social media engagement trends, marketing campaign
   performance, sentiment analysis, and audience behavior.

   Main Table:
       social_media_posts

   ============================================================ */


/* ============================================================
   1. OVERALL DATASET SUMMARY
   ============================================================

   Purpose:
   Provide a high-level overview of the dataset.
*/

SELECT
    COUNT(*) AS total_posts,
    COUNT(DISTINCT platform) AS total_platforms,
    COUNT(DISTINCT country) AS total_countries,
    COUNT(DISTINCT language) AS total_languages,

    AVG(engagement_rate) AS avg_engagement_rate,
    AVG(likes) AS avg_likes,
    AVG(comments) AS avg_comments,
    AVG(shares) AS avg_shares
FROM social_media_posts;



/* ============================================================
   2. PLATFORM PERFORMANCE ANALYSIS
   ============================================================

   Purpose:
   Compare engagement performance across social media platforms.
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
   3. BEST POSTING HOURS
   ============================================================

   Purpose:
   Identify the hours with the highest average engagement.
*/

SELECT
    hour,
    COUNT(*) AS total_posts,
    AVG(engagement_rate) AS avg_engagement_rate
FROM social_media_posts
GROUP BY hour
ORDER BY avg_engagement_rate DESC;



/* ============================================================
   4. DAY OF WEEK ANALYSIS
   ============================================================

   Purpose:
   Determine which weekdays generate the highest engagement.
*/

SELECT
    day_of_week,
    COUNT(*) AS total_posts,
    AVG(engagement_rate) AS avg_engagement_rate
FROM social_media_posts
GROUP BY day_of_week
ORDER BY avg_engagement_rate DESC;



/* ============================================================
   5. COUNTRY PERFORMANCE ANALYSIS
   ============================================================

   Purpose:
   Compare engagement performance across countries.
*/

SELECT
    country,
    COUNT(*) AS total_posts,
    AVG(engagement_rate) AS avg_engagement_rate,
    AVG(likes) AS avg_likes
FROM social_media_posts
GROUP BY country
ORDER BY avg_engagement_rate DESC;



/* ============================================================
   6. SENTIMENT DISTRIBUTION
   ============================================================

   Purpose:
   Analyze the distribution of sentiment labels.
*/

SELECT
    sentiment_label,
    COUNT(*) AS total_posts
FROM social_media_posts
GROUP BY sentiment_label
ORDER BY total_posts DESC;



/* ============================================================
   7. SENTIMENT VS ENGAGEMENT
   ============================================================

   Purpose:
   Compare engagement rates across sentiment categories.
*/

SELECT
    sentiment_label,
    AVG(engagement_rate) AS avg_engagement_rate,
    AVG(likes) AS avg_likes,
    AVG(comments) AS avg_comments,
    AVG(shares) AS avg_shares
FROM social_media_posts
GROUP BY sentiment_label
ORDER BY avg_engagement_rate DESC;



/* ============================================================
   8. EMOTION TYPE ANALYSIS
   ============================================================

   Purpose:
   Analyze engagement by detected emotion type.
*/

SELECT
    emotion_type,
    COUNT(*) AS total_posts,
    AVG(engagement_rate) AS avg_engagement_rate
FROM social_media_posts
WHERE emotion_type IS NOT NULL
GROUP BY emotion_type
ORDER BY avg_engagement_rate DESC;



/* ============================================================
   9. TOXICITY ANALYSIS
   ============================================================

   Purpose:
   Examine relationship between toxicity and engagement.
*/

SELECT
    AVG(toxicity_score) AS avg_toxicity,
    AVG(engagement_rate) AS avg_engagement_rate
FROM social_media_posts
WHERE toxicity_score IS NOT NULL;



/* ============================================================
   10. HASHTAG USAGE ANALYSIS
   ============================================================

   Purpose:
   Analyze how hashtag count affects engagement.
*/

SELECT
    hashtag_count,
    COUNT(*) AS total_posts,
    AVG(engagement_rate) AS avg_engagement_rate
FROM social_media_posts
GROUP BY hashtag_count
ORDER BY hashtag_count;



/* ============================================================
   11. VIRAL VS NON-VIRAL ANALYSIS
   ============================================================

   Purpose:
   Compare viral and non-viral post performance.
*/

SELECT
    is_viral,
    COUNT(*) AS total_posts,
    AVG(engagement_rate) AS avg_engagement_rate,
    AVG(likes) AS avg_likes,
    AVG(comments) AS avg_comments,
    AVG(shares) AS avg_shares
FROM social_media_posts
WHERE is_viral IS NOT NULL
GROUP BY is_viral;



/* ============================================================
   12. CONTENT TYPE ANALYSIS
   ============================================================

   Purpose:
   Compare engagement across content types.
*/

SELECT
    content_type,
    COUNT(*) AS total_posts,
    AVG(engagement_rate) AS avg_engagement_rate,
    AVG(likes) AS avg_likes
FROM social_media_posts
GROUP BY content_type
ORDER BY avg_engagement_rate DESC;



/* ============================================================
   13. TOP PERFORMING CAMPAIGNS
   ============================================================

   Purpose:
   Identify marketing campaigns with highest engagement.
*/

SELECT
    campaign_name,
    COUNT(*) AS total_posts,
    AVG(engagement_rate) AS avg_engagement_rate,
    SUM(likes) AS total_likes,
    SUM(comments) AS total_comments,
    SUM(shares) AS total_shares
FROM social_media_posts
WHERE source = 'marketing'
GROUP BY campaign_name
ORDER BY avg_engagement_rate DESC;



/* ============================================================
   14. CAMPAIGN PHASE ANALYSIS
   ============================================================

   Purpose:
   Compare engagement across campaign phases.
*/

SELECT
    campaign_phase,
    COUNT(*) AS total_posts,
    AVG(engagement_rate) AS avg_engagement_rate
FROM social_media_posts
WHERE source = 'marketing'
GROUP BY campaign_phase
ORDER BY avg_engagement_rate DESC;



/* ============================================================
   15. BRAND PERFORMANCE ANALYSIS
   ============================================================

   Purpose:
   Compare engagement across brands.
*/

SELECT
    brand_name,
    COUNT(*) AS total_posts,
    AVG(engagement_rate) AS avg_engagement_rate,
    SUM(likes) AS total_likes
FROM social_media_posts
WHERE source = 'marketing'
GROUP BY brand_name
ORDER BY avg_engagement_rate DESC;



/* ============================================================
   16. PRODUCT PERFORMANCE ANALYSIS
   ============================================================

   Purpose:
   Compare engagement across products.
*/

SELECT
    product_name,
    COUNT(*) AS total_posts,
    AVG(engagement_rate) AS avg_engagement_rate,
    SUM(likes) AS total_likes
FROM social_media_posts
WHERE source = 'marketing'
GROUP BY product_name
ORDER BY avg_engagement_rate DESC;



/* ============================================================
   17. LANGUAGE ANALYSIS
   ============================================================

   Purpose:
   Compare engagement across languages.
*/

SELECT
    language,
    COUNT(*) AS total_posts,
    AVG(engagement_rate) AS avg_engagement_rate
FROM social_media_posts
GROUP BY language
ORDER BY avg_engagement_rate DESC;



/* ============================================================
   18. SOURCE COMPARISON
   ============================================================

   Purpose:
   Compare marketing posts and general posts.
*/

SELECT
    source,
    COUNT(*) AS total_posts,
    AVG(engagement_rate) AS avg_engagement_rate,
    AVG(likes) AS avg_likes,
    AVG(comments) AS avg_comments,
    AVG(shares) AS avg_shares
FROM social_media_posts
GROUP BY source;



/* ============================================================
   19. TOP 20 POSTS BY ENGAGEMENT RATE
   ============================================================

   Purpose:
   Identify the highest-performing posts.
*/

SELECT TOP 20
    post_id,
    platform,
    country,
    engagement_rate,
    likes,
    comments,
    shares
FROM social_media_posts
ORDER BY engagement_rate DESC;



/* ============================================================
   20. TOP 20 POSTS BY TOTAL ENGAGEMENT
   ============================================================

   Purpose:
   Identify posts with highest total interactions.
*/

SELECT TOP 20
    post_id,
    platform,
    country,
    (likes + comments + shares) AS total_engagement,
    engagement_rate
FROM social_media_posts
ORDER BY total_engagement DESC;



/* ============================================================
   21. MONTHLY ENGAGEMENT TREND
   ============================================================

   Purpose:
   Analyze engagement trends over time.
*/

SELECT
    YEAR(post_datetime) AS post_year,
    MONTH(post_datetime) AS post_month,
    COUNT(*) AS total_posts,
    AVG(engagement_rate) AS avg_engagement_rate
FROM social_media_posts
GROUP BY
    YEAR(post_datetime),
    MONTH(post_datetime)
ORDER BY
    post_year,
    post_month;



/* ============================================================
   22. PLATFORM + SENTIMENT COMBINATION ANALYSIS
   ============================================================

   Purpose:
   Compare sentiment performance across platforms.
*/

SELECT
    platform,
    sentiment_label,
    COUNT(*) AS total_posts,
    AVG(engagement_rate) AS avg_engagement_rate
FROM social_media_posts
GROUP BY
    platform,
    sentiment_label
ORDER BY
    platform,
    avg_engagement_rate DESC;



/* ============================================================
   23. AVERAGE ENGAGEMENT BY COUNTRY AND PLATFORM
   ============================================================

   Purpose:
   Identify the strongest platform in each country.
*/

SELECT
    country,
    platform,
    AVG(engagement_rate) AS avg_engagement_rate
FROM social_media_posts
GROUP BY
    country,
    platform
ORDER BY
    country,
    avg_engagement_rate DESC;



/* ============================================================
   24. USER GROWTH IMPACT ANALYSIS
   ============================================================

   Purpose:
   Analyze relationship between user growth and engagement.
*/

SELECT
    AVG(user_engagement_growth) AS avg_user_growth,
    AVG(engagement_rate) AS avg_engagement_rate
FROM social_media_posts
WHERE user_engagement_growth IS NOT NULL;



/* ============================================================
   25. BUZZ CHANGE RATE ANALYSIS
   ============================================================

   Purpose:
   Analyze relationship between buzz changes and engagement.
*/

SELECT
    AVG(buzz_change_rate) AS avg_buzz_change_rate,
    AVG(engagement_rate) AS avg_engagement_rate
FROM social_media_posts
WHERE buzz_change_rate IS NOT NULL;



/* ============================================================
   END OF ANALYTICAL QUERY FILE
   ============================================================ */