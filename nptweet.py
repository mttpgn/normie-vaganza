import tweepy

keys = ['/etc/tweepy_akey',\
        '/etc/tweepy_asecret',\
        '/etc/tweepy_ckey',\
        '/etc/tweepy_csecret']
secretkeys = []

for i in range(len(keys)):
    with open(keys[i]) as a:
        secretkeys.append(a.read().strip())

akey = secretkeys[0]
asecret = secretkeys[1]
ckey = secretkeys[2]
csecret = secretkeys[3]

auth = tweepy.OAuthHandler(ckey,csecret)
auth.set_access_token(akey, asecret)
api = tweepy.API(auth)
nv_root = '/var/opt/normie-vaganza'
with open(nv_root+'/logs/latestid.txt', 'r') as npfile:
    new_status = npfile.read()

api.update_status("Now playing on https://twitch.tv/normievaganza : " + new_status)


