# WebCan - System for Web Archive Management

_This is a legacy application._

- Source Control: internal svn server at /web_archiving/webcan/
- Database: Oracle

## Useful SQL query

_reminder_ `ALTER SESSION SET CURRENT_SCHEMA = webcan;`

Find the folder name where a theme is (_note:_ a folder can contain more than one theme)
    
    select distinct c.CRAWL_JOB_NBR, c.CRAWL_JOB_STRG_LCTN_FLDR_TXT, c.CRAWL_JOB_NME 
     from CRAWL_JOB c
     join CRAWL_JOB_THEME on c.CRAWL_JOB_NBR=CRAWL_JOB_THEME.CRAWL_JOB_NBR 
     where CRAWL_JOB_THEME.THEME_NBR=361;

Find all the themes that are in a specific folder name

    alter session set current_schema = webcan;
    select distinct CRAWL_JOB_THEME.THEME_NBR
    from CRAWL_JOB c
    join CRAWL_JOB_THEME on c.CRAWL_JOB_NBR=CRAWL_JOB_THEME.CRAWL_JOB_NBR 
    where c.CRAWL_JOB_STRG_LCTN_FLDR_TXT = 'canada-federal-government-domain-crawl-001'
    order by CRAWL_JOB_THEME.THEME_NBR;

## Files location

mount point for archives in table `S_CFGTN`, configuration property name `whmd.lacFileStore.indexMountPoints`

in `LACFileStore.java#copyArchiveFileToStore()`, code loop thru the `ConfigurationConstants.ARCHIVE_MOUNT_POINTS_CONFIG_PROPERTY` and use the first folder that have enough space for the current file size

Directory structure:

    <mountPoint>/heritrix/<folderLocation (CRAWL_JOB_STRG_LCTN_FLDR_TXT aka normalized theme name))>/<crawlJobName>

`<mountpoint>` being something like `/mnt/webarch001`