---
layout: post
title: Cleverly using web maps for outdoor activities.
---

There's a plethora of maps freely available out there, offered by different companies or states. Just to name a few:

* [Open Streetmap](http://www.openstreetmap.org/#map=18/48.18229/11.61098)
* [Google (Terrain)](http://maps.google.com)
* [Kompass](http://www.kompass.de/touren-und-regionen/wanderkarte/)
* [Outdooractive](https://www.outdooractive.com/de/tourenplaner/)
* [Norway](http://www.norgeskart.no/#5/378604/7226208)
* [Bavaria](http://geoportal.bayern.de/bayernatlas/?X=5253240.74&Y=4380640.88&zoom=10&lang=de&topic=ba&bgLayer=tk&layers=lod,e528a2a8-44e7-46e9-9069-1a8295b113b5&layers_opacity=0.2,0.25&catalogNodes=122)
* [Switzerland](https://map.geo.admin.ch/)
* [France](https://www.geoportail.gouv.fr/)

All maps come with their own user interface. While some provide a wide range of funtionalities like drawing, measuring and printing (e.g. Swisstopo)  others are not more than a simple map viewer. Especially the state maps are of high quality. What you find in the web portal is the same material which you can buy as paper maps for usually a considerable amount of money. That's what makes the web maps so attractive. But how can we make use of them for outdoor activities?  


## Trip planning with Google Earth
For exploring the terrain and investigating potential tour variants, Google Earth is a fantastic tool. Apart from viewing GPS tracks on a 3D elevation profile it is also possible to measure distances on the map. 

Unfortunately, satellite imagery lacks important information such as contour lines, hiking trails and cottages. Ideally, we could combine the power of Google Earth with the power of topographical maps instead of viewing the above web maps in a clumsy web interface. 

The [Google Map Overlay webservice](http://ge-map-overlays.appspot.com/) promises to bridge web maps into Google Eearth. The tool works nicely, but has the downside that it's closed-source and one cannot add own maps to the service. 

To provide a more flexible alternative, I developed [GEOS](https://github.com/grst/geos), the *Google Earth Overlay Server*. This is a python script running on your laptop. It is easy to install, open source and fully customizeable. The software is availabe on [github](https://github.com/grst/geos). There you can also find a tutorial on how to add own maps. 

![Google Earth with Map Overlay](/assets/projects/2016-10-30_geos/ge_screenshot.png)


## Printing Maps
Nothing replaces a good old paper map out on tour! Although I do see the advantages of GPS devices and smartphones for mobile navigation, I am still a big fan of paper maps:  

* they never run out of battery 
* there is no way to get an overview over the area on an electronical device (unless you carry a 24" flatscreen)

However paper maps can be quite pricy - so why not simply printing one yourself? 

During [my exchange in norway](http://ut.gregor-sturm.de/norwegen.html) I regularily made use of [nkart.no](http://nkart.no), a very easy-to-use website for downloading paper maps of the Norwegian state maps. Also the [Swiss geoportal](http://map.geo.admin.ch/) has decent printing capabilties.  

Apart from that, I am aware of [MOBAC](http://mobac.sourceforge.net/), a general-purpose desktop app for converting maps to various formats. In addition to generating paper maps it also supports creating offline maps for Android Apps and Garmin GPS devices. However, In comparison with the elegant nkart, MOBAC appears old fashioned and cumbersome to use. 

Ideally, we had one unified web app simliar to Swisstopo or nkart, only supporting all possible web maps. As a next step, I could imagine extending GEOS to be able to view and print web maps from your web browser.  

