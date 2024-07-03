{% snapshot Postcode_Details %}

{{ 
    config(
        tags=["purchase_data_transformations"],
        target_database='CUSTOMER_PURCHASES',
        target_schema='PURCHASE_DATA',
        unique_key='POSTCODE',
        strategy='check',
        check_cols=[
            'COUNTRY', 'REGION', 'INTRODUCED', 'TERMINATED', 'CONSTITUENCY',
            'LATITUDE', 'LONGITUDE',
        ], 
        post_hook=["{{ delete_old_data(this, 5) }}"],
    ) 
}}

-- set a VAR `run_date` (this will use run_date if it is set via CLI during a DBT build/run, else defaults to None) 
-- for example, if needing to run backfill, could set a specific run date 
{% set run_date = var('run_date', None) %}

-- SQL logic to build the SCD II snapshot table 
WITH POSTCODE_SOURCE AS (
    SELECT DISTINCT
        CAST(UPPER(TRIM("postcode")) AS VARCHAR) AS POSTCODE,
        CAST("Latitude" AS DECIMAL(10,6)) AS LATITUDE,
        CAST("Longitude" AS DECIMAL(10,6)) AS LONGITUDE,
        CAST(INITCAP(TRIM("Country")) AS VARCHAR) AS COUNTRY,
        CAST(INITCAP(TRIM("Constituency")) AS VARCHAR) AS CONSTITUENCY,
        CAST(INITCAP(TRIM("Region")) AS VARCHAR) AS REGION,
        TO_DATE("Introduced") AS INTRODUCED,
        TO_DATE("Terminated") AS TERMINATED
        
    FROM {{ source('RAW', 'RAW_CUST_DATA') }} -- let's you specify which source to use from the DBT configs (sources.yml) 
    WHERE "postcode" IS NOT NULL 

    {% if run_date %} -- This checks that `run_date` IS NOT EQUAL to None. And if so, use the following to compile the SQL
        AND EXTRACT_DATE = '{{ run_date }}'
    {% else %} -- else, should run_date be None, use this to compile the SQL instead 
        AND EXTRACT_DATE = CURRENT_DATE() 
    {% endif %}
)
SELECT 
    POSTCODE, COUNTRY, REGION, INTRODUCED, TERMINATED, CONSTITUENCY, LATITUDE, LONGITUDE
FROM POSTCODE_SOURCE

{% endsnapshot %}