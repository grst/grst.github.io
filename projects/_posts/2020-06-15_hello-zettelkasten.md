---
layout: post
title: Hello Zettelkasten! 
---

Over the last months, posts about
[Zettelkästen](https://en.wikipedia.org/wiki/Zettelkasten) 
tended to show up quite frequently on [Hacker
News](https://news.ycombinator.com/) and caught my attention. 
A *Zettelkasten* is an ingenious system of organizing notes, cleverly linking
notes to each other. The system has most famously been applied by the
German sociologist Niklas Luhmann (1927-1998), back then based on 
physical boxes ("Kasten") with slips of paper ("Zettel") in them. 

![zettelkasten](2020-06-15_zettelkasten/zettelkasten.png)
*Image by [David B. Clear](https://medium.com/@davidbclear) under CC BY-SA 4.0*


## My personal story of notetaking 

Years before *Zettelkästen* got hyped, I used to keep notes in Microsoft
OneNote. Essentially I stored every note taken during my last three years 
of secondary school and my Bachelor's studies in one huge notebook. If exported
to PDF, it comprised several thousand pages. I was quite content with the
functionality: Everything was organized in pages and subpages, I could
cross-reference relevant topics and everything was searchable (it even OCRed 
screenshots). 

Eventually, I switched to Linux as my main operating system and couldn't use
OneNote any more (In fact, OneNote was the only thing that kept me from doing so
for at least two years). Being locked into the proprietary system, my notes ended up
being dumped into a HTML file, and almost never looked upon again. Since then, 
I stored notes as a mixture of [Google Keep](https://keep.google.com), 
[Dropbox Paper](https://paper.dropbox.com), [Google Docs](https://docs.google.com) 
and a bunch of unorganized markdown files. By no means organized, cross-linked
or universally searchable. 

As of today, I started migrating my notes to [Zettlr](https://zettlr.com/), implementing
the Zettelkasten system. Zettlr is nothing more or less than an excellent markdown editor.
My notes are stored as plain markdown files in a Git repository -- no more
vendor lock-in! 
With this system, I finally believe that I found a solution at least as good as OneNote. 

## How to build a Zettelkasten
There are a lot of extensive posts explaining in detail how the system works. 
I particularly enjoyed reading the articles by [David B.
Clear](https://writingcooperative.com/zettelkasten-how-one-german-scholar-was-so-freakishly-productive-997e4e0ca125)
and [Magnus
Eriksson](https://omxi.se/2015-06-21-living-with-a-zettelkasten.html). 

From what I learned, the most important points about writing good *Zettel* are: 

 * **atomicity**: Each note should contain one idea and one idea only.
 * **autonomy**: Each note should be self-contained. 
 * **link**: Each note needs to be linked by at least another. If it is not
   linked it is likely never found again. 
 * **no explicit structure**: By linking notes, the Zettelkasten organizes
   itself. It is not required (and discouraged) to explicitly arrange Zettel
   into a hierarchy. 

Furthermore, notes can be organized using *connection notes* ("Strukturzettel")
and *outline notes* ("Folgezettel"). A connection note is a note that links
multiple Zettel and explains why they are related. An outline note connects notes
in a particular order to form a storyline. They can be considered as a precursor
of writing, for instance a blog post or a scientific paper. 
