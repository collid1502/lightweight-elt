# ETL & ELT Application

This application will replicate using pulling data from a few API sources, by making use of the Python library `faker`. This library let's us generate fake data easily, and customise where we need to.

My notes here won't explore the use of the API, as it is fairly well documented, but comments inside of the code should help where needed.

The proposed steps of this application are as follows:

* Python scripts to generate fake data & collect open-source data like UK ONS postcodes information
* Python (with Pandas & DuckDB) to perform the initial transformation of RAW data, with some basic DQ checks (cuallee)
* Python (snowpark) to push the transformed RAW data, into a staging layer within Snowflake
* DBT will then execute the data modelling, on the staged data, into the presentation & analytics layers, as well as run DQ checks on that data

All the above will be designed using Docker, so that the application can be shipped to AWS, to be run on AWS Fargate, which supports serverless architecture for containers.

## The Process

### 1. Installing Docker on your development machine

Use the below code to install Docker on the AWS Linux machine you have:

```
# Install Docker to build images, run containers etc. 
sudo yum install -y docker

# start docker & enable it at boot 
sudo systemctl start docker 
sudo systemctl enable docker 

# check docker status 
sudo service docker status # followed by ctrl+c to exit

# verify installation is working fine 
sudo docker run hello-world 

# enable the ec2-user to use docker without sudo 
sudo usermod -aG docker ec2-user 

# apply group changes immediately 
newgrp docker 

# or, stop docker by 
sudo systemctl stop docker

# then restart it 
sudo systemctl start docker 

# and try a command without sudo 
systemctl status docker 
docker run hello-world # should be all working as expected!!!
```

### 2. Building the application with Docker

holder ...