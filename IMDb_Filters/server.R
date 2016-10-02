# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  # Filtros para gráfico principal
  logic <- reactive({
    l <- d$Year >= input$year[1] &
    d$Year <= input$year[2] &
    d$imdbRating >= input$rating[1] &
    d$imdbRating <= input$rating[2] 

    if(input$genre != "All"){
      l <- l & d$Genre %in% input$genre
    } 
    if(input$country != "All"){
      l <- l & d$Country %in% input$country
    } 
    if(input$language != "All"){
      l <- l & d$Language %in% input$language
    } 
    if (!is.null(input$director) && input$director != ""){
      l <- l & grepl(input$director, d$Director)  
    }
    if (!is.null(input$actor) && input$actor != ""){
      l <- l & grepl(input$actor, d$Actors)  
    }
    l
  })

  output$filtros <- renderPlotly({
    ggplotly(
      ggplot(d[
        logic()
        ], aes(x = Year, y = imdbRating)) +
        geom_jitter(aes(
          color = Success,
          text = paste(
          '<b>Título: <i>',Title,'</b></i>','<br>'
          , 'Director: <b>', Director,'</b>','<br>'
          , 'Protagonista: <b>', Actors,'</b>','<br>'
          , 'Género: ', Genre,'<br>'
          , 'País: ', Country,'<br>'
          , 'Idioma: ', Language,'<br>'
          , 'Estreno: ', Released,'<br>'
          , 'Metascore: ', Metascore
        ))) +
      theme_minimal() +
      # coord_cartesian(ylim = c(0,10),xlim=c(minyear,maxyear))+
      # scale_x_continuous(breaks = seq(minyear,maxyear,1))+
      labs(x='Año',y='Rating imdb')
    )
  })
  output$box1 <- renderValueBox({
    valueBox(
      value = tags$p("Cantidad de películas", style = "font-size: 70%;")
      , subtitle = tags$p(nrow(d[logic(),]), style = "font-size: 150%;")
      , icon = icon("dollar")
      , color = "blue"
    )
  })
  output$box2 <- renderValueBox({
    valueBox(
      value = tags$p("Calificación media", style = "font-size: 70%;")
      , subtitle = tags$p(d[logic(), format(mean(imdbRating, na.rm = TRUE), digits = 3)], style = "font-size: 150%;")
      , icon = icon("bicicle")
      , color = "orange"
    )
  })
  output$box3 <- renderValueBox({
    valueBox(
      value = tags$p("Proporción de éxito", style = "font-size: 70%;")
      , subtitle = tags$p(format(
      d[logic(), .N, by = Success][Success %in% "Success", N]/d[logic(), .N, by = Success][Success %in% "Fail", N]
      , digits=3), style = "font-size: 150%;")
      , icon = icon("dollar")
      , color = "red"
    )
  })
})
