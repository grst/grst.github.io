# Reproducible Research: there's no excuse -- start NOW!
Using a single command we can reproduce all results and figures from the paper
and supplementary material:

```
nextflow run grst/my_analysis
```

Here's how!

## Related Reads:
* https://nbis-reproducible-research.readthedocs.io/en/latest/ (basically the
  smae as this, only more extensive)
* https://reproducibility.sschmeier.com/downloads.html

## The Levels of reproducibility

| Level | problem | tool | recommended software |
| ------+---------+------+----------------------|
| 1     | keep track of & publish code & publish data | version control | git + github |
| 2     | keep track of your analysis | notebooks | Rmarkdown/jupyter |
| 2.1   | generate publication-ready reports | render engine | reportsrender |
| 3     | keep track of software versions | environments | conda+singularity |
| 4     | chain everything together | pipelines | nextflow |

## Keep track of code
Publishing all your code lets users reproduce what you did - it's as easy as
that. It will still be a pain for them (I'll show why in the next steps). But
it's a start!

GitHub is the perfect place to share code publicly. Do it now:

```
git init
git add -A
git commit -m "Add first step of analysis"
git push -u origin master
```

Additional benefits:
 * never worry again about backups
 * restory any state of your work if you screwed up
 * issue tracker
 * collaborate with others.

## Keep track of your analysis
Are executing commands on the command-line to convert some files?
Ever wondered a month later how you generated them?
Are you creating plots in the R console and copying them to a word document?
Ever had to re-do them because you found a mistake in a previous step?

Rmarkdown notebooks (in Rstudio) and jupyter notebooks are a great tools
that allow you to keep track of all the commands you ran to generate your
result.

Additional benefits:
 * Describe what you did in plain text to make your analysis understandable.
 * Publication-ready reports are just one step away!

Recommended software
 * Rmarkdown
 * jupyter notebooks
 * jupytext


### Generate publication-ready reports.
Notebooks are not only great to keep track of code, they are also great for
writing! (There are people that wrote their PhD thesis entirely in Rmarkdown).

How about writing the reports you send to your collaborators
directly in a notebook? No more copying & pasting to word documents. Simply
generate a HTML or PDF document and send it out. The Plus: if you find
a mistake in the analaysis, simply fix it and re-generate the report.
No need to copy it over to Word again (and, thereby, forget that you should've
regenerated figure 3 as well that, eventually, is copied to the manuscript...)

The only problem with notebooks is that they might include a lot of code that
is not of interest for your readers. Luckily, Rmarkdown already provides
fine-grained control over what is shown in the final report:

````
```{r include=FALSE}
# neither code nor results will show up in the report.
```

```{r echo=FALSE}
# code will not show up, but the plot will.
plot(1:10)
```
````

To achive the same with jupyter notebooks, we developed `reportsrender`

TODO: TODO describe how to hide cells.


## Keep track of software versions
Ever spent an entire afternoon on getting to run a certain script in R?
Installing and uninstalling R and corresponding libraries until you finally
found a combination that is (1) actually installable and (2) actually works?

There's an easy solution: Fix the software versions in an environment.

Start now:
```
conda create -n my_analysis r-base=3.6.1 r-dplyr r-ggplot2 bioconductor-edger
conda activate my_analysis
```

You can, finally, export your environment to a `yml` file that allow others to
reproduce exactly the same environment on their system:

```
conda env export > environment.yml
```

Even better, create a singularity or docker image that contains your
environment.

TODO describe how to create singularity image.

### Viable software
* docker
* singularity
* conda
* virtualenv
* packrat


## File structure and template
There's no universal structure that fits every project. However there are some
conventions that I found useful. The most important one is:

> Keep INPUT, RESULTS and CODE strictly separate.

To achieve this I usually have at least the following three folders:

```
data      # input data
notebooks # code
results   # output
```

You should always be able to delete the `results` folder and re-generate it
from `data` using the code in the `notebooks` folder. If that is the case, your
research is fully reproducible.



## Additional tips for writing reusable code (aka "packages")
* Write unit tests
* Use continuous integration




