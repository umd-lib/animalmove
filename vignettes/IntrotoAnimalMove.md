<!--
%\VignetteEngine{knitr::docco_classic}
%\VignetteIndexEntry{An Introduction to the animalmove package}
-->

An Introduction to the **animalmove** package
=======================================





Introduction
------------

The  **animalmove** package provides a series statistical analyses of the spatio-temporal animal movement patterns at the population level.
The package implement analyses described in the original paper **"How landscape dynamics link individualto population-level movement patterns:a multispecies comparison of ungulate relocation data"** (Mueller T., et. al, 2011).


We start with the import of the library **animalmove** in R environment. The package can be installed in the local system from the source package archive for OS X or Win platform.

## [Package Installation](../README.md)

Statistical Analyses
----------------------------

There are three statistical analyses in the package: 

## [Realized Mobility Index](RMIAnalysis.md)

## [Population Dispersion Index](PDIAnalysis.md)

## [Movement Coordination Index](MCIAnalysis.md)

Each of the analyses incorporates the methodology described in the paper, and produces a numerical outcome, which can assesed by the examining the result set or summarized and visualized the custom summaries and high-level functions.

The analyses assume the relocation data of multiple species are preliminary syncronized and preprocessed by time and space dimensions.


