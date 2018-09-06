 #!/bin/bash

sudo apt-get update

# Unpack Resources
sudo tar xvf /srv/www/server-files.tar.gz -C /srv/www/

# Install packages
sudo apt-get -y install apache2 libapache2-mod-wsgi mysql-client python python-pip libxml2-dev libxslt-dev python-dev libxslt1-dev zlib1g-dev

# Linkage for datasploit on Ubuntu
sudo ldconfig -v

# Pip requirments
pip install flask flask-mysql flask-wtf pip flask-bootstrap datasploit

# Symbolic Link for WSGI App
sudo ln -sT /srv/www/resources /var/www/html/resources

# Enable the WSGI configuration
sudo a2enmod wsgi

# Apache Setup
sudo echo "WSGIDaemonProcess resources threads=5
WSGIScriptAlias / /var/www/html/resources/app.wsgi

<Directory resources>
	WSGIProcessGroup resources
	WSGIApplicationGroup %{GLOBAL}
	Order deny,allow
	Allow from all
</Directory>" > /etc/apache2/sites-enabled/000-default.conf

# Restart Apache
sudo apachectl restart

# Sleep 5 min just incase DB takes longer to create
sleep 300

### Set up DB

# Set DB password
export DB="324neWWEkdn31ejkjrr"

# Create DB table
mysql -h database -u serverAdmin -p$DB -e "CREATE TABLE p2db.records (record_id BIGINT AUTO_INCREMENT,record_type VARCHAR(255) NULL,record_result VARCHAR(255) NULL,record_tag VARCHAR(255) NULL,PRIMARY KEY (record_id));"

# Create procedure
mysql -h database -u serverAdmin -p$DB -e "USE p2db;
DELIMITER //

CREATE PROCEDURE createRecord(IN r_type VARCHAR(255), IN r_result VARCHAR(255), IN r_tag VARCHAR(255))

BEGIN
    IF ( SELECT exists (SELECT 1 FROM records WHERE record_tag = r_tag)) THEN SELECT 'Record Exists';
    ELSE INSERT into records(record_type,record_result,record_tag) values(r_type,r_result,r_tag);
    END IF;
END//"

# Create user for servers with limited access
mysql -h database -u serverAdmin -p$DB -e "CREATE USER 'server'@'%' IDENTIFIED BY 'server_password';"
mysql -h database -u serverAdmin -p$DB -e "GRANT SELECT,INSERT,UPDATE ON p2db.records TO 'server'@'%'"
mysql -h database -u serverAdmin -p$DB -e "GRANT EXECUTE ON p2db.* TO 'server'@'%';"

# Unset DB password
unset DB

# Purge bootstrap file
sudo rm /tmp/bootstrap.sh

