# ## Connecting to Doogal.co.uk ~ Postcode Lookup 
# This script collects postcodes & other metadata from the UK ONS
# provided as a service by Doogal. 
# open data portal through their endpoint

# key imports 
import pandas as pd 
from datetime import datetime 

def source_uk_postcodes():
    """
    Simple script to collect the four nations postcode sources.\n
    Note, England is larger so operates in chunks. \n
    All data combined into one pandas dataframe.
    """
    # here we list a subsection of metadata points we wish to obtain 
    colsToRead = [
        "Postcode", "In Use?", "Latitude", "Longitude", "Country", "Constituency",
        "Introduced", "Terminated", "Region", 
        "Last updated", "Postcode area", "Postcode district"
    ]
    # each country and its CSV URL 
    countries = {
        "NI": r"https://www.doogal.co.uk/UKPostcodesCSV/?Search=BT&uprn=false",
        "England": r"https://www.doogal.co.uk/UKPostcodesCSV/?country=England&uprn=false",
        "Scotland": r"https://www.doogal.co.uk/UKPostcodesCSV/?country=Scotland&uprn=false",
        "Wales": r"https://www.doogal.co.uk/UKPostcodesCSV/?country=Wales&uprn=false"
    }
    # the UK is made up of 4 separate countries. As such, we will individually collect/read each CSV
    # which is one per country, and append to a dataframe

    data_NI = pd.read_csv(countries['NI'], usecols=colsToRead)
    data_Wales = pd.read_csv(countries['Wales'], usecols=colsToRead)
    data_Scotland = pd.read_csv(countries['Scotland'], usecols=colsToRead)

    # will take the longest as is largest
    eng_dfs = [] 
    for chunk in pd.read_csv(countries['England'], usecols=colsToRead, chunksize=500):
        eng_dfs.append(chunk)

    data_England = pd.concat(eng_dfs, ignore_index=True) # combine all England chunks to one DF

    # once all countries have been done union dataframes into one
    all_dfs = [data_NI, data_Wales, data_Scotland, data_England] 
    postcodeData = pd.concat(all_dfs, ignore_index=True) 

    return postcodeData 


if __name__ == "__main__":
    # run data sourcing 
    postcode_data = source_uk_postcodes() 
    # Set the column width to display the whole DataFrame
    pd.set_option('display.max_colwidth', None)
    print(postcode_data.head(5))
