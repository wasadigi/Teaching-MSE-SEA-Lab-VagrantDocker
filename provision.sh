 #!/bin/bash

# Add a repo to grap Oracle JDK 8
#sudo apt-get install software-properties-common -y
#sudo add-apt-repository ppa:webupd8team/java -y

# Update the package index
echo "************************  apt-get update  ************************"
sudo apt-get update

# Install util packages
echo "************************  apt-get install git -y  ************************"
sudo apt-get install git -y

# Install Docker
echo "************************  apt-get install git -y  ************************"
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
sudo sh -c "echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list"
sudo apt-get update
sudo apt-get install -y lxc-docker

# Install node.js (also remove the "Amateur Packet Radio Node Program" conflicting package)
#echo "************************  apt-get install nodejs -y  ************************"
#sudo apt-get --purge remove node  -y
#sudo apt-get install nodejs -y
#sudo ln -s /usr/bin/nodejs /usr/bin/node
#sudo apt-get install npm -y

# Install JDK 8
#echo "************************  install oracle jdk 8  ************************"
#echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
#sudo apt-get install oracle-java8-set-default -y

# Install glassfish
#echo "************************  install glassfish  ************************"
#sudo apt-get install -y wget unzip pwgen expect
#sudo wget http://download.java.net/glassfish/4.1/release/glassfish-4.1.zip
#sudo unzip glassfish-4.1.zip -d /opt
#sudo rm glassfish-4.1.zip

#sudo mv /opt/glassfish4 /opt/glassfish4.1
#sudo addgroup --system glassfish
#sudo adduser --system --shell /bin/bash --ingroup glassfish glassfish
#sudo chown -R glassfish:glassfish /opt/glassfish4.1

#sudo su glassfish <<RUN_AS_GLASSFISH_BLOC
#cd /opt/glassfish4.1/glassfish/bin
#./asadmin start-domain domain1
#echo "AS_ADMIN_PASSWORD=" > /tmp/password.txt
#echo "AS_ADMIN_NEWPASSWORD=adminadmin" >> /tmp/password.txt
#./asadmin --user admin --passwordfile /tmp/password.txt change-admin-password
#echo "AS_ADMIN_PASSWORD=adminadmin" > /tmp/password.txt
#./asadmin --user admin --passwordfile /tmp/password.txt enable-secure-admin
#./asadmin stop-domain domain1
#./asadmin start-domain domain1
#RUN_AS_GLASSFISH_BLOC

# Install maven
#echo "************************  install maven  ************************"
#sudo apt-get install maven -y

