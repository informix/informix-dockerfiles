# informix-client-sandbox
A collection of sample projects for various Informix client SDK's for use in a developement sandbox.

You can use these example projects as starters or helpers for developing your own applications against the Informix database.

## Updating the sandbox

You can update the demos to their latest version at any time by running the following command in this directory

`> git reset --hard`

`> git pull`

## Using the sandbox

Most demo applications are designed to pull connection information from the file `/sandbox/client-sandbox/connections.json`. You must updated this file to point to the correct Informix server running and a database which want samples to execute against.  You can use a managed cloud service or the Informix Developer Edition docker image for a local Informix server to run against.

## Building the docker image

`> docker build -t hclcom/informix-client-sandbox .`

## Building the docker container

`> docker create -t -i informix-client-sandbox`

## Running the docker container

`> docker start -i <container id>`