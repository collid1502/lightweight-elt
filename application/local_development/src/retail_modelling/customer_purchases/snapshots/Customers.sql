{% snapshot Customers %}

-- Specify the configurations for this Data Model
-- uses the check method, checking if the below columns have changed, per the unique Key
-- post hook can run one of more actions, after the completion of a model / snapshot run
-- we will use this, to run a generic macro with inputs, to clear down "historic" data (5 years specified)
-- this uses `this` to reference this model as the input argument
{{ 
    config(
        tags=["purchase_data_transformation"],
        target_database='CUSTOMER_PURCHASES',
        target_schema='PURCHASE_DATA',
        unique_key='ID',
        strategy='check',
        check_cols=[
            'NAME', 'POSTCODE', 'EMAIL_ADDRESS', 'PROFESSION'
        ], 
        post_hook=["{{ delete_old_data(this, 5) }}"],
    ) 
}}

-- set a VAR `run_date` (this will use run_date if it is set via CLI during a DBT build/run, else defaults to None) 
-- for example, if needing to run backfill, could set a specific run date 
{% set run_date = var('run_date', None) %}

-- SQL logic to build the SCD II snapshot table 
WITH CUSTOMER_SOURCE AS (
    SELECT DISTINCT
        CAST("customerID" AS BIGINT) AS ID,
        CAST(INITCAP(TRIM("firstName")) AS VARCHAR) AS FIRST_NAME,
        CAST(INITCAP(TRIM("lastName")) AS VARCHAR) AS LAST_NAME,
        CAST(UPPER(TRIM("emailAddress")) AS VARCHAR) AS EMAIL_ADDRESS,
        CAST(UPPER(TRIM("postcode")) AS VARCHAR) AS POSTCODE,
        CAST(TRIM("profession") AS VARCHAR) AS PROFESSION,
        TO_TIMESTAMP_NTZ(TRIM("dob")) AS DOB,
        TO_TIMESTAMP_NTZ(TRIM("customerJoined")) AS CUSTOMER_JOINED
    FROM {{ source('RAW', 'RAW_CUST_DATA') }} -- let's you specify which source to use from the DBT configs (sources.yml) 
    WHERE "customerID" IS NOT NULL 

    {% if run_date %} -- This checks that `run_date` IS NOT EQUAL to None. And if so, use the following to compile the SQL
        AND EXTRACT_DATE = '{{ run_date }}'
    {% else %} -- else, should run_date be None, use this to compile the SQL instead 
        AND EXTRACT_DATE = CURRENT_DATE() 
    {% endif %}
)
SELECT 
    ID,
    CONCAT(FIRST_NAME, ' ', LAST_NAME) AS NAME,
    CUSTOMER_JOINED AS JOINED,
    TO_DATE(DOB) AS DATE_OF_BIRTH,
    POSTCODE, 
    EMAIL_ADDRESS, 
    PROFESSION 
FROM CUSTOMER_SOURCE

{% endsnapshot %}