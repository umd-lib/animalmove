Build Process
====

### Download the package source

*	Obtain the source using git or download the package zip archive from [Github](https://github.com/umd-lib/animalmove).

* Unpack the the package zip (if the archive was downloaded)

* Change current directory to the package root directory

```
$ cd /projectroot/

* Configure local bash [profile](DevelopmentEnvironmentMacOS.md). 

```
* Build the package from the command line

```
$ R CMD BUILD .

```
Output

```
* checking for file ‘./DESCRIPTION’ ... OK
* preparing ‘animalmove’:
* checking DESCRIPTION meta-information ... OK
* cleaning src
* installing the package to build vignettes
* creating vignettes ... OK
* cleaning src
* checking for LF line-endings in source and make files
* checking for empty or unneeded directories
* looking to see if a ‘data/datalist’ file should be added
* re-saving tabular files
* building ‘animalmove_0.1.0.99.tar.gz’
```


*Install the package from the command line*

```
$ R CMD INSTALL .

```
Output

```
* installing to library ‘/Library/Frameworks/R.framework/Versions/3.0/Resources/library’
* installing *source* package ‘animalmove’ ...
** libs
make: Nothing to be done for `all'.
installing to /Library/Frameworks/R.framework/Versions/3.0/Resources/library/animalmove/libs
** R
** data
*** moving datasets to lazyload DB
** inst
** preparing package for lazy loading
Warning: replacing previous import by ‘Hmisc::label’ when loading ‘animalmove’
Warning: replacing previous import by ‘Hmisc::zoom’ when loading ‘animalmove’
Creating a generic function for ‘aov’ from package ‘stats’ in package ‘animalmove’
Creating a generic function for ‘TukeyHSD’ from package ‘stats’ in package ‘animalmove’
Creating a generic function for ‘kruskal.test’ from package ‘stats’ in package ‘animalmove’
Creating a generic function for ‘kruskalmc’ from package ‘pgirmess’ in package ‘animalmove’
Creating a generic function for ‘polygon’ from package ‘graphics’ in package ‘animalmove’
** help
*** installing help indices
** building package indices
** installing vignettes
   ‘IntrotoAnimalMove.Rmd’
** testing if installed package can be loaded
Warning: replacing previous import by ‘Hmisc::label’ when loading ‘animalmove’
Warning: replacing previous import by ‘Hmisc::zoom’ when loading ‘animalmove’
* DONE (animalmove)
```





