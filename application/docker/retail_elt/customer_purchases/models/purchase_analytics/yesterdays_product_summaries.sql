{{ config(
    materialized='view',
    database='CUSTOMER_PURCHASES',
    schema='PURCHASE_ANALYTICS',
    tags=['purchase_analytics_views']
) }}

WITH 
yday_transactions AS (
    SELECT
        CUSTOMER_ID AS ID, 
        TRANSACTION_TS, PRODUCT, QUANTITY 
    FROM {{ ref('Purchases_vw') }}
    WHERE 
        TO_DATE(TRANSACTION_TS) > DATEADD(DAY, -1, CURRENT_DATE)
    AND TO_DATE(TRANSACTION_TS) < DATEADD(DAY, 1, CURRENT_DATE)
)
, joined_prices AS (
    SELECT 
        TS.ID, TS.TRANSACTION_TS, TS.PRODUCT, TS.QUANTITY,
        PB.PRICE,
        (TS.QUANTITY * PB.PRICE) AS VALUE_AMT,
        TO_DATE(TRANSACTION_TS) AS DATE
    FROM 
        yday_transactions AS TS 
    LEFT JOIN 
        {{ ref('Product_Brochure_vw') }} AS PB 
    ON 
        TS.PRODUCT = PB.PRODUCT 
    AND DATEADD(DAY, -1, PB.VALID_FROM) <= TS.TRANSACTION_TS 
    AND TS.TRANSACTION_TS <= PB.VALID_TO 
)
, product_summary AS (
    SELECT 
        DATE,
        PRODUCT,
        SUM(QUANTITY) AS QUANTITY_SOLD,
        SUM(VALUE_AMT) AS VALUE_SOLD
   FROM joined_prices
   GROUP BY DATE, PRODUCT
)
SELECT * FROM product_summary