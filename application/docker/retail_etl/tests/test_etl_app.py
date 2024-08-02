# Run unit tests of key functions from ETL/app.py

# imports 
from time import sleep
import pandas as pd 
from datetime import datetime 
import pytest
from snowflake.snowpark.types import IntegerType, StringType, StructType, StructField
from ..utils import write_to_snowflake
from ..transforms import merge_customers_postcodes 


# create test for proving write to snowflake works (uses the snowpark fixture from conftest file)
def test_write_to_snowflake(snowpark):
    dummySchema = StructType(
        [
            StructField("name", StringType()),
            StructField("age", IntegerType())
        ]
    )
    dummy_data = snowpark.create_dataframe(
        [
            ['Dan', 30],
            ['Tim', 35],
            ['Ellie', 42]
        ],
        schema=dummySchema
    )
    # use the write to snowflake method to save this data to snowflake
    write_to_snowflake(
        snowpark_df=dummy_data, 
        snowflake_schema="PURCHASE_DATA_STG",
        snowflake_table="UNIT_TEST_SNOWFLAKE",
        mode="overwrite" 
    )
    sleep(3) # sleep 3 seconds
    # attempt to read that data back now via snowpark 
    result_df = snowpark.table("PURCHASE_DATA_STG.UNIT_TEST_SNOWFLAKE")

    # now, the result df, when collected, should equal the dummy data df, if the save function has worked as expected
    assert sorted(dummy_data.collect()) == sorted(result_df.collect()) 


# create a test for the merge customer postcodes to ensure its working as expected 
def test_merge_customers_postcodes():
    # create some fake customer data
    test_cust_data = {
        "CUSTOMERID": [101],
        "FIRSTNAME": ["John"],
        "LASTNAME": ["Doe"],
        "REWARDSMEMBER": [True],
        "EMAILADDRESS": ["john.doe@example.com"],
        "PROFESSION": ["Engineer"],
        "DOB": ["1990-01-01"],
        "CUSTOMERJOINED": ["2015-09-01"],
        "POSTCODE": ["SW19 1BB"]  
    }
    test_cust_df = pd.DataFrame(test_cust_data) 

    # create some fake postcode data
    test_postcode_data = {
        "POSTCODE": ["SW19 1BB", "W1A 1HQ", "SW1A 2AA"],
        "LATITUDE": [51.519881, 51.518948, 51.503440],
        "LONGITUDE": [-0.097530, -0.144414, -0.127716],
        "COUNTRY": ["England", "England", "England"],
        "CONSTITUENCY": ["Merton", "Westminster", "Westminster"],
        "REGION": ["London", "London", "London"],
        "INTRODUCED": ["1980-01-01", "1965-07-01", "1801-01-01"],
        "TERMINATED": ["2022-01-01", "2022-01-01", "2022-01-01"],
        "LAST UPDATED": ["2022-05-01", "2022-05-01", "2022-05-01"]
    }
    test_postcode_df = pd.DataFrame(test_postcode_data)

    # create the expected result!
    exp_result_data = {
        "CUSTOMERID": [101],
        "FIRSTNAME": ["John"],
        "LASTNAME": ["Doe"],
        "REWARDSMEMBER": [True],
        "EMAILADDRESS": ["john.doe@example.com"],
        "PROFESSION": ["Engineer"],
        "DOB": ["1990-01-01"],
        "CUSTOMERJOINED": ["2015-09-01"],
        "POSTCODE": ["SW19 1BB"],
        "LATITUDE": [51.519881],
        "LONGITUDE": [-0.097530],
        "COUNTRY": ["England"],
        "CONSTITUENCY": ["Merton"],
        "REGION": ["London"],
        "INTRODUCED": ["1980-01-01"],
        "TERMINATED": ["2022-01-01"],
        "POSTCODE_LAST_UPDATED": ["2022-05-01"]
    }
    exp_df = pd.DataFrame(exp_result_data)
    # Add a new column with today's date
    exp_df['EXTRACT_DATE'] = datetime.now().strftime('%Y-%m-%d')
    # Convert the 'date' column to datetime with microsecond precision
    exp_df['EXTRACT_DATE'] = pd.to_datetime(exp_df['EXTRACT_DATE'], format='%Y-%m-%d').astype('datetime64[us]')
    # Reorder columns to make 'CURRENT DATE' the first column
    column_order = ['EXTRACT_DATE'] + [col for col in exp_df.columns if col != 'EXTRACT_DATE']
    exp_df = exp_df[column_order]

    # now, run the function to test, and assert its output matches the expected result 
    test_merge = merge_customers_postcodes(
        cust_df=test_cust_df,
        postcode_df=test_postcode_df
    )

    list1 = sorted(list(exp_df.itertuples(index=False, name=None)))
    list2 = sorted(list(test_merge.itertuples(index=False, name=None)))

    assert list1 == list2, "DataFrames are not equal for output of `merge_customers_postcodes()`"

# end