{{ config(
    materialized='incremental',
    database='CUSTOMER_PURCHASES',
    schema='PURCHASE_DATA',
    tags=['purchase_data_transformations'],
    unique_key=['CUSTOMER_ID', 'TRANSACTION_TS'],
    on_schema_change='fail',
    post_hook="DELETE FROM {{ this }} WHERE TRANSACTION_TS < DATEADD(YEAR, -5, CURRENT_DATE())"
) }}
-- For transactions, we use the incremental strategy
-- This will only load new transactions, in append mode, to the table, or update existing rows
-- where the Unique Key is a match from the source 

WITH SOURCE_DATA AS (
    SELECT 
        CAST("customerID" AS INTEGER) AS CUSTOMER_ID, 
        TO_TIMESTAMP_NTZ("transaction_TS") AS TRANSACTION_TS,
        CAST(INITCAP(TRIM("Product")) AS VARCHAR) AS PRODUCT,
        CAST("volume" AS INTEGER) AS QUANTITY 
    FROM {{ source('RAW', 'RAW_TXN_DATA')  }}

    {% if is_incremental() %}

        -- this filter will only be applied on an incremental run
        -- (uses >= to include records whose timestamp occurred since the last run of this model)
        -- (If TRANSACTION_TS is NULL or the table is truncated, the condition will always be true and load all records)
        WHERE TRANSACTION_TS > (SELECT COALESCE(MAX(TRANSACTION_TS), '1900-01-01') from {{ this }} )
    {% endif %}
)
SELECT * FROM SOURCE_DATA 