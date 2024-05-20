# use of the faker package to generate fake customer data

# Imports
import pandas as pd
from faker import Faker 
import datetime
from faker.providers import DynamicProvider, BaseProvider


def get_customers(seed: int) -> pd.DataFrame:
    """Runs a mock dataset build by using the Faker APi.

    Args:
        seed (int): Specifyng the same seed value, ensures same data is generated each time.

    Returns:
        pd.DataFrame: Dataframe of mock customer data 
    """
    # create the base Faker & seed it so as to remain constant 
    fake = Faker(locale='en_GB') # set to GB locale for fake data creation (i.e Postcodes etc)
    Faker.seed(seed) # seed with a random unique number 

    ## create own providers beyond what exists as standard 
    # example, create a "professions" list and randomly assign to customers 
    professions_provider = DynamicProvider(
        provider_name="profession", # this is the name of the `method` to generate the fake data 
        elements=[
            "Engineer","Graphic Designer","Architect","Civil engineer","Software Developer"
            ,"Laboratory Technician","Mechanical engineer","Scientist","Veterinarian","Artist"
            ,"Bricklayer","Producers and Directors","Plasterer","Nurse","Roofer","Musician","Social Worker"
            ,"Physiotherapist","Health professional","Teacher","Radiographer","Paramedic","Physician","Welder"
            ,"Archaeologist","Association football manager","Technician","Electrician","Engineering technician"
            ,"Accountant","Painter and decorator","Librarian","Private investigator","Pharmacy Technician"
            ,"Technology specialist","Quantity surveyor","Air traffic controller","Financial Manager"
            ,"Official","Chef","Plumber","Aviator","Broker","Police officer","Designer","Optician"
            ,"Adviser","Trader","Consultant","Chartered Surveyor","Pipefitter"
        ]
    )
    fake.add_provider(professions_provider) # then add new provider to faker instance

    # start and end dates for birthdays 
    bday_start = datetime.date(year=1950, month=1, day=1)
    bday_end = datetime.date(year=2005, month=1, day=1)

    # start and end dates for customer joined
    joined_start = datetime.date(year=1990, month=1, day=1)
    joined_end = datetime.date(year=2023, month=12, day=31)

    custList = [] 
    for i in range(10000, 150000): # creates a range to loop through & builds Customer IDs
        newDict = {}
        newDict['customerID'] = i
        newDict['firstName'] = fake.first_name()
        newDict['lastName'] = fake.last_name() 
        newDict['rewardsMember'] = fake.boolean() 
        newDict['emailAddress'] = fake.email()
        newDict['postcode'] = fake.postcode()
        newDict['profession'] = fake.profession()
        newDict['dob'] = fake.date_between(start_date=bday_start, end_date=bday_end)
        newDict['customerJoined'] = fake.date_time_between(start_date=joined_start, end_date=joined_end)
        # append dict to custList 
        custList.append(newDict) 
    #print(f"volume of records generated: {len(custList)}") 
    custData = pd.DataFrame.from_dict(custList) 
    #custData.head(3)
    return custData


if __name__ == "__main__":
    custData = get_customers(seed=12345) 
    pd.set_option('display.max_colwidth', None)
    print(custData.head())
    #outPath = r"./customerMasterExtract.csv"
    #custData.to_csv(outPath, sep='\t', encoding='utf-8', index=False)
