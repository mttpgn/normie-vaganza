# normie-vaganza

This is the code for a [24/7 Twitch stream](https://twitch.tv/normievaganza "Normie-vaganza on Twitch"), which is live at the current time of publication.

The `setup.sh` script allows this script easily to be customized to suit the 
interests of any other normie who wants to stream content. 

## Requirements
Run the following command to install the necessary dependencies. 

`pip install internetarchive tweepy`

The script also relies on `ffmpeg` for streaming. The [latest ffmpeg static builds](https://www.johnvansickle.com/ffmpeg/) 
support hardware x264 compression. The versions available from standard 
repositories (< 3.0) lack this feature, a feature I did make use of to reduce 
latency. 

If running someone else's binaries makes you queezy, note well that building 
ffmpeg from source, while possible, has not worked for me, since the default dependencies are not all linked by default. 

After installing `ffmpeg`, you may or may not need to edit `fstream_file.sh` with the location of your `ffmpeg` binary. 

## Keys
This script assumes your Twitch stream key and Twitter OAuth keys are stored 
in `/etc` at the following locations:

* /etc/twitchapikey
* /etc/tweepy_akey
* /etc/tweepy_asecret
* /etc/tweepy_ckey
* /etc/tweepy_csecret

You can acquire these keys from the [Twitch](http://www.twitch.tv/user_name/dashboard/streamkey) and [Twitter](https://apps.twitter.com/) accounts you'll be 
using to broadcast your stream. Write them to the above locations.

## Twitter use
By default, normie-vaganza will tweet out the title of the video that's 
currently playing. To disable this, simply change $USING_TWITTER to `false`
in moviebroadcasting.sh.

## Customization
The name of your project and Twitch account are requested during the first
run of `setup.sh`; this value can be changed later by editing the
PROJ_NAME variable across scripts.

## Content
The content downloaded for streaming is determined by the search parameters
given at `searchparams.cfg`. The syntax for these searches is documented 
on the [internetarchive documentation page](https://internetarchive.readthedocs.io/en/latest/cli.html#search).

I've hardcoded a few exceptions into `dlia.sh` which get turned automatically 
into a badstuff.txt with the identifiers for all the files I don't want, even 
though they match the search parameters. 

## Licensing
I've chosen to get videos that meet the criteria for public domain or other
creative commons licensing. In the future, the filter may be tightened 
further so that only public domain videos are streamed. I am not sure
whether or not tweeting what's "Now Playing" meets the requirements for 
attribution.

Twitch's terms of service do not allow for the streaming of copyrighted content.

## Usage
Simply run `moviebroadcasting.sh` inside a `screen` or `tmux` session. The
script will run continuously without requiring input. The script pulls new 
content as needed from the web and deletes videos after they've been viewed.

The application automatically montiors the utilized space of the filesystem
/srv resides on and will not pull additional content after a 90% threshold 
is breeched.
