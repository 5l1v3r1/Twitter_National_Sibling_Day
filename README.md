# Sibling Interactions on Twitter
## A Sample Identified by Tweets About National Siblings Day on April 10, 2018
This is a class project for Timothy Brick's HDFS 597 "Mining Internet with Python" at the Pennsylvania State University.
* Copyrights to Xiaoran Sun, MS, and Timothy Brick, Ph.D., at the Pennsylvania State University.
* For citation, please contact Xiaoran Sun xiaoran.sun@psu.edu

## Study Background
Siblings play important role in one another's development (Dunn, 1983; McHale, Updegraff, & Whiteman, 2012). Research on siblings has used global questionnaires and interviews to examine their relationships and interactions, mostly through *offline* activities. However, although social media has become an important part of many people's life, especially among youth and young adults (Pew Research Center, 2016), we know much less about how they interact *online*, including on social media (LeBouef & Dworkin, 2017). Twitter is a platform that people use for social networking and obtaining information (Zhao & Rosson, 2009). I use Twitter to examine sibling interactions online because it provides free, open source data through the API, and previous research has used data from Twitter to capture interactions between romantic partners (Garimella, Weber, & Cin, 2014).

One important step to examine sibling interactions on Twitter is to identify siblings, but the identifying process can be time-consuming and expensive, involving a large amount of human annotation work (Sun, Chi, Yin, & McHale, in progress). However, the National Sibling Day on April 10 may allow us to identify sibling Twitter users in a more efficient way. On that day, #NationalSiblingsDay (and other similar hashtags) is a trending topic on Twitter, and people tend to tweet that topic and mention their siblings in the tweet. Therefore, collecting tweets about that topic on that particular day and utilizing a subset of those where one user mentions the other(s), we are likely to identify sibling users in a potentially reliable way.

Accordingly, in this study, I obtained real-time tweets about National Siblings Day, and used text analysis to identify characteristics that could potentially be helpful to filter relevant tweets that potentially could help to identify sibling Twitter users. Using the characteristics, I filtered potentially relevant tweets, which I then used to identify siblings by the users' mentions in the tweets. With these users identified, I further filtered out the non-human users using BotCheck (Davis, Varol, Ferrara, Flammini, & Menczer, 2016). Finally, 

## Method
### Streaming Tweets about National Siblings Day
Starting from 9pm, April 9th, until 4am, April 11st, I used Twitter Streaming API to filter realtime tweets that have any of the hashtags (case-insensitive), including "#nationalsiblingday", "#nationalsiblingsday", "#nationalsibday", "#nationalsibsday", "#siblingday", "#siblingsday", "#sibday", and "#sibsday", and/or any of the key words, including "sibling day", "siblings day", "sibling's day", "sib day", "sib's day", and "sibs day". I stored the tweets in json format on my disk. 

The corresponding code file is `00_DiskListener.py`, created by Timothy Brick, with little edits by Xiaoran Sun for filtering criterion.

This resulted in 383,040 tweets, with the total data file size as around 2.5GB. To get these raw data, please contact Xiaoran Sun.

### Pre-Processing Raw Data Files
The raw data file (in json) is too large and when it's read in Jupyter as a whole, my laptop would crash. Therefore, I used bash command (on the Terminal application) to separate the json file by lines into separate text files.

To separate a big json file into smaller files that are not larger than 30,000 lines, I used:
`split -l 30000 filename.json`

But these smaller files cannot be read directly into jupyter due to their incompleteness. Therefore, at the beginning of each file, I had to make sure there was or I added a `[`, and at the end of each file, `]`.

To check whether these files are complete as json lists and also get to know the length of each file, I used (bash command):
`jq '. | length' SmallFileName`. When checked by this command, there was some parse error or EOF with some small files, and I found that it was because `"` at the beginning or the end was reformatted into `“` or `”`. These quotation marks had to be formatted back. I did it manually, but I know it is better to write codes for this task and I will update on this soon.

### Text Analyses
Before identifying siblings using the data, I examined what the the users were talking about when they tweeted about National Siblings Day, using text analyses. This procedure was mainly for identifying irrelevant or confounding tweets in the dataset where users were not very possible talking about, especially mentioning their siblings. Characteristics, including hashtags, keywords, and topics, found in this procedure could be used as selection criteria to filter out confounding tweets and keep those that would be relevant.

Text analyses conducted include:
  * descriptives of the hashtags, including occurrences and co-occurrences (i.e., bigrams, trigrams) of hashtags,
  * descriptives of the tweets' content, including 
       * word frequency and ngrams frequency, 
       * topic modeling,
       * sentiment analyses.

In the analyses, I was only interested in what people were *tweeting*, but not *retweeting*, given that popular accounts with tweets that have been retweeted many times can be extremely overrepresentative in the sampled tweets. I also got rid of tweets that were identified as in languages other than English. These two subsetting rules resulted in 132,469 tweets for text analyses.

The corresponding code file is `01_text_analyses.ipynb`. <br>
I used the `nltk` and `genism` python package for text analyses.

## Results
### Text Analyses: Hashtags
Hashtags extracted from all the tweets include 101,525 single hashtags, 62,612 bigrams, and 31,328 trigrams.
The four most frequent single hashtags are #nationalsiblingsday, #nationalsiblingday, #siblingsday, and #siblingday. To make a better representation of other hashtags, I deleted those four from the single hashtag list and bigrams and trigrams that contain any of these four hashtags. With this exclusion criterion, the 15 most frequent occurring single hashtags, bigrams, and trigrams are displayed below respectively.

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

From these hashtags, first we could infer that some tweets can be sibling and/or family themed-- those that include #siblings, #family, #sister(s), #brother(s), and #love, and these hashtags tended to co-occur. 

Other hashtags, however, seemed confounding with the National Siblings Day:
   * One theme is with the #equalpayday, because April 10 also happened to be the Equal Pay Day, and this hashtag tended to co-occur with #tuesdaythoughts #lifecouldbeeasier. 
   * Another group of co-occurring hashtags included #brochure, #rack, #flyer, and #roll. 
   * Other random hashtags that appeared in the top trigrams (e.g., #michaelcohen, #mondaymotivation, #fcbsfc) looked confusing first, but when I looked into the tweets with these hashtags, I found that those tweets seemed to come from bots and the entire piece of tweets consisted of all kinds of hashtags, for example:
       * '#NationalSiblingsDay\n#FelizMartes\n#temblor\n#CBX_BloomingDays\n#MondayMotivation\n#fft18\n#fcbsfc\n#asiaafricacarnival2018\n#GusIpulMbakPuti\n#PersijaDay\n#CSKvKKR\n#BlackberrysKeepRising\nA great account ❤️👌🏻 A must to follow 😁 \nTwitter: @s_alqhtani7 \nSnap:https://t.co/PYNDtvIx7O'. <br />
   * Another confounding single hashtag is #onlychild. Only children tweeted about National Siblings Day to express their wishes about having siblings, seek compassion from other only children, or highlight their identities as only children. For example:
       * 'Wish I had one #NationalSiblingsDay #onlychild #boo https://t.co/IDH5w2dr6X',
       * 'Shout out to all the Only Childs on #NationalSiblingsDay 🙌🏻\nRemember in French it is said “Je suis fille unique”, it’s good to be unique. It’s not our fault that our parents realised they couldn’t improve on perfection 🤷🏻\u200d♀️ #onlychild',
      * 'Hey Twitter Good Tuesday morning 🐣🐰 Happy national sibling day 👪to everyone who has siblings sincerely from #onlychild'.

Therefore, before the analyses of users and user mentions, I deleted tweets that had these groups of confounding/ irrelevant hashtags.

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
Blow is the wordcloud for unigrams. The most common unigrams, unsurprisingly, were 'sibl' (stem for sibling(s)), 'day', 'happi (stem for 'happy'), 'nation', 'broter', and 'sister). Example for other common unigrams include stemmed words for family, celebrate/celebration, thank, and friend, and emojies including '❤' '😂''💕''😘'. However, I did not find any irrelevant common unigrams in the list of 50 most frequent unigrams.
![alt text](https://github.com/sxrpsy/Twitter_National_Sibling_Day/blob/master/output_pictures/Text_Unigram_WordCloud.png)

* Bigrams <br>
Blow is the wordcloud for bigrams. The most common bigrams, unsurprisingly, were combinations in "happy national sibling day". Other comon bigrams included "brother sister", "little/big brother/sister", "best friend", "love much", "day ❤". However, I did not find any irrelevant common bigrams in the list of 50 frequent bigrams.
![alt text](https://github.com/sxrpsy/Twitter_National_Sibling_Day/blob/master/output_pictures/Text_Bigram_WordCloud.png)

* Trigrams <br>
Blow is the wordcloud for trigrams. The most common trigrams, unsurprisingly, were combinations in "happy national sibling day". Other comon trigrams included "sibling day love/best/brother/❤/sister/💕", '😂 😂 😂'. Again, I did not find any irrelevant common unigrams in the list of 50 frequent bigrams.
![alt text](https://github.com/sxrpsy/Twitter_National_Sibling_Day/blob/master/output_pictures/Text_Trigram_WordCloud.png)
<br>
In sum, analyses in this section could not help me rule out irrelevant tweets for identifying sibling dyads.

#### 2. Topic Modeling- Latent Dirichlet allocation (LDA)
Then I conducted topic modeling to find different topics among the tweets and check whether there were topics that were deviant from the National Siblings Day. I used latent dirichlet allocation (LPA) for topic modeling. LDA performs analyses with pre-determined number of topics. Because I did not know how many topics would fit the models the best prior to the analyses, I performed LDA with a range of number of topics from 1 to 20, and every time obtained two indices, *model perplexity* and *topic coherence*, to find the best option(s) for number of topics. Lower model perplexity and higher topic coherence indicate better topic models.

Below are the model perplexities and topic coherences for each number of topics predifined for LDA. As shown, model perplexity descreased from 3 to 20 topics, whereas topic coherences peaked at the model with 4 topics and 11 topics. Therefore, I further looked into the 4-topic, 11-topic, and 20-topic models for the specific topics that these models found.

![alt text](https://github.com/sxrpsy/Twitter_National_Sibling_Day/blob/master/output_pictures/LDA_perplexity.png)
![alt text](https://github.com/sxrpsy/Twitter_National_Sibling_Day/blob/master/output_pictures/LDA_coherence.png)
