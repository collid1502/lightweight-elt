{{ config(
    materialized='view',
    database='CUSTOMER_PURCHASES',
    schema='PURCHASE_DATA',
    tags=['purchase_data_views']
) }}

SELECT * FROM {{ ref('Purchases') }}