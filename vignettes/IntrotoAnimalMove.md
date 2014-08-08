<!--
%\VignetteEngine{knitr::docco_classic}
%\VignetteIndexEntry{An Introduction to the animalmove package}
-->

An Introduction to the **animalmove** package
=======================================


Introduction
------------

The  **animalmove** package provides a series of statistical analyses of spatio-temporal animal movement patterns at the population level, as originally described in the paper **"How landscape dynamics link individual- to population-level movement patterns: a multispecies comparison of ungulate relocation data"**, Mueller, Thomas, et al. Global Ecology and Biogeography 20, no. 5 (2011): 683–94. [DOI: 10.1111/j.1466-8238.2010.00638.x](http://doi.org/10.1111/j.1466-8238.2010.00638.x).

We start with the import of the library **animalmove** in R environment. The package can be installed in the local system from the source package archive for OS X or Win platform.  See the package [README](../README.md) for installation information.

Statistical Analyses
----------------------------

There are three statistical analyses in the package, each with its own vignette demonstrating analysis usage:

[Realized Mobility Index (RMI)](RMIAnalysis.md) - reports the amount of habitat an individual
 occupies as a proportion of the population range calculated across individuals

[Movement Coordination Index (MCI)](MCIAnalysis.md) - measures the degree to which movements
among individuals are related in direction and distance

[Population Dispersion Index (PDI)](PDIAnalysis.md) - measures the inter-relation of relocation records across individuals within a species as a point pattern to detect whether individuals co-
occur, are dispersed from each other or are independently distributed

Each of the analyses incorporates the methodology described in the paper, and produces a numerical outcome, which can be assesed by examining the result set or be summarized and visualized using the custom summaries and high-level functions.

The analyses assume the relocation data of multiple species are preliminarily synchronized and preprocessed by time and space dimensions.


