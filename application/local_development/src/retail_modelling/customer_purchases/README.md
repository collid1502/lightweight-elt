# Customer Purchases Project

Further details are typically found in the README in the directory above this one.<br>
But some details can be found here, which are more specific to this project, rather than learning DBT in general.

---------

#### Custom Schema use in DBT

By Default, DBT can target all models at one schema (the one specified within the profile being used)<br>

There is set behaviour where, if specifying a custom schema in a config block, it actually appends that name to tha target name, like:

```
target_name_custom_name
```

rather than just:

```
custom_name
```

So, whilst using this with caution!!! as it can lead to multiple dev's overwriting each others work if using same schema names etc. you can change this default behaviour by modifying the a custom macro to get the custom schema name.

In the `macros` folder, I create a sub-dir called `utils` and within this, an SQL file called:

***get_custom_schema***

In this file, paste:

```
{% macro generate_schema_name(custom_schema_name, node) -%}

   {%- set default_schema = target.schema -%}
   {%- if custom_schema_name is none -%}

       {{ default_schema }}

   {%- else -%}

       {{ custom_schema_name | trim }}

   {%- endif -%}

{%- endmacro %}
```

Now, you will have the ability that when you specify a schema in the model config block within a model file, it will use that specific schema. This means one DBT project can now write and target multiple schemas where needed.

----------

### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
