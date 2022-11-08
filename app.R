library(shiny)
pacman::p_load(shinydashboard,tidyverse, readxl)



ui <- fluidPage(titlePanel(HTML("<center>Esta app es para ver cómo cargar archivos </center>")),
  sidebarLayout(
    sidebarPanel(
      radioButtons(inputId = "data_t", "Selecciona el tipo de datos",choices = c(csv=",",tab="\t", excel = ".xlsx")),
      fileInput(inputId = "data_f",label = "selecciona el archivo")
      
    ),
    mainPanel(
      tabsetPanel(
        tabPanel(title = "Base",tableOutput(outputId = "mostrar_datos"))
                )
              )
            )
          )


server <- function(input, output, session) {
  
  data_file = reactive({ ## 1: crear reactive y poner condiciones de acuerdo al radio buttons
    if(is.null(input$data_f)){ ## Hay que poner esto, de lo contrario genera un error todo el tiempo
      return() ## arrojar ningún output si no hay nada en el input
    } else if(input$data_t %in% c(",","\t")){
      file_path = input$data_f
      aa = read.table(file = file_path$datapath, header=T, sep = input$data_t)
      return(aa)
    } else if(input$data_t %in% c(".xlsx")){
      file_path = input$data_f
      aa = read_excel(path = file_path$datapath)
      return(aa)
    }
  })
  
  
  
  output$mostrar_datos = renderTable({
    if(is.null(input$data_f)){ ## Hay que poner esto, de lo contrario genera un error todo el tiempo
      return()
    } else{
      head(data_file(),5)
    }
  })
  
}

shinyApp(ui, server)