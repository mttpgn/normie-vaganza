#!/bin/bash

########################
## setup.sh           ##
########################

PROJ_NAME="normie-vaganza"
mkdir /srv/iarchive
mkdir /srv/iarchive_staging
chmod 777 /srv/iarchive
chmod 777 /srv/iarchive_staging
mkdir /var/opt/$PROJ_NAME
chmod 777 /var/opt/$PROJ_NAME
cp -a ./* /var/opt/$PROJ_NAME

echo "You will need a Twitch.tv accout to use this software."
echo "Log in and find your Twitch streaming key at https://www.twitch.tv/broadcast/dashboard/streamkey"
echo "Write this secret key to /etc/twitchapikey for reading."
echo "Once done, you can begin streaming by running /var/opt/moviebroadcasting.sh"

exit 0

