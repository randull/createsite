#!/bin/bash
#
####    Prompt user to enter Business Name & Domain             ####
read -p "Business Name: " sitename
read -p "Domain Name: " domain
####    Prompt user to enter Password for User1(Hackrobats)     ####
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
####    Create variables from Domain Name                       ####
tld=`echo $domain  |cut -d"." -f2,3`
name=`echo $domain |cut -f1 -d"."`
longname=`echo $name |tr '-' '_'`
shortname=`echo $name |cut -c -16`
machine=`echo $shortname |tr '-' '_'`
dbpw=$(pwgen -n 16)
####    Create database and user                                ####
db="CREATE DATABASE IF NOT EXISTS $machine;"
db1="GRANT ALL PRIVILEGES ON $machine.* TO $machine@dev IDENTIFIED BY '$dbpw';GRANT ALL PRIVILEGES ON $machine.* TO $machine@dev.hackrobats.net IDENTIFIED BY '$dbpw';"
db2="GRANT ALL PRIVILEGES ON $machine.* TO $machine@prod IDENTIFIED BY '$dbpw';GRANT ALL PRIVILEGES ON $machine.* TO $machine@prod.hackrobats.net IDENTIFIED BY '$dbpw';"
db3="GRANT ALL PRIVILEGES ON $machine.* TO $machine@localhost IDENTIFIED BY '$dbpw';"
mysql -u deploy -e "$db"
mysql -u deploy -e "$db1"
mysql -u deploy -e "$db2"
mysql -u deploy -e "$db3"
####    Create directories necessary for Drupal installation    ####
cd /var/www && sudo -u deploy mkdir $domain
cd /var/www/$domain && sudo -u deploy mkdir html logs private public tmp
cd /var/www/$domain/html && sudo -u deploy mkdir -p sites/default && sudo -u deploy ln -s /var/www/$domain/public sites/default/files
cd /var/www/$domain/logs && sudo -u deploy touch access.log error.log
cd /var/www/$domain/private && sudo -u deploy mkdir -p backup_migrate/manual backup_migrate/scheduled
cd /var/www/$domain && sudo -u deploy chmod 775 html logs public private tmp
sudo -u deploy chmod -R u=rw,go=r,a+X html/* && sudo -u deploy chmod -R ug=rw,o=r,a+X public/* private/*

####    Create virtual host file, enable and restart apache     ####
sudo -u deploy echo "<VirtualHost *:80>
        ServerAdmin maintenance@hackrobats.net
        ServerName dev.$domain
        ServerAlias *.$domain $name.510interactive.com $name.hackrobats.net
        ServerAlias $name.5ten.co $name.cascadiaweb.com $name.cascadiaweb.net
        DocumentRoot /var/www/$domain/html
        ErrorLog /var/www/$domain/logs/error.log
        CustomLog /var/www/$domain/logs/access.log combined
        DirectoryIndex index.php
</VirtualHost>
<VirtualHost *:80>
        ServerName $domain
        Redirect 301 / http://dev.$domain
</VirtualHost>  " > /etc/apache2/sites-available/$machine.conf
sudo -u deploy chown root:www-data /etc/apache2/sites-available/$machine.conf
sudo -u deploy a2ensite $machine.conf && sudo -u deploy service apache2 reload
####    Create /etc/cron.hourly entry                           ####
sudo -u deploy echo "#!/bin/bash
/usr/bin/wget -O - -q -t 1 http://dev.$domain/sites/all/modules/elysia_cron/cron.php?cron_key=$machine" > /etc/cron.hourly/$machine
sudo chown deploy:www-data /etc/cron.hourly/$machine
sudo chmod 775 /etc/cron.hourly/$machine
####    Create Drush Aliases                                    ####
sudo -u deploy echo "<?php
\$aliases[\"dev\"] = array(
  'remote-host' => 'dev.hackrobats.net',
  'remote-user' => 'deploy',
  'root' => '/var/www/$domain/html',
  'uri' => 'dev.$domain',
  '#name' => '$machine.dev',
  '#file' => '/home/deploy/.drush/$machine.aliases.drushrc.php',
  'path-aliases' => 
  array (
    '%drush' => '/usr/share/php/drush',
    '%dump-dir' => '/var/www/$domain/tmp',
    '%private' => '/var/www/$domain/private',
    '%files' => '/var/www/$domain/public',
    '%site' => 'sites/default/',
  ),
  'databases' =>
  array (
    'default' =>
    array (
      'default' =>
      array (
        'database' => '$machine',
        'username' => '$machine',
        'password' => '$dbpw',
        'host' => 'dev.hackrobats.net',
        'port' => '',
        'driver' => 'mysql',
        'prefix' => '',
      ),
    ),
  ),
);
\$aliases[\"prod\"] = array(
  'remote-host' => 'prod.hackrobats.net',
  'remote-user' => 'deploy',
  'root' => '/var/www/$domain/html',
  'uri' => 'www.$domain',
  '#name' => '$machine.dev',
  '#file' => '/home/deploy/.drush/$machine.aliases.drushrc.php',
  'path-aliases' => 
  array (
    '%drush' => '/usr/share/php/drush',
    '%dump-dir' => '/var/www/$domain/tmp',
    '%private' => '/var/www/$domain/private',
    '%files' => '/var/www/$domain/public',
    '%site' => 'sites/default/',
  ),
  'databases' =>
  array (
    'default' =>
    array (
      'default' =>
      array (
        'database' => '$machine',
        'username' => '$machine',
        'password' => '$dbpw',
        'host' => 'prod.hackrobats.net',
        'port' => '',
        'driver' => 'mysql',
        'prefix' => '',
      ),
    ),
  ),
);" > /home/deploy/.drush/$machine.aliases.drushrc.php
sudo -u deploy chmod 664  /home/deploy/.drush/$machine.aliases.drushrc.php
sudo -u deploy chown deploy:www-data /home/deploy/.drush/$machine.aliases.drushrc.php




####    Initialize Git directory                                ####
cd /var/www/$domain/html
sudo -u deploy git init
sudo -u deploy git remote add origin git@github.com:/randull/$longname.git
sudo -u deploy git pull origin master
####    Create site structure using Drush Make                  ####
cd /var/www/$domain/html
drush make https://raw.github.com/randull/createsite/master/profiles/hackrobats/createsite.make -y
####    Deploy site using Drush Site-Install                    ####
drush si createsite --db-url="mysql://$machine:$dbpw@localhost/$machine" --site-name="$sitename" --account-name="hackrobats" --account-pass="$drupalpass" --account-mail="maintenance@hackrobats.net" -y
####    Remove Drupal Install files after installation          ####
cd /var/www/$domain/html
sudo -u deploy rm CHANGELOG.txt COPYRIGHT.txt install.php INSTALL.mysql.txt INSTALL.pgsql.txt INSTALL.sqlite.txt INSTALL.txt LICENSE.txt MAINTAINERS.txt README.txt UPGRADE.txt
cd /var/www/$domain/html/sites
sudo -u deploy rm README.txt all/modules/README.txt all/themes/README.txt
sudo -u deploy chown -R deploy:www-data all default
sudo -u deploy chmod 755 all default
sudo -u deploy chmod 644 /var/www/$domain/html/sites/default/settings.php
sudo -u deploy chmod 644 /var/www/$domain/public/.htaccess
sudo -u deploy rm -R all/libraries/plupload/examples
####    Create omega 4 sub-theme and set default                ####
drush cc all
drush omega-subtheme "Hackrobats Omega Subtheme" --machine-name="omega_hackrobats"
drush omega-subtheme "$sitename" --machine-name="omega_$machine" --basetheme="omega_hackrobats" --set-default
drush omega-export "omega_$machine" --revert -y
####    Set owner of entire directory to deploy:www-data        ####
cd /var/www
sudo -u deploy chown -R deploy:www-data $domain
sudo -u deploy chown -R deploy:www-data /home/deploy
####    Set Cron Key & Private File Path
cd /var/www/$domain/html
drush vset cron_key $machine
drush vset cron_safe_threshold 0
drush vset file_private_path /var/www/$domain/private
drush vset maintenance_mode 1
####    Clear Drupal cache, update database, run cron
drush cc all && drush updb -y && drush cron
####    Push changes to Git directory                           ####
sudo -u deploy git add .
sudo -u deploy git commit -a -m "initial commit"
sudo -u deploy git push origin master




####    Create DB & user on Production                          ####
db4="CREATE DATABASE IF NOT EXISTS $machine;"
db5="GRANT ALL PRIVILEGES ON $machine.* TO $machine@dev IDENTIFIED BY '$dbpw';GRANT ALL PRIVILEGES ON $machine.* TO $machine@dev.hackrobats.net IDENTIFIED BY '$dbpw';"
db6="GRANT ALL PRIVILEGES ON $machine.* TO $machine@prod IDENTIFIED BY '$dbpw';GRANT ALL PRIVILEGES ON $machine.* TO $machine@prod.hackrobats.net IDENTIFIED BY '$dbpw';"
db7="GRANT ALL PRIVILEGES ON $machine.* TO $machine@localhost IDENTIFIED BY '$dbpw';FLUSH PRIVILEGES;"
sudo -u deploy ssh deploy@prod "mysql -u deploy -e \"$db4\""
sudo -u deploy ssh deploy@prod "mysql -u deploy -e \"$db5\""
sudo -u deploy ssh deploy@prod "mysql -u deploy -e \"$db6\""
sudo -u deploy ssh deploy@prod "mysql -u deploy -e \"$db7\""
####    Clone site directory to Production                      ####
sudo -u deploy rsync -avzh /var/www/$domain/ deploy@prod:/var/www/$domain/
####    Clone Drush aliases                                     ####
sudo -u deploy rsync -avzh /home/deploy/.drush/$machine.aliases.drushrc.php deploy@prod:/home/deploy/.drush/$machine.aliases.drushrc.php
####    Clone Apache config & reload apache                     ####
sudo -u deploy rsync -avz -e ssh /etc/apache2/sites-available/$machine.conf deploy@prod:/etc/apache2/sites-available/$machine.conf
sudo -u deploy ssh deploy@prod "sudo -u deploy sed -i -e 's/dev./www./g' /etc/apache2/sites-available/$machine.conf"
sudo -u deploy ssh deploy@prod "sudo chown root:www-data /etc/apache2/sites-available/$machine.conf"
sudo -u deploy ssh deploy@prod "sudo -u deploy a2ensite $machine.conf && sudo service apache2 reload && sudo service apache2 restart"
####    Clone DB
sudo -u deploy ssh deploy@prod "drush sql-sync @$machine.dev @$machine.prod -y"
####    Clone cron entry                                        ####
sudo -u deploy rsync -avz -e ssh /etc/cron.hourly/$machine deploy@prod:/etc/cron.hourly/$machine
sudo -u deploy ssh deploy@prod "sudo -u deploy sed -i -e 's/dev./www./g' /etc/cron.hourly/$machine"
