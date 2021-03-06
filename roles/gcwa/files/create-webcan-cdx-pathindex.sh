## Given a harddrive from WebCan
##  - create the cdx
##  - sort the CDX
##  - create an index.cdx for each collection
##  - create a path-index.txt for each collection
## execute from a webarchXYZ folder on the drive

# !!! WON'T work with MINGw64 (provided by Git / Git-bash), USE CYGWIN !!!


### EDIT THIS !! ###

# JAVA install to use
#export JAVA_HOME="/cygdrive/c/Program Files/Java/jdk1.8.0_74"
export JAVA_HOME="/etc/alternatives/jre"

# Pointer to your OpenWayback install (preferably GCWA version)
#export WAYBACK_HOME="/cygdrive/c/Users/LAC_local/Applications/openwayback-2.3.0-dist"
export WAYBACK_HOME="/opt/openwayback"

# Java runtime options
export JAVA_OPTS="-Xmx1024m"

### STOP EDITING ###


## Functions

# param: foldername
function create_indexcdx {
    echo "create index.cdx in     " $1
    export LC_ALL=C # somehow this setting disapear sometimes...
    cd $1
    rm -fr index.cdx
    for i in *.cdx; do echo -en $(basename $i)'\0';done | sort -m -u -o index.cdx --files0-from=-
}

# param: foldername
function create_pathindextxt {
    echo "create path-index.txt in" $1
    cd $1
    rm -f path-index.txt
    for warc in *arc.gz 
    do 
        echo -e $warc"\t"`pwd`"/"$warc >> path-index.txt
    done
    export LC_ALL=C # somehow this setting disapear sometimes...
    sort path-index.txt -o path-index.txt    
}

# param: foldername
function create_theme_indexes {
    echo "create theme index.cdx/path-index.txt in     " $1
    export LC_ALL=C # somehow this setting disapear sometimes...
    cd $1
    rm -fr index.cdx path-index.txt
    for i in */arcs/index.cdx; do echo -en $i'\0';done | sort -m -u -o index.cdx --files0-from=-
    for i in */arcs/path-index.txt; do echo -en $i'\0';done | sort -m -u -o path-index.txt --files0-from=-
}

## /Functions


basedir=`pwd`


## Main script

echo "Create a CDX file for every ARC/WARC"
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

## Create one index.cdx and one path-index.txt in each `arc` folder
for arc in heritrix/*/*/arcs
do 
    create_indexcdx $arc
    cd $basedir
    create_pathindextxt $arc
    cd $basedir
done

## Create one index.cdx/path-index.txt in each "theme" folder
for theme in heritrix/*
do
    create_theme_indexes $theme
    cd $basedir
done