# Sibling Interactions on Twitter
## A Sample Identified by Tweets About National Siblings Day on April 10, 2018
This is a class project for Timothy Brick's HDFS 597 "Mining Internet with Python" at the Pennsylvania State University.
* Copyrights to Xiaoran Sun, MS, and Timothy Brick, Ph.D., at the Pennsylvania State University.
* For citation, please contact Xiaoran Sun xiaoran.sun@psu.edu

## Study Background
Siblings play important role in one another's development (Dunn, 1983; McHale, Updegraff, & Whiteman, 2012). Research on siblings has used global questionnaires and interviews to examine their relationships and interactions, mostly through *offline* activities. However, although social media has become an important part of many people's life, especially among youth and young adults (Pew Research Center, 2016), we know much less about how they interact *online*, including on social media (LeBouef & Dworkin, 2017). Twitter is a platform that people use for social networking and obtaining information (Zhao & Rosson, 2009). I use Twitter to examine sibling interactions online because it provides free, open source data through the API, and previous research has used data from Twitter to capture interactions between romantic partners (Garimella, Weber, & Cin, 2014).

Identifying sibling users on Twitter can be time-consuming, involving a large amount of human annotation work (Sun, Chi, Yin, & McHale, in progress). However, the National Sibling Day on April 10 may allow us to identify sibling Twitter users in a more efficient way. On that day, #NationalSiblingsDay (and other similar hashtags) is a trending topic on Twitter, and people tend to tweet that topic and mention their siblings in the tweet. Therefore, collecting tweets about that topic on that particular day and utilizing a subset of those where one user mentions the other(s), we are likely to identify sibling users in a potentially reliable way.

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
Before identifying siblings using the data, I would like to know what the users were talking about when they tweeted about National Siblings Day, using text analyses. Before analyses, I expected that possibilities include:
  * individual human users mentioned their siblings on Twitter and celebrate the day,
  * individual human users post past pictures with their siblings in memory of their experiences,
  * non-human accounts celebrate the day for example, by mentioning how siblings are precious,
  * non-human bussiness accounts make promotions for this day.

Text analyses conducted include:
  * descriptives of the hashtags, including occurrences and co-occurrences (i.e., bigrams, trigrams) of hashtags,
  * descriptives of the tweets' content, including 
       * word frequency and ngrams frequency, 
       * topic modeling- LDA,
       * word clustering analyses - k-means.

In the analyses, I was only interested in what people were *tweeting*, but not *retweeting*, given that popular accounts with tweets that have been retweeted many times can be extremely overrepresentative in the sampled tweets. I also got rid of tweets that were identified as in languages other than English. These two subsetting rules resulted in 132,469 tweets for text analyses.

The corresponding code file is `01_text_analyses.ipynb`.

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

From these hashtags, first we could infer that some tweets can be sibling and/or family themed-- those that include #siblings, #family, #sister(s), #brother(s), and #love, and these hashtags tended to co-occur. Other hashtags, however, seemed confounding with the National Siblings Day. One theme is with the #equalpayday, because April 10 also happened to be the Equal Pay Day, and this hashtag tended to co-occur with #tuesdaythoughts #lifecouldbeeasier. Another group of co-occurring hashtags included #brochure, #rack, #flyer, and #roll. Other random hashtags that appeared in the top trigrams (e.g., #michaelcohen, #mondaymotivation, #fcbsfc) looked confusing first, but when I looked into the tweets with these hashtags, I found that those tweets seemed to come from bots and the entire piece of tweets consisted of all kinds of hashtags, for example: '#NationalSiblingsDay\n#FelizMartes\n#temblor\n#CBX_BloomingDays\n#MondayMotivation\n#fft18\n#fcbsfc\n#asiaafricacarnival2018\n#GusIpulMbakPuti\n#PersijaDay\n#CSKvKKR\n#BlackberrysKeepRising\nA great account ❤️👌🏻 A must to follow 😁 \nTwitter: @s_alqhtani7 \nSnap:https://t.co/PYNDtvIx7O'. <br />
Therefore, before the analyses of users and user mentions, I deleted tweets that had these groups of confounding/irrelevant hashtags.

