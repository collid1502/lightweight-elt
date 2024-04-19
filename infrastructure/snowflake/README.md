# Snowflake

In this example project, we will be using Terraform to manage Snowflake infrastructure, however, below is some guidance on setting up SnowSQL CLI client, so that you can interact with your snowflake resources from your machine, without logging into the console.

### Setup

Assuming you already have a snowflake account, and login credentials, let's get started!

check that you have at least Python 3.8 installed on your machine. If not, install it.

```
python --version
```

I have 3.11.7 installed on my dev machine

Next, use PIP to install the Snowflake SQL CLI package

```
pip install snowflake-cli-labs

# verify it's installation with a quick test 
snow --help
``` 

If that test command returns guidance, then you have successfully installed it to your machine!

With the package installed, you should now create a configuration file on your system that snowflake can look to, in order to establish a connection

Navigate to your home folder `~`. Create a new directory called `.snowflake`. Inside of that directory, create a new file called `config.toml`. This is where the credentials for connection will be stored.

```
cd ~
mkdir .snowflake

cd .snowflake
touch config.toml 
ls -a
```

And you should see your empty, `config.toml` file there.

You can use a text editor for linux, like **vi** ot **nano** to edit this file.

```
nano config.toml
```

Inside this file, you will want to have the following:

```
default_connection_name = "infra_service"

[connections.infra_service]
account = "your_account_identifier"
user = "sf_infra_srv_user"
password = "the_password"
warehouse = "compute_wh"
database = "SNOWFLAKE"
schema = "INFORMATION_SCHEMA"
```

This will specify a connection profile (you can have multiple in this config file) and it will specify the default connection the CLI package should use when you don't specify an individual profile as a command line argument at connection.

You can then use ***ctrl+o*** to save the file, and ***ctrl+x*** to exit back to the command line.

You will also need to edit permissions on this file, so that the fille is not fully exposed to anyone. Use:

```
chmod 0600 config.toml
```

With this done, let's run a quick connection test!

In your terminal, execute:

```
snow connection test --connection="infra_service"
```
You should get a message back to the terminal with details indicating the connection was successful!

You can also run a quick test of actually connecting via the default profile we set, and running an SQL statement

```
snow sql -q "select 'hello world' as starter;"
```

This will then execute the query (the `-q` option) and return a result with hello world!

You can actually also log into snowflake, and view this query on your warehosue query history

Now, you are all set for any Snowflake command line activity, and know that you have working credentials for a remote connection from your machine!