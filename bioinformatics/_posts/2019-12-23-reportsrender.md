---
layout: post
title: Building a Fully Reproducible Data Analysis Workflow Using Notebooks and Nextflow
---

In this post, I will describe a data-analysis workflow I developed to
address the challenges I face as a computational biologist:

1. **Ensure full reproducibility down to the exact versions of software used.**
   The irreproducibility of results is a [major problem in science](https://www.nature.com/news/1-500-scientists-lift-the-lid-on-reproducibility-1.19970).
   I can tell from own experience that it is really hard to get other people's
   code to run, if they did not carefully specify software requirements.

2. **Support mixing of R, Python and Shell commands.** Whether R or Python is
   better often depends on the particular task. Sometimes it's even
   preferable to run a command-line tool. Therefore, I want to be
   able to switch between languages.

3. **Automatic execution on a high performance cluster (HPC).** Manually writing
   [job scripts](https://www.msi.umn.edu/content/job-submission-and-scheduling-pbs-scripts)
   and babysitting running jobs is a pain, the workflow should take care
   of that automatically.

4. **Automatically only re-execute modified parts.** Some steps can be
   computationally expensive, so it would be nice not having to execute them
   every time I fix a typo in the final report.

5. **Automatically generate reports and deploy them as a website.**
   A major part of my work is to present the results of my analyses
   to a non-technical audience (that's usually Molecular Biologists).
   This usually involves copying and pasting figures to a word document
   that is sent around by email -- a process that is error-prone and leads
   to [outdated versions floating around](https://xkcd.com/1459/).

I achieve this by tying together two well-established technologies:
[Jupyter](https://Jupyter-notebook-beginner-guide.readthedocs.io/en/latest/what_is_Jupyter.html)
and [Rmarkdown](https://rmarkdown.rstudio.com/) notebooks on the one hand and the
pipelining engine [Nextflow](https://www.nextflow.io/) on the other hand.

## This post in brief

In the following section, I explain why using Jupyter or
Rmarkdown notebooks alone is not enough. I will reflect on a few weaknesses of
notebooks and propose how to address them.

Next, I'll introduce [reportsrender](https://github.com/grst/reportsrender/),
a python package I created to facilitate generating HTML reports from both
Jupyter and Rmarkdown notebooks.

Finally, I'll show how to use reportsrender and Nextflow to build
a fully reproducible data analysis pipeline.

Reportsrender is [available from GitHub](https://github.com/grst/reportsrender/).
The full example pipeline is available from [a separate repository](https://github.com/grst/universal_analysis_pipeline/)
and I suggest to use it as a starting point for your next data analysis project.

## Notebooks alone are not enough

Notebooks are widely used among data scientists, and they are a great tool to make
analyses accessible. They are an obvious choice to form the basis
of my workflow. However, notebooks alone have several shortcomings
that we need to address:

1. **Using notebooks alone does not ensure reproducibility of your code.** The
   exact software libraries used must be documented. Moreover, Jupyter
   notebooks have been
   [critizised for](https://docs.google.com/presentation/d/1n2RlMdmv1p25Xy5thJUhkKGvjtV-dkAIsUXP-AL4ffI/preview#slide=id.g362da58057_0_1) potentially containing hidden states
   that hamper reproducibility.

2. **Jupyter notebooks don't allow for fine-grained output control.**
   A [feature of Rmarkdown](https://yihui.org/knitr/options/#text-results)
   that I'm missing in the Jupyter world is
   to control for each cell if I want to hide the input, the output or both.
   This is extremely helpful for generating publication-ready reports. Like
   that, I don't have to scare the poor Molecular Biologist who is going to read
   my report with 20 lines of `matplotlib` code but can rather show the
   plot only.

3. **Multi-step analyses require chaining of notebooks**. Clearly,
   in many cases it makes sense to split up the workflow in multiple notebooks,
   potentially alternating programming languages.  
   [Bookdown](https://bookdown.org/) and [Jupyter book](https://Jupyterbook.org/intro.html)
   have been developed to this end and allow the integration of
   multiple Rmarkdown or Jupyter notebooks respectively into a single
   "book". I have
   [used bookdown previously](https://github.com/icbi-lab/immune_deconvolution_benchmark/)
   and while it made a great report, it was not entirely satisfying:
   It can't integrate Jupyter notebooks, there's no HPC support
   and caching is ["handy but also tricky sometimes"](https://bookdown.org/yihui/rmarkdown/r-code.html):
   It supports caching individual code chunks, but it doesn't support proper
   cache invalidation based on external file changes. I, therefore, kept re-executing
   the entire pipeline most of the time.

### Fix reproducibility by re-executing notebooks from command-line in a conda environment

In [this excellent post](https://yihui.org/en/2018/09/notebook-war/),
Yihui Xie, the inventor of Rmarkdown, advocates re-executing every notebook from
scratch in linear order,
responding to [Joel Grus' criticism](https://docs.google.com/presentation/d/1n2RlMdmv1p25Xy5thJUhkKGvjtV-dkAIsUXP-AL4ffI/preview#slide=id.g362da58057_0_1)
on notebooks. Indeed, this immediately solves the issue with
'hidden states'.

We can execute notebooks from command-line through `Rscript -e "rmarkdown::render()"` or
`Jupyter nbconvert --execute`, respectively. Moreover, we can turn notebooks into
parametrized scripts that allow us to specify input and output files from the command
line. While this is [natively supported](https://bookdown.org/yihui/rmarkdown/parameterized-reports.html)
by Rmarkdown, there's the [papermill](https://github.com/nteract/papermill)
extension for Jupyter notebooks.

If we, additionally, define a [conda environment](https://towardsdatascience.com/data-science-best-practices-python-environments-354b0dacd43a) that pins
all required software dependencies, we can be fairly sure that the result
can later be reproduced by a different person on a different system. Alternatively,
we could use a [Docker](https://towardsdatascience.com/docker-made-easy-for-data-scientists-b32efbc23165)
or [Singularity](https://sylabs.io/docs/) container. Nextflow supports
either of these technologies out-of-the-box (see below).

### Hide outputs in Jupyter notebooks by using a _nbconvert_ preprocessor

While being natively supported by Rmarkdown, we need to find a workaround
to control the visibility of inputs/outputs in Jupyter notebooks.

Luckily, `nbconvert` comes with a [TagRemovePreprocessor](https://nbconvert.readthedocs.io/en/latest/api/preprocessors.html#nbconvert.preprocessors.TagRemovePreprocessor)
that allows to filter cells based on their metadata.

By enabling the preprocessor, we can, for instance, add `{'tags': ["remove_input"]}`
to the metadata of an individual cell and hide the input-code in the HTML report.

### Use Nextflow to orchestrate multi-step analyses and automate caching

[Nextflow](https://nextflow.io) is a relatively novel _domain specific language_
designed to build data-driven computational pipelines. It is really easy to get started
with and yet very powerful. Wrapping our pipeline in nextflow automatically
adresses the remaining issues:

- **run everywhere**: Nextflow abstracts the pipeline logic from the execution layer.
  Your pipeline will, therefore, run locally, on an HPC or in the cloud with
  no additonal effort.
- **caching**: Nextflow automatically only re-executes steps that have changed.
  Based on the input files declared for each process, it properly supports cache
  invalidaiton.
- **environments**: Nextflow comes with native support for conda, Docker and
  Singularity. For instance, you can provided a conda [yaml file](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#create-env-file-manually)
  that lists all required dependencies and Nextflow will automatically
  download them before executing the analysis.

### Deploy reports on GitHub pages

By executing the notebooks from the command line, we obtain an HTML report for each
analysis step. While you could send them around via email, I recommend to automatically
distribute them via GitHub pages. The website serves as a _single point of truth_
and everyone needing to access your results will automatically receive the latest
version.

## I created the reportsrender package to facilitate building the pipeline

To make these steps as easy as possible, I developed the [reportsrender](https://github.com/grst/reportsrender)
package in Python which wraps Nbconvert and Rmarkdown into a single command.
It adds support for [hiding inputs/outputs](https://reportsrender.readthedocs.io/en/latest/features.html#hiding-cell-inputs-outputs)
and [notebook-parameters](https://reportsrender.readthedocs.io/en/latest/features.html#parametrized-notebooks)
to Jupyter notebooks.
Both Rmarkdown and Jupyter notebooks are rendered with the same template
through [pandoc](https://github.com/jgm/pandoc), ensuring consistently looking reports.

Executing and converting a notebook to HTML is as easy as:

```
reportsrender hello.ipynb hello_report.html
```

or

```
reportsrender hello.Rmd hello_report.html
```

Through [jupytext](https://github.com/mwouts/jupytext/), reportsrender
supports executing arbitrary notebook formats. It can even execute
python notebooks with Rmarkdown through the reticulate engine:

```
# Execute a markdown notebook with nbconvert
reportsrender hello.md hello_report.html

# execute a Jupyter notebook with Rmarkdown
reportsrender --engine=rmd hello.ipynb hello_report.html
```

Running parametrized notebooks is as easy as

```
reportsrender hello.Rmd hello_report.html --params="foo=bar"
```

Using the `index` subcommand, it allows for generating
an index page for github-pages:

```
reportsrender index --index=index.md first_report.html second_report.html third_report.html
```

## Building the pipeline in nextflow: full example

Let's build a minimal example pipeline that first

1. generates some data in a Jupyter notebook, then
2. visualizes the data in an Rmarkdown notebook and finally
3. deploys the reports to GitHub pages.

The full pipeline including additional recommenations on how to structure
the project is [available from GitHub](https://github.com/grst/universal_analysis_pipeline).

Here, I will describe step-by-step how to build it.

<div style="text-align: center;"><img src="/assets/bioinformatics/2019-11-29-reportsrender/pipeline_flowchart.png" alt="pipeline workflow" /></div>

### 1. Create a Jupyter notebook that generates the data

Show on GitHub: [`01_generate_data.ipynb`](https://github.com/grst/universal_analysis_pipeline/blob/master/analyses/01_generate_data.ipynb)

Let's first create a cell that defines the parameters
for this notebook (in our case, the `output_file`).

To this end, define a variable in a cell and add the
tag `parameters` to the cell metadata. This is documented on the
[papermill website](https://papermill.readthedocs.io/en/latest/usage-parameterize.html).
The declared value serves as default parameter, and
will be overwritten if the parameter is specified from the command line.

```python
In [1]: output_file = "results/dataset.tsv"
```

This parameter can be manipulated from the `reportsrender` call:

```
reportsrender 01_generate_data.ipynb 01_generate_data.html --params="output_file=results/data.csv"
```

Now, let's generate some data. For the sake of the example, we will just
download the _iris_ example dataset and write it to a `csv` file.

```python
In [2]: import pandas as pd
        iris = pd.read_csv(
            "https://raw.githubusercontent.com/mwaskom/seaborn-data/master/iris.csv"
        )
        iris.to_csv(output_file)
```

### 2. Create an Rmarkdown notebook for visualizing the data

Show on GitHub: [`02_visualize_data.Rmd`](https://github.com/grst/universal_analysis_pipeline/blob/master/analyses/02_visualize_data.Rmd)

First, we define the input file as a [parameter in the Rmd document](https://bookdown.org/yihui/rmarkdown/parameterized-reports.html).

```Rmd
---
title: Visualize Data
params:
   input_file: "results/dataset.tsv"
---
```

Next, we use `ggplot2` to create a plot:

````Rmd
```{r}
library(ggplot2)
library(readr)

iris_dataset = read_csv(params$input_file)

ggplot(iris_dataset, aes(x=sepal_width, y=sepal_length, color=species))
```
````

### 3. Create a nextflow pipeline that chains everything together

Show on GitHub: [`main.nf`](https://github.com/grst/universal_analysis_pipeline/blob/master/main.nf)

The first process takes the Jupyter notebook as an input and
generates an HTML report and a `csv` file containing the dataset.
The channel containing the dataset is passed on to the second
process. Note that we use the `conda` directive, to define a
conda environment in which the process will e executed.

```nextflow

process generate_data {
    def id = "01_generate_data"
    conda "envs/run_notebook.yml"  //define a conda env for each step...

    input:
        file notebook from Channel.fromPath("analyses/${id}.ipynb")

    output:
        file "iris.csv" into generate_data_csv
        file "${id}.html" into generate_data_html

    """
    reportsrender ${notebook} \
        ${id}.html \
        --params="output_file=iris.csv"
    """
}

```

The second process takes the Rmarkdown notebook and the `csv` file as input
and generates another HTML report.

```nextflow
process visualize_data {
    def id = "02_visualize_data"
    conda "envs/run_notebook.yml"  //...or use a single env for multiple steps.

    input:
        file notebook from Channel.fromPath("analyses/${id}.Rmd")
        file 'iris.csv' from generate_data_csv

    output:
        file "${id}.html" into visualize_data_html


    """
    reportsrender ${notebook} \
        ${id}.html \
        --params="input_file=iris.csv"
    """
}
```

The HTML reports are read by a third process and turned into a website
ready to be served on GitHub pages. The `publishDir` directive
will copy the final reports into the `deploy` directory, ready to be pushed to
GitHub pages.

```nextflow
process deploy {
    conda "envs/run_notebook.yml"
    publishDir "deploy", mode: "copy"

    input:
        file 'input/*' from Channel.from().mix(
            generate_data_html,
            visualize_data_html
        ).collect()

    output:
        file "*.html"
        file "index.md"

    // need to duplicate input files, because input files are not
    // matched as output files.
    // See https://www.nextflow.io/docs/latest/process.html#output-values
    """
    cp input/*.html .
    reportsrender index *.html --index="index.md" --title="Examples"
    """
}
```
