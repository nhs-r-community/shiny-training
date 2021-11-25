# Shiny training

## One day Shiny training for health and care analysts

This training has been prepared for delivery by the NHS-R community but all the source materials are provided under an open licence. If you work in health and social care in the UK and you would like to attend this training (which is provided for free) then please use the contact information on the NHS-R community page to get in touch with NHS-R. If you'd like to run it in your organisation feel free to get in touch or just use the materials however you please.

If you have comments or suggestions please get in touch with the author or file an issue or a pull request.

## Course outline

The course is intended for analysts with little to no prior experience of Shiny and covers the following:

-   Introduction to Shiny and setting out your code

-   Your first application

-   Build a real application

-   Simplifying reactivity with reactive expressions

-   Optional:

    -   NSE in Shiny applications

    -   Bookmarks

-   Dynamic UI

-   Writing nice error messages for your Shiny applications

-   Downloading files/ Rmarkdown

-   Custom layout functions

-   {shinydashboard}

-   Interacting with a Shiny plot

-   Optional:

    -   Modules

(please note that at the time of writing this is subject to revision because the training is not yet complete)

## Prerequisites

The material is pitched at analysts with at least beginner level of R. The more familiar you are with R, the better able you will be to complete the exercises but if you get stuck you can browse the answers so you shouldn't get completely left behind. Those who are very competent at R or have a bit of experience with Shiny are likely to get through the material with time to spare and there is extra material for those who might otherwise finish a bit early.

## Preparation
For the course you can either use the NHS-R Community cloud which has everything set up or you can download all the course material to your own laptop. Instructions for the NHS-R Community introduction to R and R Studio are same up to the point of installing packages.

You can also type the following code into the Console:

``` r
# install.packages("usethis")
usethis::use_course("nhs-r-community/shiny-training")
```
which downloads the zip from this page, creates a project in a default location and unzips the documents ready to use. You will be asked to confirm whether or not to delete the zip file.

Note that the {usethis} package must be downloaded first to run and has been commented out in this example code.

Other packages that need to be installed for this course are:

install.packages("tidyverse")
install.packages("leaflet")
install.packages("rmarkdown")
install.packages("shiny")
install.packages("shinydashboard")
install.packages("DiagrammeR")
install.packages("DT")
install.packages("lubridate")
install.packages("knitr")
