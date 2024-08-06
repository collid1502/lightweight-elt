# AWS infrastructure

Here, we will be creating some resources on AWS to execute our Docker image through a serverless service like Fargate

### Configure your AWS CLI access from your machine

You first need to ensure you have AWS CLI installed.<br>
You can check this with:

```
aws --version
```

if not already installed, follow documentation online to download & install for your relevant OS.

Assuming you now have it installed, configure it on your machine:

```
aws configure
```

which will prompt you for credentials, default region etc.

Also, create some environment variables with the TF_VAR prefix, which will let terraform pick them up!<br>
You can do this by modifying the .bashrc file or using the `export` command

