#!/bin/bash  

# specify the paths to the relevant dockerfiles
# we can now build some custom docker images to use 

# "-t" option tags the resulting image with a name
# "-f" option specifies the path to the relevant dockerfile
# --no-cache ensures a clean, new build at run time
# "." at the end represents the build context, which is the current directory

## format:  docker build -t >image_name>:<tag> -f <path/to/dockerfile> . 
docker build \
    --build-arg snowflake_account=$snowflake_account \
    --build-arg etl_serv_password=$etl_serv_password \
    -t retail_etl_app:v2 -f ./dockerfile .