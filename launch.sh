#!/bin/bash

# Remove older server file compression if it exists
if [ -f "server_files.tar.gz" ]
then
    rm server_files.tar.gz
fi

# Compress server files
tar czf server_files.tar.gz resources/

# run terraform
<<<<<<< HEAD
terraform apply -auto-approve -var random_s3_name=$RANDOM
=======
terraform apply -auto-approve
>>>>>>> 54197b61c31c317fa02c3d0f89052106d4e82ae3
