---
layout: base
title: words
---
# Words

## Introduction

Words are one of the most fundamental building blocks of our language.
Although words may look simple on the surface, they are very ingenious
devices that pack useful information. For our purposes, we will say
that a words consists of a *stem* and *affixes*. Let's look at three simple
sentences:

I **walk**.<br/>
John **walk**s.<br/>
Jack **walk**ed.<br/>

All three sentences contain some 'form' of *walk*. We say that these
instances are all *inflections* of the verb *walk*. The part of the
inflections that is shared (*walk*) is what we call the *stem*. The
parts that are not common are named *affixes*. We inflect verbs
to indicate tense (present, past, etc.), the person of the verb's subject
(first, second, and third person), and the number (singular or plural).

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

    Prelude> :t 'h'
	'h' :: Char

Great. Not all that practical with the small amount of single-lettered words
in English. Rather than a single character, we want a sequence of characters.
Not surprisingly, Haskell has a data types to build sequences. The most
commonly used sequence is the list. You can have lists of many things: lists
of groceries, lists of planets, and lists of characters. We can make a
literal list in Haskell by enumerating its elements, separated by commas and
surrounded by square brackets. For instance, the list *1, 2, 3, 4, 5* is
written as *[1, 2, 3, 4, 5]*. Let's try to make a list of characters:

    Prelude> ['h','e','l','l','o']
	"hello"

Now we are getting somewhere! Let's look at the type of this list:

    Prelude> :t ['h','e','l','l','o']
	['h','e','l','l','o'] :: [Char]

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

    Prelude> length "hello"
	5
	Prelude> length [1,2,3]
	3

To get a better impression of functions, it is often useful to look at its
type:

    Prelude> :type length
	length :: [a] -> Int

That's one heck of a type! Basically, it says 'give me a list of something,
then I will give you an Int'. In these so-called *type signatures*, letters
that are not capitalized are generic, meaning that they can be of some
unspecified type. Consequently, *[a]* is a list with elements of some type. **But:** all elements should be of the same type. An *Int* is an integral
number: a positive or negative whole number.

Two other basic list functions are *head* and *tail*. *head* returns the first
element of a list, *tail* everything but the first element:

    Prelude> head "hello"
	'h'
	Prelude> tail "hello"
	"ello"

The type of head is the following:

    Prelude> :type head
	head :: [a] -> a

Hey, two *a*'s! Equipped with the knowledge we have, we know that *head*
is a function that takes a list of something, and gives back something.
But there is an additional constraint here: although $a$ is some type,
all $a$'s have to be the same type. So, applying *head* to a list of numbers
gives a number, applying *head* to a list of characters gives a character,
etc.

The type of *tail* should now be easy to understand:

    Prelude> :type tail
	tail :: [a] -> [a]

We apply *tail* to a list of some type, and get back a list with the same
type.

Finally, the last function for now is *reverse*. I have to admit presenting
this function with a bit of joy, since it will allow us to write our first
little useful Haskell program. As expected, *reverse* reverses the elements
of a list:

    Prelude> reverse "hello"
	"olleh"

Olé! And another one:

    Prelude> reverse "level"
	"level"

We bumped into a *palindrome*, a word that can be read forward and backward.
Now, suppose we would like to write our own function to detect wether a word
is a palindrome? We first need to make a slightly more abstract definition
of a palindrome: a word is a palindrome if it is equal to its reverse. In
Haskell we can compare values using the *==* operator:

    Prelude> "hello" == "hello"
	True
	Prelude> "hello" == "olleh"
	False

Such a comparison evaluates to *True* if both values are equal, or to *False*
when they are not. *True* and *False* are the only values of the *Bool*
type. Since *reverse* also returns a value, nothing holds us from using it
in comparisons:

    Prelude> "hello" == reverse "hello"
	False
	Prelude> "level" == reverse "level"
	True

The test that we devised for detecting palindromes seems to work. But it is
a lot of typing. We can generalize this into a function. Let's replace both
words by the symbolic name *word* (but don't execute this in **ghci** yet,
since it does not know this symbolic name):

    word == reverse word

Let's do some magic:

    Prelude> let palindrome word = word == reverse word

This defines the function *palindrome* taking one argument, and binds
this argument to the symbolic name *word*. To this function we assign
the expression *word == reverse word*. Play a little with this function
to be convinced that it actually works. Some examples:

    Prelude> palindrome "hello"
	False
	Prelude> palindrome "level"
	True
	Prelude> palindrome "racecar"
	True

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
a program!

## From words to sentences

