rem @echo off

set ALL=PACK-IPTV PACK-SQL PACK-SYS 
set SVN_PATH=svn://sqsaaa01.questor.intra/svnr-qs/PACK
set USERNAME=farley
set PASSWORD=xyzzy

for /D  %%p in (%ALL%) do ( 

    echo processing  %%p - check out path %SVN_PATH%/%%p
    if not exist %%p md %%p
    pushd %%p
    svn --force --username %USERNAME% --password %PASSWORD% export %SVN_PATH%/%%p .
    popd
    
)


echo this is the end