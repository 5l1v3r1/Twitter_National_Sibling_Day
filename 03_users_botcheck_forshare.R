#setwd("~/Desktop/paper/Python class/project") #set working directory
library(jsonlite) 
install.packages("devtools")
library(devtools)
install_github("marsha5813/botcheck")
library(botcheck)
library(httr)
library(xml2) 
library(RJSONIO)

#Provide Mashape Key from https://market.mashape.com/OSoMe/botometer/
Mashape_key = ""

#Use Twitter app key and token info
##get your own tokens by registering a Twitter app: https://apps.twitter.com/
consumer_key = ""
consumer_secret = ""
access_token = ""
access_secret = ""

myapp1 = oauth_app("BotCheck", key=consumer_key, secret=consumer_secret)
sig = sign_oauth1.0(myapp1, token=access_token, token_secret=access_secret)


sib_tweets<-stream_in(file("sibling_tweets_short.txt"))
length(sib_tweets$text) #consistent with the length found in python

#First, conduct botcheck with the users (but not user mentions) to filter out non-human users
##rate limit: 180 per 15 minutes
##
sib_tweets$botprob<-rep(NA, 24031)
for(i in 1:24031){
  score<-botcheck(sib_tweets$screen_name[i])
  if(!is.null(score)){
    sib_tweets$botprob[i]<-score
  }
  print(i)
  #store the data every 100 output
  if(i%%100==0){
    save(sib_tweets, file = "~/Desktop/paper/Python class/project/sib_tweets.Rdata")
  }
  #if(i%%180==0){
  #Sys.sleep(10*60)
  #}  #this is not necessary since Botcheck itself is usually running slowly 
      #and would not reach the 180 bar within 15 inutes
}

