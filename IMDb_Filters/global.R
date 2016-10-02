# setwd("C:/Users/CamiloE/Dropbox/1. Proyectos/Ikognitive/Blogs/Viz with Shiny/IMDB Graphs/"); source("read.R")
# require(shiny) ; runApp("C:/Users/CamiloE/Dropbox/1. Proyectos/Ikognitive/Blogs/Viz with Shiny/IMDB_Filters", launch.browser = TRUE)
# require(rsconnect); rsconnect::deployApp('C:/Users/CamiloE/Dropbox/1. Proyectos/Ikognitive/Blogs/Viz with Shiny/IMDB_Filters')

require(shiny)
require(shinydashboard)
require(plotly)
require(stringr)
require(data.table)

source("read.R")