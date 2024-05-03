# Developing Locally

We are going to develop the code base locally first, using a conda virtual environment to be created on my machine, which happens to be running AWS Linux. Once the scripts are developed, I will then begin to "dockerise" the process, by building a relevant dockerfile.

To follow this local development, you will need conda installed on your machine.

Guidance below:

```
# Let's install miniconda so that we can create virtual python environments from this EC2 machine
# download installer file (not this will download it to your current folder location)
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

# create temp folder, copy the installer there
cd ~
mkdir temp
chmod +x temp # grant execution rights

# copy it to temp and then execute 
cp ~/work/retailCustomer_DE_Project/Miniconda3-latest-Linux-x86_64.sh ~/temp/
cd ~/temp
ls # you should now see the Miniconda execution installer there 
chmod +x ./Miniconda3-latest-Linux-x86_64.sh

# execute 
./Miniconda3-latest-Linux-x86_64.sh # click enter where needed in terminal & yes to confirm installation & location etc.

# run source ~/.bashrc for changes to take effect 
# you should now see that the (base) conda environment is activated automatically 

# remove the conda installer file 
rm ~/work/retailCustomer_DE_Project/Miniconda3-latest-Linux-x86_64.sh
rm ~/temp/Miniconda3-latest-Linux-x86_64.sh

# you can also check for the version installed correctly with
conda -- version
```

With that in place, run the `build_dev_env.sh` script which replaces any current conda environment of the target name, and builds a fresh environment for you to start developing with locally.