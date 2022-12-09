sudo yum update
sudo yum install -y java-1.8.0-openjdk-devel
wget https://dlcdn.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
sudo tar xf ./apache-maven-*.tar.gz -C /opt
sudo ln -s /opt/apache-maven-3.6.3 /opt/maven
echo 'export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.342.b07-1.amzn2.0.1.x86_64' >> maven.sh
echo 'export M2_HOME=/opt/maven' >> maven.sh
echo 'export MAVEN_HOME=/opt/maven' >> maven.sh
echo 'export PATH=${M2_HOME}/bin:${PATH}' >> maven.sh
sudo mv maven.sh /etc/profile.d/
rm apache-maven-3.6.3-bin.tar.gz
sudo chmod +x /etc/profile.d/maven.sh
source /etc/profile.d/maven.sh
sudo yum install -y git-all
git clone https://github.com/Roberto-Gentili/burningwave-site.git
cd burningwave-site
mvn clean dependency:list install
screen -d -m sudo java \
-Dspring.profiles.active=burningwave,ssl \
-jar ./target/site-1.0.0.jar \
-cp=./ \
--APPLICATION_AUTHORIZATION_TOKEN=yourToken \
--GITHUB_CONNECTOR_AUTHORIZATION_TOKEN=yourToken \
--IO_GITHUB_TOOL_FACTORY_NEXUS_AUTHORIZATION_TOKEN=yourToken \
--ORG_BURNINGWAVE_NEXUS_AUTHORIZATION_TOKEN=yourToken \
--SCHEDULED_OPERATIONS_PING_CRON=- \
--SERVER_SSL_KEY_STORE=config/keystore.p12
--SERVER_SSL_KEY_PASSWORD=changeit

#For certificate:
wget -O epel.rpm –nv https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y ./epel.rpm
sudo yum install -y python2-certbot
sudo certbot-2 certonly --manual
sudo chmod 755 /etc/letsencrypt/archive
sudo chmod 755 /etc/letsencrypt/archive/www.burningwave.org/*
sudo chmod 755 /etc/letsencrypt/live
rm ./config/keystore.p12
sudo openssl pkcs12 -export -in /etc/letsencrypt/live/www.burningwave.org/fullchain.pem -inkey /etc/letsencrypt/live/www.burningwave.org/privkey.pem \
-out /home/ec2-user/burningwave-site/config/keystore.p12 -name burningwave.site -CAfile chain.pem -caname root