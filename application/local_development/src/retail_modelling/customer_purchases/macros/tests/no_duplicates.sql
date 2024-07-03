{% test no_duplicates(model, columns) %}

WITH duplicates AS (
    SELECT
        {{ columns | join(', ') }},
        COUNT(*) AS obs 
    FROM {{ model }}
    GROUP BY {{ columns | join(', ') }}
    HAVING obs > 1
)

SELECT * FROM duplicates 

{% endtest %}