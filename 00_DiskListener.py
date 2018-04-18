#!/usr/bin/env python
# -*- coding: utf-8 -*-

""" Tweepy sampling program

    This is a short script to gather tweets from the twitterverse and write them to screen or disk.\n
    Developed for and by HDFS 597-001: Mining the Internet with Python at
    the Pennsylvania State University, Spring 2018.
"""

# Bring in tweepy
import tweepy
from HDFS597_Helper_Functions import * 

#__authors__ = "Timothy R. Brick, et al."   # or __author__ if there's only one
#__copyright__ = "Copyright 2018, The Pennsylvania State University"
#__status__ = "Development"                 # "Production" usually means the software is done.

#This is a basic listener that just prints received tweets to disk.
class DiskListener(tweepy.StreamListener):
    def set_file(self, filename):
        self.f = open(filename, 'w+')
        self.f.write('[')
    def on_data(self, data):
        self.f.write(data + ",")
        return True
    def on_error(self, status):
        print(status)  # Or quit, if you want.
    def close_file(self):
        self.f.write("]")
        self.f.close()

if __name__ == '__main__':

    # Authenticate and go.
    
    my_auth = get_JSON_creds(filename=".usercreds.json",return_dict=True)
        
    l = DiskListener()
    l.set_file("test3.json")
    auth = tweepy.OAuthHandler(my_auth["CONSUMER_KEY"], my_auth["CONSUMER_SECRET"])
    auth.set_access_token(my_auth["ACCESS_TOKEN"], my_auth["ACCESS_TOKEN_SECRET"])
    stream = tweepy.Stream(auth, l)
    stream.filter(track=["#nationalsiblingday", "#nationalsiblingsday", "#nationalsibday", "#nationalsibsday", 
    "sibling day", "siblings day", "sibling's day", "sib day", "sib's day", "sibs day",
    "#siblingday", "#siblingsday",
    "#sibday", "#sibsday"])
    try:
        stream.sample()
    except Exception:
        pass
    finally:
        l.close_file()
