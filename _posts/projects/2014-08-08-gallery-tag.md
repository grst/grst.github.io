---
layout: post
category : projects 
tags : [jekyll]
---
{% include JB/setup %}
Since I will soon begin to write some posts about my ERASMUS-Exchange to Trondheim, Norway, I needed to find a solution for displaying galleries (what would be a travel-blog without pictures!?). The [JekyllGalleryTag](https://github.com/redwallhp/JekyllGalleryTag) seemed as a good solution to me. It promised to generate thumbnails automatically using ImageMagick and is easy to embedd in a post by using a Liquid-Tag:

    {% raw %}
    {% gallery galleryname %}
    subfolder/myfirstimage.jpg:: A caption!
    subfolder/myseconfimage.png:: Another caption
    subfolder/mythirdimage.jpg
    subfolder/myfourthimage.png
    subfolder/myfifthimage.jpg
    {% endgallery %}
    {% endraw %}

However, as always, things turned out not to be as easy as expected.

## Issues I encountered
* Since I am using cygwin on Windows (don't blame me - it turned out to be the most productive combination so far), it was quite a pain to get the RMagick libary installed. What finally helped was downloading the *right* ImageMagick packages as described in the [RMagick wiki](https://github.com/rmagick/rmagick/wiki/Installing-on-Cygwin-(Windows)), using a 1.8.x version of Ruby Gem instead of the latest 2.4.1 release and to symlink the folder
`/cygdrive/c/cygwin/usr/include/ImageMagick/wand` to `/cygdrive/c/cygwin/user/include/wand` 
* The version of JekyllGalleryTag as provided on github is not compatible with the current version of jekyll. Although the thumbnails in `_site` were generated, they were later overwritten. I found out that this behaviour was fixed in the [fork by internaut](https://github.com/internaut/JekyllGalleryTag) while providing some nice additional features. 
* I had to modifiy the html-output of the plugin to generate responsive bootstrap-thumbnails. Now the width and number of thumbs per line is adjusted depending of the browser size. 
* In order to add a nice gallery effect using [colorbox](http://www.jacklmoore.com/colorbox/) I had to add some javascript to the output. Unfortunately `maruku` was adding incorrect CDATA-tags to embedded javascript resulting in a syntax-error in Chrome. Switching to the [kramdown](http://kramdown.        gettalong.org/) engine solved the problem. I found the          solution on <https://github.com/bhollis/maruku/issues/120>

## Example
This gallery shows some photos from my hike at the [Hoher Ifen](http://www.outdooractive.com/de/bergtour/allgaeu-kleinwalsertal-tannheimer-tal/hoher-ifen-abstieg-ueber-schwarzwasserhuette/6622165/)

{% gallery test %}
ifen/
{% endgallery %}
