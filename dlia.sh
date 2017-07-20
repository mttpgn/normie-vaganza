#!/bin/bash

###############################################################################
##                                                                           ##
## dlia                                                                      ##
##                                                                           ##
## This script downloads all available movie files within every "item"       ##
## categorized under a given collection (defined as $COLL) on                ##
## internetarchive.org and stores them in /srv/iarchive.                     ##
##                                                                           ##
###############################################################################

NV_ROOT="/var/opt/normie-vaganza"
SEARCHPARAMETERS="$NV_ROOT/config/searchparams.cfg"
ITEMLIST="$NV_ROOT/config/itemlist.txt"
BADSTUFF="$NV_ROOT/config/badstuff.txt"
readarray -t COLLS < $SEARCHPARAMETERS

while (true); do
    DATE=`date +'%Y%m%d'`
    LOG="$NV_ROOT/logs/dl/downloading_$DATE.log"
    exec > $LOG 2>&1
    echo "Checking for old logs to delete..."
    find $NV_ROOT/logs/dl/ -type f ! -name downloading_$DATE.log -delete # Purge log from previous days
    echo "Now writing all items in specified I.A. collections to $ITEMLIST" 
    echo '' > $ITEMLIST # Clear the file.
    for parameter in "${COLLS[@]}"; do
        ia search $parameter --itemlist >> $ITEMLIST
    done
    # Now we prepare the list of stuff we don't want.
    ia search "creator:'iLL WiLL PrEss'" --itemlist > $BADSTUFF
    echo "RAScartoonrealitieswhenartimitateslifetheFascistcultureofviolence" >> $BADSTUFF
    echo "Banned" >> $BADSTUFF
    echo "multfilmi" >> $BADSTUFF
    echo "cartoon7" >> $BADSTUFF
    echo "Jingle_bells" >> $BADSTUFF
    echo "NoAudio" >> $BADSTUFF
    echo "Sintel" >> $BADSTUFF
    echo "Maddness" >> $BADSTUFF
    echo "TrinketRP" >> $BADSTUFF
    echo "blend_intro" >> $BADSTUFF
    echo "NateBradleyAnimation" >> $BADSTUFF
    echo "Fabian_de_mov" >> $BADSTUFF

    echo "Done writing item lists. Download loop starting." 
    NEWLIST=`sort $ITEMLIST | uniq | shuf --random-source=/dev/urandom | grep -v -f $BADSTUFF`
    for item in $NEWLIST; do
        ORDINAL=`grep -n $item $ITEMLIST | cut -f 1 -d :|head -1`
        LISTLENGTH=`wc -l $ITEMLIST`
        echo 
        echo "Now downloading item $ORDINAL of $LISTLENGTH." 
        if [ ! -d "/srv/iarchive/$item" ]; then
            echo "Beginning to download $item" 
            SPACEFREE=`df -k /srv | awk '{if ($1 != "Filesystem") print $5 " "}' | tr -d '%' | cut -d \  -f 1`
            if [[ "$SPACEFREE" -gt 95 ]]; then
                echo "Insufficient space. Please do some filesystem cleanup."
                echo "Waiting 15 minutes before retrying."
                sleep 900 # Wait 15 mins for the other script to catch up
            fi
            specificorigfiles=`ia metadata $item | jq '.files'| grep '"original": '| sort | uniq | cut -f 2 -d :|sed 's/,$//' | tr '\n' ' '|tr -d '"'` # This gets only all the originally uploaded files in an item.
            cd /srv/iarchive_staging
            echo "ia download $item $specificorigfiles"
            ia download $item $specificorigfiles 
            echo "Moving completed files from staging to prod."
            cp -av /srv/iarchive_staging/$item /srv/iarchive/$item 
            echo "Cleaning up" 
            rm -rfv /srv/iarchive_staging/* 
            echo "Successfully processed $item."
        else
            echo "Huh. Seems we've already downloaded $item. Skipping." 
        fi
        echo "Waiting 46 seconds before next download."
        sleep 46
    done
    echo "Processing completed. All ${COLLS[@]} items saved to disk"
    sleep 15
done

exit 0

