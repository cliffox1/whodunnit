# whodunnit
Using dbt to perform analytics on whodunnit data

## Requirements
* dbt-core, dbt-postgres, pgadmin
* Docker Compose

## Start the database container
```bash
docker compose up postgres pgadmin
```
This will create a postgres and pgadmin container from the image defined in the docker-compose.yaml file.

## Create a virtual environment (Windows)
```bash
pip install virtualenv
```
This will install the virtual environment package.
Now while in the project directory use the following command:
```bash
virtualenv env
```
All that is left is activating the environment.
```bash
\env\Scripts\activate.bat
```

## Create a virtual environment (Linux and MacOS)
Open terminal and install the package.
```bash
pip3 install virtualenv
```
To create the environment go to the project directory and type:
```bash
virtualenv venv
```
And to activate it use this command.
```bash
source venv/bin/activate
```

## Install dependencies
```bash
pip install -r requirements.txt
```
Make sure you are using a virtual environment for this. 

Now move inside the demo folder.
```bash
cd demo
```


## Install dbt packages 
Packages stated at the <b>packages.yml</b> file must be installed in order to use predefined functions, which in dbt are called <i>macros</i>.
Once they are installed, you are then able to call them via {{_}} Jinja tags. These type of functions can be called inside sql queries or independently. 

E.g.: {{ macro_name(<optional_parameters>)}}

Refer to https://hub.getdbt.com/ to check out packages and their usage.
```bash
dbt deps
```
