# Dockerfiles - Build Informix Image 
    

## Instructions To Build Image

1 - Put Informix product in ```informix-db``` directory and name it informix.tar
```
cd informix-db
cp <informix product> informix.tar 
```

2 - Run the Build phase
```
. ./build
```

* This will build a ```debian-os``` image as a base os image.
* It will then use the debian-os image and build an ```ifx-prune``` image.  The ifx-prune image is used to prune the Informix installation directory if wanted.
* It will then use the ifx-prune image and build the final Informix image ```informix-db```

3 - (Optional)  Prune Informix Directory

``` 
(Section of Dockerfile.prune)

RUN cc /opt/hcl/dinit.c -o /opt/hcl/dinit
RUN /bin/bash /opt/hcl/informix_install.sh
#RUN /bin/bash /opt/hcl/informix_prune.sh
RUN /bin/tar -C /opt/hcl -cvf /tmp/informix.prune.tar informix
```
* The Dockerfile.prune will execute the informix_prune.sh script if specified to do so.  It is currently commented out.
* To Execute this script during the build phase, remove the # comment and adjust the informix_prune.sh file, removing the desired files from the installation directory. 


## Instructions To Run/Start Image

1 - Starting the Informix Docker Image for the First time.

```
     docker run --name ifx -p 9088:9088 -p 9089:9089 -p 27017:27017 \
         -p 27018:27018 -p 27883:27883  informix-db
```

*  ```-p```,  expose port ```9088``` to allow remote connections from TCP clients
*  ```-p```,  expose port ```9089``` to allow remote connections from DRDA clients
*  ```-p```,  expose port ```27017``` to allow remote connections from mongo clients
*  ```-p```,  expose port ```27018``` to allow remote connections from REST clients
*  ```-p```,  expose port ```27883``` to allow remote connections from MQTT clients

* The default password for user ```informix``` is ```in4mix```, for ```root``` access informix has sudo privileges.


* The ```docker run``` command will perform a disk initialization for the Informix Database Server.  

* After disk initialization of the Informix server you should start and stop the server with ```docker start/stop```


2 - Start the Informix Docker container

The docker start command will start the container and bring the database online.  It will not perform a disk initialization.  This command is used to start the container after a disk initialization has already occured, and the container is currently not running.

```
docker start ifx 
```


3 - Stop the Informix Docker container

The docker stop command  will stop the container and take the database offline.


```
docker stop ifx 
```

4 - To attach to the Informix Docker container (shell)

```
docker exec -it ifx bash
```

5 - Storage Options: 

The docker image supports anonymous volumes, named volumes or bind mounts.  

*  Default behavior is anonymous volume.  When you issue the docker run command it will create an anonymous volume which can be seen in a ```docker volume ls``` command. No -v option is used on the docker run command.
* Named volumes can be used, use the -v option and follow these instructions:
```
Create a named  volume:
   docker volume create ifx-vol

Use The named volume:
     docker run --name ifx -v ifx-vol:/opt/hcl/data \
          -p 9088:9088 -p 9089:9089 -p 27017:27017  \
          -p 27018:27018 -p 27883:27883  informix-db
```

* ```-v ifx-vol:/opt/hcl/data``` This option mounts a named volume __(ifx-vol)__ to a pre-defined internal volume __(/opt/hcl/data)__   For more information on the named volume see the ```docker volume``` command. 

* Bind mounts can be used, use the -v option and follow these instructions:
```
Create a mount point on the host system:
   Example:  mkdir /home/datavol 

Use The Bind mount:
     docker run --name ifx -v /home/datavol:/opt/hcl/data \
          -p 9088:9088 -p 9089:9089 -p 27017:27017        \
          -p 27018:27018 -p 27883:27883  informix-db
```

* ```-v /home/datavol:/opt/hcl/data``` This option mounts a bind mount (external mount point) __(/home/datavol)__ to a pre-defined internal volume __(/opt/hcl/data)__   

 
6 - Custom ```$ONCONFIG``` file:
* To use a custom $ONCONFIG file use the Bind mount option and place the file you want to use at ```/home/datavol/onconfig```.  Assuming ```/home/datavol``` is your mount point.
* The docker run command will create all spaces/logs, etc in ```/home/datavol```.  The onconfig file and the sqlhosts file will be in ```/home/datavol/links``` and can be modified here.

7 - Data persistence:

Data is stored in volume storage so it will persist but it is recommended you use Named volumes or Bind mounts.  If you use anonymous volumes the data location is not known.  But if you use named volumes or bind mounts the data volume location is ___well known___.




## License

The Dockerfile and associated scripts are licensed under the [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0). 


