---
layout: post
title: Using web maps for outdoor activities.
tagline: Trip planning and paper maps.  
---

Being an outdoor fanatic and orienteering runner I love topographical maps. Planning trips in Google Earth is really fun when you can explore routes for the next MTB trans alp in 3D. However, the satellite imagery is lacking important information you can find in topographical paper maps. 

A round of googling brought me to [...](...appspot) where you can download a kml file that contains a collection of maps that you can display in google earth as overlay. This works nicely, the downside is that the author keeps his python scripts close and although he does from time to time respond to requests about adding more maps, this doesn't quite give me the flexibility I want to.

Therefore, I dug a bit into google earth KML network links and implemented my own solution. 

### How it works
// technical details are on github anyway and not of interest for the average reader. 
Obviously, loading the entire earth as one picture would be unfeasible, therefore a web map is made out of tiles. Most of the sites have adapted the following standard that was proposed by google []. 

* on zoom level 0 the world can be displayed on one single tile 
* each zoom level divides each tile into four sub-tiles. 

This can be modeled in Google Earth with Network links and Ground overlays. 
A ground overlay represents one tile. A network link fetches the next zoom level on-demand, namely when the user zooms into the respective region. 

Therefore, I divide each zoom level into 'regions'. Each region contains four network links and a set of tiles. 

### Printing web maps. 
During [my exchange in norway](ut.gregor-sturm.de/norwegen.html) I was pointed to the webservice [nkart.no](nkart.no) a very easy-to-use website for downloading paper maps of the Norwegian state maps. 

The swiss also have a delightful web portal for their "Landeskarten", also offerting an easy-to-use printi tool and great features for measuring on the map, creating altitude profiles. 

I am aware of [MOBAC](...), a general-purpose desktop app for converting tiled maps in various formats, including paper maps, but also Garmin GPS devices, Android Mapping Apps etc. 

In comparison with the elegant nkart, MOBAC appears old fashioned and cumbersome to use. 

In a next step, I plan to extend the GEOS web server to be able to view and print maps.  


