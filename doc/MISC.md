# Misc / Draft

theses snippets will be move to proper documentation page once completed and tested (if they prove to be useful)

## CDX Indexer

monitor directory and subdir

    - for each *.warc without a corresponding cdx, create the cdx, sort the cdx
    - when all warc have a cdx in a folder
        - create a foldername.cdx that is an aggregate of all the cdx under it
        - copy the foldername.cdx in openwayback, add a line to cdxcollections.xml
        - create a foldername.path-index.txt
        - add each foldername.path-index.txt to /tmp/openwayback/path-index.txt, ignore duplicate

http://superuser.com/questions/363437/shell-scripting-loop-through-folders

    START_TIME=$SECONDS
    cd /mnt/webarch001
    for arc in heritrix/*/*/arcs/*arc.gz
    do
        cdx=$(basename $arc)
        cdx=${arc:0:-3}.cdx
        if test ! -e $cdx; then 
            echo "- indexing $arc"
            /opt/openwayback/bin/cdx-indexer $arc $cdx
        fi
    done
    ELAPSED_TIME=$(($SECONDS - $START_TIME))
    let ELAPSED_MINUTES="$ELAPSED_TIME/60"
    echo "Completed in about $ELAPSED_MINUTES minutes"

## delete cdx without accompanying warc file

	for i in *.cdx
	do
	    warc=$(basename $i)
	    warc=${warc:0:-4} 
	    if test ! -e $warc""; then 
	        rm $(basename $i)
	    fi
	done

## create a new md5sums file with only those who previously failed

	while read f; do
	  cat md5sums.txt | grep $f
	done <md5sums-failed-20151220.txt  > md5sums.txt2

## create md5sums file for a webcan drive (from cygwin)

    cd /cygdrive/e/webarch010
    find -type f -name *arc.gz -exec md5sum "{}" + > md5sums.txt

## create a CDX for a WebCan theme/folder

    export LC_ALL=C
    cd /mnt/webarch013/heritrix/lac-deleted-sites/
    rm -fr index.cdx
    for i in */arcs/index.cdx; do echo -en $i'\0';done | sort -m -u -o index.cdx --files0-from=-

## Move the CDX and path-index to a local drive, and rename them to keep the directory structure info

For example, it will get
`/mnt/webarch001/heritrix/war-of-1812/index.cdx` 
and copy it to 
`/data/openwayback/cdx-index/webarch013__war-of-1812__Twitter-201112151204__path-index.txt`

    for source in /mnt/webarch0*/heritrix/*/index.cdx
    do
        echo "Processing " $source
        fileshare=$(basename $(dirname $(dirname $(dirname $source))))
        collection=$(basename $(dirname $source))        
        cp $source "/data/indexes/openwayback/cdx-index/"$fileshare"__"$collection"__index.cdx"
    done

    for source in /mnt/webarch0*/heritrix/*/path-index.txt
    do
        echo "Processing " $source
        fileshare=$(basename $(dirname $(dirname $(dirname $source))))
        collection=$(basename $(dirname $source))        
        cp $source "/data/indexes/openwayback/path-index/"$fileshare"__"$collection"__path-index.txt"
    done

    for source in /mnt/lto01*/*/index.cdx
    do
        echo "Processing " $source
        fileshare=$(basename $(dirname $(dirname $source)))
        collection=$(basename $(dirname $source))        
        cp $source "/data/indexes/openwayback/cdx-index/"$fileshare"__"$collection"__index.cdx"
    done

    for source in /mnt/lto01*/*/path-index.txt
    do
        echo "Processing " $source
        fileshare=$(basename $(dirname $(dirname $source)))
        collection=$(basename $(dirname $source))        
        cp $source "/data/indexes/openwayback/path-index/"$fileshare"__"$collection"__path-index.txt"
    done