#!/bin/bash

########################
## setup.sh           ##
########################


mkdir /srv/iarchive
mkdir /srv/iarchive_staging
chmod 777 /srv/iarchive
chmod 777 /srv/iarchive_staging
mkdir /var/opt/normie-vaganza
chmod 777 /var/opt/normie-vaganza
cp -a ./* /var/opt/normie-vaganza

echo "You will need a Twitch.tv accout to use this software."
echo "Log in and find your Twitch streaming key at https://www.twitch.tv/broadcast/dashboard/streamkey"
echo "Write this secret key to /etc/twitchapikey for reading."
echo "Once done, you can begin streaming by running /var/opt/moviebroadcasting.sh"

exit 0

