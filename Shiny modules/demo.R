library(shiny)
library(ggplot2)

#call the module plot

plot_UI <- function(id){ #say that it is a UI fonction
  ns <- NS(id)

  tagList( #makes sure R will treate id well -> items separate the right way
    selectInput(
      inputId = ns("selected_col"),
      label = "selected column",
      choices = colnames(mtcars)
    ),
    plotOutput(
      outputId = ns("plot")
    )
  )
}

plot_server <- function(id){
  moduleServer(
    id,
    function(input, output, session){
      output$plot <- renderPlot({ #just need to refer to plot and no need for namespace
        ggplot(mtcars, aes(x = .data[[input$selected_col]], #new way to access colnames
                           y = mpg)) +
          geom_point()
      })
    }
  )
}

ui <- fluidPage(
  plot_UI(
    id = "module_1"
    ),
  plot_UI(
    id = "module_2"
  )
)

server <- function(input, output, session){
  plot_server(
    id = "module_1"
  )
  plot_server(
    id = "module_2"
  )
}

shinyApp(ui, server)
