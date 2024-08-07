{{ config(
    materialized='view',
    database='CUSTOMER_PURCHASES',
    schema='PURCHASE_DATA',
    tags=['purchase_data_views']
) }}

WITH SOURCE_DATA AS (
    SELECT 
        *,
        -- RENAME & CLEAN THE DBT VALID / FROM COLUMNS ETC 
        CASE WHEN DBT_VALID_FROM IS NOT NULL THEN DBT_VALID_FROM ELSE NULL END AS VALID_FROM,
        CASE WHEN DBT_VALID_TO IS NULL THEN TO_TIMESTAMP_NTZ('9999-12-31') ELSE DBT_VALID_TO END AS VALID_TO
    FROM {{ ref('Customers') }}
)
SELECT 
    ID, "NAME", JOINED, DATE_OF_BIRTH, POSTCODE, EMAIL_ADDRESS, PROFESSION, VALID_FROM, VALID_TO
FROM SOURCE_DATA 