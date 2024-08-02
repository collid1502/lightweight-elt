# -it option runs container and allows interactive terminal if needed  
# --rm automatically removes container when it stops running 
# we tell the container to run, and then using the bin/bash executable, execute the script run_pipeline.sh 
docker run -it --rm retail_etl_app:v5 /bin/bash /app/retail_etl/run_unit_tests.sh 