-15--
layout: post
title: A fully reproducible data analysis workflow using nextflow and jupyter or Rmarkdown notebooks.  
---


In this post I will describe a data-analysis workflow that helps to address the challenges that I face as a computational biologist. 

The workflow should: 

 * be fully reproducible, including the software packages
 * language agnostic (I tend to switch between mostly R and python depending of the task and sometimes need to execute standalone programs in between) 
 * executable on a HPC 
 * support caching  (only re-execute parts that have changed) 
 * self-reporting (no error-prone, manual creating of reports) 
 * all results should be available at a central place  (always up-to-date)


I achieve this by tying together two well estabilshed technologies: Notebooks (jupyter for python, Rmarkdown for R) and nextflow on the other hand. 


## The downside of bookdown
Review of possibilities (nbconver, rmd, jupyerbook)

## I created the reportsrender package to facilitate building the pipeline


## Universal analysis pipeline, a template for future projects 


