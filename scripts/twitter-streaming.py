#!/usr/bin/python

import json
import sys

from tweepy.streaming import StreamListener
from tweepy import OAuthHandler
from tweepy import Stream

# Go to http://dev.twitter.com and create an app.
# The consumer key and secret will be generated for you after
consumer_key="CONSUMER_KEY"
consumer_secret="CONSUMER_SECRET"

# After the step above, you will be redirected to your app's page.
# Create an access token under the the "Your access token" section
access_token="ACCESS_TOKEN"
access_token_secret="ACCESS_TOKEN_SECRET"

class StdOutListener(StreamListener):
    """ A listener handles tweets are the received from the stream.
    This is a basic listener that just prints received tweets to stdout.

    """
    def __init__(self):
        StreamListener.__init__(self)

    def on_data(self, data):
        print data
        return True

    def on_error(self, status):
        print status

if __name__ == '__main__':
    l = StdOutListener()
    auth = OAuthHandler(consumer_key, consumer_secret)
    auth.set_access_token(access_token, access_token_secret)
    
    keyword = sys.argv[1]
    lang = sys.argv[2] or 'en'

    stream = Stream(auth, l)
    stream.filter(track=[keyword], languages=[lang])
