shinyUI(
  dashboardPage(
    dashboardHeader(title = "Filtros en Shiny"),
    dashboardSidebar(
      sliderInput("year", "Año de Salida", 2000, 2016, value = c(2010, 2016))
      , sliderInput("rating", "Rating IMDB", 0, 10, value = c(0,10))
      , selectInput("genre", "Género de la película", c(levels(d$Genre),'All'), selected = 'All') #, multiple = TRUE)
      , textInput("director", "Nombre del director", placeholder = 'Por ejemplo: Woody Allen')
      , textInput("actor", "Nombre del actor", placeholder='Por ejemplo: Nicolas Cage')
      , selectInput("country", "País de la película", c(levels(d$Country),'All'),selected = 'All')
      , selectInput("language", "Lenguaje de la película", c(levels(d$Language),'All'),selected = 'All')
    ),
    dashboardBody(
      fluidRow(
        valueBoxOutput("box1", width = 4)
        , valueBoxOutput("box2", width = 4)
        , valueBoxOutput("box3", width = 4)
      )
      , fluidRow(
        plotlyOutput("filtros", height=500)
      )
    )
  )
)