animalmove: Analysis of animal population-level patterns in R. 
====

## Features

* [Animal Movement Indices](vignettes/IntrotoAnimalMove.md)
  
  * Realized Mobility Index
  * Movement Coordination Index
  * Population Dispersion Index

## Installation

*Install Development Tools*

```
> install.packages("devtools")

```

*Install Package from Github*

```
> install_github(repo="umd-lib/animalmove", auth_user="github_username", password="github_password")

```
Example command

```
> install_github(repo="umd-lib/animalmove", auth_user="ibelyaevumd", password="xxxx")

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
