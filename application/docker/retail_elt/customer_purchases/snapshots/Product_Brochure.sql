{% snapshot Product_Brochure %}

{{ 
    config(
        tags=["purchase_data_transformations"],
        target_database='CUSTOMER_PURCHASES',
        target_schema='PURCHASE_DATA',
        unique_key='PRODUCT',
        strategy='check',
        check_cols=[
            'PRICE'
        ], 
        post_hook=["{{ delete_old_data(this, 5) }}"],
    ) 
}}

-- set a VAR `run_date` (this will use run_date if it is set via CLI during a DBT build/run, else defaults to None) 
-- for example, if needing to run backfill, could set a specific run date 
{% set run_date = var('run_date', None) %}

-- SQL logic to build the SCD II snapshot table 
WITH PRODUCT_SOURCE AS (
    SELECT DISTINCT
        CAST(INITCAP(TRIM("Product")) AS VARCHAR) AS PRODUCT,
        CAST("Price" AS DECIMAL(10,2)) AS PRICE
    FROM {{ source('RAW', 'RAW_TXN_DATA') }} -- let's you specify which source to use from the DBT configs (sources.yml) 
    WHERE "Product" IS NOT NULL 

    {% if run_date %} -- This checks that `run_date` IS NOT EQUAL to None. And if so, use the following to compile the SQL
        AND EXTRACT_DATE = '{{ run_date }}'
    {% else %} -- else, should run_date be None, use this to compile the SQL instead 
        AND EXTRACT_DATE = CURRENT_DATE() 
    {% endif %}
)
SELECT * FROM PRODUCT_SOURCE

{% endsnapshot %}