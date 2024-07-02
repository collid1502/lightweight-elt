#!/bin/bash

# ensure being in the correct working dir
cd "/home/ec2-user/work/lightweight-elt/application/local_development/src/retail_sourcing"

# use the conda executable from the correct environment to run the relevant Python code 
~/miniconda3/envs/retail_etl_dev/bin/python app.py 

# end 