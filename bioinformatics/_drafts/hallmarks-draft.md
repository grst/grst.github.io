---
id: 20200628092923
layout: post
title: Hallmarks of Great Scientific Software
---

Science is facing a [reproducibility
crisis](https://en.wikipedia.org/wiki/Replication_crisis). Poorly designed or
 implemented scientific software represent a major limitation in making
packages reusable and analyses reproducible. In this article, I'll break down
good software engineering practices to six *hallmarks*. These hallmarks guide
researchers through improving their code quality, maximizing the utility and
impact of the software, and in the long run improve the perspective of
replication in science.

![hallmarks](/assets/bioinformatics/hallmarks_annotated.png)

**Figure 1**: The Hallmarks of Good Scientific Software[^hallmarks]. The icons
 (except pipeline) are from [fontawesome](https://fontawesome.io). The figure
 may be reused under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)
 license.

[^hallmarks]: Of course, the title and the figure are inspired by [the hallmarks
  of cancer](https://doi.org/10.1016/j.cell.2011.02.013).

Let's first distinguish between *software packages* and *data analysis reports*.
Both are pieces of software which are covered by the hallmarks – however, they
have slightly different priorities.  Software packages are a tool, or a
collection of tools which are created with the aim of being applied to different
datasets. A typical example would be a sequence aligner like
[STAR](https://github.com/alexdobin/STAR), or a library for single-cell RNA-seq
analysis like [scanpy](https://scanpy.readthedocs.io/) or
[Seurat](https://satijalab.org/seurat/). The main goal of software packages is
**reusability**, defined by the ability to reuse the code for multiple datasets
and for diverse goals of data analysis.

In contrast, *Data analysis reports* mostly build upon existing software
packages and are specifically adapted to produce interpretable results for a
certain dataset. The main goal of data analysis reports is **reproducibility**,
defined by the ability to reproduce the results when run in another computing
environment or in a later time point than when the report was written.  Yet, it
can often make sense to abstract a data analysis report into a reusable pipeline
which can be applied to other datasets.

The first four hallmarks apply to both software packages and data analysis
reports. (In fact, they apply to pretty much any kind of software):

1. Use version control ([git](https://git-scm.com/))
2. Use automated testing and continuous integration (e.g. [GitHub actions](https://github.com/features/actions))
3. Containerize all dependencies (e.g. [Docker](https://www.docker.com/), [Singularity](https://sylabs.io/docs/))
4. Write extensive, high-quality documentation (e.g. [sphinx](https://www.sphinx-doc.org/en/master/), [pkgdown](https://pkgdown.r-lib.org/))

In addition to that, two more hallmarks apply to data analysis reports:

5. Use automated reporting (e.g. [Rmarkdown](https://rmarkdown.rstudio.com/), [Jupyter notebooks](https://jupyter.org/))
6. Use a workflow manager (e.g. [nextflow](https://www.nextflow.io/), [Snakemake](https://snakemake.readthedocs.io/en/stable/))

## Use version control
![vc](/assets/bioinformatics/brick_vc.png)

The first, and arguably the most important hallmark is to use
[git](https://git-scm.com)[^vc-systems]. It keeps track of all your code
changes, and allows you to share your code on public repositories such as
[GitHub](https://github.com/)[^github]. **Making the code publicly available and
easy to be modified by others is the first step towards making your project both
discoverable and reproducible.**

[^vc-systems]: There are other version control systems than git, but they play a diminishing role nowadays.

There are many benefits of using git and GitHub, for instance:

* You don't need to worry about backups any more. Every version of your code you store in git can be restored at any time.
* It allows you to keep track of what you did (this is very useful when continuing on a project after several weeks of interruption).
* It allows you to synchronize changes across working environments (say laptop and server cluster) and between collaborators.
* GitHub provides an issue tracker and project management tools to keep track of bugs and suggestions.
* GitHub increases your visibility in the community and promotes community contributions in form of [pull requests](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests). 

**Tool of choice:** [git](http://git-scm.com) in combination with [GitHub](https://github.com) or [GitLab](https://gitlab.com). 

[^github]: [GitLab](https://about.gitlab.com/) is an alternative to GitHub which
  is becoming more and more popular. In contrast to GitHub it is open source and
  can be installed on your own servers. Nevertheless, GitHub is where all the
  developers are and that's where you want your project to be for being
  discovered.

## Use automated testing and continuous integration
![testing](/assets/bioinformatics/brick_testing.png)

Automated testing is an industry standard in software firms for *years*, but it
is terribly underused in most scientific software, particularly those developed
by single contributors such as students and contractors. Automated testing does
not only ensure that your software package works on other systems than yours or
that you don't break old functionality while adding new one – **it also
increases the likelihood that the results your software generates are actually
predictable, at least within the space of the input parameters that you can
test, and correct**. The correctness of the software output is top priority for
scientific software.

The concept of automated testing is simple: for every piece of code you write,
you also write a *unit test* that calls the piece of code with some example
data, and validates that it produces the expected result.  

Initially, this might seem like a waste of time, but it isn't: it helps to to
**find bugs early**. As a result, it pays and saves time in the long run.
Finding bugs early decreases the cost for fixing them. If you detect a bug right
after writing the function, you still have everything in your memory and can
likely fix it within minutes. If the bug is discovered by someone else a few
months later, it might take you hours or days to figure out the problem, because
you have to dig into the code again. There are excellent packages for automated
testing for virtually every programming language. The most common ones are
[pytest](https://docs.pytest.org/en/latest/) for Python (here I recommend
hypothesis as well, which can greatly expand the input space) and
[testthat](https://testthat.r-lib.org/) for R.

Writing tests by itself is not helpful if they are not executed on a regular
basis. This is where *continuous integration* comes into place. Continuous
integration runs your tests every time you upload your code on e.g. GitHub and
notifies you if the tests fail. By combining continuous integration with a
[branch-and-pull-request
workflow](https://guides.github.com/introduction/flow/), you ensure that the
code on your master branch is always fully tested. You are notified when tests
fail, therefore increasing the chance to fix bugs early and quickly.

**Tools of choice**: [pytest](foo) for Python packages, [testthat](foo) for R
packages. [GitHub Actions](foo) for continuous integration. 

## Containerize dependencies
![container](/assets/bioinformatics/brick_container.png)

> If I have seen further it is by standing on the shoulders of Giants.

*(Isaac Newton, 1675)*

This is definitely true for scientific software. Most software packages and data
analyses would not be possible without giants like
[dplyr](https://dplyr.tidyverse.org/),
[ggplot2](https://ggplot2.tidyverse.org/), [numpy](https://numpy.org/),
[scipy](https://www.scipy.org/) and many more domain-specific packages.
Unfortunately, complex dependencies make it hard to install and run your
software. They also hamper reproducibility of your analysis as different
versions might be incompatible or produce slightly different results. This
phenomenon is commonly referred to as the *[dependency
hell](https://en.wikipedia.org/wiki/Dependency_hell).*

Therefore, it is vital to accurately declare all dependencies required for your
software to run, **down to the exact version number**.  The most reliable way of
doing so is to build a *container* with all software required to run your
software. That way, your package or analysis can be ran in exactly the same
software environment you have been using. Containers are one of the few ways to ensure
that your analysis can be ran in a few years from now[^conda-reprod] (just a
joke: another way is to buy a new server every time when you publish a software
paper, keep that running, and book the bills from your funding agency - if not
joking, there are other ways, for instance dedicated server, but I agree
containerization is a good point).

For software packages (as opposed to data analysis reports) it is also
appropriate to declare the dependencies in the format of the corresponding
package manager. This could be a [DESCRIPTION
file](http://r-pkgs.had.co.nz/description.html) for R, a [setup.py
file](https://python-packaging.readthedocs.io/en/latest/dependencies.html) for
python, or a [conda
recipe](https://docs.conda.io/projects/conda-build/en/latest/resources/define-metadata.html#source-section).
Arguably, the best option is to offer both: properly declared dependencies and a
container.

**Tools of choice**: [Singularity](https://sylabs.io/docs/) and
[Docker](https://www.docker.com/) for data analyses.
[Bioconda](https://bioconda.github.io/) or
[conda-forge](https://conda-forge.org/) for software packages.

[^conda-reprod]: I long believed that by [exporting a conda
  environment](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#sharing-an-environment)
  the same can be achieved, but was proven wrong. See the [discussion on
  GitHub](https://github.com/conda/conda/issues/9257). 

## Write extensive, high-quality documentation
![docs](/assets/bioinformatics/brick_docs.png)

Documentation is an essential part of each software. **Without proper
documentation, the most elegant piece of software can be useless.** As a rule of
thumb, the documentation should have at least as many lines as the source code.
Documentation helps users getting started with your software quickly and vastly
increases the potential userbase.

For software packages, good documentation consists, one the one hand, of a
documentation of the public interface (API). The API consists of all functions,
classes etc. which are exposed to the end user. The API documentation describes
the input parameters and results for each function.  On the other hand, the
documentation should comprise instructions on how to install the package and a
step-by-step tutorial teaching the user to apply the software to real-world
datasets.

For data analysis reports, it is best to mix the documentation with the code
(see [self-reporting analyses](#write-self-reporting-data-analyses). Moreover,
it is vital to provide step-by-step instructions on how to rerun the analysis.


(David: here I have a question: what's the best practice to keep codes and
documentation synchronized? Often I spend much time on this, too, and have not
found good solutions. What happens is that when I change the code, I forgot to
change the documentation, until an user complains.)

**Tools of choice**: [sphinx](https://www.sphinx-doc.org/en/master/)
(Python/general purpose) and [pkgdown](https://pkgdown.r-lib.org/) for R. 

## Write self-reporting data-analyses
![notebooks](/assets/bioinformatics/brick_reporting.png)

It is common practice to run a few commands in an R shell to produce a plot and
then copy and paste it to a PowerPoint presentation. **This is not only terrible
from a reproducibility perspective, it is also inefficient and error-prone.** It
is inefficient, because you have to re-do the plot manually if you change your
preprocessing or get new data. It is error-prone, because you'll forget to
update all plots and old (wrong) versions keep floating around.

By using self-reporting data analyses this process gets streamlined and
automated.  An excellent way to write self-reporting data analyses are
*Notebooks*[^notebooks]. Notebooks are an implementation of [literate
programming](https://en.wikipedia.org/wiki/Literate_programming), a way of
mixing computer code with prose language. In this way, you can explain your data
and your results at the same place where you perform the analysis. Notebooks can
be rendered into beautiful web-pages, presentations, or PDF documents which you
can directly share with your collaborators. Finally, you can publish them
alongside your paper ensuring other researchers can understand your analysis.

**Tools of choice:** [Rmarkdown](https://rmarkdown.rstudio.com/) and
[bookdown](https://bookdown.org/home/) when using R, [Jupyter
notebooks](https://jupyter.org/), and [jupyter
book](https://jupyterbook.org/intro.html) for Python and other languages.

[^notebooks]: Notebooks are a *terrible* tool to develop software packages. Only
  use them to describe your analysis and factor out longer code snippets into
  external modules. For more background, read [this post by Yihui
  Xie](https://yihui.org/en/2018/09/notebook-war/). 

## Use a workflow manager
![pipelines](/assets/bioinformatics/brick_pipeline.png)

While notebooks are great for documenting and streamlining downstream analyses,
they are unsuitable for computationally expensive tasks like preprocessing raw
sequencing files. Similar to the downstream analyses, **the naive approach is to
write a few bash scripts and run them on a workstation or submit them to a high
performance cluster (HPC). Again, this is irreproducible, inefficient and
error-prone.** It is irreproducible, because it is hard to appreciate in which
order the scripts need to be ran. Moreover, the scripts are likely to be
specific for the scheduler used on your HPC. It is inefficient, because you
manually need to ensure that all jobs completed successfully before running the
next step. It is error-prone, because it is easy to forget to re-execute certain
steps after changing parameters or fixing bugs.

By using a *workflow manager*, you solve all these problems. In a
pipeline-script, you implicitly document which of your analysis-steps depends on
which input-files and intermediate results and thereby, in which order they need
to be executed.  The workflow manager takes care of executing the individual
steps **in parallel** wherever possible and makes sure to only re-compute parts
that were modified. Moreover, it abstracts the pipeline logic from the
system used for execution, enabling your pipeline to **run everywhere**, be
it on a personal computer, institutional HPC or cloud instances.

Workflow managers play well with the other concepts discussed in this article.
They can directly execute pipelines from GitHub, execute tasks in containers and
can be used to [tie together multiple
notebooks](https://grst.github.io/bioinformatics/2019/12/23/reportsrender.html).
In brief, by providing a pipeline, other researchers can reliably reproduce your
entire analysis with a single-command.

Finally, when developing re-usable software packages, it can often make sense to
build upon a workflow manager. Many problems, like parallelization, submitting
jobs to HPC or cloud instances, caching, etc. has already been excellently
solved by these tools and there is no need to re-invent the wheel.

**Tools of choice:** [nextflow](https://www.nextflow.io/) or
[Snakemake](https://snakemake.readthedocs.io/en/stable/)[^pipelinetools]

[^pipelinetools]: Both nextflow and Snakemake are excellent. I personally prefer
  nextflow because I find it easier to get started with. See also my [comparison
  on GitHub](https://github.com/grst/snakemake[^x]:_nextflow_wdl).

## Further reading

In this article, I gave a high-level overview of the hallmarks. For a hands-on
tutorial I recommend [this
training material](https://nbis-reproducible-research.readthedocs.io/en/latest/repres_project/)
by the [NBIS](https://www.nbis.se/). Quite recently a [review preprint](
https://www.biorxiv.org/content/10.1101/2020.06.30.178673v1.abstract?%3Fcollection=)
about how and why you should use pipelining engines has been published on
biorXiv.

## Footnotes

## Further comments by David

Thanks Gregor for sharing. I enjoyed the reading. A few points that I think
important, though I am pretty sure that you know them already.

* What you talk about are rather *tools*. What I believe matter a lot are
    *mindsets*. For instance, the simple rules including *don't repeat your
    self*, and *keep it simple, stupid* are important as well. They are the
    fundamentals of developing reusable and reproducible code. There the book *clean
    code* (though written for Java) is a good one. Or the refactor book is a
    good starting point.
* For people working with applied bioinformatics and computational sciences, I
    believe an important skill set (as you described) is to write functions in
    reports, factor them out, and **package them**. This should become a habit
    as early as possible in the career.
* Another point I am missing is to *involve people*. You discussed this in
    multiple contexts implicitly. I want to discuss it also explicitly: sharing
    a piece of code with the public is to communicate with them. Concretely,
    involve as many people as possible to test your code (github is one way,
    another way is for instance by teaching, yet another way is to setup Web
    UIs and ask for feedback). Invite them to give feedback, not only about
    logic but also about code. Given enough eyeballs, all bugs are shallow,
    E. Raymond got it right.
* In the same line, read other people's code and learn from them. That is a
    fast lane to program well.
* Maybe you can consider your points also in the FAIR context. What you describe
    make software findable (github), accessible (github), interoperable
    (containerization and workflow), and reproducible.
* Developing software is a long-term investment. A piece of high-quality
    software is a wealth. Create them with enthusiasm and craftsmanship, because
    users and other coders can feel that.
