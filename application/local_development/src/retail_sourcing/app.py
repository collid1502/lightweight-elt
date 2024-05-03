"""
This script is designed to collect data (using Faker rather than a real API) from sources, 
combine, basic DQ checks & stage RAW data into Snwoflake via Snowpark
"""

# Imports
from data_sources.customers import get_customers
from data_sources.transactions import get_transactions
import os 
import sys 
import logging 
import yaml 
from datetime import date, timedelta
from snowflake.snowpark.session import Session 


# create a function that returns a logging object to be used in pipeline
def logger(output: str = 'terminal', level: str = 'INFO', filename: str = None) -> object:
    """Creates & returns a logging object.

    Args:
        output (str, optional): choose terminal or file as to where to direct log messages to. Defaults to 'terminal'.
        level (str, optional): choose logging level. Defaults to 'INFO'.
        filename (str, optional): if writing logs to file, provide the filepath.log. Defaults to None.

    Returns:
        object: a logging object that can be called throughout a script
    """
    # configure logging 
    logger = logging.getLogger() 
    eval(f"logger.setLevel(logging.{level})") # evaluates logging level provided & sets it
    # determine whether to log to terminal or file 
    if output != "terminal" and output != "file":
        raise ValueError("Please specify a value of 'terminal' or 'file' for the output argument")
    elif output == "file":
        if filename == None:
            raise ValueError("You have specified file logging, but provided no filename argument. Please provide `filename` path")
        else:
            handler = logging.FileHandler(filename, mode='a') # sets to append for logging to given file name
    else:
        handler = logging.StreamHandler(stream=sys.stdout) 
    # set formatting for logs 
    formatter = logging.Formatter("%(asctime)s -- %(levelname)s : %(message)s") 
    handler.setFormatter(formatter)
    logger.addHandler(handler) 
    return logger 


# Create function to return a snowpark object for remote interaction with snowflake 
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




# run the ETL application 
if __name__ == "__main__":

    # configure logging 
    log = logger() # use defaults 
    log.info("Running ETL process for Retail Customer Purchases") 

    # read in configurations from `service_configs.yml`
    log.info("Read configuration details in ...")
    with open("./service_configs.yml") as configFile:
        configs = yaml.safe_load(configFile) 
    try:
        snowflake_connection_details = configs['snowflake'] # reads the snowflake configs as a dict object 
        # use OS to get environment variables, and update account & password with hidden values 
        snowflake_connection_details['account'] = os.getenv('snowflake_account')
        snowflake_connection_details['password'] = os.getenv('etl-serv_password')
        log.info("Snowpark configuration details set")
    except Exception as e:
        log.error(e)
        raise e

    # Collect customer data 
    log.info("Source customer data from API extraction ...")
    try:
        customers_df = get_customers(seed=87654) # Leave this seed hardcoded, so customers are always the same for this example project
        log.info("Customer data sourced")
    except Exception as e:
        log.error(e)
        raise e
    
    # Collect transactions data
    log.info("Source transactions data from API extraction ...")
    try:
        today = date.today() # use today's date to generate the values that will build fake txn data 
        tomorrow = (date.today() + timedelta(days=1)) 
        txns_df = get_transactions(today, tomorrow) 
        log.info("Transactions data sourced")
    except Exception as e:
        log.error(e)
        raise e

    # Collect UK ONS Postcode Data



    

    # create snowpark session 
    #snowpark = getSnowpark(snowflake_connection_details) 

    log.info("End of pipeline") 
