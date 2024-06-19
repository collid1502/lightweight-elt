# Data Modelling with DBT (Data Build Tool)

So, with the RAW data pushed into Snowflake, now is the the time to build our Data Model, which can be done with DBT.<br>

DBT (core) is a useful open-source tool that allows us to create data models, through SQL, Jinja templating and other useful features. It's compatible with a variety of cloud & self-hosted database providers, such as Snowflake that we are using.

## Setting up our DBT project 

We can use the initiation command to create a project. So, we move to our directory that the DBT project should be developed in, and then execute the initiation command

```
cd ./application/local_development/src/retail_modelling 

dbt init
```

After executing `dbt init`, you will then be able to follow setup steps within the command line.

