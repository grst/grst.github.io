# How I acquired the hallmarks of good scientific software development

As cancer aquires the hallmarks of cancer, a software engineer acquires the
hallmarks of good practice. Here I share my story, hoping that it won't take you
as long as it did me. 


I was 15 when I started getting serious with programming. With serious I mean 
moving from [Lego Robots]() to real-world scenarios. Back then I was working 
on implementing my own content managment system (CMS) in PHP. What a stupid
idea, given that there are tons of open source CMS out there. But well, I
learned a lot, and soon started to adopt an object-oriented style. 

Apparently, I also recognized the need for versioning my source code, 
because at some point, my folder structure looked like this: 



It took me four more years and the help of a friend to learn how to do this
properly.  This was in 2012, when I met [Sebastian Wilzbach]() after
starting to study Bioinformatics in Munich. We were working together on one of
our first coding exercises and he was like: *Why don't you use git?*. 

Git is a tool that [tracks projects through a beautiful distributed graph theory
model](https://xkcd.com/1597/). It immediately made sense to me. 
This is how I acquired, the first, and arguably most important hallmark of good
software development. 

* Tell the story of myself when I was 14
* Sebi teaching me git


More recently, in 2017, I did an internship in the Bioinformatics department at
Roche. There, amongst others, I was developing gene signatures for tissues
and primary cell lines. 

Two years later, they asked me if I could redo some figures because the 
signatures would become part of a paper they were about to submit. 
Even though I had all the code in a git repository, and well-documented, 
it took me two days to generate the figures, because I did not store 
the *exact versions of the dependencies* I had been using. Also, 
it took me quite some while to figure out in what order I needed to 
run my preprocessing scripts, because I did not have pipeline 
that executes the script in their right order. 

