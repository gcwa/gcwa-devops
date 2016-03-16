## Given a harddrive from WebCan
##  - create the cdx
##  - sort the CDX
##  - create an index.cdx for each collection
##  - create a path-index.txt for each collection
## execute from a webarchXYZ folder on the drive

# !!! WON'T work with MINGw64 (provided by Git / Git-bash), USE CYGWIN !!!

### EDIT THIS !! ###
# JDK install to use
export JAVA_HOME="/cygdrive/c/Program Files/Java/jdk1.8.0_74"
# Pointer to your openwayback 2.3 install
export WAYBACK_HOME="/cygdrive/c/Users/LAC_local/Applications/openwayback-2.3.0-dist"
# Java runtime options
export JAVA_OPTS="-Xmx1024m"
### STOP EDITING ###

echo "Create CDXs"
START_TIME=$SECONDS
for arc in heritrix/*/*/arcs/*arc.gz
do
    cdx=$(basename $arc)
    cdx=${arc:0:-3}.cdx
    if test ! -e $cdx; then 
        echo "- indexing $arc"
        $WAYBACK_HOME/bin/cdx-indexer $arc $cdx
    fi
done
ELAPSED_TIME=$(($SECONDS - $START_TIME))
let ELAPSED_MINUTES="$ELAPSED_TIME/60"
echo "CDXs created in in about $ELAPSED_MINUTES minutes"


echo "Sort CDXs"
export LC_ALL=C
for cdx in heritrix/*/*/arcs/*.cdx 
do 
   echo " sort: " $(basename $cdx)
   sort -u $cdx -o $cdx
done

## TMP send CDX in the cloud at this point, as the rest of the script is not working yet
#rsync --dry-run -ruth --progress --include="*/" --include="*.cdx" --exclude="*" ./ lacwayback@lacbac03.cloudapp.net:/mnt/webarch003/

## TODO have the rest of the script deal with the deep directory structure used by webcan
##  and create an index.cdx/path-index.txt for each theme

#echo "Create folder's main index.cdx"
#export LC_ALL=C
#rm -fr index.cdx
#for i in *.cdx; do echo -en $(basename $i)'\0';done | sort -m -u -o index.cdx --files0-from=-


#echo "create path-index.txt"
#rm -f path-index.txt
#for warc in *.warc.gz 
#do 
#     echo -e $warc "\t/mnt/lto01v/"`basename \`pwd\``"/"$warc >> path-index.txt
#done
#export LC_ALL=C
#sort path-index.txt -o path-index.txt


#echo "Compress CDXs"
#gzip *.cdx