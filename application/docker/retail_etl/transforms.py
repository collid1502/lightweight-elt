# Imports
import pandas as pd 
import duckdb as ddb 


def merge_customers_postcodes(cust_df: pd.DataFrame, postcode_df: pd.DataFrame) -> pd.DataFrame:
    """Take the input dataframes of customer data & ONS postcode data, merge them together

    Args:
        cust_df (pd.DataFrame): pandas df holding customer extract from CSV
        postcode_df (pd.DataFrame): pandas df holding postcode extract from ONS 

    Returns:
        pd.DataFrame: a merged dataframe of the two inputs joined by `postcode` 
    """
    output_df = (
        ddb.query(
        """
        SELECT 
            CURRENT_DATE() AS EXTRACT_DATE,
            TB1.CUSTOMERID, TB1.FIRSTNAME, TB1.LASTNAME, TB1.REWARDSMEMBER, TB1.EMAILADDRESS, 
            TB1.PROFESSION, TB1.DOB, TB1.CUSTOMERJOINED, 
            TB1.POSTCODE,
            TB2.LATITUDE, TB2.LONGITUDE, TB2.COUNTRY, TB2.CONSTITUENCY, TB2.REGION, 
            TB2.INTRODUCED, TB2.TERMINATED, TB2."LAST UPDATED" AS POSTCODE_LAST_UPDATED
        FROM 
            cust_df AS TB1
        LEFT JOIN 
            postcode_df AS TB2
        ON 
        UPPER(REPLACE(TB1.POSTCODE, ' ', '')) = UPPER(REPLACE(TB2.POSTCODE, ' ', ''))
        """
        ).to_df() # converts to pandas DF from DuckDB result
    )
    return output_df 
