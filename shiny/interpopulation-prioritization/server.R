#-----------------------------------------------------------------------------------------------------------------------

# Define server

server <- function(input, output) {

  all_inputs <- eventReactive(input$calculate, {
    x <- reactiveValuesToList(input)
    as.data.frame(as.matrix(x[!str_detect(names(x), "herds|calculate|shinyjs|reset|table")])) %>%
      rownames_to_column("parameter") %>%
      mutate(weight = as.numeric(V1)) %>%
      select(-V1)
  }, ignoreNULL = FALSE)

  d1 <- eventReactive(input$calculate, {

  criteria_prep %>%
    #select(herd, population_size) %>%
    pivot_longer(2:last_col(), names_to = "parameter", values_to = "value") %>%
    filter(!parameter == "population_trend") %>%
    left_join(all_inputs(), by = "parameter") %>%
    mutate(score = value * weight) %>%
    group_by(herd) %>%
    summarise(sum = sum(score)) %>%
    mutate(Rank = dense_rank(desc(sum)))

  }, ignoreNULL = FALSE)

  d2 <- eventReactive(input$calculate, {
    herds %>%
      left_join(d1(), by = "herd")
  }, ignoreNULL = FALSE)

  output$herds <- renderLeaflet({

    pal <<- colorNumeric(
      palette = "viridis",
      domain = d2()$Rank,
      reverse = TRUE
    )

    leaflet(d2()) %>%
      addTiles() %>%
      addProviderTiles("Esri.WorldImagery", group = "Satellite Imagery") %>%
      addFullscreenControl() %>%
      addResetMapButton() %>%
      addScaleBar(position = "bottomleft",
                  options = scaleBarOptions(imperial = FALSE)) %>%

      # Add polygon layers
      addPolygons(color = "black",
                  weight = 1,
                  smoothFactor = 0.2,
                  opacity = 1,
                  fillOpacity = 0.8,
                  fillColor = ~ pal(Rank),
                  group = "Caribou Herds",
                  popup = paste("Herd: ", "<b>", d2()$herd, "</b>", "<br>",
                                "<br>",
                                "Rank: ", "<b>", d2()$Rank, "</b>"),
                  highlightOptions = highlightOptions(color = "white", weight = 2, bringToFront = TRUE)) %>%

      # Layers control
      addLayersControl(overlayGroups = c("Satellite Imagery",
                                         "Caribou Herds"),
                       options = layersControlOptions(collapsed = FALSE),
                       position = "topright") %>%

      hideGroup("Satellite Imagery") %>%

      # Legend
      addLegend(position = "topright",
                pal = pal,
                values = ~ Rank,
                bins = 17,
                opacity = 1)

  })

  output$plot <- renderPlot(

    d2() %>%
      mutate(herd = fct_reorder(herd, Rank, .desc = TRUE),
             Rank = as.factor(Rank)) %>%
      ggplot() +
      geom_col(aes(x = herd, y = sum, fill = Rank),
               color = "black", width = 0.75) +
      labs(x = "",
           y = "Relative Importance") +
      scale_fill_viridis_d(direction = -1) +
      theme_classic() +
      guides(fill = guide_legend(reverse = TRUE,
                                 title.position = "top",
                                 label.position = "bottom",
                                 title.hjust = 0.5,
                                 nrow = 1)) +
      theme(axis.text.y = element_blank(),
            axis.text.x = element_text(angle = 45, hjust = 1,
                                       size = 12, face = "bold"),
            axis.title.x = element_blank(),
            axis.title.y = element_text(size = 18, face = "bold"),
            legend.position = "top",
            legend.direction = "horizontal",
            legend.spacing.x = unit(0, "cm"),
            legend.spacing.y = unit(0.2, "cm"),
            legend.title = element_text(size = 14, face = "bold"),
            legend.text = element_text(size = 12),
            axis.ticks.y = element_blank())

  )

  output$table <- renderDT(

    d2() %>%
      st_set_geometry(NULL) %>%
      mutate(Score = round(sum, digits = 2)) %>%
      select(Rank, Herd = herd, Score) %>%
      arrange(Rank) %>%
      DT::datatable(extensions = "Buttons",
                    rownames = FALSE,
                    options = list(
                      buttons = list(
                        'copy', 'print', list(
                          extend = "collection",
                          buttons = c('csv', 'excel', 'pdf'),
                          text = "Download")),
                      dom = "Bft",
                      pageLength = 17))
  )

  observeEvent(input$reset, {

    shinyjs::reset("side-panel")

  })

}
