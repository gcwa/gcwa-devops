## Given a harddrive from ArchiveIT
##  - sort the CDX
##  - create an index.cdx for each collection
##  - create a path-index.txt for each collection
## execute from inside the ltoXYZ directory on the drive

echo "Uncompress CDXs"
gunzip *.cdx.gz


echo "Sort CDXs"
export LC_ALL=C
for cdx in *.cdx 
do 
    sort -u $cdx -o $cdx 
done


echo "Create folder's main index.cdx"
export LC_ALL=C
rm -fr index.cdx
for i in *.cdx; do echo -en $(basename $i)'\0';done | sort -m -u -o index.cdx --files0-from=-


echo "create path-index.txt"
rm -f path-index.txt
for warc in *.warc.gz 
do 
     echo -e $warc "\t/mnt/lto01v/"`basename \`pwd\``"/"$warc >> path-index.txt
done
export LC_ALL=C
sort path-index.txt -o path-index.txt


echo "re-compress CDXs"
gzip *.cdx