animalmove: Analysis of animal population-level movement patterns in R. 
====

Discontinued
-----------
Further work on this version of the animalmove package is discontinued.  See https://github.com/ctmm-initiative for all subsequent work on the ctmm package for Continuous-Time Movement Modeling.

Introduction
------------

The  **animalmove** package provides a series of statistical analyses of spatio-temporal animal movement patterns at the population level, as originally described in the paper **"How  landscape dynamics link individual- to population-level movement patterns: a multispecies   comparison of ungulate relocation data"**, Mueller, Thomas, et al. Global Ecology and    Biogeography 20, no. 5 (2011): 683–94. [DOI: 10.1111/j.1466-8238.2010.00638.x](http://doi.org/10.1111/j.1466-8238.2010.00638.x).

See [Introduction to the *animalmove* package](vignettes/IntrotoAnimalMove.md) for more information on using the package and the provided quantified measures for population-level movement patterns.

## Installation

*Install Development Tools*

```
> install.packages("devtools")

```

*Install Package from Github*

```
> install_github(repo="umd-lib/animalmove")

```

Example output

```
installing to /Library/Frameworks/R.framework/Versions/3.0/Resources/library/animalmove/libs
** R
** data
*** moving datasets to lazyload DB
** inst
** tests
** preparing package for lazy loading
Warning: replacing previous import by 'Hmisc::label' when loading 'animalmove'
Warning: replacing previous import by 'Hmisc::zoom' when loading 'animalmove'
Creating a generic function for 'aov' from package 'stats' in package 'animalmove'
Creating a generic function for 'TukeyHSD' from package 'stats' in package 'animalmove'
Creating a generic function for 'kruskal.test' from package 'stats' in package 'animalmove'
Creating a generic function for 'kruskalmc' from package 'pgirmess' in package 'animalmove'
Creating a generic function for 'polygon' from package 'graphics' in package 'animalmove'
** help
*** installing help indices
** building package indices
** installing vignettes
** testing if installed package can be loaded
Warning: replacing previous import by 'Hmisc::label' when loading 'animalmove'
Warning: replacing previous import by 'Hmisc::zoom' when loading 'animalmove'
* DONE (animalmove)
```

*Note*

You may see the following warning message. Please, ignore (this is a well-known devtools and RStudio conflict).

```
In FUN(X[[2L]], ...) :
  Created a package name, ‘2014-04-01 23:37:06’, when none found
```
## License

This package is free and open source software, licensed under [GPLv3](https://www.gnu.org/licenses/gpl-3.0-standalone.html).
