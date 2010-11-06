---
layout: base
title: Words
---

## Contents

* [Introduction](#introduction)
* [Playing with words](#playwithwords)
* [From words to sentences](#sentences)
* [A note on tokenization](#tokenization)
* [Word lists](#wordlist)
* [Word frequency lists](#freqlist)

<a name="introduction"/>
## Introduction

Words are the most fundamental building blocks of our language.
Although they may look simple on the surface, they are very ingenious
devices that pack not only meaning, but also grammatical information. 
For our purposes, we will say that a words consists of a *stem* and 
*affixes*. Let's look at three simple sentences:

I **walk**.<br/>
John **walk**s.<br/>
Jack **walk**ed.<br/>

All three sentences contain some 'form' of *walk*. We say that these
instances are all *inflections* of the verb *walk*. The part of the
inflections that is shared (*walk*) is what we call the *stem*. The
parts that are not common are named *affixes*. We inflect verbs
to indicate tense (present, past, etc.), the person of the verb's subject
(first, second, and third person), and the number (singular or plural).
The affix *s* in John walk*s*, for instance, tells us (in combination
with the subject John) that the verb *walk* is in present tense, 
third person singular.

Other types of words have inflections as well. For example, we inflect
nouns to distinguish singular and plural:

I saw one **duck**.<br />
I saw two **duck**s.

Up to this point, we have just seen one kind of affix: one that is
glued to the end of the word. There are actually many kinds of affixes.
For now, you should only know about two:

 * Prefix: appears in front of the stem. For example, *un*believable.
 * Suffix: appears after the stem. For example, duck*s*.

Now, with that out of the way, let's get some work done.

<a name="playwithwords"/>
## Playing with words

Written words consists of characters. We can write down characters in
Haskell with single quotes. If you type in a character in *ghci*, it
will simply echo back the character:

{% highlight haskell %}
Prelude> 'h'
'h'
{% endhighlight %}

This is all that *ghci* does, it evaluates whatever you type. A character
evaluates to... a character. We confirm that Haskell agrees with us that
this actually a character by asking the type with *:type* or its shorthand
*:t*:

{% highlight haskell %}
Prelude> :t 'h'
'h' :: Char
{% endhighlight %}

Great. Not all that practical with the small amount of single-lettered words
in English. Rather than a single character, we want a sequence of characters.
Not surprisingly, Haskell has a data types to build sequences. The most
commonly used sequence is the list. You can have lists of many things: lists
of groceries, lists of planets, and lists of characters. We can make a
literal list in Haskell by enumerating its elements, separated by commas and
surrounded by square brackets. For instance, the list *1, 2, 3, 4, 5* is
written as *[1, 2, 3, 4, 5]*. Let's try to make a list of characters:

{% highlight haskell %}
Prelude> ['h','e','l','l','o']
"hello"
{% endhighlight %}

Now we are getting somewhere! Let's look at the type of this list:

{% highlight haskell %}
Prelude> :t ['h','e','l','l','o']
['h','e','l','l','o'] :: [Char]
{% endhighlight %}

Its type is *[Char]*, which should be read as 'list of characters'. Of course,
writing down words like this is not very convenient. And as the second to last
example already suggests, there is a more convenient notation: wrap the
characters in double quotes:

{% highlight haskell %}
Prelude> "hello"
"hello"
Prelude> :type "hello"
"hello" :: [Char]
{% endhighlight %}

I will take this opportunity to seriously demolish some words, but all
with the noble cause of learning some commonly-used Haskell list functions.
The first function *length* returns the length of a list:

{% highlight haskell %}
Prelude> length "hello"
5
Prelude> length [1,2,3]
3
{% endhighlight %}

To get a better impression of functions, it is often useful to look at its
type:

{% highlight haskell %}
Prelude> :type length
length :: [a] -> Int
{% endhighlight %}

That's one heck of a type! Basically, it says 'give me a list of something,
then I will give you an Int'. In these so-called *type signatures*, letters
that are not capitalized are generic, meaning that they can be of some
unspecified type. Consequently, *[a]* is a list with elements of some type. **But:** all elements should be of the same type. An *Int* is an integral
number: a positive or negative whole number.

Two other basic list functions are *head* and *tail*. *head* returns the first
element of a list, *tail* everything but the first element:

{% highlight haskell %}
Prelude> head "hello"
'h'
Prelude> tail "hello"
"ello"
{% endhighlight %}

The type of head is the following:

{% highlight haskell %}
Prelude> :type head
head :: [a] -> a
{% endhighlight %}

Hey, two *a*'s! Equipped with the knowledge we have, we know that *head*
is a function that takes a list of something, and gives back something.
But there is an additional constraint here: although *a* is some type,
all *a*'s have to be the same type. So, applying *head* to a list of numbers
gives a number, applying *head* to a list of characters gives a character,
etc.

The type of *tail* should now be easy to understand:

{% highlight haskell %}
Prelude> :type tail
tail :: [a] -> [a]
{% endhighlight %}

We apply *tail* to a list of some type, and get back a list with the same
type.

Finally, the last function for now is *reverse*. I have to admit presenting
this function with a bit of joy, since it will allow us to write our first
little useful Haskell program. As expected, *reverse* reverses the elements
of a list:

{% highlight haskell %}
Prelude> reverse "hello"
"olleh"
{% endhighlight %}

Olé! And another one:

{% highlight haskell %}
Prelude> reverse "level"
"level"
{% endhighlight %}

We bumped into a *palindrome*, a word that can be read forward and backward.
Now, suppose we would like to write our own function to detect wether a word
is a palindrome? We first need to make a slightly more abstract definition
of a palindrome: a word is a palindrome if it is equal to its reverse. In
Haskell we can compare values using the *==* operator:

{% highlight haskell %}
Prelude> "hello" == "hello"
True
Prelude> "hello" == "olleh"
False
{% endhighlight %}

Such a comparison evaluates to *True* if both values are equal, or to *False*
when they are not. *True* and *False* are the only values of the *Bool*
type. Since *reverse* also returns a value, nothing holds us from using it
in comparisons:

{% highlight haskell %}
Prelude> "hello" == reverse "hello"
False
Prelude> "level" == reverse "level"
True
{% endhighlight %}

The test that we devised for detecting palindromes seems to work. But it is
a lot of typing. We can generalize this into a function. Let's replace both
words by the symbolic name *word* (but don't execute this in **ghci** yet,
since it does not know this symbolic name):

{% highlight haskell %}
word == reverse word
{% endhighlight %}

Let's do some magic:

{% highlight haskell %}
Prelude> let palindrome word = word == reverse word
{% endhighlight %}

This defines the function *palindrome* taking one argument, and binds
this argument to the symbolic name *word*. To this function we assign
the expression *word == reverse word*. Play a little with this function
to be convinced that it actually works. Some examples:

{% highlight haskell %}
Prelude> palindrome "hello"
False
Prelude> palindrome "level"
True
Prelude> palindrome "racecar"
True
{% endhighlight %}

If this function is still a mystery to you, it may be useful two write
out application of the function stepwise:

    palindrome "hello"
	palindrome "hello" = "hello" == reverse "hello"
	palindrome "hello" = "hello" == "olleh"
	palindrome "hello" = False
	
	palindrome "racecar"
	palindrome "racecar" = "racecar" == reverse "racecar"
	palindrome "racecar" = "racecar" == "racecar"
	palindrome "racecar" = True

Congratulations, you have made your first function, which is in essence
a small program!

<a name="sentences"/>
## From words to sentences 

A higher level of representation that is often useful are sentences. With
the previous section, you should also be able to store sentences. A first
try:

{% highlight haskell %}
Prelude> "The cat is on the mat."
"The cat is on the mat."
{% endhighlight %}

That's fine for a beginning, although not so convenient. What if I ask you
to give me the first word of a sentence? We know that *head* can be used
to get the first element of an array:

{% highlight haskell %}
Prelude> head "The cat is on the mat."
'T'
{% endhighlight %}

As you probably expected, that didn't work. We represented a sentence as
a list of characters (a string), and asking for the first element will give
the first character. But wait, what if we represented a sentence as a list
of words?

{% highlight haskell %}
Prelude> ["The", "cat", "is", "on", "the", "mat", "."]
["The","cat","is","on","the","mat","."]
Prelude> :type ["The", "cat", "is", "on", "the", "mat", "."]
["The", "cat", "is", "on", "the", "mat", "."] :: [[Char]]
{% endhighlight %}

Nifty! We just constructed a list of a list of characters. Though, you may 
wonder why I made the punctation at the end of the sentence a separate word.
This is mostly a pragmatic choice, because gluing this punctuation sign
to *mat* does not really form a word either. Having the period sign separate
is more practical for future processing. Formally, we say that a sentence
consists of tokens, where a token can be a word, a number, and a punctuation
sign.

Rinse and repeat:

{% highlight haskell %}
Prelude> head ["The", "cat", "is", "on", "the", "mat", "."]
"The"
{% endhighlight %}

Since a word is also a list, we can apply a function to words as well. For
example, we can get the first character of the first word by applying *head*
to the *head* of a sentence:

{% highlight haskell %}
Prelude> head (head ["The", "cat", "is", "on", "the", "mat", "."])
'T'
{% endhighlight %}

Note that we need parenthesis to force Haskell to evaluate the part in 
parentheses first. If we do not enforce this order of evaluation, Haskell
will try to evaluate *head head* first, which makes no sense. Remember that
*head* requires a list as its argument, and *head* is not a list.

This is a good time to try to write yet another small program. This time,
we will write a function to calculate the average token length in a corpus.
Since we did not look at real corpora yet, pick any sentence you like as
*My First Corpus*™. I will use *"Oh, no, flying pink ponies."* The average
token length is the sum of the lengths of all tokens, divided by the number
of tokens. So, stepwise, we have to:

1. Get the length of each token in the corpus.
2. Sum the lengths of the tokens.
3. Divide the sum by the length of the corpus.

You know how to get the in characters length of a single token:

{% highlight haskell %}
Prelude> length "flying"
6
{% endhighlight %}

Since you are lazy (and if not, you should!), you are not going to apply
*length* token by token manually. And in our final function, this will not
work anyway, since we do not know the length of the sentence beforehand.
Instead we want to say to Haskell "Hey Haskell! Please apply this length
function to each element of the array." It turns out that Haskell has a
function to do this called *map*. Time to inspect *map*:

{% highlight haskell %}
Prelude> :type map
map :: (a -> b) -> [a] -> [b]
{% endhighlight %}

And we are in for another surprise. The most surprising element is probably
the first element in the type signature, *(a -> b)*. Also surprising is that 
we now see three types, *(a -> b)*, *[a]* and *[b]*. The latter is simple: 
this function takes two arguments, *(a -> b)* and *[a]*, and returns *[b]*.
*(a -> b)* as the notation suggests, is a function taking an *a* and returning
a *b*. So, *map* is actually a function that takes a function as its argument,
or in functional programming-speak a *higher order* function. 

So, *map* is a function that takes a function that maps from *a* to *b*, takes
a list of *a*s, and returns a list of *b*s. That looks a suspiciously lot like
what we want! We have a list of tokens represented as strings, the function 
length that takes a list and returns its length as an integer, and we want to
have a list of integers representing the lengths. Looks like we have a winner!

{% highlight haskell %}
Prelude> map length ["Oh", ",", "no", ",", "flying", ",", "pink" ,"ponies"]
[2,1,2,1,6,1,4,6]
{% endhighlight %}

We have now completed out first step: we have the length of each token in the
corpus. We now have to sum the lengths that we just retrieved. Fortunately,
Haskell has a *sum* function:

{% highlight haskell %}
Prelude> :type sum
sum :: (Num a) => [a] -> a
{% endhighlight %}

Ok, sum takes a list of *a*, and returns an *a*. But where did the
*(Num a) =>* come from? *Num* is a so-called typeclass. A type can belong
to one or more typeclasses. But this does not come without cost, belonging
to a typeclass requires that certain functions need to be defined. For
instance, the typeclass *Num* is a typeclass for numbers, that requires 
amongst others functions that define addition or subtraction. Coming back to 
the type signature, *sum* will sum a list of *a*, but not just any *a*, only
those that belong to the typeclass *Num*. And after all, this makes sense:
we cannot sum strings or planets, only numbers.

After this solemn introduction into typeclasses, feel free to take a cup
of tea, and try step two:

{% highlight haskell %}
Prelude> sum (map length ["Oh", ",", "no", ",", "flying", ",", "pink" ,"ponies"])
23
{% endhighlight %}

By now, you will probably smell victory. You only need to divide the sum
by the length of the sentence using the division operator (*/*):

{% highlight haskell %}
Prelude> sum (map length ["Oh", ",", "no", ",", "flying", ",", "pink" ,"ponies"]) /
  length ["Oh", ",", "no", ",", "flying", ",", "pink" ,"ponies"]

<interactive>:1:0:
    No instance for (Fractional Int)
      arising from a use of `/' at <interactive>:1:0-136
    Possible fix: add an instance declaration for (Fractional Int)
    In the expression:
          sum (map length ["Oh", ",", "no", ",", ....])
        / length ["Oh", ",", "no", ",", ....]
    In the definition of `it':
        it = sum (map length ["Oh", ",", "no", ....])
           / length ["Oh", ",", "no", ....]
{% endhighlight %}

I hope you poured yourself a cup of herb tea! While this is all a bit cryptic,
the second line (*No instance for (Fractional Int)*) gives some idea where 
this comes from. *Fractional* is typeclass for fractional numbers, and Haskell
complains that Int is not defined to be of the typeclass *Int*. This sounds
obvious, since an integer is not a fractional number. In other words, Haskell
is trying to tell us that there is an *Int* in some place where it expected
a type belonging to the typeclass *Fractional*. Since the division is the
only new component, it is the first suspect:

{% highlight haskell %}
Prelude> :type (/)
(/) :: (Fractional a) => a -> a -> a
{% endhighlight %}

First off, I put the division operator in parentheses. This is a so-called 
*infix function* that is put between its arguments (like *1.0 / 2.0*). By 
putting an infix operator in parentheses, you are stating that you would like
to use it as a regular function. This means you can things like this:

{% highlight haskell %}
Prelude> (/) 1.0 2.0
0.5
{% endhighlight %}

Anyway, the verdict of the typesignature of *(/)* is clear, it requires two
arguments that belong to the *Fractional* typeclass. The sum and length
that we calculated clearly do not belong to this typeclass, since they are
of the type *Int*:

{% highlight haskell %}
Prelude> :type sum (map length ["Oh", ",", "no", ",", "flying", ",", "pink" ,"ponies"])
sum (map length ["Oh", ",", "no", ",", "flying", ",", "pink" ,"ponies"])
  :: Int
Prelude> :type length ["Oh", ",", "no", ",", "flying", ",", "pink" ,"ponies"]
length ["Oh", ",", "no", ",", "flying", ",", "pink" ,"ponies"]
  :: Int
{% endhighlight %}

Fortunately, Haskell provides the function *fromIntegral* that converts an
integer to any kind of number. Add *fromIntegral*, and you surely do get the
average token length of the corpus:

{% highlight haskell %}
Prelude> fromIntegral (sum (map length ["Oh", ",", "no", ",", "flying", ",", "pink" ,"ponies"])) /
  fromIntegral (length ["Oh", ",", "no", ",", "flying", ",", "pink" ,"ponies"])
2.875
{% endhighlight %}

That's a bumpier ride than you may have expected. Don't worry! During my first
forays into Haskell, I was convinced that I am too stupid for this. After more 
practice, you will learn that Haskell is actually a very simple and logical
language.

Maybe it will feel more like a victory after generalizing this to a function.
You can follow the same pattern as in the palindrome example: replace the
sentence with a symbolic name and transform it into a function:

{% highlight haskell %}
Prelude> let averageLength l = fromIntegral (sum (map length l)) / fromIntegral (length l)
Prelude> averageLength ["Oh", ",", "no", ",", "flying", ",", "pink" ,"ponies"]
2.875
{% endhighlight %}

Congratulations, you just wrote your second function! But wait, you actually
accomplished more than you may expect. Check the type signature of 
*averageLength*.

{% highlight haskell %}
Prelude> :type averageLength
averageLength :: (Fractional b) => [[a]] -> b
{% endhighlight %}

You made your first weird type signature. Show it off to your colleague,
significant other, or dog. *averageLength* is a function that takes a
list of a list of *a*, and returns a *b* that belongs to the *Fractional*
typeclass. But wait, *a* can be anything, right? What happens if we apply
this function to a list of sentences?

{% highlight haskell %}
Prelude> averageLength [["I", "like", "Haskell", "."],
  ["Ruby", "rocks", "the", "too", "."],
  ["Who", "needs", "Java", "?"]]
4.333333333333333
{% endhighlight %}

That's the average sentence length. It turns out that, although we set out
to make a function to calculate the average token length, we wrote a function
that calculates the average length of lists in a list. This happens very often
when you write Haskell programs: lots of functions are generic and can be
reused for other tasks.

<a name="tokenization"/>
# A note on tokenization

When dealing with real-world text, it is usually not neatly split in sentences
and tokens. For example, consider this book - punctuation is usually glued to
words. These processes, sentence splitting and tokenization may seem trivial,
unfortunately they are not. Consider the following sentence:

*Eg. Jack doesn't have 19.99 to spend.

If we simply perform sentence splitting on periods (*.*), we will find four
sentences:

1. *E.*
2. *g.*
3. *Jack doesn't have 19.*
4. *99 to spend.*

Of course, it is just one sentence. Similar problems arise during punctuation:
how do we know that *E.g.* and *19.99* should not be split? And how about
*doesn't*, which should probably be split as *does n't* or *does not*? Tokenization
can be performed accurately, but it requires techniques that you will see in
later chapters. So, we will come back to tokenization later. We promise!

Of course, up to the point where we handle tokenization, we need material to work
on. To make life easier for you, the material for the first chapters of the book
is pre-tokenized in a plain-text file using two simple rules:

1. One sentence per line.
2. Tokens are separated by a space.

To convert a text file to a Haskell representation, sentence splitting is a matter
of splitting by line, and tokenization splitting by space. Have a look at the
following example:

{% highlight haskell %}
Prelude> "This is Jack .\nHe is a Haskeller ."
"This is Jack .\nHe is a Haskeller ."
{% endhighlight %}

This is exactly the representation that we will be using for our textual data.
As you can see, the tokens are separated by spaces. Both sentences are separated
using a newline. When writing down a string literally, you can insert a newline
using *\n*.

Haskell provides a *lines* function to split up a string by line. Not surprisingly,
this function accepts a string as its first argument, and will return a list of
strings:

{% highlight haskell %}
Prelude> :type lines
lines :: String -> [String]
Prelude> lines "This is Jack .\nHe is a Haskeller ."
["This is Jack .","He is a Haskeller ."]
{% endhighlight %}

That was easy! Now the actual tokenization. For all sentences, we have a string
representing the sentence. We want to split this string on the space character.
Haskell also has a function to do this, named *words*. *words* is nearly the same
function as *lines*, except that it splits on spaces rather than newlines:

{% highlight haskell %}
Prelude> words "This is Jack ."
["This","is","Jack","."]
{% endhighlight %}

That will do, but we have to apply this to every sentence in the list of sentences.
We can use the *map* function we have seen earlier to apply the *words* function
to each element of the list of (untokenized) sentences:

{% highlight haskell %}
Prelude> map words (lines "This is Jack .\nHe is a Haskeller .")
[["This","is","Jack","."],["He","is","a","Haskeller","."]]
{% endhighlight %}

Allright! That will do the job. We know how to turn this into a full-fledged
function:

{% highlight haskell %}
Prelude> let splitTokenize text = map words (lines text)
Prelude> splitTokenize "This is Jack .\nHe is a Haskeller ."
[["This","is","Jack","."],["He","is","a","Haskeller","."]]
{% endhighlight %}

This is a good moment to beautify this function a bit. To make it simpler, we first
need to get rid of the parentheses. We use the parentheses to tell Haskell that it
should evaluate *lines text* first, or otherwise it will try to map over the function
*lines*, which will fail, because it is not a list. Very often, you will encounter
function applications of the form *f(g(x))*, or *f(g(h(x)))*, etc. Haskell provides
the *(.)* function to combine such function applications. So, *f(g(x))* can be rewritten
to *(f . g) x* and *f(g(h(x)))* as *(f . g . h) x*. As you can see, this so-called
*function composition* makes things much easier to read. We can rewrite our function
by using function composition:

{% highlight haskell %}
Prelude> let splitTokenize text = (map words . lines) text
{% endhighlight %}

This may not yet seem so interesting. However, it allows us to make yet another
simplification step. Consider the type of the *map* function:

{% highlight haskell %}
Prelude> :type map
map :: (a -> b) -> [a] -> [b]
{% endhighlight %}

*map* takes a function, and a list, and returns a list. Now we will do something
that may look weird, but is very common in functional programming.

{% highlight haskell %}
Prelude> :type map words
map words :: [String] -> [[String]]
{% endhighlight %}

Applying *map* to just one argument will give... another function! What we just did
is to bind just one argument of the map function, and that gives another function
that has implicitly bound that argument. This process is called *currying* in functional
programming slang.

If we look back at our *splitTokenize* function, and look up the type of *map words .
lines*, we see that it is a function that takes a *String* and returns a list of a
list of a string:

{% highlight haskell %}
Prelude> :type map words . lines
map words . lines :: String -> [[String]]
{% endhighlight %}

In our function body, we apply this function to the argument *text*. Of course, this
is not really necessary, because *map words . lines* already defines our function.
We just need to bind this to the name *splitTokenize*. Consequently the function can
be simplified:

{% highlight haskell %}
Prelude> let splitTokenize = (map words . lines)
Prelude> :type splitTokenize
splitTokenize :: String -> [[String]]
Prelude> splitTokenize "This is Jack .\nHe is a Haskeller ."
[["This","is","Jack","."],["He","is","a","Haskeller","."]]
{% endhighlight %}

<a name="wordlist"/>
## Word lists

In the following two sections, we will introduce two prototypical tasks related words.
The first is to make a word (or actually token) list,the second task is making a word
frequency.

A word list is a very simple data structure: it is just a list of words or tokens that
occur in a text, without duplicates. Our corpus is also just a list of words, but since
it contains duplicates, it is not a word list. The obvious method to make a word list
is to go through a corpus word by word, and adding words that we did not see yet to a
second list. This requires some functions we haven't seen yet:

* Adding an element to a list.
* Checking whether an element is (or is not) in a list.
* Constructing a list while traversing another list.

We like easy things first, so let's start with the first item: adding an element to a
list. We have seen the *head* function before that chops of the head of the list and
returns it. But we can also do the reverse: take a list and give it a new head. The old
head then becomes the head of the tail (are you still following?). In Haskell, we can
do this using the *(:)* function:

{% highlight haskell %}
Prelude> 2 : [3,4,5]
[2,3,4,5]
{% endhighlight %}

Ain't that great? We can also add a head, and yet another:

{% highlight haskell %}
Prelude> 1 : 2 : [3,4,5]
[1,2,3,4,5]
{% endhighlight %}

What if we do not have an element yet? Add the head to the empty list (*[]*):

{% highlight haskell %}
Prelude> "Hi" : []
["Hi"]
{% endhighlight %}

With that covered, the next thing we need to be able to do is checking whether some
element belongs to a list. We can do this using the *elem* function. It takes an
element as its first argument, and a list as its second. It will return a Bool of the
value *True* if the element was in the list, or *False* otherwise. For example:

{% highlight haskell %}
Prelude> elem 2 [1,2,3,4,5]
True
Prelude> elem 6 [1,2,3,4,5]
False
{% endhighlight %}

The function *notElem* is exactly the inverse of *elem*, and returns *True* if an
element is not in the list, and *False* otherwise:

{% highlight haskell %}
Prelude> notElem "foo" ["foo","bar","baz"]
False
Prelude> notElem "pony" ["foo","bar","baz"]
True
{% endhighlight %}

Ok, so we want to add an element to a list if, but only if, it is true that it
is not yet a member of that list. Or in other words, the addition is conditional.
Haskell provides a set of keywords to model conditionals, if..then..else. The
structure is like this:

{% highlight haskell %}
if expr then a else b
{% endhighlight %}

This whole structure itself is an expression. This expression evaluates to
*a* if *expr* evaluates to *True* or to *a* if *expr* evaluates to False.
To give a working, but useless example:

{% highlight haskell %}
Prelude> if 1 == 2 then "cuckoo" else "egg"
"egg"
Prelude> if 1 == 1 then "cuckoo" else "egg"
"cuckoo"
{% endhighlight %}

This looks exactly like what we need. Just fill in the blanks:

{% highlight haskell %}
Prelude> if elem "foo" ["foo","bar","baz"] then ["foo","bar","baz"]
  else "foo" : ["foo", "bar", "baz"]
["foo","bar","baz"]
Prelude> if elem "pony" ["foo","bar","baz"] then ["foo","bar","baz"]
  else "pony" : ["foo", "bar", "baz"]
["pony","foo","bar","baz"]
{% endhighlight %}

That's a bit contrived, but not if we rewrite it to a function:

{% highlight haskell %}
Prelude> let elemOrAdd e l = if elem e l then l else e:l
Prelude> elemOrAdd "foo" ["foo", "bar", "baz"]
["foo","bar","baz"]
Prelude> elemOrAdd "pony" ["foo", "bar", "baz"]
["pony","foo","bar","baz"]
{% endhighlight %}

Now we need to apply this to all words in a text, starting with an empty
list. Haskell provides a function to do this, but brace yourself, the
first time it may look a bit 'difficult'. It is named *foldl* (a so-called)
left-fold. A left fold traverses a list from head to tail, applying a
function to each element, just like *map*. However, the difference is that
it can, but does not necessarily return a list. As such, it is a generalization
of the *map* function. As usual, you can inspect the type signature to
see the arguments of *foldl*:

{% highlight haskell %}
Prelude> :type foldl
foldl :: (a -> b -> a) -> a -> [b] -> a
{% endhighlight %}

Now consider this example using *foldl*:

{% highlight haskell %}
Prelude> foldl (+) 0 [1,2,3,4,5]
15
{% endhighlight %}

Stepwise, this fold is executed in the following manner:

{% highlight haskell %}
foldl (+) 0 [1,2,3,4,5]
foldl (+) ((0)+1) [2,3,4,5]
foldl (+) (((0)+1)+2) [3,4,5]
foldl (+) ((((0)+1)+2)+3) [4,5]
foldl (+) (((((0)+1)+2)+3)+4) [5]
foldl (+) ((((((0)+1)+2)+3)+4)+5)) []
((((((0)+1)+2)+3)+4)+5))
15
{% endhighlight %}

So, it works by applying a function to some initial argument (*0* in this case)
as its first argument, and the first element of the list as its second argument.
When processing the second element of the list, this expression is then the
first argument of the function, and the second element is the second argument,
etc. The first argument of the function that is applied is also called the
*accumulator*, since it accumulates results up till that point.

This could also work for our *elemOrAdd* function. Unfortunately, *elemOrAdd*
requires the accumulator as the second argument, and the function passed to
*foldl* as the first argument. Compare the type signatures:

{% highlight haskell %}
Prelude> :type foldl
foldl :: (a -> b -> a) -> a -> [b] -> a
Prelude> :type elemOrAdd
elemOrAdd :: (Eq a) => a -> [a] -> [a]
{% endhighlight %}

In the function that is the first argument to *foldl*, the return type is
the same as the type of the first argument. In the case of *elemOrAdd*,
the type of the second argument corresponds to that of the first. Of course,
an easy 'hack' to solve this, is to redefine elemOrAdd, switching its
arguments, and plug it into foldl:

{% highlight haskell %}
Prelude> let elemOrAdd l e = if elem e l then l else e:l
Prelude> foldl elemOrAdd [] ["blue", "blue", "red", "blue", "red"]
["red","blue"]
{% endhighlight %}

Since we are building a list, we use the empty list (*[]*) as the
initial accumulator for this fold. Stepwise, the fold works like this:

{% highlight haskell %}
foldl elemOrAdd [] ["blue", "blue", "red", "blue", "red"]
foldl elemOrAdd ("blue":([])) ["blue", "blue", "red", "blue", "red"]
foldl elemOrAdd ("blue":([])) ["blue", "red", "blue", "red"]
foldl elemOrAdd ("blue":([])) ["red", "blue", "red"]
foldl elemOrAdd ("red":("blue":([]))) ["blue", "red"]
foldl elemOrAdd ("red":("blue":([]))) ["red"]
foldl elemOrAdd ("red":("blue":([]))) []
("red":("blue":([])))
["red","blue"]
{% endhighlight %}

Now we wrap it up in another function, and you have constructed two
functions that, together, make word lists: 

{% highlight haskell %}
Prelude> let wordList l = foldl elemOrAdd [] l
Prelude> wordList ["blue", "blue", "red", "blue", "red"]
["red","blue"]
{% endhighlight %}