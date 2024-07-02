{% macro delete_old_data(target_table, years_to_delete_after) %}

{# This macro is designed to delete data that is older than (years_to_delete_after) years from a target
table within the snapshots build of the project & be called via a reference to this macro #}

DELETE FROM {{ target_table }}
WHERE DBT_VALID_TO IS NOT NULL 
AND DBT_VALID_TO < DATEADD(YEAR, -({{ years_to_delete_after }}), CURRENT_DATE)

{% endmacro %}