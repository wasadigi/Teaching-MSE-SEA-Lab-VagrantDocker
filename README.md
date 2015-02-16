# Teaching-MSE-SEA-Lab-VagrantDocker
A repo for the introductory lab to Vagrant and Docker

## How to use this repo

### 1. Create and start the VM

 After cloning this repo, type the following command from the root directory: 
 
 `vagrant up`
 
This will start a process that will quite a bit of time, since it involves the download of an ubuntu image from the network.
 
What happens when you type the command is defined by the content of the `Vagrantfile` file. If you are familiar with VirtualBox and its GUI client, you can think of this file as a way to automate the configuration of a VM box. For instance, you can configure network properties.

If you take a look at the content of `Vagrantfile` in this repo, you will see the following section:

```
  config.vm.provision "shell", path: "provision.sh", privileged: false
```

**Provisioning** refers to the process of installing software on top of the VM operating system. Vagrant supports different provisioning mechanisms and we are using a very simple one here. We provide a shell script (`provision.sh`) that will be executed *within* the VM after it is booted the first time.

One thing that you have to be aware of is that by default, the content of the directory that contains `Vagrantfile` (on the host computer) will be mounted at `/vagrant` in the VM. In other words, what you see in `provision.sh` on your computer will also be visible at `/vagrant/provision.sh` in the VM.

### 2. Understand what happens when provision.sh is executed

If you look at the script, you will see that many lines are commented out. The full script includes steps to download and install Java 8, the Java EE Glassfish application server, apache maven and Node.js. Fetching and installing all of these components takes a lot of time and we don't need them immediately, which is why we have disabled them. However, it will be useful for you to know how to install the components later on.

One thing that we do in the script is to install Docker. This is based on instructions provided in the Docker documentation and is done by the following instructions:

```
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
sudo sh -c "echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list"
sudo apt-get update
sudo apt-get install -y lxc-docker
```

### 3. Login into the VM

From a terminal on your host, type the following command: `vagrant ssh`. When doing this, you will log into the VM. What happens here is that the VM is run by VirtualBox, but without any GUI (there is an option to start the GUI if you need, but that is usually not the way people use Vagrant).

When you are connected, you can see that you are in Ubuntu environment (because in our Vagrantfile, we have used a ubuntu "box" as a starting point). You can also check that Docker has been installed by typing the following command: `sudo docker -v` and see the following output:

```
vagrant@ubuntu-14:~$ sudo docker -v
Docker version 1.5.0, build a8a31ef
```

As we previously indicated, you can have a look at the content of the `/vagrant` directory. You should see:

```
vagrant@ubuntu-14:~$ cd /vagrant/
vagrant@ubuntu-14:/vagrant$ ls
docker  LICENSE  provision.sh  README.md  Vagrantfile
```

Which is the content of the directory on your host computer. The `docker` folder contains a sample configuration to validate the Docker installation.


### 4. Create a Docker image and run a Docker container

Type the following command:

```
cd /vagrant/docker/nodejs
sudo docker build -t my-node-service .
```

Now, you will have to wait for quite some time again, because Docker is downloading a linux image again. 

Docker has 2 important notions: **images** and **containers**. To take an object-oriented analogy, you can think of them as **classes** and **instances**. Docker is a virtualization technology, which allows you to run lightweight VMs (containers) on top of a linux OS. In our setup, we have a heavyweight VM run by Vagrant, and within this VM we will have a number of lightweight VMs run by Docker.

A Docker **image** is the **snapshot** of a lightweight VM. Using an image as a reference, you can then **run one or more containers**. With the previous command, we have asked Docker to build a new image. Notice the `.` at the end of command. This means that we work in the current Directory. Docker then uses the content of the `Dockerfile` file to know how it should build the image. An image is always created from a base image, on top of which additional software can be installed and configured by running comands. 

The Dockerfile used in the previous command fetches a Node.js distribution and copy some files from the Vagrant box into the Docker image file system (into `/opt/services`). The Dockerfile also specifies which command should be executed when a new container is started, with the following line:

```
CMD [ "node", "/opt/services/s1.js" ]
```

In other words, every time we run a container based on our new image, the s1.js script will be executed by Node.js. What is surprising at first when using Docker is that as soon as this command returns, the container stops. Don't be surprised if you do a `sudo docker ps` and don't see any running container. If you do a `sudo docker ps -a`, you will see a trace of containers that have been run but are no longer running.

Once your image is created, you can check that it is available with the following command:

```
vagrant@ubuntu-14:/vagrant/docker/nodejs$ sudo docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
my-node-service     latest              5ae9b400f2a5        12 minutes ago      705.2 MB
buildpack-deps      jessie              787349ce806c        2 weeks ago         673.9 MB
```

And then, you can run a container from the image with the following commands:

```
vagrant@ubuntu-14:/vagrant/docker/nodejs$ sudo docker run --name mycontainer my-node-service
Starting service 1
Shutting down service 1

vagrant@ubuntu-14:/vagrant/docker/nodejs$ sudo docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

vagrant@ubuntu-14:/vagrant/docker/nodejs$ sudo docker ps -a
CONTAINER ID        IMAGE                    COMMAND                CREATED             STATUS                      PORTS               NAMES
886a0772e1cc        my-node-service:latest   "node /opt/services/   16 seconds ago      Exited (0) 15 seconds ago                       mycontainer         
```

The first command starts the container. What you see on the output console is the output generated by the Node.js script. 

The second command lists the running containers. There is none, because as previously indicated, as soon as the command returns, the container stops.

The third command lists all containers, including those that have stopped.
