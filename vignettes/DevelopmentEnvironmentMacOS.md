# R and R Development Tools Installation



## R Software Prerequisites

*	Download and install the latest stable version of R for [Mac OS](http://cran.r-project.org/bin/macosx/) (3.0.2 or higher).

*	Download the latest stable version of [RStudio Desktop](http://www.rstudio.com/ide/download/desktop) for Mac OS.


## Package Development Prerequisites

*	The core software development utilities (GNU software development tools including a C/C++ compiler).
*	LaTeX for building R manuals and vignettes.
*	R development tools.

### Installation of core software development utilities
1.	Download and install XCode from the [Mac AppStore](http://itunes.apple.com/us/app/xcode/id497799835?mt=12).
2.	Within XCode go to Preferences : Downloads and install the Command Line Tools.
3.	Install the [MacTeX LaTeX distribution](http://www.tug.org/mactex/downloading.html) (or another version of LaTeX for the Mac). 
	
### R development tools installation

*Install Development packages*

	install.packages("devtools", repos="http://cran.rstudio.com/")
	install.packages("roxygen2", repos="http://cran.rstudio.com/")
	install.packages("knitr", repos="http://cran.rstudio.com/")
	install.packages("markdown", repos="http://cran.rstudio.com/")

*Load Libraries*

	library("devtools")
	library("roxygen2")
	library("knitr")
	library("markdown")


### Configuration of Local Environment

*Create local .Rprofile*

```
$ cd ~ 
$ vi .Rprofile
```

```
First <-function() {
  options(
    repos = c(CRAN = "http://cran.rstudio.com/"),
    browserNLdisabled = TRUE,
    deparse.max.lines = 2)
}

if (interactive()) {
  suppressMessages(require(devtools))
}
```

*Add environment variable to avoid build errors for packages in Suggests entry in the namespace*

```
$ cd ~ 
$ vi .profile
```

```
export _R_CHECK_FORCE_SUGGESTS_=FALSE
```
