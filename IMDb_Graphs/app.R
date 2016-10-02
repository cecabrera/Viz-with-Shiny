# setwd("C:/Users/CamiloE/Dropbox/1. Proyectos/Ikognitive/Blogs/Viz with Shiny/IMDB_Graphs/"); source("read.R")
# require(shiny) ; runApp("C:/Users/CamiloE/Dropbox/1. Proyectos/Ikognitive/Blogs/Viz with Shiny/IMDB_Graphs", launch.browser = TRUE)
# require(rsconnect); rsconnect::deployApp('C:/Users/CamiloE/Dropbox/1. Proyectos/Ikognitive/Blogs/Viz with Shiny/IMDB_Graphs')

require(shiny)
require(shinydashboard)
require(countrycode)
require(plotly)
require(data.table)

source("read.R")

# Fase Set up
# require(shiny) ; runApp("C:/Users/CamiloE/Dropbox/1. Proyectos/Ikognitive/Blogs/Viz with Shiny/IMDb_Graphs", launch.browser = TRUE)
ui <- dashboardPage(
  dashboardHeader(title = "Viz with Shiny")
  , dashboardSidebar(
    selectInput(
      inputId='grafico'
      , label='Selecciona el gráfico:'
      , choices = c('Histograma', 'Género', 'País', 'Idioma', "Mapa")
    )
  )
  , dashboardBody(
  	plotlyOutput('graph')
  )
)

server <- function(input, output) {
	output$graph <- renderPlotly({
		plot <- NULL
	    if(input$grafico %in% 'Histograma'){
			plot <- plot_ly(
			  data = d
			  , x = ~ imdbRating
			  , type ='histogram'
			  ) %>% layout(
			    title = "Histograma del rating"
			  )
	    } else if(input$grafico == 'Género'){
	      			plot <- ggplotly(
	      			  ggplot(d[Genre %in% levels(Genre)]) +
	      			  geom_bar(aes(x = Genre,fill = Success)) +
	      			  labs(x = '',y = '', title = 'Películas por género') +
	      			  theme(axis.text.x = element_text(angle = 90, hjust = 1))
	      			)
	      	    }
	})
}

# Fase Aplicación Terminada
# ui <- dashboardPage(
#   dashboardHeader(title = "Gráficas en Shiny"),
#   dashboardSidebar(
# 	    # radioButtons(
# 	    selectInput(
# 	      inputId='grafico'
# 	      , label='Selecciona el gráfico:'
# 	      , choices = c('Histograma', 'Género', 'País', 'Idioma', "Mapa")
# 	    )
#   ), dashboardBody(
#   	plotlyOutput('graph')
#   )
# )
# 
# server <- function(input, output) { 
# 	output$graph <- renderPlotly({
# 		plot <- NULL
# 	    if(input$grafico %in% 'Histograma'){
# 			plot <- plot_ly(
# 			  data = d
# 			  , x = ~ imdbRating
# 			  , type ='histogram'
# 			  ) %>% layout(
# 			    title = "Histograma del rating"
# 			  )
# 	    } else if(input$grafico == 'Género'){
# 			plot <- ggplotly(
# 			  ggplot(d[Genre %in% levels(Genre)]) +
# 			  geom_bar(aes(x = Genre,fill = Success)) +
# 			  labs(x = '',y = '', title = 'Películas por género') +
# 			  theme(axis.text.x = element_text(angle = 90, hjust = 1))
# 			)
# 	    } else if(input$grafico == 'País'){
# 			plot <- ggplotly(
# 			  ggplot(d[Country %in% levels(Country)[10:40]]) +
# 			  geom_bar(aes(x=Country,fill=Success),position='fill') +
# 			  labs(x='',y='',title='Películas por país') +
# 			  theme(axis.text.x = element_text(angle = 90, hjust = 1))
# 			)
# 	    } else if(input$grafico %in% 'Idioma'){
# 			plot <- ggplotly(
# 			  ggplot(d[Language %in% levels(Language)[25:50]])+
# 			  geom_bar(aes(x=Language,fill=Success),position='fill')+
# 			  labs(x='',y='',title='Películas por idioma') +
# 			  theme(axis.text.x = element_text(angle = 90, hjust=1))
# 			)
# 		} else if(input$grafico == "Mapa") {
# 			plot <- plot_ly(
# 			  data = d[, .N, by = .(Country, Country_Code)][order(-N)]
# 			  , z = ~N
# 			  , text = ~Country
# 			  , locations = ~Country_Code
# 			  , type = 'choropleth'
# 			  , color = ~sqrt(N)
# 			  , marker = list(line = list(color = toRGB("grey"), width = 0.5))
# 			  , colorbar = list(title = '')
# 			) %>% layout(
# 			  title = 'Cantidad de películas por país'
# 			  , margin = list(t=75)
# 			  , geo = list(
# 			    showframe = FALSE
# 			    , showcoastlines = TRUE
# 			    , projection = list(type = 'Mercator')
# 			  )
# 			)
# 		}
# 	    plot
# 	})
# }

shinyApp(ui, server)