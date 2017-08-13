#!/bin/bash

###############################################################
##                                                           ##
## moviebroadcasting.sh                                      ##
##                                                           ##
## This script runs in a constant loop to pull a random file ## 
## from the collection we've downloaded and stream it using  ##
## another shell script fstream_file.sh. It updates the log  ##
## and clears space in our collection when each file is      ##
## finished being broadcast.                                 ##
##                                                           ##
###############################################################
PROJ_NAME="normie-vaganza"      # Change to the name of your stream.
CURR_TIMEZONE="America/Chicago" # Change to your timezone.
USING_TWITTER=true              # Change to false if you don't want to tweet.
NV_ROOT="/var/opt/$PROJ_NAME"   # Don't change this.

$NV_ROOT/dlia.sh &

while (true); do
    D=`date +'%Y%m%d'`
    LOGNAME="$NV_ROOT/logs/np/nowplaying_$D.log"
    if [ -n "$(ls -A /srv/iarchive)" ]; then
        itemidentifier=`ls -t /srv/iarchive | tail -1` # No need for shuffling here; it's already done.
        echo "We'll play $itemidentifier"
        for freshfile in `ls /srv/iarchive/$itemidentifier --sort=size | grep -v ".mp3"| grep -v ".pdf"`; do
            echo "Selecting $freshfile"
            echo "$(TZ=$CURR_TIMEZONE date) streaming $itemidentifier - $freshfile" >> $LOGNAME
            find $NV_ROOT/logs/np/ -type f ! -name nowplaying_$D.log -delete
            title=`ia metadata $itemidentifier | jq '.metadata.title'`
            echo $title > "$NV_ROOT/logs/latestid.txt"
            if $USING_TWITTER; then
                python $NV_ROOT/nptweet.py
            fi
            echo "Updated Twitter with our current title."
            $NV_ROOT/fstream_file.sh /srv/iarchive/$itemidentifier/$freshfile
            rm -vf /srv/iarchive/$itemidentifier/$freshfile # Delete the file we just played (maybe there are others yet to be played).
            echo "! Finished streaming /srv/iarchive/$itemidentifier/$freshfile"
            sleep 8 # Ads anyways.
        done
        rm -vfr /srv/iarchive/$itemidentifier # Now delete the whole directory.
    else
        echo "Oh no! Internet archive cache is empty!"
        echo "Waiting 20 minutes for more videos to be pulled."
        sleep 1200 # Wait for dlia to pull some more videos
    fi
done

exit 0
