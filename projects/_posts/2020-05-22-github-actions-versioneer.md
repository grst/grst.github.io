---
layout: post
title: Using GitHub actions to bump version numbers of Python packages upon release
---

I used to be a big fan of projects like [Versioneer](https://github.com/warner/python-versioneer)
or [get_version](https://github.com/flying-sheep/get_version) because they make
releasing a new version of a package as easy as

```bash
git tag v1.2.3
python setup.py sdist bdist_wheel
twine upload dist/*
```

No more tedious manual editing of version strings!

However, I found that this doesn't always work reliably, for instance on
continous integration (CI) servers which only perform a shallow clone of the last
commit and do not fetch tags. Also, the approaches mentioned above require
additional dependencies and can break alternative build tools, such as [flit](https://github.com/takluyver/flit).

Finally, [@takluyver](https://github.com/takluyver)'s comments in [takluyver/flit#257](https://github.com/takluyver/flit/issues/257)
convinced me that obtaining the version at runtime is a bad idea:

> I'm concerned about what the package winds up doing at runtime. It needs some extra dependency installed, and then it goes hunting for its metadata to figure out it's version number. I consider this similar to an object using introspection to look up its variable name in the call stack: you can do it, but you shouldn't. It can also have performance issues, because it winds up having to scan every installed package to find the one that it is. And it definitely violates the principle of 'do as little as possible on import'.
>
> I definitely want version numbers to be 'stamped' into the code of a package somehow so the package doesn't need to go looking for them.

## Back to static version strings

I went back to static version strings -- but now I have them automatically
generated by GitHub actions upon each release.

Here is an [example repository](https://github.com/grst/python-ci-versioneer)
demonstrating how it works. When creating a new release on GitHub,
the CI replaces the `__version__` variable with an actual version string derived
from the current tag. Then it builds the package and uploads it on PyPI.