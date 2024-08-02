# Imports 
import sys 
import logging 
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


def write_to_snowflake(snowpark_df: object, snowflake_schema: str, snowflake_table: str, mode: str = "overwrite"):
    """Writes a snowpark dataframe to a snowflake table 

    Args:
        snowpark_df (object): the dataframe to save
        snowflake_schema (str): schema to target
        snowflake_table (str): tabke to target
    """
    snowpark_df.write.mode(mode).save_as_table(f"{snowflake_schema}.{snowflake_table}")
