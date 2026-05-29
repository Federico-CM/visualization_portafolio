 library(shiny)
library(DT)
library(dplyr)
library(readr)
library(ggplot2)
library(scales)

data <- read_csv("GD037Criminal_limpio.csv", show_col_types = FALSE)

data <- data %>%
  mutate(
    fecha_min = as.numeric(fecha_min),
    fecha_max = as.numeric(fecha_max),
    mujeres_acusadas = as.logical(mujeres_acusadas),
    acusados_multiples = as.logical(acusados_multiples),
    mujeres_afectadas = as.logical(mujeres_afectadas),
    afectados_multiples = as.logical(afectados_multiples)
  )

display_fields <- c(
  "fuente",
  "observaciones",
  "delito",
  "acusado",
  "afectado",
  "lugar"
)

ui <- fluidPage(
  titlePanel("Consulta GD037 Criminal"),

	fluidRow(

	  column(
		width = 4,

		sliderInput(
		  "year_range",
		  "Rango de años:",
		  min = min(data$fecha_min, na.rm = TRUE),
		  max = max(data$fecha_max, na.rm = TRUE),
		  value = c(
		    min(data$fecha_min, na.rm = TRUE),
		    max(data$fecha_max, na.rm = TRUE)
		  ),
		  step = 1,
		  sep = ""
		),

		checkboxInput("mujeres_acusadas", "Mujeres acusadas", value = FALSE),
		checkboxInput("acusados_multiples", "Acusados múltiples", value = FALSE),
		checkboxInput("mujeres_afectadas", "Mujeres afectadas", value = FALSE),
		checkboxInput("afectados_multiples", "Afectados múltiples", value = FALSE)
	  ),

	  column(
		width = 8,

		h4("Registros por año"),

		plotOutput(
		  "year_chart",
		  height = "320px"
		)
	  )
	),

  fluidRow(
    column(
      width = 12,
      downloadButton("download_filtered", "Descargar resultados"),
      br(), br(),
      h4(textOutput("count")),
      DTOutput("table")
    )
  )
)

server <- function(input, output, session) {

  filtered_data_full <- reactive({
    df <- data %>%
      filter(
        fecha_min <= input$year_range[2],
        fecha_max >= input$year_range[1]
      )

    if (input$mujeres_acusadas) {
      df <- df %>% filter(mujeres_acusadas == TRUE)
    }

    if (input$acusados_multiples) {
      df <- df %>% filter(acusados_multiples == TRUE)
    }

    if (input$mujeres_afectadas) {
      df <- df %>% filter(mujeres_afectadas == TRUE)
    }

    if (input$afectados_multiples) {
      df <- df %>% filter(afectados_multiples == TRUE)
    }

    df
  })

  table_data <- reactive({
    filtered_data_full() %>%
      select(all_of(display_fields))
  })

  searched_data_full <- reactive({
    df_full <- filtered_data_full()
    rows <- input$table_rows_all

    if (is.null(rows)) {
      df_full
    } else {
      df_full[rows, , drop = FALSE]
    }
  })

  searched_data_display <- reactive({
    searched_data_full() %>%
      select(all_of(display_fields))
  })

  output$count <- renderText({
    paste("Número de registros encontrados:", nrow(searched_data_full()))
  })

  output$year_chart <- renderPlot({
    chart_data <- searched_data_full() %>%
      filter(!is.na(fecha_min)) %>%
      count(fecha_min, name = "registros") %>%
      arrange(fecha_min)

    if (nrow(chart_data) == 0) {
      plot.new()
      text(0.5, 0.5, "No hay datos para mostrar")
      return()
    }

    ggplot(chart_data, aes(x = fecha_min, y = registros)) +
      geom_area(alpha = 0.25, fill = "#b36b3c") +
      geom_line(linewidth = 1, color = "#9a552b") +
      geom_point(size = 1.5, color = "#9a552b") +
      scale_x_continuous(
        limits = input$year_range,
        breaks = pretty_breaks(n = 8)
      ) +
      labs(
        x = NULL,
        y = NULL
      ) +
      theme_minimal(base_size = 13) +
      theme(
        plot.title = element_blank(),
        panel.grid.minor = element_blank()
      )
  })

  output$table <- renderDT({
    datatable(
      table_data(),
      rownames = FALSE,
      filter = "top",
      options = list(
        pageLength = 25,
        lengthChange = TRUE,
        scrollX = TRUE,
        search = list(
          regex = FALSE,
          caseInsensitive = TRUE
        ),
        language = list(
          search = "Búsqueda global:",
          lengthMenu = "Mostrar _MENU_ registros",
          info = "Mostrando _START_ a _END_ de _TOTAL_ registros",
          infoEmpty = "Mostrando 0 a 0 de 0 registros",
          infoFiltered = "(filtrado de _MAX_ registros totales)",
          zeroRecords = "No se encontraron registros",
          paginate = list(
            first = "Primero",
            last = "Último",
            `next` = "Siguiente",
            previous = "Anterior"
          )
        )
      )
    )
  }, server = FALSE)

  output$download_filtered <- downloadHandler(
    filename = function() {
      paste0("GD037Criminal_resultados_", Sys.Date(), ".csv")
    },

    content = function(file) {
      write_csv(searched_data_display(), file)
    }
  )
}

shinyApp(ui, server)
