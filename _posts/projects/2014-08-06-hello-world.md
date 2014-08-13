---
layout: post
category : projects 
tags : [jekyll]
title: Hello World!
---
{% include JB/setup %}
I finally managed to set up my new website using [Jekyll and Bootstrap](http://jekyllbootstrap.com/). This allows me to maintain my website in a quite hackish way: I can write all entries and blogposts on the console in vi using pure markdown. The markdown is then compiled to a static html site.<!--more--> The article by [Mike Greiling](http://pixelcog.com/blog/2013/jekyll-from-scratch-core-architecture/) was a great help while creating the site. 

{% comment %}
## Issues I encountered
Since I am working with cygwin on Windows (don't blame me, it turned out to be the most productive combination for me) 
* maruku was adding incorrect CDATA-tags to embedded javascript. Switching to the [kramdown](http://kramdown.gettalong.org/) engine solved the problem. I found the solution on <https://github.com/bhollis/maruku/issues/120>
{% endcomment %}

## Things that are still to do
* Multilingual support (german/english)
* Responsive layout (just use the bootstrap classes!)
* Some tweaks of the layout
* Add a gallery

and of course to make a nice landing page and to add some more contents.
