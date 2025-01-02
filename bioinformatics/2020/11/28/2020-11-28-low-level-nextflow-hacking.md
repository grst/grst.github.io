---
title: Low-level Nextflow Hacking
layout: post
---

I recently created a proof-of-principle for a [deeper integration of jupyter notebooks with nextflow](https://github.com/grst/nxfvars/) 
and started implementing my first [modules](https://github.com/nf-core/modules) in the
new [Nextflow DSL2](https://www.nextflow.io/blog/2020/dsl2-is-here.html).  While doing so, I learned a lot about Groovy, and Nextflow itself.

![dungbeetle](dung_beetle.jpg)
*A small bug: A dung beetle, captured in Piano Battaglia, Sicily, Italy*


## 1. Closures

Closures are omnipresent in nextflow pipelins, and I have used them many times
without knowing. For instance in

```groovy
awesome_channel.map { it -> it + 1}
```
the expression `{it -> it + 1 }` is a closure. 

Closures are like the anonymous functions I know from Python, 
except they are not. 
In an anonymous function, the variables are evaluated in the scope where the function 
is defined. In a closure they are evaluated in the scope the closure gets executed. 

In the following Python code, `inc` uses `a` from the outer scope, because this 
is where it got defined:  

**Input**:
```python
a = 41

inc = lambda _: a + 1

def main():
    a = 0
    print(inc(None))

main()
```
**Output:**
```
42
```

However, in the following Groovy code, `inc` uses `a` from the inner scope, because
this is where it gets executed: 

**Input**:
```groovy
a = 41

inc = { a + 1}

def main() {
    a = 0
    println inc()
}

main()
```

**Output:**
```
1
```


## 2. Using a dynamic `tag` value

In [nf-core modules](https://github.com/nf-core/modules), for each process, the sample id is used
as the [`tag`](https://www.nextflow.io/docs/latest/process.html#tag),
such that it niecely shows up in the log. The problem is, the `tag` directive
gets evaluated, before variables from the input channels become available. 

Therefore, the following snippet does not work: 

**Input**:
```groovy                                                                              
nextflow.enable.dsl = 2                                                         
                                                                                
process foo {                                                                   
    tag id     

    //It does not work either to use `meta.id` directly (without `exec`)
    //tag meta.id                                                          
                                                                                
    input:                                                                      
    val meta                                                                    
                                                                                
    exec:                                                                     
    id = meta.id                                                                
}                                                                               
                                                                                
workflow {                                                                      
    foo([id: 'test'])                                                           
}   
```
**Output:**
```
No such variable: id
```

To work around this, we can use a closure (`tag { id }`) 
to defer the evaluation until the 
process actually gets executed and the values become available: 


**Input**:
```groovy                                                                              
nextflow.enable.dsl = 2                                                         
                                                                                
process foo {                                                                   
    tag { id }                                                                  
                                                                                
    input:                                                                      
    val meta                                                                    
                                                                                
    exec:                                                                     
    id = meta.id                                                                
}                                                                               
                                                                                
workflow {                                                                      
    foo([id: 'test'])                                                           
}   
```
**Output:**
```
[07/76cf28] process > foo (test) [100%] 1 of 1 ✔
```

An intriguing detail is that by using Groovy's [string interpolation](http://docs.groovy-lang.org/latest/html/documentation/#_string_interpolation),
we can successfully use `tag "${meta.id}"`, but not `tag "${id}"`. Apparently, 
the string interpolation defers the execution until the input channels are available, 
but not until the code in the `exec` section got executed.  


## 3. The Nextflow "Script" class and the implicit variable "this"

Internally, for Nextflow, each `.nf` file is an instance of the class [`Script`](https://docs.groovy-lang.org/latest/html/api/groovy/lang/Script.html).
From within the file it can be accessed as the implicit variable `this`. 

Its arguments can be retrieved using `this.binding.variables`, containing,
amongst others:
 * the [`params`](https://www.nextflow.io/docs/latest/config.html?highlight=params#scope-params),
 * [nextflow implicit variables](https://www.nextflow.io/docs/latest/script.html?highlight=basedir#implicit-variables)
   such as `baseDir`, `workDir`, and 
 * variables globally defined in a `.nf` file (→ `script_var` in the example). 
  
Note that variables declared using `def` are not accessible through `this` (→ `other_var` in the example) . 

**Input:**
```groovy
params.bar = "test"                                                             
script_var = 42                                                                 
def other_var = 1                                                     
                                                                                
process foo {                                                                   
    exec:                                                                       
    println this.binding.variables                                              
}                                                                               
                                                                                
workflow {                                                                      
    foo()                                                                       
}    
```

**Output**:
```
[
    args:[], params:[bar:test], baseDir:/scratch/nf-test,
    projectDir:/scratch/nf-test, workDir:/scratch/nf-test/work, 
    workflow:repository: null, projectDir: /scratch/nf-test,
    commitId: null, revision: null,
    startTime: 2020-11-28T16:47:44.162643+01:00, endTime: null,
    duration: null, container: {}, commandLine: nextflow ./test.nf,
    nextflow: nextflow.NextflowMeta([...]), success: false,
    workDir: /scratch/nf-test/work, launchDir: /scratch/nf-test,
    profile: standard, nextflow:nextflow.NextflowMeta([...]),
    launchDir:/scratch/nf-test, moduleDir:/scratch/nf-test,
    script_var:42
]
```

## 4. Nextflow's process representation and the "task" implicit variable

I already used the expression `task.cpus` many times in my nextflow pipelines, without
questioning how it works. 

When a process gets executed in Nextflow, it is an instance of the class [`TaskRun`](https://github.com/nextflow-io/nextflow/blob/master/modules/nextflow/src/main/groovy/nextflow/processor/TaskRun.groovy),
which holds a config object of the instance [`TaskConfig`](https://github.com/nextflow-io/nextflow/blob/master/modules/nextflow/src/main/groovy/nextflow/processor/TaskConfig.groovy). 
The latter is accessible through the implicit variable `task`.

It contains all variables defined within a process; `cpus` just
happens to be one of them. Additionally, we can access all `input` variables via `task.binding`. Again, variables declared with `def` cannot be accessed. 

**Input:**
```groovy
process foo {                                                                   
    process_var = 42                                                            
    def other_var = 42                                                          
    cpus = 2                                                                    
                                                                                
    input:                                                                      
    val(meta)                                                                   
                                                                                
    exec:                                                                       
    id = meta.id                                                                
    def local_var = 1                                                           
    println "task = ${task}"                                                    
    println "task.binding = ${task.binding}"                                    
}                                                                               
                                                                                
workflow {                                                                      
    foo([id: "test"])                                                           
}
```

**Output:**
```
task = [
    process_var:42, process:foo, cpus:2, index:1, echo:false,
    validExitStatus:[0], maxRetries:0, maxErrors:-1, 
    shell:[/bin/bash, -ue], executor:local, name:foo, 
    cacheable:true, errorStrategy:TERMINATE,
    workDir:/scratch/nf-test/work/7a/605dabf4d1b454c288434b6381622c, 
    hash:7a605dabf4d1b454c288434b6381622c
]

task.binding = [meta:[id:test], $:true, task:[...], id:test]
```



## 5. Debugging Nextflow

I found that Nextflow's fancy ANSI-logging feature sometimes swallows `println` statements
or error messages. It is possible to turn it off using `nextflow run -ansi-log false`. 
I also learned to check the `.nextflow.log` file more often. It sometimes contains
helpful additional information, such as full Java stack traces. 
