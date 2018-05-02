# Identifying Siblings on Twitter:
## Using Tweets About the National Siblings Day on April 10, 2018
This is a class project for Timothy Brick's HDFS 597 "Mining Internet with Python" at the Pennsylvania State University.
* Copyrights to Xiaoran Sun, MS, and Timothy Brick, Ph.D., at the Pennsylvania State University.
* For citation, please contact Xiaoran Sun xiaoran.sun@psu.edu

## Study Background
Siblings play important role in one another's development (Dunn, 1983; McHale, Updegraff, & Whiteman, 2012). Research on siblings has used global questionnaires and interviews to examine their relationships and interactions, mostly through *offline* activities. However, although social media has become an important part of many people's life, especially among youth and young adults (Pew Research Center, 2018), we know much less about how they interact *online*, including on social media (LeBouef & Dworkin, 2017). Twitter is a platform that people use for social networking and obtaining information (Zhao & Rosson, 2009). I use Twitter to examine sibling interactions online because it provides free, open source data through the API, and previous research has used data from Twitter to capture interactions between romantic partners (Garimella, Weber, & Cin, 2014).

One important step to examine sibling interactions on Twitter is to identify siblings, but the identification process can be time-consuming and expensive, involving a large amount of human annotation work (Sun, Chi, Yin, & McHale, in progress). However, the National Siblings Day on April 10 can provide unique opportunity to identify sibling Twitter users in a more efficient way. On that day, #NationalSiblingsDay (and other similar hashtags) is a trending topic on Twitter, and people tend to tweet that topic and mention their siblings in the tweet. Therefore, collecting tweets about that topic on that particular day and utilizing a subset of those where one user mentions the other(s), it is likely to identify sibling users in a potentially reliable way.

Accordingly, in this study, I obtained real-time tweets about National Siblings Day, and used text analysis to identify characteristics that could potentially be helpful to filter relevant tweets that potentially could help to identify siblings on Twitter. Using the characteristics, I filtered potentially relevant tweets, which I then used to identify siblings by the users' mentions in the tweets. With these users identified, I further filtered out the non-human sibling users using botcheck (Davis, Varol, Ferrara, Flammini, & Menczer, 2016). Finally, to assess the validity of my method for identifying sibling users, I randomly selected a proportion of all the identified sibling users and manually annotated them as siblings vs not siblings, based on their tweets and Twitter profiles, and calculated the percentage of the human-annotated sibling users as index for validity.

## Method
### Streaming Tweets about National Siblings Day
Starting from 9pm, April 9th, until 4am, April 11st, I used Twitter Streaming API to filter realtime tweets that contained any of the hashtags (case-insensitive), including "#nationalsiblingday", "#nationalsiblingsday", "#nationalsibday", "#nationalsibsday", "#siblingday", "#siblingsday", "#sibday", and "#sibsday", and/or any of the key words, including "sibling day", "siblings day", "sibling's day", "sib day", "sib's day", and "sibs day". I stored the tweets in json format on my disk. 

The corresponding code file is `00_DiskListener.py`, created by Timothy Brick, with little edits by Xiaoran Sun for filtering criterion.

This resulted in 383,040 tweets, with the total data file size as around 2.5GB. To get these raw data, please contact Xiaoran Sun.

### Pre-Processing Raw Data Files
The raw data file (in json) was too large and when it was read in Jupyter as a whole, my laptop would crash. Therefore, I used bash command (on the Terminal application) to separate the json file by lines into separate text files.

To separate a big json file into smaller files that are not larger than 30,000 lines, I used:
`split -l 30000 filename.json`

But these smaller files cannot be read directly into jupyter due to their incompleteness. Therefore, at the beginning of each file, I had to make sure there was or I added a `[`, and at the end of each file, `]`.

To check whether these files were complete as json lists and also get to know the length of each file, I used (bash command):
`jq '. | length' SmallFileName`. When checked by this command, there was some parse error or EOF with some small files, and I found that it was because `"` at the beginning or the end was reformatted into `“` or `”`. These quotation marks had to be formatted back. I did it manually, but I know it is better to write codes for this task and I will update on this soon.

### Text Analyses
Before identifying siblings using the data, I examined what the users were talking about when they tweeted about National Siblings Day, using text analyses. This procedure was mainly for identifying irrelevant or confounding tweets in the dataset where users were not very possible talking about, especially mentioning their siblings. Characteristics, including hashtags, keywords, and topics, found in this procedure could be used as selection criteria to filter out confounding tweets and keep those that would be relevant.

Text analyses conducted include:
  * descriptives of the hashtags, including occurrences and co-occurrences (i.e., bigrams, trigrams) of hashtags,
  * descriptives of the tweets' content, including 
       * word frequency and ngrams frequency, 
       * topic modeling,
       * sentiment analyses.

In the analyses, I was only interested in what people were *tweeting*, but not *retweeting*, given that tweets from popular accounts that have been retweeted many times can be extremely overrepresentative in the sampled tweets. I made this decision because my preliminary analyses with all the tweets, including retweets, found that the popular hashtags were predominantly about movies and/or TV shows, such as '#blackpanther' and '#strangerthings', probably because people were excited about those shows and retweeted tweets from the shows' official accounts and relevant celebrities' tweets. I also got rid of tweets that were identified as in languages other than English. These two subsetting rules resulted in 132,469 tweets for text analyses.

The corresponding code file is `01_text_analyses.ipynb`. <br>
I used the `nltk` and `genism` python package for text analyses.

### Identify Sibling Users
To idenify sibling users using the tweets that I streamed in, I took the following steps:
* First, filter out irrelevant tweets using the filtering criteria determined with results of text analyses;
* Second, select tweets where users mentioned other Twitter account(s) (e.g., @username), given that the accounts mentioned in the tweets for National Siblings Day were likely to be the users' siblings; in this step, I could get raw data of groups (e.g., dyads, triads, etc.) of siblings;
* Finally, filter out non-human users among the 'siblings' identified in the former step by means of botcheck using the [Botometer API](https://github.com/sxrpsy/botcheck).

The corresponding code file for the first two steps is `02_identify_siblings.ipynb`. <br>
The code file for botcheck is `03_botcheck_forshare.R`. 

### Validate Sibling Users
The final step was to validate whether the sibling users identified in the previous step were actual siblings. I randomly selected 200 tweets from the sibling-mention tweets determined by the previous step, and manually classified among these 200 tweets based on the tweet content and the users' profiles, to determine whether the user(s) mentioned in the tweets were siblings. A more reliable approach is to form a group of independent coders and classify the randomly selected tweets. However, due to the time limit of this project, I relied on my own judgement for now, but independent coding should be an important further step.

A true positive rate over .80 would indicate that the approach for identifying sibling Twitter users in this project is reliable.

## Results
### Text Analyses: Hashtags
From all the tweets that were not retweeted, I extracted hashtags, includng 101,525 single hashtags, 62,612 bigrams, and 31,328 trigrams. Then I counted the frequencies of each single, bigram, and trigram hashtags to find the most frequent, that is, representative ones.
The four most frequent single hashtags were #nationalsiblingsday, #nationalsiblingday, #siblingsday, and #siblingday. To make a better representation of other hashtags, I deleted those four from the single hashtag list and bigrams and trigrams that contain any of these four hashtags. With this exclusion criterion, the 15 most frequent occurring single hashtags, bigrams, and trigrams are displayed below respectively.

*Occurrences of single hashtags* <br />

<table>
    <tr>
        <th>Single Hashtag</th>
        <th>Count</th>
    </tr>
    <tr>
        <td>siblings</td>
        <td>1000</td>
    </tr>
    <tr>
        <td>family</td>
        <td>765</td>
    </tr>
    <tr>
        <td>tuesdaythoughts</td>
        <td>695</td>
    </tr>
    <tr>
        <td>sisters</td>
        <td>649</td>
    </tr>
    <tr>
        <td>equalpayday</td>
        <td>603</td>
    </tr>
    <tr>
        <td>brothers</td>
        <td>456</td>
    </tr>
    <tr>
        <td>love</td>
        <td>365</td>
    </tr>
    <tr>
        <td>zuckerberg</td>
        <td>364</td>
    </tr>
    <tr>
        <td>sister</td>
        <td>352</td>
    </tr>
    <tr>
        <td>flyer</td>
        <td>294</td>
    </tr>
    <tr>
        <td>brochure</td>
        <td>291</td>
    </tr>
    <tr>
        <td>brother</td>
        <td>280</td>
    </tr>
    <tr>
        <td>rack</td>
        <td>268</td>
    </tr>
    <tr>
        <td>onlychild</td>
        <td>243</td>
    </tr>
    <tr>
        <td>roll</td>
        <td>237</td>
    </tr>
</table>

*Occurrences of hashtag bigrams* <br />

<table>
    <tr>
        <th>Hashtag Bigrams</th>
        <th>Count</th>
    </tr>
    <tr>
        <td>(&#x27;brochure&#x27;, &#x27;flyer&#x27;)</td>
        <td>290</td>
    </tr>
    <tr>
        <td>(&#x27;flyer&#x27;, &#x27;rack&#x27;)</td>
        <td>268</td>
    </tr>
    <tr>
        <td>(&#x27;brochure&#x27;, &#x27;rack&#x27;)</td>
        <td>268</td>
    </tr>
    <tr>
        <td>(&#x27;equalpayday&#x27;, &#x27;tuesdaythoughts&#x27;)</td>
        <td>260</td>
    </tr>
    <tr>
        <td>(&#x27;brochure&#x27;, &#x27;roll&#x27;)</td>
        <td>236</td>
    </tr>
    <tr>
        <td>(&#x27;flyer&#x27;, &#x27;roll&#x27;)</td>
        <td>236</td>
    </tr>
    <tr>
        <td>(&#x27;rack&#x27;, &#x27;roll&#x27;)</td>
        <td>236</td>
    </tr>
    <tr>
        <td>(&#x27;family&#x27;, &#x27;siblings&#x27;)</td>
        <td>168</td>
    </tr>
    <tr>
        <td>(&#x27;equalpayday&#x27;, &#x27;zuckerberg&#x27;)</td>
        <td>167</td>
    </tr>
    <tr>
        <td>(&#x27;americanidol&#x27;, &#x27;foodasitcom&#x27;)</td>
        <td>152</td>
    </tr>
    <tr>
        <td>(&#x27;americanidol&#x27;, &#x27;marilynmonday&#x27;)</td>
        <td>148</td>
    </tr>
    <tr>
        <td>(&#x27;foodasitcom&#x27;, &#x27;marilynmonday&#x27;)</td>
        <td>148</td>
    </tr>
    <tr>
        <td>(&#x27;family&#x27;, &#x27;love&#x27;)</td>
        <td>144</td>
    </tr>
    <tr>
        <td>(&#x27;brother&#x27;, &#x27;sister&#x27;)</td>
        <td>142</td>
    </tr>
    <tr>
        <td>(&#x27;lifecouldbeeasierif&#x27;, &#x27;tuesdaythoughts&#x27;)</td>
        <td>126</td>
    </tr>
</table>

*Occurrences of hashtag trigrams* <br />

<table>
    <tr>
        <th>Hashtag Trigrams</th>
        <th>Count</th>
    </tr>
    <tr>
        <td>(&#x27;brochure&#x27;, &#x27;flyer&#x27;, &#x27;rack&#x27;)</td>
        <td>268</td>
    </tr>
    <tr>
        <td>(&#x27;flyer&#x27;, &#x27;rack&#x27;, &#x27;roll&#x27;)</td>
        <td>236</td>
    </tr>
    <tr>
        <td>(&#x27;brochure&#x27;, &#x27;flyer&#x27;, &#x27;roll&#x27;)</td>
        <td>236</td>
    </tr>
    <tr>
        <td>(&#x27;americanidol&#x27;, &#x27;foodasitcom&#x27;, &#x27;marilynmonday&#x27;)</td>
        <td>148</td>
    </tr>
    <tr>
        <td>(&#x27;equalpayday&#x27;, &#x27;lifecouldbeeasierif&#x27;, &#x27;tuesdaythoughts&#x27;)</td>
        <td>97</td>
    </tr>
    <tr>
        <td>(&#x27;cbx_bloomingdays&#x27;, &#x27;felizmartes&#x27;, &#x27;temblor&#x27;)</td>
        <td>97</td>
    </tr>
    <tr>
        <td>(&#x27;cbx_bloomingdays&#x27;, &#x27;mondaymotivation&#x27;, &#x27;temblor&#x27;)</td>
        <td>81</td>
    </tr>
    <tr>
        <td>(&#x27;felizmartes&#x27;, &#x27;mondaymotivation&#x27;, &#x27;temblor&#x27;)</td>
        <td>81</td>
    </tr>
    <tr>
        <td>(&#x27;americanidol&#x27;, &#x27;foodasitcom&#x27;, &#x27;michaelcohen&#x27;)</td>
        <td>80</td>
    </tr>
    <tr>
        <td>(&#x27;foodasitcom&#x27;, &#x27;marilynmonday&#x27;, &#x27;michaelcohen&#x27;)</td>
        <td>80</td>
    </tr>
    <tr>
        <td>(&#x27;fcbsfc&#x27;, &#x27;fft18&#x27;, &#x27;mondaymotivation&#x27;)</td>
        <td>80</td>
    </tr>
    <tr>
        <td>(&#x27;cbx_bloomingdays&#x27;, &#x27;fft18&#x27;, &#x27;temblor&#x27;)</td>
        <td>80</td>
    </tr>
    <tr>
        <td>(&#x27;cbx_bloomingdays&#x27;, &#x27;fcbsfc&#x27;, &#x27;mondaymotivation&#x27;)</td>
        <td>80</td>
    </tr>
    <tr>
        <td>(&#x27;felizmartes&#x27;, &#x27;fft18&#x27;, &#x27;temblor&#x27;)</td>
        <td>80</td>
    </tr>
    <tr>
        <td>(&#x27;fcbsfc&#x27;, &#x27;felizmartes&#x27;, &#x27;temblor&#x27;)</td>
        <td>80</td>
    </tr>
</table>

From these hashtags, first we could infer that some tweets can be sibling and/or family themed-- those that contained #siblings, #family, #sister(s), #brother(s), and #love, and these hashtags tended to co-occur in same tweets. 

Other hashtags, however, seemed confounding with the National Siblings Day:
   * One theme is with the #equalpayday, because April 10 also happened to be the Equal Pay Day, and this hashtag tended to co-occur with #tuesdaythoughts #lifecouldbeeasier #zuckerberg. 
   * Another group of co-occurring hashtags included #brochure, #rack, #flyer, and #roll. 
   * Other random hashtags that appeared in the top trigrams (e.g., #michaelcohen, #mondaymotivation, #fcbsfc) seemed confusing first, but when I looked into the tweets with these hashtags, I found that those tweets seemed to come from bots, and the entire piece of tweets consisted of all kinds of hashtags, for example:
       * '#NationalSiblingsDay\n#FelizMartes\n#temblor\n#CBX_BloomingDays\n#MondayMotivation\n#fft18\n#fcbsfc\n#asiaafricacarnival2018\n#GusIpulMbakPuti\n#PersijaDay\n#CSKvKKR\n#BlackberrysKeepRising\nA great account ❤️👌🏻 A must to follow 😁 \nTwitter: @s_alqhtani7 \nSnap:https://t.co/PYNDtvIx7O'. <br />
   * Another confounding single hashtag is #onlychild. Only children tweeted about National Siblings Day to express their wishes about having siblings, seek compassion from other only children, or highlight their identities as only children. For example:
       * 'Wish I had one #NationalSiblingsDay #onlychild #boo https://t.co/IDH5w2dr6X',
       * 'Shout out to all the Only Childs on #NationalSiblingsDay 🙌🏻\nRemember in French it is said “Je suis fille unique”, it’s good to be unique. It’s not our fault that our parents realised they couldn’t improve on perfection 🤷🏻\u200d♀️ #onlychild',
      * 'Hey Twitter Good Tuesday morning 🐣🐰 Happy national sibling day 👪to everyone who has siblings sincerely from #onlychild'.

Therefore, before the analyses of users and user mentions, I deleted tweets that had these groups of confounding/irrelevant hashtags.

### Text Analyses: Tweet Content
Then I extracted all the tweets text to conduct analyses based on the content. Before all the analyses, I eliminated all the following from the text:
    * http urls
    * words starting with '@' (i.e., mentions) and '#' (i.e., hashtags)
    * 'RT' (term used for retweets)
    * punctuations
    * English stopwords (included in the nltk package)
And I tokenized each tweet text into a list of words, transformed all the words to lower cases, and stemmed all the words so that same words in different formats would be (hopefully) changed into one same format.

#### 1. Ngrams frequency analysis
First, with the cleaned word tokens, I counted the occurences of each single word (i.e., unigrams), and co-occurences of words, including bigrams and trigrams.

* Unigrams <br>
Below is the wordcloud for unigrams. The most common unigrams, unsurprisingly, were 'sibl' (stem for sibling(s)), 'day', 'happi (stem for 'happy'), 'nation', 'broter', and 'sister. Example for other common unigrams include stemmed words for family, celebrate/celebration, thank, and friend, and emojies including '❤' '😂''💕''😘'. However, I did not find any irrelevant common unigrams in the list of 50 most frequent unigrams.
![alt text](https://github.com/sxrpsy/Twitter_National_Sibling_Day/blob/master/output_pictures/Text_Unigram_WordCloud.png)

* Bigrams <br>
Below is the wordcloud for bigrams. The most common bigrams, unsurprisingly, were combinations in "happy national sibling day". Other comon bigrams included "brother sister", "little/big brother/sister", "best friend", "love much", "day ❤". However, I did not find any irrelevant common bigrams in the list of 50 frequent bigrams.
![alt text](https://github.com/sxrpsy/Twitter_National_Sibling_Day/blob/master/output_pictures/Text_Bigram_WordCloud.png)

* Trigrams <br>
Below is the wordcloud for trigrams. The most common trigrams, unsurprisingly, were combinations in "happy national sibling day". Other comon trigrams included "sibling day love/best/brother/❤/sister/💕", '😂 😂 😂'. Again, I did not find any irrelevant common unigrams in the list of 50 frequent bigrams.
![alt text](https://github.com/sxrpsy/Twitter_National_Sibling_Day/blob/master/output_pictures/Text_Trigram_WordCloud.png)
<br>
In sum, analyses in this section could not help me rule out irrelevant tweets for identifying sibling dyads.

#### 2. Topic Modeling- Latent Dirichlet allocation (LDA)
Then I conducted topic modeling to find different topics among the tweets and check whether there were topics that were deviant from the National Siblings Day. I used latent dirichlet allocation (LPA) for topic modeling. LDA performs analyses with pre-determined number of topics. Because I did not know how many topics would fit the models the best prior to the analyses, I performed LDA with a range of number of topics from 1 to 20, and every time obtained two indices, *model perplexity* and *topic coherence*, to find the best option(s) for number of topics. Lower model perplexity and higher topic coherence indicate better topic models.

Below are the model perplexities and topic coherences for each number of topics predifined for LDA. As shown, model perplexity descreased from 3 to 20 topics, whereas topic coherences was the highest with 4 topics. Therefore, I further looked into the 4-topic model for the specific topics that this model found.

![alt text](https://github.com/sxrpsy/Twitter_National_Sibling_Day/blob/master/output_pictures/LDA_perplexity.png)
![alt text](https://github.com/sxrpsy/Twitter_National_Sibling_Day/blob/master/output_pictures/LDA_coherence.png)
<br>


* 4-Topic Model
Keywords generated for each topic of the 4-topic LDA model are:
   * __Topic 1__: 0.061*"love" + 0.045*"sister" + 0.041*"brother" + 0.039*"happi" + 0.026*"best" + 0.025*"…" + 0.018*"littl" + 0.016*"thank" + 0.015*"much" + 0.015*"alway"
   * __Topic 2__: 0.187*"day" + 0.171*"sibl" + 0.120*"nation" + 0.106*"happi" + 0.053*"️" + 0.041*"❤" + 0.018*"love" + 0.015*"…" + 0.011*"\u200d" + 0.008*"sib"
   * __Topic 3__: 0.028*"research" + 0.017*"keyword" + 0.012*"celebr" + 0.006*"new" + 0.006*"2018" + 0.006*"profession" + 0.006*"–" + 0.006*"market" + 0.006*"competitor" + 0.006*"digit"
   * __Topic 4__: 0.033*"sibl" + 0.024*"post" + 0.020*"..." + 0.020*"brother" + 0.018*"like" + 0.018*"😂" + 0.015*"sister" + 0.015*"one" + 0.011*"pictur" + 0.010*"pic" 
<br>
Among these four topics, Topic 3 seems irrelevant to the National Sibilngs Day and least likely to include tweets where users mention their siblings. Therefore, I extracted tweets that include any of the word in the list ['research', 'keyword', 'profession', 'market', 'competitor', 'digit'] and at the same time do not include any of the irrelevant hashtags defined above. After looking into some examples, I found that these tweets include:

* Marketing tweets from business accounts that made some promotions using National Siblings Day. Examples are:
   * "it’s Sibling Day today – we’ve got lots of siblings between us at Suki Marketing, some near, some far, but all dear. #siblingday #siblings #sisters"
   * "There’s no better friends than siblings. The perfect combination of @Cummins X12 and X15 offers customers the Power of Choice for optimum performance, efficiency and weight savings in the heavy duty market. Happy Siblings Day!"
   * "Happy National Siblings Day! You can't pick your siblings...but you can sure pick some sweet strawberries at #KingsFarmMarket"
* Some random marketing tweets that are irrelevant to National Siblings Day but use this hashtag to attract views:
   * "Be professional.Use eye catchy signature to your E-mail.\nYour Email Signature is more than just your name and title.\nplease visit https://t.co/dZRYLWiF7P to create email signature\n #NationalSiblingsDay"
   * "#NationalSiblingsDay\nNeed a professional graphic designer?I am here.\n    #businesscard\n    #professional\n    #custom design\n    #double sided card\n    #uniqe\n    #graphics design\n\nI will make you for $5.\nPlease visit this link:https://t.co/QTqu36ezkk"
   * "With all the speak within the #SEO world a small degree factor that happens to be the muse of #keyword_research. I say that while not #keywords , there isn't any such factor for your #SEO campaigns.https://t.co/BEzTWFTKUv \n#NationalSiblingsDay #GFA20 #CSKvKKR #LEGOIdea2018 #dkbiz https://t.co/IHr9NXrtTt""
* Tweets about research related to siblings. Examples are:
   * "Please help with our ASD and WS sibling research if you can.... #NationalSiblingDay"
   * "Older male siblings are more emotionally stable &amp; socially outgoing, research finds: https://t.co/wpyPeYemRs #NationalSiblingsDay"
   * "Research shows older siblings can actually increase the chances of their siblings living to adulthood\n#NationalSiblingsDay \nhttps://t.co/6YrUj52J9K via @sheffielduni"
* Tweets about 'digital siblings' that are not real siblings. Examples are:
   * "Do you have a favorite digital sibling? #NationalSiblingsDay \n\nMine is Charlie Sheen in major league 1989. @FunSheen @wesleysnipes @BerengerOnline #WildThing #Repost #Love #ChampionsLeague #JerseyShore #golfwang #Tyler #QTip #illmatic #NoDoubt #RIFFRAFF"
   * " Happy to be part of this combo! Also, shoutout to the best Weber sibling, the digitally mysterious @WeberBegley! "
* Some tweets, with keywords in this topic, however, were about real siblings, and tended to be where users talked about how they were proud with their siblings. Examples are:
   * "Happy national siblings day, @gbrenna! Here's a throwback to that one time we totally tricked mom into thinking we broke our arms. How we haven't turned into professional actors yet is beyond me\U0001f929 #siblingsforlife."
   * If you have siblings and they are athletes too, then you know what I mean when I say Training Day is everyday, no matter the sport or the season. Happy #NationalSiblingsDay to my toughest competitors and best teammates."
 <br>
Therefore, I shortened the topic 3 list to ['research', 'keyword', 'market','digit'] and used this list as one of the criteria for filtering out irrelevant tweets.


#### 3. Sentiment Analyses
Finally for text analyses, I conducted sentiment analyses for the tweet content. I expected that irrelevant tweets would have different ranges of sentiment scores than the relevant tweets. Before sentiment analyses, I filtered out the irrelevant tweets that contained any of the irrelevant hashtags or keywords identified in prevoius sections, which resulted in 128,481 tweets in total for following analyses. 

Distributions of the sentiment scores, including compound, positive, negative, and neutral scores, are shown below.
![alt text](https://github.com/sxrpsy/Twitter_National_Sibling_Day/blob/master/output_pictures/sentiment_compound.png)
![alt text](https://github.com/sxrpsy/Twitter_National_Sibling_Day/blob/master/output_pictures/sentiment_pos.png)
![alt text](https://github.com/sxrpsy/Twitter_National_Sibling_Day/blob/master/output_pictures/sentiment_neg.png)
![alt text](https://github.com/sxrpsy/Twitter_National_Sibling_Day/blob/master/output_pictures/sentiment_neu.png)

First, there seemed to be four clusters in the *compound* scores: very positive (>.50; N = 72937), somewhat positive (>.0 and <.50; N = 15595), neutral (=.00; N = 27716), and negative (<.00; N = 12231). Accordingly, I looked into tweets in each cluster to see whether the relevant or irrelevant tweets tended to dominate any cluster. Example tweets in each cluster according to the compound score can be seen [here](https://github.com/sxrpsy/Twitter_National_Sibling_Day/blob/master/sentiment_examples/compound.md). Regrettably, according to the examples, relevant tweets tended to dominate in each cluster, and thus the compound score could not help to filter out irrelevant tweets.

Then, for positive, negative, and neutral scores, I looked into clusters that seemed deviant from the majority of the distribution, which was >.70 for positive, >.20 for negative, and <.30 for neutral scores. Example tweets for these three "deviant" clusters can be found [here](https://github.com/sxrpsy/Twitter_National_Sibling_Day/blob/master/sentiment_examples/pos_neg_neu.md). Again, sadly, I found both relevant and irrelevant tweets in all those three clusters and so it seemed that I could not use the sentiment analysis or scores to filter out irrelevant tweets.

#### 4. Summary of Text Analysis: Criteria Used to Filter Out Irrelevant Tweets
In sum, the whole process of text analysis helped me to determine the following criteria to select relevant tweets for identifying siblings and filter out irrelevant tweets:
* Only keep original tweets by filtering out retweets,
* Only keep tweets that were identified as in English,
* Filter out tweets that contained any of the irrelevant hashtags, including 
   * '#equalpayday', '#tuesdaythoughts', '#lifecourbeeasier', '#zuckerberg', #brochure', '#rack', '#flyer', '#roll', '#cbx_bloomingdays', '#felizmartes', '#temblor', '#mondaymotivation', '#americanidol', '#foodasitcom', '#michaelcohen', '#fcbsfc', '#fft18', '#michaelcohen', "#onlychild",
* Filter out tweets that contained any of the irrelevant keywords, including
   * 'research', 'keyword', 'market','digit'.

However, neither ngrams analyses of the tweet content nor the sentiment analysis helped me to determine other criterion for filtering.

### Identify Sibling Users
Using the filtering criteria determined by the text analyses together with subsetting tweets that mentioned at least one Twitter account resulted in a subset of 24,031 tweets for identifying sibling users. For each tweet, the user who post the tweet is refered as "User 1" hereafter.

With the subset of tweets where Twitter users who could potentially be siblings, I conducted botcheck to rule out non-human users. Noteably, the Botometer API only allows 17,280 requests per day, per user, which corresponds to Twitter's REST API rate limit, 180 requests per 15-minute window under user authentication. Thus running botcheck for all the users identified is time-consuming, and here I want to acknowledge [Tingyu Mao](https://www.linkedin.com/in/tingyu-mao-07812ba2?trk=chatin_wnc_redirect_pubprofile) and [Mengjun Han](https://angel.co/mengjun-han) who helped me run botcheck for a considerable proportion of users in the dataset. 

First, the botcheck was performed among the 24,031 Users 1, to rule out tweets post by the non-human users. Botometer API does not distinguish human vs. non-human users, but returns the *probability* of one Twitter account to be non-human. Documention of the API does not suggest a cutoff for the probability, but an ongoing study with bullying tweets has found that accounts with probability lower than .50 were very likely to be human users, though this cutoff was relatively stringent and could have a high false negative rate, that is, some human users could have probability over .50 (Zhang & Felmlee, in progress). In this study I prefer lower false positive than false negative rate, thus I adopted the .50 cutoff to filter out all users with the botcheck probability returned as larger than .50. 

Below is the distribution of bot probability for Users 1. Among these 24,031 users, 645 returned botcheck score as NULL, and possible reasons can be that their accounts were protected (due to their privacy setting), suspended, or deleted; 979 had bot probability larger than .50. After deleting the users that either had NULL or above .50 botcheck score, 22,407 Users 1 (and tweets) were left in the dataset.
![alt text](https://github.com/sxrpsy/Twitter_National_Sibling_Day/blob/master/output_pictures/user1_botcheck.png)

Then with these 22,407 tweets, I further conducted botcheck among all the users mentioned in the tweets. A large majority of these tweets (17,150) only had one mention, but there were also a considerble number of tweets had two or more, up to 11, mentions. Although it is very unlikely that all of these 11 mentions are siblings, it is possible that at least one of the mentions is a sibling, and others can be other human or non-human users. The total number of user mentions among these tweets were 30,498. 

Again, using botcheck, I filtered out all the mentioned accounts that had either NULL or above .50 botcheck scores. The aim was to keep all the tweets that had *at least one* mentioned user as having a botcheck score lower than .50. Results showed that, however, all the 22,407 tweets reached this criterion, and thus no tweets were deleted in this step. 

### Validate Sibling Users Identified in the Previous Step
I randomly selected 200 tweets from the 22,407 tweets and manually checked whether the User 1 was a sibling with at lease one of the users mentioend in each tweet, based on the tweet content and the user profiles. Among the 200 dyads (or triads and more) of siblings, I found 140 as actual siblings, and thus I got a true positive rate as 70%. These actual siblings usually either shared same last names in their user names or profile names, or post childhood pictures for a throwback in the tweet. Some tweets also showed sibling rivalry (in a sarcastic way), for example, "happy national siblings day losers ❣️ love to hate yaa, @username2 @username3", which reflected the love-hate relationship characteristic in sibling dynamics (Dunn, 2002). 

For the 30% who I found were not actual siblings, they can be:
* Friends who stated their relationships were as close as siblings:
  * "happy siblings day to my sista from another mother @username2 ❤️❤️❤️"
  * "Happy #NationalSiblingsDay to @username2 since everyone thinks we are siblings anyways lol....ð❤️ð #bestfriends #brid"
  * "When you’re an only child, but I count @username2 as my siblings. ❤️ #NationalSiblingsDay"
* Colleagues at work or in the same occupations who show their close relationship:
  * "Happy #nationalsiblingsday @GIGCatering @username2 and @username3 #GIGLegends #Cateringheadlinerssince1984 #makeithappenpeople"
* Two or more users mentioned in the tweets were siblings with each other, but not with User 1 (friend, parent, or fan):
  * "Happy National Siblings day to these two beauties!! ððð @username2 @username3"
  * "It’s #NationalSiblingsDay Mia and AJ   @username2 and @username3  Enjoy the day you crazy kids! ð "
  * "Dominance comes in many forms like @uclabeachvb twin duo @username2 and @username3. #NationalSiblingsDay"
  * "my favourite on screen sisters, definitly Wynonna and Wavery Earp! @DominiqueP_C @melanie0n  #NationalSiblingsDay"
* Non-human users whose botcheck scores were lower than .50:
  * Reagan_Airport:	"Wishing @Dulles_Airport a happy #NationalSiblingsDay. What a pretty baby picture. ð¶"
  * "Beers with my brother. #NationalSiblingsDay - Drinking a Chocolate Sombrero (2017) by @clownshoesbeer"
  * "#NationalSiblingsDay We Are Family https://t.co/UCgZvP2i7F via @YouTube https://t.co/DPgIkPJjB7"
* Users who retweeted another tweet celebrating National Siblings Day and added some comments, which could not be filtered out by the "retweet_status" in the Twitter object.

## Summary
In this project, I streamed in 383,040 tweets posted on National Siblings Day, 2018, in order to identify sibling users on Twitter using these tweets. To filter out irrelevant tweets, I conducted text analysis, including hashtag and tweet content ngrams, topic modeling, and sentiment analysis, to determine filtering criteria, which resulted in 128,481 tweets retained. Then I selected the subset of tweets that contained user mentions, resulting in 24,031 tweets. Further, I conducted botcheck to filter out users who had relatively high likelihood of being non-human accounts, and finally led to 22,407 tweets for validation. Validation of randomly selected 200 tweets from this final subset showed a 70% true positive rate and found some characteristics that often appeared among tweets for actual siblings, such as same last name in usernames and/or screen names, childhood pictures, and love-hate language. Therefore, to further increase the true positive rate, more natural language processing tools can be utilized to determine filtering criteria.

## Asking for Comments or Suggestions:
I would appreciate a lot if you could leave any comments or suggestions for this project! Also, I have some specific concerns for which I would like your feedback!
* Should I conduct text analysis *after* the user-mention filtering instead? In other words, I am wondering if it is better to find out common themes in tweets where people talked about National Siblings Dat *and* mentioned another Twitter account. I did not take this sequence in my analyses because I wanted to get an idea about what people were tweeting about on National Siblings Day in general, and the whole dataset was much larger than the user-mention subset, which could made sure that I had enough data for counting common ngrams and topic modeling.
* Any other text analyses I can do to filter out irrelevant tweets?
* Any other analyses I can do to determine sibling users, especially after seeing the manual classification descriptives?
* Is .70 as true positive rate good enough? How should I determine the cutoff?
* Should I also check the true negative rate?
* Specific question for Tim: Since you know my other Twitter study (based on Christmas, 2015 data and 279 sibling dyads identified with manual classification), do you think this project is a separate paper from that study, or I should combine these two samples? Also, what kind of connection or cross-validation do you think I can build between these two samples?

## References
* Davis, C. A., Varol, O., Ferrara, E., Flammini, A., & Menczer, F. (2016, April). Botornot: A system to evaluate social bots. In *Proceedings of the 25th International Conference Companion on World Wide Web* (pp. 273-274). International World Wide Web Conferences Steering Committee.
* Dunn, J. (1983). Sibling relationships in early childhood. *Child Development, 54,* 787. doi:10.2307/1129886
* Dunn, J. (2002). Sibling relationships. In P. K. Smith & C. H. Hart (Eds.), *Blackwell handbook of childhood social development* (pp. 223–237). Malden, MA: Blackwell.
* Garimella, V. R. K., Weber, I., & Dal Cin, S. (2014, November). From “I love you babe” to “leave me alone”-Romantic Relationship Breakups on Twitter. In *International Conference on Social Informatics* (pp. 199-215). Springer, Cham. doi:10.1007/978-3-319-13734-6_14
* LeBouef, S. & Dworkin, J. (2017, November). *Near, Far, Wherever You Are: Siblings and Social Media Communication*. Paper presented at the National Council on Family Relations. Orlando, FL.
* McHale, S. M., Updegraff, K. A., & Whiteman, S. D. (2012). Sibling relationships and influences in childhood and adolescence. *Journal of Marriage and Family, 74*, 913-930. doi:10.1111/j.1741-3737.2012.01011.x
* Sun, X., Chi, G., Yin, J., & McHale, S. M. (*in progress*). [*Siblings’ Interactions and Shared Interests on Twitter: Analyses of A Selected Sibling Sample Based on Archived Twitter Data*.](https://github.com/sxrpsy/Twitter_National_Sibling_Day/blob/master/output_pictures/Sun%20Twitter%202018-4-11.pdf)
* Pew Research Center (2018). *Social Media Use in 2018*. Retrived from http://www.pewinternet.org/2018/03/01/social-media-use-in-2018/.
* Zhang, A., & Felmlee, D. (*in progress*). *You \*&#\*%!: Identifying Bullying Tweets.*
* Zhao, D., & Rosson, M. B. (2009, May). How and why people Twitter: the role that micro-blogging plays in informal communication at work. In *Proceedings of the ACM 2009 international conference on Supporting group work* (pp. 243-252). ACM. doi:10.1145/1531674.1531710
