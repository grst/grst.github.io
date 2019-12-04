---
layout: post
title: A Fully Reproducible Data Analysis Workflow Using Notebooks and Nextflow 
---

In this post I will describe a data-analysis workflow that helps to address the challenges that I face as a computational biologist. 

The workflow should: 

 * be fully reproducible, including the software packages
 * be language agnostic (I tend to switch between R and python depending on the task and sometimes need to execute standalone programs in between) 
 * be executable on a high performance cluster (HPC)
 * support caching  (only re-execute parts that have changed) 
 * automatically generate reports and deploy them as a website (no error-prone, manual creating of reports) 


I achieve this by tying together two well estabilshed technologies: Jupyter or Rmarkdown notebooks on the one hand and the pipelining engine Nextflow on the other hand. 


Notebooks are very popular among data scientists and they are a great tool to make analyses available to others. They have a few downsides. Reproducibility is not given, 
if you don't make the exact software packages available to run the notebooks. 
They have been critizised for being 'non-linear' which I think [doesn't matter if you re-execute them in a clean environment to generate a report](). 
Also, jupyter notebooks don't allow for fine-grained output control to generate publication-ready reports (imagine I generate a report for a biologist: he is only interested in the plots and their 
interpretation and not the code that generated them. 
And, many analyses consist of multiple steps that need to be tied together somehow. 

There are the excellent [bookdown]() and [jupyter book]() projects that address these points to a certain extent. They allow to chain together multiple Rmarkdown documents or jupyter notebooks
into a single report. I used bookdown [in a former project]() and even though it made a nice report, it felt somewhat unflexible: 

* I can't mix Rmarkdown and jupyter notebooks (I could use python chunks within Rmarkdown with reticulate) 
* I can't use standalone programs in between (I could call them from R/python, but what if they need to run hihgly parallelized on the cluster) 
* Even though it supports caching, I kept re-executing the entire pipeline


## Chaining notebooks with nextflow
Therefore, for the current project, I broke down the analysis into individual notebooks and chain them together using nextflow. 
How to make it work:

* each notebook has input and output paramters (through [Rmd params]() and [papermill]())
* notebooks can be rendered as HTML through [Rmarkdown package]() and [nbconvert]()
* For each notebook, I define a process in nextflow, declaring inputs and outputs.
* Nextflow takes care of caching
* Nextflow takes care of executing the reports in either a conda env or a Docker/singularity container
* Finally, I generate an index page in HTML that links to the individual steps and deploy the HTML files to github-pages. 


## I created the reportsrender package to facilitate building the pipeline
To make these steps as easy as possible, I generated the [reportsrender]() package in pyhon which
wraps Nbconvert and Rmarkdown into a single command. Both R and jupyter notebooks will 
be rendered with a consistent template using pandoc. 

Executing and converting a notebook to HTML is as easy as: 
```
reportsrender hello.ipynb hello_report.html
```

or

```
reportsrender hello.Rmd hello_report.html
```

Through [jupytext]() reportsrender supports executing arbitrary notebook formats. It can even execute 
python notebooks with Rmarkdown through the reticulate engine:

```
reportsrender hello.md hello_report.html
reportsrender --engine=rmd hello.ipynb hello_report.html
```

Parametrizing notebooks is as easy as

```
reportsrender hello.Rmd hello_report.html --params="foo=bar"
```


It also generates an index page which can be used to deploy the reports: 
```
reportsrender index --index=index_file.html first_report.html second_report.html third_report.html
```

## Universal analysis pipeline, a template for future projects 
Here I demonstrate how to build a minimal pipeline in nextflow that
(1) generates some data in a jupyter notebook
(2) visualizes this data in an Rmd document. 

A template repo that I call the *Universal Analysis Pipeline* is available [from GitHub](). It contains 
a more comprehensive examplea and a directory structure for a data science project and will
serve me as template for future projects. 


### Let's first create the two notebooks: 

`01_generate_data.ipynb`

We, first define a cell that specifies the path to the output file of the first notebook. 
This parameter can be manipulated from nextflow, if you add the tag `parameters` to the 
jupyter notebook cell. This is documented on the [papermill website](). 

```python
In [1]: output_file = "results/dataset.tsv"
```

Let's load some example data from the internet and save it to the output file: 

```python
In [2]: import pandas as pd
	iris = pd.read_csv("https://raw.githubusercontent.com/mwaskom/seaborn-data/master/iris.csv")
	iris.to_csv(output_file)
```

`02_visualize.Rmd`

We define the input file as a [parameter in the Rmd document](). Then, we use ggplot 
to visualize the dataset:

````Rmd
---
title: Visualize Data
params:
   input_file: "results/dataset.tsv"
---

```{r}
library(ggplot2)
library(readr)

iris_dataset = read_csv(params$input_file)

ggplot(iris_dataset, aes(x=sepal_width, y=sepal_length, color=species))
```
````

### Now, we chain them together using nextflow:
`main.nf`

```nextflow

process generate_data {
	def id = "01_generate_data"
	publishDir "results/$id"

	input:
		"notebook.ipynb" from Channel.fromPath("${id}.ipynb")

	output:
		file "data.csv" into generate_data_data
		file "${id}.html" into generate_data_report

	"""
	reportsrender notebook.ipynb ${id}.html --params="output_file=data.csv"
	"""
}

process visualize {
	def id = "02_visualize"
	publishDir "results/$id"

	input:
		"notebook.Rmd" from Channel.fromPath("${id}.Rmd")
		"data.csv" from generate_data_data

	output:
		file "${id}.html" into generate_data_report

	"""
	reportsrender notebook.Rmd ${id}.html --params="output_file=data.csv"
	"""

}

```
