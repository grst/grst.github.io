---
layout: post
title: Cleverly using web maps for outdoor activities - Part II
---


In an [earlier blog post]({{ site.baseurl }}{% post_url projects/2016-10-30-google-earth-overlay-server %}) I described [GEOS](https://github.com/grst/geos), the *Google Earth Overlay Server*. The python-tool allows to display web maps (such as Google Maps or open streetmaps) as an overlay in Google Earth. 

In the same post, I also noted, that web maps and Google Earth are nice, but for outdoor activities, paper maps are indispensable. 

In the most recent version, GEOS features a web UI which allows to display all maps in a unified interface in the browser. It provides basic tools for measuring and drawing on the map and allows to generate high-quality PDFs in A3 and A4 paper formats, ready for printout. 

And the best: I deployed GEOS to a free instance of [heroku](https://heroku.com) - you can therefore check it out online on [https://geos-web.herokuapp.com](http://geos.gsturm.eu) without having to install anything.

