---
layout: post
title: A Fully Reproducible Data Analysis Workflow Using Notebooks and Nextflow 
---

In this post I will describe a data-analysis workflow I developed to  
address the challenges that I face as a computational biologist. 
In the first section, I will explain the challenges and why they can't be solved
with classical Rmarkdown and jupyter notebooks only. 
Next, I will describe how I extend notebooks to a data science workflow. 
If you are not interested in the technical details but want to get started with
the workflow as quickly as possible, you can jump to section XXX and the
[reportsrender documentation]() directly. 

1. **Ensure full reproducibility down to the exact versions of software used.**
   Irreproducibility of results is a [major problem in science](https://www.nature.com/news/1-500-scientists-lift-the-lid-on-reproducibility-1.19970).
   I can tell from own experience that it is a pain to get other people's
   scripts to run, if they did not carefully specify software requirements.

2. **Support mixing of R, Python and Shell commands.** Whether R or Python is
   better often depends on the particular task. Sometimes it's even 
   preferable to run a command-line tool. Therefore, I want to be 
   able to switch between languages. 

3. **Automatic execution on a high performance cluster (HPC).** Manually writing
   [job scripts](https://www.msi.umn.edu/content/job-submission-and-scheduling-pbs-scripts) 
   is a pain, the workflow should take care of that automatically. 

4. **Automatically only re-execute modified parts.** Some steps can be
   computationally expensive, so it would be nice not having to execute them
   every time I fix a typo in the final report. 

5. **Automatically generate reports and deploy them as a website.** 
   A major part of my work is to opresent the results of my analyses 
   to a non-technical audience (that's usually Molecular Biologists).
   This usually involves copying and pasting figures to a word document
   that is sent around by email -- a process that is error-prone and leads 
   to [outdated versions floating around](https://xkcd.com/1459/). 


I achieve this by tying together two well estabilshed technologies: 
[Jupyter](https://jupyter-notebook-beginner-guide.readthedocs.io/en/latest/what_is_jupyter.html)
and [Rmarkdown](https://rmarkdown.rstudio.com/) notebooks on the one hand and the
pipelining engine [Nextflow](https://www.nextflow.io/) on the other hand. 


## Notebooks alone are not enough
Notebooks are widely used among data scientists and they are a great tool to make 
analyses accessible. They are an obvious choice to form the basis
of my workflow. However, notebooks alone have several shortcomings
that we need to address:

1. **Using notebooks alone does not ensure reproducibility of your code.** The 
   excact software libraries used must be documented. Moreover, jupyter
   notebooks have been 
   [critizised for containing hidden states](https://docs.google.com/presentation/d/1n2RlMdmv1p25Xy5thJUhkKGvjtV-dkAIsUXP-AL4ffI/preview#slide=id.g362da58057_0_1)
   that hamper reproducibility. 

2. **Jupyter notebooks don't allow for fine-grained output control.**
   A [feature of Rmarkdown](https://yihui.org/knitr/options/#text-results)
   which I'm missing in the Jupyter world is 
   to decide for each cell if I want to hide the input, the output or both. 
   This is extremely helpful for generating publication-ready reports. Like 
   that I don't have to scare the poor molecular biologist who has to read 
   my report with 20 lines of `matplotlib` code but can rather show the 
   plot only. 

3. **Multi-step analyses require chaining of notebooks**. Clearly, 
   it makes often sense to split up the workflow in multiple notebooks,
   potentially switching between R and python between them.  
   [Bookdown](https://bookdown.org/) and [jupyter book](https://jupyterbook.org/intro.html) 
   have been developed to this end and allow the integration of
   multiple Rmarkdown or jupyter notebooks respectively into a single
   "book" document. I have 
   [used bookdown previously](https://github.com/icbi-lab/immune_deconvolution_benchmark/) 
   and while it is great in principle, I wasn't completely satisfied: 
   It can't integrate jupyter notebooks, there's no HPC support 
   and caching is ["handy but also tricky sometimes"](https://bookdown.org/yihui/rmarkdown/r-code.html): 
   It supports caching individual code chunks, but it doesn't support proper
   cache invalidation based on external file changes. I therefore kept re-executing
   the entire pipeline most of the time. 


## I address these problems by combining notebooks with Nextflow

1. **Execute all notebooks from command-line and generate a HTML report.**
   This immedeatly solves the problem of hidden states. See also this 
   [excellent post by Yihui Xie](https://yihui.org/en/2018/09/notebook-war/).
   We can do that through `Rscript -e "rmarkdown::render()"` or `jupyter
   nbconvert --execute`, respectively. 

2. **Use conda environments to pin software dependencies.** Nextflow supports
   [conda environments](https://towardsdatascience.com/data-science-best-practices-python-environments-354b0dacd43a)
   out-of-the-box. To ensure reproducibility of a notebook, I just
   need to declare all dependencies in a [yaml file](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#create-env-file-manually)
   and nextflow takes care of the rest. The same is true for [Docker](https://towardsdatascience.com/docker-made-easy-for-data-scientists-b32efbc23165)
   or [Singularity](https://sylabs.io/docs/) containers, should you prefer those. 

3. **Use a nbconvert
   [TagRemovePreprocessor](https://nbconvert.readthedocs.io/en/latest/api/preprocessors.html#nbconvert.preprocessors.TagRemovePreprocessor)
   to hide input and output cells**. Like this, we can add `{'tags': ["remove_input"]}` 
   to the metadata of individual cells and hide the code in the HTML file.  

4. **Chain notebooks using nextflow.**
   Nextflow automatically only re-executes steps that have changed. 
   It supports proper cache-validation based on external file changes (if all
   input files are properly declared) 

5. **Publish the results on github-pages**. 
   No more E-mailing of reports. 

* Chain together individual notebooks using nextflow. Integrate all HTML files
  into a single website that can be shared with collaborators. 


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
