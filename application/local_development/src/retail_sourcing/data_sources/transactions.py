# use of the faker package to generate fake customer transaction data
# imports
import pandas as pd
from faker import Faker 
import datetime
from faker.providers import DynamicProvider, BaseProvider
import random


def get_transactions(start, end) -> pd.DataFrame:
    """generates some fake transaction data from the Faker API

    Args:
        start: datetime to start transactions build from
        end: datetime to end transactions build at

    Returns:
        pd.DataFrame: dataframe containing fake transaction data
    """
    # create the base Faker & seed it so as to remain constant 
    fake = Faker(locale='en_GB') # set to GB locale for fake data creation (i.e Postcodes etc)
    # start and end dates for transaction timestamps
    TS_start = start #datetime.date(year=year, month=month, day=startDay)
    TS_end = end #datetime.date(year=year, month=month, day=endDay)

    productPrices = {
        "Laptop": 399.99, 
        "Desktop": 599.99, 
        "Monitor": 120, 
        "Keyboard": 35, 
        "Mouse": 8,
        "Docking Station": 70, 
        "HDMI Cable": 14.98,
        "Office Chair Premium": 250, 
        "Office Chair Standard": 160, 
        "Desk": 400, 
        "Laptop Bag": 55, 
        "Laptop Stand": 12.99,
        "Extension Cable": 4.99, 
        "USB Flash Drive 16gb": 3.99, 
        "Tablet": 115, 
        "Printer": 70,
        "Projector": 300, 
        "WiFi Range Extender": 30
    }

    # create a dynamic provider for products 
    product_provider = DynamicProvider(
        provider_name="product", # this is the name of the `method` to generate the fake data 
        elements=[
            "Laptop", "Desktop", "Monitor", "Keyboard", "Mouse",
            "Docking Station", "HDMI Cable", "Office Chair Premium", 
            "Office Chair Standard", "Desk", "Laptop Bag", "Laptop Stand",
            "Extension Cable", "USB Flash Drive 16gb", "Tablet", "Printer",
            "Projector", "WiFi Range Extender"
        ]
    )

    fake.add_provider(product_provider) # then add new provider to faker instance

    # create a provider that will create the customer id
    # we do this so that a customer id can have multiple transactions on a given day etc.
    class customerIdGen(BaseProvider):
        def custId(self) -> int:
            """Simple function to return a random integer between a range

            Returns:
                int: random integer that acts as CustomerId 
            """
            return random.randrange(start=10000, stop=150000)
        

    # create a provider that will generate a volume of purhcase in transaction
    class txnGen(BaseProvider):
        def txnVol(self) -> int:
            """Simple function to return a random integer for transaction volume

            Returns:
                int: transaction volume of products
            """
            return random.randrange(start=1, stop=7)


    # add the providers to the faker instance 
    fake.add_provider(customerIdGen) 
    fake.add_provider(txnGen)

    # create seed
    seed = TS_start.strftime("%Y%m%d") # formats YYYYMMDD 
    seedVal = int(seed)
    Faker.seed(seedVal) # seed with a random unique number (aka the YYYYMMDD format of intended date)

    # build transactions 
    txnList = [] 
    for i in range(0, 200000): # creates a range to loop through & builds transactions
        newDict = {}
        newDict['customerID'] = fake.custId()
        newDict['transaction_TS'] = fake.date_time_between(start_date=TS_start, end_date=TS_end)
        newDict['item'] = fake.product() 
        newDict['volume'] = fake.txnVol() 
        # append dict to custList 
        txnList.append(newDict) 

    #print(f"volume of records generated: {len(txnList)}") 

    txnData = pd.DataFrame.from_dict(txnList).rename(columns={'item':'Product'})
    txnData['volume'] = txnData['volume'].astype(float)
    #txnData.dtypes

    # use the product price dict and join to pandas df 
    prodPrices = pd.DataFrame(productPrices.items(), columns=['Product', 'Price'])
    #prodPrices.dtypes

    # merge 
    txnDataOut = txnData.merge(prodPrices, how='left',on='Product')
    #txnDataOut.dtypes

    # calculate transaction value 
    def txnAmount(row):
        return row['volume'] * row['Price']


    # calculate txn value buy applying above function to each row in Pandas DF 
    txnDataOut['txn_amount'] = txnDataOut.apply(lambda row: txnAmount(row), axis=1)
    # return fake data as dataframe 
    return txnDataOut 


# run when main
if __name__ == "__main__":
    # execute transaction build
    txnDataOut = get_transactions(
        start=datetime.date(year=2023, month=10, day=15),
        end=datetime.date(year=2023, month=10, day=16)
    )
    # write data out
    outPath = f"./dummy_txns.csv"
    txnDataOut.to_csv(outPath, sep='\t', encoding='utf-8', index=False)
