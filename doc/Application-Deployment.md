# WebArchiving Application Deployment

In all cases, Linux server needs to be setup with https://github.com/gcwa/gcwa-devops
Open file `playbook-openwayback.yml` and only keep the roles you need before running ansible.

## GCWebArchives 

- Server: `bac-lac`
- Ansible roles: common, java, mysql, gcwebarchives
- App: /opt/gcwebarchives/gcwebarchives-0.2.0-SNAPSHOT.jar`  (Version number will change over time)
- Systemd: `/etc/systemd/system/gcwebarchives.service`
- Properties: `/opt/gcwebarchives/application.properties`

        # Embedded tomcat
        server.tomcat.basedir=/opt/gcwebarchives/tomcat
        logging.path=/opt/gcwebarchives/

        # Database connection
        spring.datasource.url=jdbc:mysql://localhost:3306/gcwa
        spring.datasource.username=root
        spring.datasource.password=SECRETPASSWORDHERE

        # Application Specific
        gcwa.wayback.url.en=http://bac-lac.cloudapp.net:8080/wayback/*/
        gcwa.wayback.url.fr=http://bac-lac.cloudapp.net:8080/wayback-fr/*/
        gcwa.google.analytics.tracking.id=UA-73096066-1

- if using Azure VM in Resource Manager mode, please note that the default gcwebarchives setup runs the app as the lacwayback user, which is not allowed to use a restricted port (80), so we run it on port 8081 and use an iptable rules to forward port 80 to 8081. (see http://stackoverflow.com/questions/24756240/how-can-i-use-iptables-on-centos-7)
 
    yum install iptables-service
    iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8081
    service iptables save

### To deploy:

- copy the new `gwcwebarchives-X.Y.Z.jar` file in `/opt/gcwebarchives/`
- update the `gcwebarchives.jar` symlink (make sure it's pointing to the new file, and that the owner is style lacwayback:lacwayback)
- change the owner to `lacwayback` (`chown lacwayback:lacwayback gcwebarchives*`)
- make the file user executable (`chmod u+x gcwebarchives*.jar`)
- restart the application (`systemctl restart gcwebarchives`)
  - you can see the start log with `journalctl --follow -u gcwebarchives`
- if it's the first time you are installing this, you obviously need a database `CREATE DATABASE `gcwa` CHARACTER SET utf8 COLLATE utf8_general_ci;`

## OpenWayback

- Server: `bac-lac`
- Ansible roles: common, java, tomcat
- App: `/opt/tomcat/webapps/ROOT/`
- Systemd: `/etc/systemd/system/tomcat.service`
- config (**warning** keep these config files when deploying): 
    - `/opt/tomcat/webapps/ROOT/WEB-INF/wayback.xml`
    - `/opt/tomcat/webapps/ROOT/WEB-INF/CDXCollection.xml`
- data disk: /data/indexes/openwayback (v99wayback01-921260b70d8c1ec7.vhd)
    - see: https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-linux-classic-attach-disk/      

### To deploy:

- copy the new `openwayback-XYZ.jar` as `/opt/tomcat/webapps/ROOT.jar`
- delete or rename `/tomcat/webapps/ROOT/`
- edit `/opt/tomcat/webapps/ROOT/WEB-INF/wayback.xml' config and change hostname, baseurl

        wayback.basedir.default=/data/indexes/openwayback
        wayback.url.host.default=lacbac03.cloudapp.net
        
- restart the application (`systemctl restart tomcat`)


