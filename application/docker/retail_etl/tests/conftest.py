# imports
import pytest
import yaml
import os
from snowflake.snowpark.session import Session 


def getSnowpark(snowflake_conn_details: dict) -> object:
    """Function that returns an object which contain the connection to remote snowflake instance via Snowpark

    Args:
        snowflake_conn_details (dict): Dictionary containing connection details

    Returns:
        object: snowpark connection object
    """
    if isinstance(snowflake_conn_details, dict) == False:
        raise TypeError("Snowflake connection details not provided in dictionary") 
    snowpark = Session.builder.configs(snowflake_conn_details).create() 
    return snowpark 


# collect configs 
with open("/app/retail_etl/service_configs.yml") as configFile:
        configs = yaml.safe_load(configFile)

snowflake_connection_details = configs['snowflake'] # reads the snowflake configs as a dict object 
snowflake_connection_details['account'] = os.getenv('snowflake_account')
snowflake_connection_details['password'] = os.getenv('etl_serv_password')


# create a fixture, for a snowpark session, that can be persisted across multiple tests shiuld it be required
@pytest.fixture(scope='session')
def snowpark():
    snowpark = getSnowpark(snowflake_connection_details)
    yield snowpark 

    # when tests stop, drop any temp table created & stop the snowpark session
    snowpark.sql("DROP TABLE IF EXISTS PURCHASE_DATA_STG.UNIT_TEST_SNOWFLAKE").collect() 
    snowpark.close() 
