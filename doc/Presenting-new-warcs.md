# Presenting new warcs

## Quick Summary

- Put your WARC files on a shared drive accessible to the server
- Create sorted CDX files from your WARC (ArchiveIt provides the CDX, they can be used without modifications) and put them in `/data/indexes/openwayback/cdx-index`
- add a reference to your WARC files in `/data/indexes/openwayback/path-index.txt` (sorted, see below)
- add a reference to your CDX files in `/opt/tomcat/webapps/ROOT/WEB-INF/CDXCollections.xml` under property `CDXSources`
- restart tomcat

## Servers Info

MS Azure server have been configured with https://github.com/gcwa/gcwa-devops

- Server name: `gcwa-awgc`
- Hostname: 
    - gcwa-awgc.canadaeast.cloudapp.azure.com
    - webarchive.bac-lac.gc.ca
    - archivesduweb.bac-lac.gc.ca

### OpenWayback Application

- Path: /opt/tomcat/webapps/ROOT
- App https://github.com/gcwa/openwayback
- URL: http://webarchive.bac-lac.gc.ca:8080/wayback/


### GCWA-Present (GCWebArchive)

- Path: /opt/gcwebarchives
- App: https://github.com/gcwa/gcwa-present
- URL: http://webarchive.bac-lac.gc.ca/

### Legacy

Legacy openwayback/gcwa-present, now only serving 404 application that redirecto to gcwa-awgc

- Server name: `bac-lac`
- App: https://github.com/gcwa/fourohfour
- Url: http://bac-lac.cloudapp.net
- Url: http://bac-lac.cloudapp.net:8080

Systemctl services: 

    - fourohfour-owb.service
    - fourohfour.service


## Setting up a Collection

_example using Archive-IT Collection 5500 (pm.gc.ca)_

### Get the WARC files

WARC file list and md5 files are at `https://partner.archive-it.org/cgi-bin/getarcs.pl?c=5500` the files have been downloaded on the shared storage:

    cd /mnt/laccrawlerprods/archiveit/ARCHIVEIT-5500

To download the files, create a list of files from the md5sums.txt file (this will create a file with the md5 checksum removed, keeping just the file name, that can easily be used with wget)

	perl -p -e 's/^\w+\s+//' md5sums.txt > archiveit-5500-warc.txt

Then download these files (change ArchiveIt USERNAME/PASSWORD):

	wget --http-user=USERNAME --http-password=PASSWORD --continue --no-clobber --progress=dot:mega --tries=0 --background --input-file=archiveit-5500-warc.txt --base="https://partner.archive-it.org/cgi-bin/getarcs.pl/" 
	
Check the integrity of downloaded files

    md5sum -c md5sums.txt
    
Delete and re-download any corrupted files (the wget command above can be re-executed, it will only get the missing files)

### Generate the files needed by OpenWayback

These steps are required to use WARC files with Openwayback

- create missing CDX
- sort CDX
- create index.cdx for collection
- create path-index.txt for collection

depending on where your data is coming from, you can find a script to do this in this project repository

- for [webcan](https://github.com/gcwa/gcwa-devops/blob/master/roles/gcwa/files/create-webcan-cdx-pathindex.sh)
- for [archiveit](https://github.com/gcwa/gcwa-devops/blob/master/roles/gcwa/files/create-archiveit-cdx-pathindex.sh)

### Make files available to OpenWayback

copy CDX to openwayback basedir 

    cp index.cdx /data/indexes/openwayback/cdx-index/index-ARCHIVEIT-5500.cdx

then edit `/opt/tomcat/webapps/ROOT/WEB-INF/CDXCollection.xml` to add your cdx (search for `CDXSources`)

Merge path-index content with openwayback's path-index (make sure ($basedir)/path-index.txt exists)

    sort -m ./path-index.txt /data/indexes/openwayback/path-index.txt -o /data/indexes/openwayback/path-index.txt

### Refresh Openwayback configuration

Restart Tomcat/OpenWayback

    sudo systemctl restart tomcat.service
	
