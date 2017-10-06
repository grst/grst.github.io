---
layout: post
title: Benchmarking Scripting Languages for Bioinformatics <i>or</i> The sad truth about Julia 
---

As a Bioinformatician, I am mainly confronted with two programming languages in my everyday tasks: R and python. 

As it is not a secret that R is both slow and a mess, python is usually my language of choice. Yet, the large collection of tools on Bioconductor, the power of ggplot to rapidly generate publication-quality figures and the well-implemented statistical functions often make it the pragmatic choice. Moreover, I have to admit that thanks to Hadley Wickham's [tidyverse](http://tidyverse.org) it is now possible to write readable and fairly performant code.  

Recently, I was pointed to [Julia](https://julialang.org), adding a third player to the game of languages. Their website self-confidently boasts with it's superior performance and describes itself as the 'one language to rule them all':   

> We want a language that’s open source, with a liberal license. We want the speed of C with the dynamism of Ruby. We want a language that’s homoiconic, with true macros like Lisp, but with obvious, familiar mathematical notation like Matlab. We want something as usable for general programming as Python, as easy for statistics as R, as natural for string processing as Perl, as powerful for linear algebra as Matlab, as good at gluing programs together as the shell. Something that is dirt simple to learn, yet keeps the most serious hackers happy. We want it interactive and we want it compiled.
>
> -- <cite>[https://julialang.org/blog/2012/02/why-we-created-julia](https://julialang.org/blog/2012/02/why-we-created-julia)</cite>

I decided to give it a try and compare it to both python and R.

## I implemented a real-life example in all three languages. 
My goal is to assess the usability of the languages for my everyday tasks as a data scientist. Therefore, I chose a realistic task which I implemented in all three programming languages: loading tabular data in a data-frame structure, manipulating some columns, aggregating the data and plotting the results. In particular, I loaded data from three independent Mass Spectrometry experiments (raw size 1.3 GB) and plotted some statistics on it.

### Data and souce code are available from github.
Both source code and data are [available from GitHub](https://github.com/grst/compbio_benchmark). You can have a look at the implementation for each language in the following jupyter notebooks: 

* [Python 3.6.1](https://github.com/grst/compbio_benchmark/blob/master/task1.py.ipynb)
* [R 3.3.2](https://github.com/grst/compbio_benchmark/blob/master/task1.R.ipynb)
* [Julia 0.5.2](https://github.com/grst/compbio_benchmark/blob/master/task1.jl.ipynb)

## Results 
### Data manipulation works with some caveats. 
[DataFrames.jl](https://github.com/JuliaData/DataFrames.jl) provides a comparable functionality to [pandas](https://pandas.pydata.org) or [dplyr](dplyr.tidyverse.org). Additionally, I used [DataFramesMeta.jl](https://github.com/JuliaStats/DataFramesMeta.jl) for more readable data frame manipulation. The dataframe package provides all basic functionality, but is still under active development and I encountered one or two bugs which required workarounds. 

### Plotting works decently with Gadfly. 
The [Gadfly](http://gadflyjl.org/stable/) package for plotting in Julia works really well. It implements a clean *julianic* API to the Grammar of Graphics. While maybe still not as complete as `ggplot` for R, I consider it as a sufficiently mature solution to work with on an everyday basis. 

### Julia is not faster than python.
This is where it comes to the crunch!

While staying withing tidyverse, R is not as slow as its reputation. However, when using user-defined function (and yes, it's vectorized!) R takes 14 minutes to finish what can be achieved with python in about 11 seconds. 

The sad point: Julia is significantly slower than python both for loading data and applying a function to each row. It does outperform python in applying a user-defined function to a column of a data-frame, but not very impressively. 

| Task                                              | Python  | R      | Julia | 
|---------------------------------------------------|---------|--------|-------| 
| Loading data                                      | 32.6    | 115.68 | 79.57 | 
| Group by + aggregate by count                     | 7.91    | 12.76  | 16.46 | 
| Apply user defined function to column             | 11.1    | 834    | 8.63  | 
| Loop over all rows, applying function to each row | 17.9    | 1503.6 | 70.11 | 


<br /><small>*Time in seconds. All computations have been performed on a single core of a Linux Mint 17.1 laptop with Intel(R) Core(TM) i7-2620M CPU @ 2.70GHz CPU; Julia 0.5.2, Python 3.6.1, R 3.3.2*</small>


## Python and R remain the languages of choice.  
Julia allows to write readable code for data science. Elementary packages (plotting and data frames) are available and rapidly improving. However, the most appealing claim of Julia -- it's superior performance over python -- does not hold for data manipulation within data frames. Likely, this is due to the fact that both pandas and dplyr already use highly-optimized C implementations. 

Be this as it may -- for me, this test showed that python and R are still a pragmatic choice of programming language for everyday Bioinformatics tasks -- And that I won't bother learning Julia.  

