"""
This script is designed to collect data (using Faker rather than a real API) from sources, 
combine, basic DQ checks & stage RAW data into Snwoflake via Snowpark
"""

# Imports
from data_sources.customers import get_customers
from data_sources.transactions import get_transactions
from data_sources.uk_postcodes import source_uk_postcodes 
import os 
import yaml 
from cuallee import Check, CheckLevel 
from datetime import date, timedelta
import pandas as pd 
import duckdb as ddb 
from utils import logger, getSnowpark, write_to_snowflake 
from transforms import merge_customers_postcodes 


# run the ETL application 
if __name__ == "__main__":
    # configure logging 
    log = logger(output='terminal', level='INFO', filename=None) # use defaults 
    log.info("=" * 150) 
    log.info("Running ETL process for Retail Customer Purchases") 

    # read in configurations from `service_configs.yml`
    log.info("Read configuration details in ...")
    with open("./service_configs.yml") as configFile:
        configs = yaml.safe_load(configFile) 
    try:
        snowflake_connection_details = configs['snowflake'] # reads the snowflake configs as a dict object 
        # use OS to get environment variables, and update account & password with hidden values 
        snowflake_connection_details['account'] = os.getenv('snowflake_account')
        snowflake_connection_details['password'] = os.getenv('etl_serv_password')
        log.info("Snowpark configuration details set")
    except Exception as e:
        log.error(e, exc_info=True) # includes traceback info to log
        raise e
    
    # Collect data sources & run basic DQ checks with Cuallee package
    try:
        # customers
        log.info("Source customer data from API extraction ...")
        customers_df = get_customers(seed=87654) # Leave this seed hardcoded, so customers are always the same for this example project
        log.info(f"Customer data sourced. Result dataframe has {len(customers_df)} rows")

        # DQ : do some data quality here with cuallee (on top of Pandas)
        log.info("Running DQ checks on Customers Extract ...")
        cust_checks = Check(level=CheckLevel.ERROR, name="customer_extract_DQ")
        cust_dq = (cust_checks
            .are_complete(["customerID", "emailAddress", "firstName", "lastName", "profession"])
            .is_unique("customerID")
            .is_positive("customerID")
            .validate(customers_df) # choose the DataFrame to validate the checks against 
        )
        log.info(f"\n{cust_dq.to_string()}\n") # logs the results of DQ checks
        # now run a check to see if any FAILS exist & raise if so 
        cust_dq_fails = (
            ddb.query("""
            SELECT 
                SUM(CASE WHEN STATUS = 'FAIL' THEN 1 ELSE 0 END) AS DQ_FAILURES
            FROM cust_dq 
            """).to_df().iloc[0, 0] # accesses the actual value 
        )
        if cust_dq_fails != 0:
            log.error("There has been a DQ failure for the extraction of customer data")
            raise Exception("DQ Failure for Customer Extract")
        else:
            log.info("DQ checks on Customers Extract have passed!")
        #========================================================================================

        # postcodes
        log.info("Source UK Postcode data from API extraction ...") 
        postcode_df = source_uk_postcodes()
        log.info(f"Postcode data sourced. Result dataframe has {len(postcode_df)} rows")

        # DQ : do some data quality here with cuallee (on top of Pandas)
        log.info("Running DQ checks on Postcodes Extract ...")
        postcode_checks = Check(level=CheckLevel.ERROR, name="postcode_extract_DQ")
        postcode_dq = (postcode_checks
            .are_complete(["Postcode", "In Use?", "Introduced"])
            .is_unique("Postcode")
            .validate(postcode_df) # choose the DataFrame to validate the checks against 
        )
        log.info(f"\n{postcode_dq.to_string()}\n") # logs the results of DQ checks
        # now run a check to see if any FAILS exist & raise if so 
        postcode_dq_fails = (
            ddb.query("""
            SELECT 
                SUM(CASE WHEN STATUS = 'FAIL' THEN 1 ELSE 0 END) AS DQ_FAILURES
            FROM postcode_dq 
            """).to_df().iloc[0, 0] # accesses the actual value 
        )
        if postcode_dq_fails != 0:
            log.error("There has been a DQ failure for the extraction of postcode data")
            raise Exception("DQ Failure for Postcode Extract")
        else:
            log.info("DQ checks on Postcode Extract have passed!")
        #========================================================================================

        # transactions
        log.info("Source transactions data from API extraction ...")
        today = date.today() # use today's date to generate the values that will build fake txn data 
        tomorrow = (date.today() + timedelta(days=1)) 
        txns_df = get_transactions(today, tomorrow)
        log.info(f"Transactions data sourced. Result dataframe has {len(txns_df)} rows")
        # use DuckDB to add extract date 
        txns_df_w_extract = (
            ddb.query(
                """
                SELECT 
                    *,
                    CURRENT_DATE() AS EXTRACT_DATE
                FROM txns_df 
                """
            ).to_df() # converts result back to dataframe 
        )

        # DQ : do some data quality here with cuallee (on top of Pandas)
        log.info("Running DQ checks on Transactions Extract ...")
        txn_checks = Check(level=CheckLevel.ERROR, name="txn_extract_DQ")
        txn_dq = (txn_checks
            .are_complete(["customerID", "transaction_TS"])
            .validate(txns_df_w_extract) # choose the DataFrame to validate the checks against 
        )
        log.info(f"\n{txn_dq.to_string()}\n") # logs the results of DQ checks
        # now run a check to see if any FAILS exist & raise if so 
        txn_dq_fails = (
            ddb.query("""
            SELECT 
                SUM(CASE WHEN STATUS = 'FAIL' THEN 1 ELSE 0 END) AS DQ_FAILURES
            FROM txn_dq 
            """).to_df().iloc[0, 0] # accesses the actual value 
        )
        if txn_dq_fails != 0:
            log.error("There has been a DQ failure for the extraction of transaction data")
            raise Exception("DQ Failure for Transaction Extract")
        else:
            log.info("DQ checks on Transaction Extract have passed!")
        #========================================================================================
    except Exception as e:
        log.error(e, exc_info=True) # includes traceback info to log
        raise e
    
    # combine `customers` & `postcodes` together 
    try:
        log.info("Merge customers and postcode data sources")
        full_cust_data = merge_customers_postcodes(customers_df, postcode_df) 
        log.info(f"Data merge complete. Result dataframe has {len(full_cust_data)} rows") 
    except Exception as e:
        log.error(e, exc_info=True)
        raise e 

    # create snowpark session & push dataframes `txns_df` & `full_cust_data` to snowpark
    try:
        log.info("=" * 150)
        log.info("Start connection to Snowflake through SnowPark ...") 
        snowpark = getSnowpark(snowflake_connection_details) 
        log.info("Snowflake connection established through object `snowpark`") 

        # push `full_cust_data` to snowpark & write it to stg schema 
        log.info("push full_cust_data to snowpark")
        full_cust_snow = snowpark.create_dataframe(full_cust_data) 
        log.info("write full_cust_data to snowflake") 
        write_to_snowflake(full_cust_snow, "PURCHASE_DATA_STG", "RAW_CUST_DATA")
        log.info("data written to snowflake") 

        # Now write transactions data to snowpark & snowflake 
        log.info("push txns_df_w_extract to snowpark")
        txns_snow = snowpark.create_dataframe(txns_df_w_extract) 
        log.info("write txns_df to snowflake") 
        write_to_snowflake(txns_snow, "PURCHASE_DATA_STG", "RAW_TXN_DATA")
        log.info("data written to snowflake\n")
    except Exception as e:
        log.error(e, exc_info=True)
        raise e 
    
    # Simple ETL pipeline complete, close snowpark & end 
    snowpark.close() # closes snowpark session 
    log.info("End of pipeline") 
    log.info("=" * 150)
