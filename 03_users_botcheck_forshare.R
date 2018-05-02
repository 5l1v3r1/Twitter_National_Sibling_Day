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
sib_tweets$botprob<-rep(NA, length(sib_tweets))
for(i in 1:length(sib_tweets)){
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

save(sib_tweets, file = "~/Desktop/paper/Python class/project/sib_tweets.Rdata")

missing_all<-which(is.na(sib_tweets$botprob)) 
#645 missing; may be protected, inactive, or suspended

#checking distribution of the botprob
library(ggplot2)
ggplot(data=sib_tweets, aes(botprob))+
  geom_bar()+
  labs(x = "bot probability (users 1, N = 23386)")+
  geom_vline(xintercept=0.50, colour = "red")

length(which(sib_tweets$botprob>.50) )
#979 user 1 accouts wih larger than .50 bot probability

#then subset the whole dataset into those where users 1's probability 
##is not NA and <=.50 

sib_tweets_c<-sib_tweets[!is.na(sib_tweets$botprob)&sib_tweets$botprob<=.50,]
#22407 tweets into subset

#Then based on this subset, conduct botcheck on the mentioned accounts
##find out the maximum length of user mentions
max_length<-1
for(i in 1:length(sib_tweets_c)){
  if (length(sib_tweets_c$user_mentions[[i]])>max_length){
    max_length<-length(sib_tweets_c$user_mentions[[i]])
    print(paste(max_length, i, sep=',')) 
  }
}
#maximum length is 11

#separate those users
for(i in 1:11){
  assign(paste("sib_tweets_c$mention", i, sep=""), rep(NA,length(sib_tweets_c)))
}

for(i in 1:length(sib_tweets_c)){
  if(length(sib_tweets_c$user_mentions[[i]])==1){
    sib_tweets_c$mention1[i]<-sib_tweets_c$user_mentions[[i]]
  }
  else{
    for(j in 1:length(sib_tweets_c$user_mentions[[i]])){
      sib_tweets_c[i,j+5]<-sib_tweets_c$user_mentions[[i]][j]
    }
  }
}

length(which(!is.na(sib_tweets_c$mention2))) #5257 user2
length(which(!is.na(sib_tweets_c$mention3))) #1551 user3
length(which(!is.na(sib_tweets_c$mention4))) #589 user4
length(which(!is.na(sib_tweets_c$mention5))) #294 user5
length(which(!is.na(sib_tweets_c$mention6))) #178 user6
length(which(!is.na(sib_tweets_c$mention7))) #121 user7
length(which(!is.na(sib_tweets_c$mention8))) #78 user8
length(which(!is.na(sib_tweets_c$mention9))) #29 user9
length(which(!is.na(sib_tweets_c$mention10))) #3 user10
length(which(!is.na(sib_tweets_c$mention11))) #2 user11

for(i in 1:11){
  assign(paste("sib_tweets_c$mention", i, "_prob", sep=""), rep(NA,22407))
}


#save the cleaned data
save(sib_tweets_c, file = "~/Desktop/paper/Python class/project/sib_tweets_c.Rdata")

#botcheck on users mentioned

for(j in 1:11){
  #loop through the 11 mention columns
  mentions<-eval(as.symbol(paste("sib_tweets_c$mention",j,sep="")))
  for(i in 1:length(sib_tweets_c)){
    if(is.na(mentions[i])){next}
    score<-botcheck(mentions[i])
    if(!is.null(score)){
      sib_tweets_c[i, j+16]<-score
      print(i)
    }
    else{print(paste(i, " missing"))}
    #store the data every 100 output
    if(i%%100==0){
      save(sib_tweets_c, file = "~/Desktop/paper/Python class/project/sib_tweets_c.Rdata")
    }
  }
  print(paste("mention ", j, " is finished."))
}


#combining all the scores
for(i in 17:27){
  print(length(which(!is.na(sib_tweets_c[,i]))))
}

#[1] 20072
#[1] 4813
#[1] 1442
#[1] 538
#[1] 283
#[1] 171
#[1] 118
#[1] 71
#[1] 28
#[1] 3
#[1] 2

length(sib_tweets_c[!is.na(sib_tweets_c$mention1_prob) 
                              & sib_tweets_c$mention1_prob<=.50,]$mention1_prob)
#17788 mentions 1 <=.50

#Then clean out all the bots in the user mentions: substitute the prob score with NA
sib_tweets_cleanbots<-sib_tweets_c
for(j in 17:27){
  for(i in 1:22407){
    if(!is.na(sib_tweets_cleanbots[i,j])&sib_tweets_cleanbots[i,j]>.50){
      sib_tweets_cleanbots[i,j]<-NA
    }
  }
}

length(sib_tweets_cleanbots[!is.na(sib_tweets_cleanbots$mention1_prob),]$mention1_prob)
#17788-good!

#Then leave out rows where all mentions were NAs
sib_tweets_cleanbots$all_prob<-rowSums(sib_tweets_cleanbots[,17:27], na.rm = TRUE)
length(which(is.na(sib_tweets_cleanbots$all_prob)))
#Turns out that none of the rows were all bot mentions
save(sib_tweets_cleanbots, file = "~/Desktop/paper/Python class/project/sib_tweets_cleanbots.Rdata")


#Then randomly extract 500 rows for manual classification & validation
set.seed(1234)
RandomRow500<-sample(1:22407, 500, replace=F)
library(xlsx)
sib_tweets_random500<-sib_tweets_cleanbots[RandomRow500,]
write.xlsx2(sib_tweets_random500, "sib_tweets_random500.xlsx", sheetName = "Sheet1",
            col.names = TRUE, row.names = TRUE, append = FALSE)


