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

## Results
### Text Analyses: Hashtags
Hashtags extracted from all the tweets include 329,479 single hashtags, 182,753 bigrams, and 68,185 trigrams

*Occurrences of single hashtags* <br />
The 20 most frequent hashtags among the tweets are:
<table>
    <tr>
        <th>Hashtag</th>
        <th>Count</th>
    </tr>
    <tr>
        <td>nationalsiblingsday</td>
        <td>157375</td>
    </tr>
    <tr>
        <td>nationalsiblingday</td>
        <td>39878</td>
    </tr>
    <tr>
        <td>blackpanther</td>
        <td>9828</td>
    </tr>
    <tr>
        <td>shuri</td>
        <td>7037</td>
    </tr>
    <tr>
        <td>strangerthings</td>
        <td>6609</td>
    </tr>
    <tr>
        <td>incredibles2</td>
        <td>4399</td>
    </tr>
    <tr>
        <td>starwars</td>
        <td>4182</td>
    </tr>
    <tr>
        <td>supernatural</td>
        <td>4038</td>
    </tr>
    <tr>
        <td>siblingsday</td>
        <td>3670</td>
    </tr>
    <tr>
        <td>premiosmtvmiaw</td>
        <td>3132</td>
    </tr>
    <tr>
        <td>mtvbrkpopbts</td>
        <td>2762</td>
    </tr>
    <tr>
        <td>siblingday</td>
        <td>1537</td>
    </tr>
    <tr>
        <td>siblings</td>
        <td>1244</td>
    </tr>
    <tr>
        <td>zuckerberg</td>
        <td>1148</td>
    </tr>
    <tr>
        <td>tuesdaythoughts</td>
        <td>1104</td>
    </tr>
    <tr>
        <td>family</td>
        <td>1013</td>
    </tr>
    <tr>
        <td>theoriginals</td>
        <td>994</td>
    </tr>
    <tr>
        <td>mciliv</td>
        <td>909</td>
    </tr>
    <tr>
        <td>cskvkkr</td>
        <td>887</td>
    </tr>
    <tr>
        <td>resist</td>
        <td>832</td>
    </tr>
</table>

*Occurrences of hashtag bigrams* <br />
The 10 most frequent hashtag bigrams among the tweets are:
<table>
    <tr>
        <th>Hashtag</th>
        <th>Count</th>
    </tr>
    <tr>
        <td>(&#x27;blackpanther&#x27;, &#x27;nationalsiblingsday&#x27;)</td>
        <td>9813</td>
    </tr>
    <tr>
        <td>(&#x27;nationalsiblingsday&#x27;, &#x27;shuri&#x27;)</td>
        <td>7035</td>
    </tr>
    <tr>
        <td>(&#x27;blackpanther&#x27;, &#x27;shuri&#x27;)</td>
        <td>7030</td>
    </tr>
    <tr>
        <td>(&#x27;nationalsiblingsday&#x27;, &#x27;strangerthings&#x27;)</td>
        <td>6607</td>
    </tr>
    <tr>
        <td>(&#x27;incredibles2&#x27;, &#x27;nationalsiblingsday&#x27;)</td>
        <td>4387</td>
    </tr>
    <tr>
        <td>(&#x27;nationalsiblingsday&#x27;, &#x27;starwars&#x27;)</td>
        <td>4164</td>
    </tr>
    <tr>
        <td>(&#x27;nationalsiblingsday&#x27;, &#x27;supernatural&#x27;)</td>
        <td>3935</td>
    </tr>
    <tr>
        <td>(&#x27;mtvbrkpopbts&#x27;, &#x27;premiosmtvmiaw&#x27;)</td>
        <td>2758</td>
    </tr>
    <tr>
        <td>(&#x27;nationalsiblingsday&#x27;, &#x27;premiosmtvmiaw&#x27;)</td>
        <td>1455</td>
    </tr>
    <tr>
        <td>(&#x27;mtvbrkpopbts&#x27;, &#x27;nationalsiblingsday&#x27;)</td>
        <td>1439</td>
    </tr>
</table>

*Occurrences of hashtag trigrams* <br />
The 10 most frequent hashtag trigrams among the tweets are:
<table>
    <tr>
        <th>Hashtag</th>
        <th>Count</th>
    </tr>
    <tr>
        <td>(&#x27;blackpanther&#x27;, &#x27;nationalsiblingsday&#x27;, &#x27;shuri&#x27;)</td>
        <td>7026</td>
    </tr>
    <tr>
        <td>(&#x27;mtvbrkpopbts&#x27;, &#x27;nationalsiblingsday&#x27;, &#x27;premiosmtvmiaw&#x27;)</td>
        <td>1424</td>
    </tr>
    <tr>
        <td>(&#x27;mciliv&#x27;, &#x27;resist&#x27;, &#x27;soros&#x27;)</td>
        <td>818</td>
    </tr>
    <tr>
        <td>(&#x27;cskvkkr&#x27;, &#x27;mciliv&#x27;, &#x27;soros&#x27;)</td>
        <td>818</td>
    </tr>
    <tr>
        <td>(&#x27;cskvkkr&#x27;, &#x27;mciliv&#x27;, &#x27;resist&#x27;)</td>
        <td>818</td>
    </tr>
    <tr>
        <td>(&#x27;dragonballz&#x27;, &#x27;gohanandgoten&#x27;, &#x27;nationalsiblingsday&#x27;)</td>
        <td>643</td>
    </tr>
    <tr>
        <td>(&#x27;clothes&#x27;, &#x27;nationalsiblingday&#x27;, &#x27;win&#x27;)</td>
        <td>484</td>
    </tr>
    <tr>
        <td>(&#x27;boohoo&#x27;, &#x27;clothes&#x27;, &#x27;nationalsiblingday&#x27;)</td>
        <td>483</td>
    </tr>
    <tr>
        <td>(&#x27;boohoo&#x27;, &#x27;clothes&#x27;, &#x27;win&#x27;)</td>
        <td>482</td>
    </tr>
    <tr>
        <td>(&#x27;equalpayday&#x27;, &#x27;nationalsiblingsday&#x27;, &#x27;tuesdaythoughts&#x27;)</td>
        <td>293</td>
    </tr>
</table>
