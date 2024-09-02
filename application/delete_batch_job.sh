#!/bin/bash  

# aws batch describe-job-definitions
aws batch deregister-job-definition \
    --job-definition retail-de-elt:6

# end 