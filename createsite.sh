#!/bin/bash
#
####                                                            ####
####    Prompt user to enter Site Name                          ####
####                                                            ####
read -p "Site Name: " sitename
####                                                            ####
####    Prompt user to enter Domain Name                        ####
####                                                            ####
read -p "Domain Name: " domain
####                                                            ####
####    Prompt user to enter Password for User1(Hackrobats)     ####
####                                                            ####
while true
do
    read -s -p "User1 Password: " drupalpass
    echo
    read -s -p "User1 Password (again): " drupalpass2
    echo
    [ "$drupalpass" = "$drupalpass2" ] && break
    echo "Please try again"
done
echo "Password Matches"
####                                                            ####
####    Create variables from Domain Name                       ####
####                                                            ####
www=/var/www/drupal7
tld=`echo $domain  |cut -d"." -f2,3`
name=`echo $domain |cut -f1 -d"."`
shortname=`echo $name |cut -c -15`
machine=`echo $shortname |tr '-' '_'`
dbpw=$(pwgen -n 16)
####                                                            ####
####    Notify user of MySQL password requirement               ####
####                                                            ####
echo "MySQL verification required."
####                                                            ####
####    Create database and user                                ####
####                                                            ####
db="CREATE DATABASE IF NOT EXISTS $machine;GRANT ALL PRIVILEGES ON $machine.* TO $machine@localhost IDENTIFIED BY '$dbpw';FLUSH PRIVILEGES;"
mysql -u deploy -p -e "$db"
####                                                            ####
####    Create directories necessary for Drupal installation    ####
####                                                            ####
sudo -u deploy mkdir $www/$domain $www/$domain/sites $www/$domain/sites/default $www/$domain/sites/default/files
chmod a+w $www/$domain/sites/default/files
chgrp -R www-data $www/$domain
cd $www/$domain/sites/default/files
####                                                            ####
####    Create Private directory and setup Backup directories   ####
####                                                            ####
sudo -u deploy mkdir -p $www/$domain/private/backup_migrate/scheduled/hourly $www/$domain/private/backup_migrate/scheduled/daily $www/$domain/private/backup_migrate/scheduled/weekly  $www/$domain/private/backup_migrate/scheduled/monthly
chown -R deploy:www-data $www/$domain/private
####                                                            ####
####    Download favicon.ico                                    ####
####                                                            ####
sudo -u deploy curl -o $www/$domain/sites/default/files/favicon.ico 'http://hackrobats.net/sites/default/files/favicon.ico'
####                                                            ####
####    Create log files and folders, as well as info.php       ####
####                                                            ####
sudo -u deploy mkdir $www/$domain/logs
touch $www/$domain/logs/access.log $www/$domain/logs/error.log
echo "<?php
        phpinfo();
?>" > $www/$domain/info.php
sudo chown deploy:www-data $www/$domain/info.php
####                                                            ####
####    Create virtual host file, enable and restart apache     ####
####                                                            ####
echo "<VirtualHost *:80>
        ServerAdmin maintenance@hackrobats.net
        ServerName www.$domain
        ServerAlias $domain *.$domain 
        ServerAlias $name.510interactive.com $name.hackrobats.net
        ServerAlias $name.5ten.co $name.cascadiacollective.net $name.cascadiaweb.net
        DocumentRoot $www/$domain
        ErrorLog $www/$domain/logs/error.log
        CustomLog $www/$domain/logs/access.log combined
        DirectoryIndex index.php
</VirtualHost>" > /etc/apache2/sites-available/$domain
a2ensite $domain && service apache2 reload
####                                                            ####
####    Create site structure using Drush Make                  ####
####                                                            ####
cd $www/$domain
drush make https://raw.github.com/randull/createsite/master/createsite.make -y
####                                                            ####
####    Deploy site using Drush Site-Install                    ####
####                                                            ####
drush si createsite --db-url="mysql://$machine:$dbpw@localhost/$machine" --site-name="$sitename" --account-name="hackrobats" --account-pass="$drupalpass" --account-mail="maintenance@hackrobats.net" -y
####                                                            ####
####    Remove Drupal Install files after installation          ####
####                                                            ####
cd $www/$domain
rm CHANGELOG.txt COPYRIGHT.txt install.php INSTALL.mysql.txt INSTALL.pgsql.txt INSTALL.sqlite.txt INSTALL.txt LICENSE.txt MAINTAINERS.txt README.txt UPGRADE.txt
cd $www/$domain/sites
rm README.txt all/modules/README.txt all/themes/README.txt
cd $www/$domain/sites/all/libraries/plupload
rm -R examples
####                                                            ####
####    Create omega 4 sub-theme and set default                ####
####                                                            ####
drush omega-subtheme "Hackrobats Omega Subtheme" --machine-name="omega_hackrobats"
drush omega-subtheme "$sitename" --machine-name="omega_$machine" --basetheme="omega_hackrobats" --set-default
drush omega-export "omega_$machine" --revert -y
####                                                            ####
####    Initialize Git directory                                ####
####                                                            ####
sudo -u deploy git init
####                                                            ####
####    Set owner of entire directory to deploy:www-data        ####
####                                                            ####
cd $www
sudo chown -R deploy:www-data $domain
