{% test multi_column_no_duplicates(model, column_list) %}

{# This macro can point at a model/snapshot, take an input list of columns as a parameter, to run an SQL statement
that checks for any duplication across those listed columns.
REMEMBER, DBT tests are designed to RETURN FAILURES should they exist. So design to find cases that fail, not pass #}

{% set columns_string = columns_list | join(', ') %}
{% set sql %}
    SELECT 
        {{ columns_string }},
        COUNT(*) AS OBS 
    FROM {{ model }}
    GROUP BY {{ columns_string }}
    HAVING OBS > 1
{% endset %}

{{ return(sql) }}

{% endtest %}