# Reproducible Research: there's no excuse -- start NOW!
Using a single command we can reproduce all results and figures from the paper
and supplementary material:

```
nextflow run grst/my_analysis
```

Here's how!

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




## Additional tips for writing reusable code (aka "packages")
* Write unit tests
* Use continuous integration




