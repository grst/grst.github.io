---
title: Reproducible analysis workflows using notebooks and nextflow (in 2021) 
layout: post
---

<!--

TWEET: 
Making your data analysis fully reproducible is now easier than ever by
combining @nextflowio and #jupyter or #rmarkdown notebooks using the 
brand new @nf-core notebook modules. 

--> 

Levels or reproduciblity: 
https://www.nature.com/articles/s41592-021-01256-7

workflow managers: 
it starts to sink in to use them for pipelines, not so much yet for reproducible
analyses. 

## Prerequisites

The reproducible analysis pipeline builds upon the following pieces of software

 * [nextflow]()
 * [jupyter notebooks]() or [rmarkdown documents]()
 * [nf-core tools]() to install the notebook modules (you can also install them
   manually from github) 
 * [papermill]() to parametrize jupyter notebooks
 * [jupytext](), optionally, to use text-based jupyter notebooks which play more
   niclely with version control and has [several other advantages]()

## The processes explained

There are two modules, `JUPYTERNOTEBOOK` and `RMARKDOWNNOTEBOOK`. The former can
handle `.ipynb` files and all [jupytext]() formats, the latter `.Rmd` files.
Both modules support parametrization.

The notebooks have the following input channels: 

 * `tuple val(meta), path(notebook)`: A groovy map with meta-information. 
 * `val parameters`: A groovy map with parameters. If you have no parameters,
   use the empty groovy map `[:]`. 
 * `path input_files`: A channel with one or multiple input files required by
   the notebook.  

The process produces the following outputs: 



## Implementation patterns

All implementations make use of [Nextflow DSL2](). At the very
top of your nextflow script, add the following line: 

```nextflow
nextflow.enable.dsl = 2
```

For demonstration purposes, I use jupyter notebooks. All examples 
should work the same way with rmarkdown notebooks. 

### One notebook, single dataset

In the simplest case, you want to simply reproduce a single 
analysis you performed on a certain dataset. The notebook 
is not parametrized. 

```nextflow

include { JUPYTERNOTEBOOK } from "./modules/nf-core/modules/jupyternotebook/main" addParams(
	publish_TODO: "results/..."
)

workflow {
	JUPYTERNOTEBOOK(
	   [id: 'unparametrized'], file("analyses/01_unparametrized.py"),
	   [:],
	   file("data/TODO.txt")
	)
}

```

### One notebook, multiple data

In this example, we use the same notebook, but apply it to multiple datasets. 
This is particularly useful for generating pre-defined reports for different
datasets.

We now need to pass a Channel of multiple files to the `input_files` channel. 
Unless all input files have a certain naming pattern you can use to locate the
file in the `work` directory, it makes sense to pass the filename of the
dataset to the notebook. 

```nextflow

workflow {
	ch_input_data = Channel.fromPath("data/*.TODO")
	JUPYTERNOTEBOOK(
		file("analysis/02_parametrized_report.py"),
		ch_input_data.map { it -> it.name }, 
	 	ch_input_data
	)
}
```

### One notebook, same data, multiple parameters

Using a notebook with multiple parameters and multiple datasets is left as an
exercise to the reader. 

### Filter artifacts by type


### Using custom containers


## Notes on reproducibility

### Containerization

 - docker/singularity
 - article by Paolo about docker containers
 - conda to singularity

### Limits of reproducibility

 - GPU operations depend on a specific GPU generation and on the usage of
   deterministic algorithm


### Shut up an show me the code! 

### Note: 
My third (and most successful) attempt to get fully reproducible analysis
pipelinese right. My two previous attempts [reportsrender], [nxfvars] still had 
some issues or were too cumbersome.
