---
layout: post
category : projects 
tags : [jekyll]
---
{% include JB/setup %}

## Polyglot Jekyll
Since the main target region of my small computer business is a region in southern germany and at the same time I want to provide future blog posts about Tech and Research in English I want to have all the main pages bilingual. The content of the English and German website should be independant <!--more--> (i. e. not all Blog posts will be available in both languages) and the user should be able so select the Language using a nice dropdown menu. 

I basically followed the approach by [Nicolas Carlo](http://nicoespeon.com/en/2014/04/multilingual-blog-with-jekyll-1-5/) which worked out pretty well. I just had to update my jekyll version and change the way my main navigation menu was generated. 

## Embed images with Jekyll
Generating the dropdown menu with Bootstrap is easy, however the correct positioning while maintaining the responsitivity turned out to be a lot of css hacking. To optimize the number of http-requests I thought it would be nice to use svg-flags and embed them directly in the source code. 

I found this [plugin](https://github.com/GSI/jekyll_image_encode) which provides a Liquid-tag encoding an image as base64 and providing a *data*-attribute.

    {%raw%}
    <img src="{% base64 assets/de.svg %}" />
    {% endraw %}

turns into 

    <img src="data:image;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+DQo8IURPQ1RZUEUgc3ZnIFBVQkxJQyAiLS8vVzNDLy9EVEQgU1ZHIDEuMS8vRU4iDQoJImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2ZzExLmR0ZCI+DQo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMDAiIGhlaWdodD0iNjAwIiB2aWV3Qm94PSIwIDAgNSAzIj4NCgk8ZGVzYz5GbGFnIG9mIEdlcm1hbnk8L2Rlc2M+DQoJPHJlY3QgaWQ9ImJsYWNrX3N0cmlwZSIgd2lkdGg9IjUiIGhlaWdodD0iMyIgeT0iMCIgeD0iMCIgZmlsbD0iIzAwMCIvPg0KCTxyZWN0IGlkPSJyZWRfc3RyaXBlIiB3aWR0aD0iNSIgaGVpZ2h0PSIyIiB5PSIxIiB4PSIwIiBmaWxsPSIjRDAwIi8+DQoJPHJlY3QgaWQ9ImdvbGRfc3RyaXBlIiB3aWR0aD0iNSIgaGVpZ2h0PSIxIiB5PSIyIiB4PSIwIiBmaWxsPSIjRkZDRTAwIi8+DQo8L3N2Zz4NCg==">

This seems to work nicely with png files, however svg-images were not recognized by the Browser. To fix that the correct mime-type `image/svg+xml` must be provided. 

I modified the plugin to automatically detect the mime-type of the image. Now the tag correctly becomes

    <img class="flag" src="data:image/svg+xml;base64,
    PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0i..."/>

The modified plugin is available [on Github](https://github.com/grst/jekyll_image_encode).


## Other Improvements

### category aware blog navigation 
I adapted the category aware prev/next buttons by [David Strauß](http://stravid.com/en/category-aware-previous-and-next-for-jekyll-posts/) in order to keep the different blog-sections properly separated. 

### shrinking navbar
You might have noticed the nice shrinking Navbar when you scroll down the page. This is based on a pretty damn simple jQuery-trick that I found somewhere on Stackoverflow.

    $(window).scroll(function() {
        if ($(document).scrollTop() > 50) {
            $('.navbar').addClass('shrink');
        } else {
            $('.navbar').removeClass('shrink');
        }
    });

the rest is just CSS.
