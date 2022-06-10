library(shiny)
library(DT)
library(dplyr)
data(diamonds, package = "ggplot2")

table_UI <- function(id, dataset){ #dataset in addition to be able to set up differents datasets
  ns <- NS(id) #namespace generation

  tagList(
    checkboxInput(
      inputId = ns("summary"),
      label = "show summary",
      value = FALSE
    ),
    selectInput(
      inputId = ns("summary_column"),
      label = "summary based on:",
      choices = colnames(dataset)
    ),
    DTOutput( #data table showing
      outputId = ns("table")
    )
  )
}

table_server <- function(id, dataset){
  moduleServer(
    id,
    function(input, output, session){
      table_data <- reactive({
        if(input$summary){
          data <- dataset %>%
            group_by(.data[[input$summary_column]]) %>%
            summarise(counts = n())
        }else{
          data <- dataset
        }

        data
      })

      output$table <- renderDT({
        table_data()
      })
    }
  )
}

ui <- fluidPage(
  table_UI("mtcars", dataset = mtcars),
  table_UI("diamonds", dataset = diamonds),
  table_UI("CO2", dataset = CO2)
)

server <- function(input, output, session){
  table_server("mtcars", dataset = mtcars)
  table_server("diamonds", dataset = diamonds)
  table_server("CO2", dataset = CO2)
}

shinyApp(ui, server)
