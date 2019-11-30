---
layout: post
title: Fixing the jupyter-notebook data science workflow
---

In a [recent post](https://towardsdatascience.com/5-reasons-why-jupyter-notebooks-suck-4dc201e27086) on Towards Data Science, Alexander Mueller critizised jupyter notebooks as being unsuitable for anything that goes beyond early exploratory data analysis and visualisations. 

I agree that jupyter notebooks have these shortcoming, but I'll argue that there are open source solutions to fix these proplems and use jupyter notebooks in production pipelines and larger projects. 


# Use *jupytext* to enable good code versioning
Jupytext is the most elegant solution to tacke this problem. Essentially, jupytext allows to store notebooks as plain text files (for instance markdown or plain python files). It works reliably, is well-tested and has excellent support from its creator, Marc Wouts. 
Obviously, the text files are not suitable to store output cells, but you can *pair* notebooks with an `ipynb` file that would store the outputs. However, you wouldn't want to keep them under version control. 


# Use jupytext the ... addon and black for code-style correction.  
Again, using jupytext, you can take advantage of, e.g. the [black pre-commit-hook]() to enforce proper formatting before you check in the notebook file into version control. Additionally, there's an [addon]() that allows you to use a keyboard shortcut to format the current cell. 


# Develop and test helper functions in a dedicated python module 
> A colleague of mine once said when you work with jupyter notebooks you basically forget software engineering. 

So just don't.  Yes, jupyter notebooks are a horrible tool to develop functions. But this is not what they are meant for. They are excellent for *executing* functions in order to explore and visualize data. 

To *develop* or other re-usable parts of software, just create a dedicated python module that you use alonside your notebooks. You can develop that in your favorite IDE, and write unit tests for it. 

Getting started is super easy: 

1. Create a file called `utils.py` in the same directory as the notebooks: 
```python
def my_function():
	"""
	A well-documented function, that can easily be re-used 
	along multiple notebooks. 

	Obviously, doctests are supported, or you can write a separate
	test file using e.g. `py.test`.

	>>> my_function()
	Hello World!
	"""
	return "Hello World!


```

2. From the jupyter notebook, import the function: 
```
In [1]: from utils import my_function
	my_function()

Out [1]: Hello World! 
```

As your `utils.py` file grows


# Embrace the non-linear workflow of jupyter and generate final reports in a clean environment 
The first notebook war! 
On the one hand, Jason Grout argues that he doesn't like notebooks. To solve the displute .. argues that notebooks should be renamed into "scratchpads" in which you can do whatever you want and finally be executed in a clean environment. 

This is the standard approach in the R(markdown) world and I think it's worth popagating it to the python world. An additional benefit is that you gain more control over the output-document and can, for instance, hide certain input and output cells in order to create a publication-ready report that isn't cluttered with intermediate steps that are irrelevant to your target audience. 

There's several alternatives to render notebooks:

* nbconvert (can't hide inputs/outputs)
* jupyterbook page
* reportsrender 


# Use nextflow to asynchronously execute long-running notebooks 
I [recently proposed]() a workflow that wires together jupyter notebooks using nextflow. 
Nextflow has excellent support for HPC schedulers and even cloud providers. Also, it takes care of caching the results of earlier steps so that only modified portions of the pipeline have to be re-computed. 
