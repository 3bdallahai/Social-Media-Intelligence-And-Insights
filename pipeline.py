import pandas as pd
from sqlalchemy import create_engine
from config import DB_CONFIG

def create_db_engine():
    connection_string = (
        f"mssql+pyodbc://@{DB_CONFIG['server']}/{DB_CONFIG['database']}"
        f"?driver={DB_CONFIG['driver'].replace(' ', '+')}"
        "&trusted_connection=yes"
    )
    return create_engine(connection_string)

def load_data():
    df_marketing = pd.read_csv("Data\Social Media Engagement Dataset.csv")
    df_general = pd.read_csv("Data\social_media_performance.csv")
    
    return df_marketing, df_general

def clean_marketing(df):
    df = df.copy()

    # Rename columns
    df = df.rename(columns={
        "timestamp": "post_datetime",
        "likes_count": "likes",
        "comments_count": "comments",
        "shares_count": "shares"
    })

    # Datetime
    df["post_datetime"] = pd.to_datetime(df["post_datetime"], errors="coerce")

    # Time features
    df["hour"] = df["post_datetime"].dt.hour
    df["day_of_week"] = df["post_datetime"].dt.day_name()

    # Location → country & city
    df["country"] = df["location"].apply(
        lambda x: str(x).split(",")[-1].strip() if pd.notnull(x) else None
    )
    df["city"] = df["location"].apply(
        lambda x: str(x).split(",")[0].strip() if pd.notnull(x) else None
    )

    # Content defaults
    df["content_type"] = "unknown"
    df["topic"] = None

    # Hashtags count
    df["hashtag_count"] = df["hashtags"].apply(
        lambda x: len(str(x).split()) if pd.notnull(x) else 0
    )

    # Fix engagement rate
    df["engagement_rate"] = df["engagement_rate"].apply(
        lambda x: x / 100 if x > 1 else x
    )

    # Derived views
    df["views"] = (
        (df["likes"] + df["comments"] + df["shares"]) /
        df["engagement_rate"]
    )

    # Add missing fields
    df["views"] = None
    df["is_viral"] = None

    # Source
    df["source"] = "marketing"

    return df

def clean_general(df):
    df = df.copy()

    # Rename
    df = df.rename(columns={
        "post_datetime": "post_datetime"
    })

    # Datetime
    df["post_datetime"] = pd.to_datetime(df["post_datetime"], errors="coerce")

    # Time features
    df["hour"] = df["post_datetime"].dt.hour
    df["day_of_week"] = df["post_datetime"].dt.day_name()

    # Location
    df["country"] = df["region"]
    df["city"] = None

    # Hashtag count
    df["hashtag_count"] = df["hashtags"].apply(
        lambda x: len(str(x).split()) if pd.notnull(x) else 0
    )

    # Fill missing columns to match schema
    df["topic_category"] = None
    df["mentions"] = None
    df["keywords"] = None
    df["emotion_type"] = None
    df["toxicity_score"] = None

    df["brand_name"] = None
    df["product_name"] = None
    df["campaign_name"] = None
    df["campaign_phase"] = None

    df["user_past_sentiment_avg"] = None
    df["user_engagement_growth"] = None
    df["buzz_change_rate"] = None


    # Source
    df["source"] = "general"

    return df

def merge_data(df1, df2):
    final_df = pd.concat([df1, df2], ignore_index=True)

    # Normalize language
    final_df["language"] = final_df["language"].str.upper()

    # Ensure numeric columns
    numeric_cols = [
        "likes", "comments", "shares", "views",
        "views", "engagement_rate"
    ]

    for col in numeric_cols:
        final_df[col] = pd.to_numeric(final_df[col], errors="coerce")

    # Add ingestion time
    final_df["ingestion_time"] = pd.Timestamp.now()

    final_columns = [
    'post_id',
    'platform',
    'post_datetime',
    'day_of_week',
    'hour',
    'country',
    'city',
    'content_type',
    'topic',
    'topic_category',
    'language',
    'hashtags',
    'hashtag_count',
    'mentions',
    'keywords',
    'sentiment_score',
    'sentiment_label',
    'emotion_type',
    'toxicity_score',
    'likes',
    'comments',
    'shares',
    'views',
    'engagement_rate',
    'is_viral',
    'brand_name',
    'product_name',
    'campaign_name',
    'campaign_phase',
    'user_past_sentiment_avg',
    'user_engagement_growth',
    'buzz_change_rate',
    'source',
    'ingestion_time'
]

    final_df = final_df[final_columns]

    return final_df

def load_to_sql(df, engine):
    df.to_sql(
        "social_media_posts",
        con=engine,
        if_exists="replace",   # or "replace" first time
        index=False
    )

def run_pipeline():
    engine = create_db_engine()

    df_marketing, df_general = load_data()

    df_marketing_clean = clean_marketing(df_marketing)
    df_general_clean = clean_general(df_general)

    final_df = merge_data(df_marketing_clean, df_general_clean)

    load_to_sql(final_df, engine)

    print("✅ Pipeline executed successfully!")


if __name__ == "__main__":
    run_pipeline()