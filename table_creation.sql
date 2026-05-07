CREATE TABLE social_media_posts (
    post_key INT IDENTITY PRIMARY KEY,

    -- Source tracking
    source VARCHAR(20), -- 'marketing' or 'general'

    -- Core identifiers
    post_id VARCHAR(100),
    platform VARCHAR(50),

    -- Time
    post_datetime DATETIME,
    day_of_week VARCHAR(10),
    hour INT,

    -- Location
    country VARCHAR(100),
    city VARCHAR(100),

    -- Content
    content_type VARCHAR(50),     -- from dataset 2, else 'unknown'
    topic VARCHAR(100),
    topic_category VARCHAR(100),

    -- Text features
    language VARCHAR(10),
    hashtags TEXT,
    hashtag_count INT,
    mentions TEXT,
    keywords TEXT,

    -- Sentiment
    sentiment_score FLOAT,
    sentiment_label VARCHAR(50),
    emotion_type VARCHAR(50),
    toxicity_score FLOAT,

    -- Engagement metrics
    likes INT,
    comments INT,
    shares INT,
    views FLOAT,
    impressions FLOAT,
    engagement_rate FLOAT,

    -- Viral flag (dataset 2)
    is_viral BIT,

    -- Marketing fields (dataset 1)
    brand_name VARCHAR(100),
    product_name VARCHAR(100),
    campaign_name VARCHAR(255),
    campaign_phase VARCHAR(50),

    -- User behavior (dataset 1)
    user_past_sentiment_avg FLOAT,
    user_engagement_growth FLOAT,
    buzz_change_rate FLOAT,

    -- Metadata
    ingestion_time DATETIME
);