# Infrastructure

This example project will be making use of some AWS services, and Snowflake backed on AWS as the data warehouse.<br>
In order to keep on top of infrastructure required for the project, Terraform will be used, as it can work with both AWS and Snowflake.

So, let's move into some steps for setting up Terraform!

*Note, This project is being built via ssh to my cloud9 instance on AWS running AWS Linux as its OS*

-------

## Setup

### 1. Ensure Terraform is installed on your development machine

You can start by using the CLI to download the a version of Terraform
```
# change to a temp directory 
cd ~/temp 

# collect the download 
wget https://releases.hashicorp.com/terraform/1.2.7/terraform_1.2.7_linux_amd64.zip
```

With the downloaded zip file on your machine, unzip it
```
unzip terraform_1.2.7_linux_amd64.zip
```
This will unzip it within your ~/temp folder if that's where you are currently in.

use `ls` to check what exists within the folder.<br>
You should now see the zipped folder, and `terraform`.

Next, you will need to move Terraform binary to a directory in your **PATH**. This allows you to use Terraform from any location on your instance, aka, your project folder. The common choice for adding to your path is to move a binary into `/usr/local/bin`. Note, use SUDO priveleges for this execution.
```
sudo mv terraform /usr/local/bin/
```

With that done, change to your home directory, and verify the installation has worked, vy running the terraform command with its version option
```
cd ~

terraform -version
```
If all has worked well, you should see the version you installed echoed back to your terminal. In this example, v1.2.7


### 2. Terraform for Snowflake

Firstly, this project obviously assumes you have a snowflake account handy, and the relevant admin rights to perform infra provisioning as required. If looking to set up your own snowflake account, it's pretty easy. This project doesn't cover that, but you'll be able to get up and running online within 10 minutes after visiting their site. Also, at the time of writing, snowflake were offering **FREE** credits for up to 30 days after sign up (or c.$400) whichever hits first.

Check out the `snowflake_create_role_example.sql` file for an example of setting up another user (a service account) and a role which can create and manage infrastructure via Terraform or the Snowflake Console. You ideally don't want to use AccountAdmin details, so you can avoid these ever being accidentally leaked.

Anyways, back to the root of this project:

```
cd ~/work/lightweight-elt
```

create a new folder called infrastructure

```
mkdir infrastructure
cd infrastructure
```

then follow this by creating two sub folders aws & snowflake

```
mkdir aws
mkdir snowflake
```

Ok, in order for Terraform to work with snowflake, there will be key information, such as credentials, which terraform will require in order to make the connection and build the resources.

A great way to handle secret information that should not be stored in code is through environment variables. If you create an environment variable on your machine, and prefix it with **TF_VAR_** then terraform can pick these up really easily. For example:

**TF_VAR_password** can be read by terraform using `var.password` in scripts etc.

I'm not going to cover *how* to set environment variables here, I'll simply be listing which ones have been set:

* Snowflake Account Identifier
* Snowflake User
* Snowflake User Password
* Role
* Region
* optionally: Warehouse & Database

Of the above, I'll be storing the Account Identifer, User & Password as environment variables on my machine.

Create a new, empty, terraform file in the snowflake subfolder. Here, we will write our terraform code to build some resources on Snowflake for this project.

```
# ensure you are in the snowflake sub-folder
cd snowflake

# once there, create a new terraform file
touch snowflake_infra_setup.tf
```

