---
layout: base
title: N-grams
---

## Contents

* [Introduction](#introduction)
* [Bigrams](#bigrams)
* [From bigrams to n-grams](#ngrams)
* [Collocations](#collocations)

<a name="introduction"/>
## Introduction

In the previous chapter, we have looked at words, and the combination of words into a
higher level of meaning representation: a sentence. As you might recall being told by your high school grammar teacher, not every random combination of words forms an grammatically acceptable sentence:

Colorless green ideas sleep furiously<br/>
\* Furiously sleep ideas green colorless<br/>
\* Ideas furiously colorless sleep green<br/>

The sentence *Colorless green ideas sleep furiously* (made famous by the linguist Noam
Chomsky), for instance, is grammatically perfectly acceptable, but of course entirely
non-sensical (unless you ate wrong/weird mushrooms, that is). If you compare this
sentence to the other two sentences, this grammaticality becomes evident. The sentence
*Furiously sleep ideas green colorless* is grammatically unacceptable, and so is *Ideas
furiously colorless sleep green*: these sentences do not play by the rules of the
english language. In other words, the fact that languages have rules constraints the
way in which words can be combined into an acceptable sentences. 

Hey! That sounds good (we can almost here your think) for us NLP programmers, language
play by rules, computers work with rules, well, we're done, aren't we? We'll infer a
set of rules, and there! we have ourselves *language model*. A model that describes how
a language, say English, works and behaves. Well, not so fast buster! Although we will
certainly discuss our share of such rule-based language models later on (in the chapter
about parsing), the fact is that nature is simply not so simple. The rules by which a
language plays are very complex, and no full set of rules to describe a language has
ever been proposed. Bummer, isn't it? Lucky for us, there are simpler ways to obtain a
language model, namely by exploiting the observation that words do not combine in a
random order. That is, we can learn a lot from a word and its neighbors. Language
models that exploit the ordering of words, are called *n-gram language models*, in
which the *n* represents any integer greater than zero.

N-gram models can be imagined as placing a small window over a sentence or a text, in
which only *n* words are visible at the same time. The simplest n-gram model is
therefore a so-called *unigram* model. This is a model in which we only look at one
word at a time. The sentence *Colorless green ideas sleep furiously*, for instance,
contains five unigrams: "colorless", "green", "ideas", "sleep", and "furiously". Of
course, this is not very informative, as these are just the words that form the
sentence. In fact, N-grams start to become interesting when *n* is two (a *bigram*) or
greater. Let us start with bigrams.

<a name="bigrams"/>
## Bigrams

An unigram can be thought of as a window placed over a text, such that we only look at
one word at a time. In similar fashion, a bigram can be thought of as a window that
shows two words at a time. The sentence *Colorless green ideas sleep furiously*
contains four bigrams:

* Colorless, green
* green, ideas
* ideas, sleep
* sleep, furiously

To stick to our 'window' analogy, we could say that all bigrams of a sentence can be
found by placing a window on its first two words, and by moving this window to the
right one word at a time in a stepwise manner. We then repeat this procedure, until the
window covers the last two words of a sentence. In fact, the same holds for unigrams
and N-grams with *n* greater than two. So, say we we have a body of text represented as
a list of words or tokens (whatever you prefer). For the sake of legacy, we will stick
to a list of words representing the sentence *Colorless green ideas sleep furiously*:

{% highlight haskell %}
Prelude> ["Colorless", "green", "ideas", "sleep", "furiously"]
["Colorless","green","ideas","sleep","furiously"]
{% endhighlight}

Hey! That looks like... indeed, that looks like a list of unigrams! Well, that was
convenient. Unfortunately, things do not remain so simple if we move from unigrams to
bigrams or *some-very-large-n*-grams.

{% highlight haskell %}
Prelude> take 2 ["Colorless", "green", "ideas", "sleep", "furiously"]
["Colorless","green"]
Prelude> 

{% endhighlight}
<a name="ngrams"/>
## From bigrams to n-grams
stub

<a name="collocations"/>
## Collocations
stub