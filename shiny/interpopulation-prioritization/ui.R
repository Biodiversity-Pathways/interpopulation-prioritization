#-----------------------------------------------------------------------------------------------------------------------

ui <- fluidPage(

  titlePanel("Interpopulation Prioritization of Caribou Herds in British Columbia, Canada"),

  sidebarLayout(

    sidebarPanel(

      fluidRow(
        sidebarPanel(
          # Action Button - Calculate Herd Rankings
          actionBttn(inputId = "calculate",
                     label = "Calculate Herd Rankings",
                     style = "jelly",
                     color = "success",
                     size = "sm"),
          tags$br(),
          tags$br(),
          # Action button - Reset Weights
          actionBttn(inputId = "reset",
                     label = "Reset Weights",
                     style = "jelly",
                     color = "warning",
                     size = "sm"),
          tags$br(),
          tags$br(),
          # Radio Button
          radioButtons(inputId = "norm",
                       label = NULL,
                       choices = c("Normalized Area Proportions", "Raw Area Proportions")),
          # Text output to display the total weight value
          htmlOutput(outputId = "sum"),
          width = 12)),

      fluidRow(
        sidebarPanel(
          shinyjs::useShinyjs(),
          id = "side-panel",
          style = "overflow-y:scroll; max-height:650px; position:relative;",

          # Population Size
          sliderInput(inputId = "population_size",
                      label = tags$span(
                        "Population Size",
                        bsButton("bs_pop", label = "", icon = icon("info"),
                                 style = "info", size = "extra-small")),
                      min = 0,
                      max = 100,
                      value = 5,
                      step = 0.5),
          bsPopover(id = "bs_pop",
                    title = paste0(tags$b("Effect:"), tags$br(), "Higher population increases ranking."),
                    content = paste0(tags$b("Description:"), tags$br(), "Number of caribou in herd."),
                    placement = "right", trigger = "hover", options = list(container = "body")),

          # Latitude
          sliderInput(inputId = "latitude",
                      label = tags$span(
                        "Latitude",
                        bsButton("bs_lat", label = "", icon = icon("info"),
                                 style = "info", size = "extra-small")),
                      min = 0,
                      max = 100,
                      value = 5,
                      step = 0.5),
          bsPopover(id = "bs_lat",
                    title = paste0(tags$b("Effect:"), tags$br(), "Higher latitude increases ranking."),
                    content = paste0(tags$b("Description:"), tags$br(), "Latitude (North in meters)"),
                    placement = "right", trigger = "hover", options = list(container = "body")),

          # Distance from Wells Gray Park
          sliderInput(inputId = "distance_from_wg_park",
                      label = tags$span(
                        "Distance from Wells Gray Park",
                        bsButton("bs_wg", label = "", icon = icon("info"),
                                 style = "info", size = "extra-small")),
                      min = 0,
                      max = 100,
                      value = 5,
                      step = 0.5),
          bsPopover(id = "bs_wg",
                    title = paste0(tags$b("Effect:"), tags$br(), "Lower distance increases ranking."),
                    content = paste0(tags$b("Description:"), tags$br(), "Distance to Wells Grey Park, a large area of already protected habitat (meters)."),
                    placement = "right", trigger = "hover", options = list(container = "body")),

          # Proportion of total range with THLB protection
          sliderInput(inputId = "thlb_propn_protected_total",
                      label = tags$span(
                        "Proportion of total range with THLB protection",
                        bsButton("bs_thlbpropnprotectedtotal", label = "", icon = icon("info"),
                                 style = "info", size = "extra-small")),
                      min = 0,
                      max = 100,
                      value = 0,
                      step = 0.5),
          bsPopover(id = "bs_thlbpropnprotectedtotal",
                    title = paste0(tags$b("Effect:"), tags$br(), "Higher THLB increases ranking"),
                    content = paste0(tags$b("Description:"), tags$br(), "Proportion of caribou range (core and matrix) with full THLB protection. Timber Harvesting Land Base (THLB) only includes areas that produce merchantable timber."),
                    placement = "right", trigger = "hover", options = list(container = "body")),

          # Proportion of core range with THLB protection
          sliderInput(inputId = "thlb_propn_protected_core",
                      label = tags$span(
                        "Proportion of core range with THLB protection",
                        bsButton("bs_thlbpropnprotectedcore", label = "", icon = icon("info"),
                                 style = "info", size = "extra-small")),
                      min = 0,
                      max = 100,
                      value = 0,
                      step = 0.5),
          bsPopover(id = "bs_thlbpropnprotectedcore",
                    title = paste0(tags$b("Effect:"), tags$br(), "Higher THLB increases ranking"),
                    content = paste0(tags$b("Description:"), tags$br(), "Proportion of core range with full THLB protection. Timber Harvesting Land Base (THLB) only includes areas that produce merchantable timber."),
                    placement = "right", trigger = "hover", options = list(container = "body")),

          # Proportion of matrix range with THLB protection
          sliderInput(inputId = "thlb_propn_protected_matrix",
                      label = tags$span(
                        "Proportion of matrix range with THLB protection",
                        bsButton("bs_thlbpropnprotectedmatrix", label = "", icon = icon("info"),
                                 style = "info", size = "extra-small")),
                      min = 0,
                      max = 100,
                      value = 0,
                      step = 0.5),
          bsPopover(id = "bs_thlbpropnprotectedmatrix",
                    title = paste0(tags$b("Effect:"), tags$br(), "Higher THLB increases ranking"),
                    content = paste0(tags$b("Description:"), tags$br(), "Proportion of matrix range with full THLB protection. Timber Harvesting Land Base (THLB) only includes areas that produce merchantable timber."),
                    placement = "right", trigger = "hover", options = list(container = "body")),

          # Altered (Total Core)
          sliderInput(inputId = "altered_total_core",
                      label = tags$span(
                        "Altered (Total Core)",
                        bsButton("bs_atc", label = "", icon = icon("info"),
                                 style = "info", size = "extra-small")),
                      min = 0,
                      max = 100,
                      value = 0,
                      step = 0.5),
          bsPopover(id = "bs_atc",
                    title = paste0(tags$b("Effect:"), tags$br(), "Lower altered increases ranking"),
                    content = paste0(tags$b("Description:"), tags$br(), "Proportion of total core range with permanent habitat alteration."),
                    placement = "right", trigger = "hover", options = list(container = "body")),

          # Altered (Total Matrix)
          sliderInput(inputId = "altered_total_matrix",
                      label = tags$span(
                        "Altered (Total Matrix)",
                        bsButton("bs_atm", label = "", icon = icon("info"),
                                 style = "info", size = "extra-small")),
                      min = 0,
                      max = 100,
                      value = 0,
                      step = 0.5),
          bsPopover(id = "bs_atm",
                    title = paste0(tags$b("Effect:"), tags$br(), "Lower altered increases ranking"),
                    content = paste0(tags$b("Description:"), tags$br(), "Proportion of matrix range with permanent habitat alteration."),
                    placement = "right", trigger = "hover", options = list(container = "body")),

          # Altered (Permanent Core)
          sliderInput(inputId = "altered_permanent_core",
                      label = tags$span(
                        "Altered (Permanent Core)",
                        bsButton("bs_asc", label = "", icon = icon("info"),
                                 style = "info", size = "extra-small")),
                      min = 0,
                      max = 100,
                      value = 10,
                      step = 0.5),
          bsPopover(id = "bs_asc",
                    title = paste0(tags$b("Effect:"), tags$br(), "Lower altered increases ranking"),
                    content = paste0(tags$b("Description:"), tags$br(), "Proportion of core range with permanent habitat alteration."),
                    placement = "right", trigger = "hover", options = list(container = "body")),

          # Altered (Permanent Matrix)
          sliderInput(inputId = "altered_permanent_matrix",
                      label = tags$span(
                        "Altered (Permanent Matrix)",
                        bsButton("bs_asm", label = "", icon = icon("info"),
                                 style = "info", size = "extra-small")),
                      min = 0,
                      max = 100,
                      value = 10,
                      step = 0.5),
          bsPopover(id = "bs_asm",
                    title = paste0(tags$b("Effect:"), tags$br(), "Lower altered increases ranking"),
                    content = paste0(tags$b("Description:"), tags$br(), "Proportion of matrix range with permanent habitat alteration."),
                    placement = "right", trigger = "hover", options = list(container = "body")),

          # Altered Temporary Core
          sliderInput(inputId = "altered_temporary_core",
                      label = tags$span(
                        "Altered (Temporary Core)",
                        bsButton("bs_atempcore", label = "", icon = icon("info"),
                                 style = "info", size = "extra-small")),
                      min = 0,
                      max = 100,
                      value = 0,
                      step = 0.5),
          bsPopover(id = "bs_atempcore",
                    title = paste0(tags$b("Effect:"), tags$br(), "Lower altered increases ranking"),
                    content = paste0(tags$b("Description:"), tags$br(), "Proportion of core range with temporary habitat alteration."),
                    placement = "right", trigger = "hover", options = list(container = "body")),

          # Altered (Temporary Matrix)
          sliderInput(inputId = "altered_temporary_matrix",
                      label = tags$span(
                        "Altered (Temporary Matrix)",
                        bsButton("bs_atempm", label = "", icon = icon("info"),
                                 style = "info", size = "extra-small")),
                      min = 0,
                      max = 100,
                      value = 0,
                      step = 0.5),
          bsPopover(id = "bs_atempm",
                    title = paste0(tags$b("Effect:"), tags$br(), "Lower altered increases ranking"),
                    content = paste0(tags$b("Description:"), tags$br(), "Proportion of matrix range with temporary habitat alteration."),
                    placement = "right", trigger = "hover", options = list(container = "body")),

          # Altered (Agricultural Core)
          sliderInput(inputId = "altered_agriculture_core",
                      label = tags$span(
                        "Altered (Agricultural Core)",
                        bsButton("bs_aac", label = "", icon = icon("info"),
                                 style = "info", size = "extra-small")),
                      min = 0,
                      max = 100,
                      value = 0,
                      step = 0.5),
          bsPopover(id = "bs_aac",
                    title = paste0(tags$b("Effect:"), tags$br(), "Lower altered increases ranking"),
                    content = paste0(tags$b("Description:"), tags$br(), "Proportion of core range permanently altered by agriculture."),
                    placement = "right", trigger = "hover", options = list(container = "body")),

          # Altered (Agricultural Matrix)
          sliderInput(inputId = "altered_agriculture_matrix",
                      label = tags$span(
                        "Altered (Agricultural Matrix)",
                        bsButton("bs_aam", label = "", icon = icon("info"),
                                 style = "info", size = "extra-small")),
                      min = 0,
                      max = 100,
                      value = 10,
                      step = 0.5),
          bsPopover(id = "bs_aam",
                    title = paste0(tags$b("Effect:"), tags$br(), "Lower altered increases ranking"),
                    content = paste0(tags$b("Description:"), tags$br(), "Proportion of matrix range permanently altered by agriculture."),
                    placement = "right", trigger = "hover", options = list(container = "body")),

          # Altered (Urban Core)
          sliderInput(inputId = "altered_urban_core",
                      label = tags$span(
                        "Altered (Urban Core)",
                        bsButton("bs_auc", label = "", icon = icon("info"),
                                 style = "info", size = "extra-small")),
                      min = 0,
                      max = 100,
                      value = 0,
                      step = 0.5),
          bsPopover(id = "bs_auc",
                    title = paste0(tags$b("Effect:"), tags$br(), "Lower altered increases ranking"),
                    content = paste0(tags$b("Description:"), tags$br(), "Proportion of core range permanently altered by urban areas."),
                    placement = "right", trigger = "hover", options = list(container = "body")),

          # Altered (Urban Matrix)
          sliderInput(inputId = "altered_urban_matrix",
                      label = tags$span(
                        "Altered (Urban Matrix)",
                        bsButton("bs_aum", label = "", icon = icon("info"),
                                 style = "info", size = "extra-small")),
                      min = 0,
                      max = 100,
                      value = 0,
                      step = 0.5),
          bsPopover(id = "bs_aum",
                    title = paste0(tags$b("Effect:"), tags$br(), "Lower altered increases ranking"),
                    content = paste0(tags$b("Description:"), tags$br(), "Proportion of matrix range permanently altered by urban areas."),
                    placement = "right", trigger = "hover", options = list(container = "body")),

          # Altered (Roadways Core)
          sliderInput(inputId = "altered_roadways_core",
                      label = tags$span(
                        "Altered (Roadways Core)",
                        bsButton("bs_arc", label = "", icon = icon("info"),
                                 style = "info", size = "extra-small")),
                      min = 0,
                      max = 100,
                      value = 5,
                      step = 0.5),
          bsPopover(id = "bs_arc",
                    title = paste0(tags$b("Effect:"), tags$br(), "Lower altered increases ranking"),
                    content = paste0(tags$b("Description:"), tags$br(), "Proportion of core range permanently altered by roadways."),
                    placement = "right", trigger = "hover", options = list(container = "body")),

          # Altered (Roadways Matrix)
          sliderInput(inputId = "altered_roadways_matrix",
                      label = tags$span(
                        "Altered (roadways Matrix)",
                        bsButton("bs_arm", label = "", icon = icon("info"),
                                 style = "info", size = "extra-small")),
                      min = 0,
                      max = 100,
                      value = 5,
                      step = 0.5),
          bsPopover(id = "bs_arm",
                    title = paste0(tags$b("Effect:"), tags$br(), "Lower altered increases ranking"),
                    content = paste0(tags$b("Description:"), tags$br(), "Proportion of matrix range permanently altered by roadways."),
                    placement = "right", trigger = "hover", options = list(container = "body")),

          # Altered (Mining Core)
          sliderInput(inputId = "altered_mining_core",
                      label = tags$span(
                        "Altered (Mining Core)",
                        bsButton("bs_aminec", label = "", icon = icon("info"),
                                 style = "info", size = "extra-small")),
                      min = 0,
                      max = 100,
                      value = 0,
                      step = 0.5),
          bsPopover(id = "bs_aminec",
                    title = paste0(tags$b("Effect:"), tags$br(), "Lower altered increases ranking"),
                    content = paste0(tags$b("Description:"), tags$br(), "Proportion of core range permanently altered by mining."),
                    placement = "right", trigger = "hover", options = list(container = "body")),

          # Altered (Mining Matrix)
          sliderInput(inputId = "altered_mining_matrix",
                      label = tags$span(
                        "Altered (Mining Matrix)",
                        bsButton("bs_amm", label = "", icon = icon("info"),
                                 style = "info", size = "extra-small")),
                      min = 0,
                      max = 100,
                      value = 0,
                      step = 0.5),
          bsPopover(id = "bs_amm",
                    title = paste0(tags$b("Effect:"), tags$br(), "Lower altered increases ranking"),
                    content = paste0(tags$b("Description:"), tags$br(), "Proportion of matrix range permanently altered by mining."),
                    placement = "right", trigger = "hover", options = list(container = "body")),

          # Altered (Transmission Core)
          sliderInput(inputId = "altered_transmission_core",
                      label = tags$span(
                        "Altered (Transmission Core)",
                        bsButton("bs_atransc", label = "", icon = icon("info"),
                                 style = "info", size = "extra-small")),
                      min = 0,
                      max = 100,
                      value = 0,
                      step = 0.5),
          bsPopover(id = "bs_atransc",
                    title = paste0(tags$b("Effect:"), tags$br(), "Lower altered increases ranking"),
                    content = paste0(tags$b("Description:"), tags$br(), "Proportion of core range permanently altered by transmission lines."),
                    placement = "right", trigger = "hover", options = list(container = "body")),

          # Altered (Transmission Matrix)
          sliderInput(inputId = "altered_transmission_matrix",
                      label = tags$span(
                        "Altered (Transmission Matrix)",
                        bsButton("bs_atransm", label = "", icon = icon("info"),
                                 style = "info", size = "extra-small")),
                      min = 0,
                      max = 100,
                      value = 0,
                      step = 0.5),
          bsPopover(id = "bs_atransm",
                    title = paste0(tags$b("Effect:"), tags$br(), "Lower altered increases ranking"),
                    content = paste0(tags$b("Description:"), tags$br(), "Proportion of matrix range permanently altered by transmission lines."),
                    placement = "right", trigger = "hover", options = list(container = "body")),

          # Altered (Cutblock <40 Years Core)
          sliderInput(inputId = "altered_cutblock_40_years_core",
                      label = tags$span(
                        "Altered (Cutblock <40 Years Core)",
                        bsButton("bs_acut40core", label = "", icon = icon("info"),
                                 style = "info", size = "extra-small")),
                      min = 0,
                      max = 100,
                      value = 10,
                      step = 0.5),
          bsPopover(id = "bs_acut40core",
                    title = paste0(tags$b("Effect:"), tags$br(), "Lower altered increases ranking"),
                    content = paste0(tags$b("Description:"), tags$br(), "Proportion of core range temporarily altered by cutblocks < 40 years old."),
                    placement = "right", trigger = "hover", options = list(container = "body")),

          # Altered (Cutblock <40 Years Matrix)
          sliderInput(inputId = "altered_cutblock_40_years_matrix",
                      label = tags$span(
                        "Altered (Cutblock <40 Years Matrix)",
                        bsButton("bs_acut40matrix", label = "", icon = icon("info"),
                                 style = "info", size = "extra-small")),
                      min = 0,
                      max = 100,
                      value = 10,
                      step = 0.5),
          bsPopover(id = "bs_acut40matrix",
                    title = paste0(tags$b("Effect:"), tags$br(), "Lower altered increases ranking"),
                    content = paste0(tags$b("Description:"), tags$br(), "Proportion of matrix range temporarily altered by cutblocks < 40 years old."),
                    placement = "right", trigger = "hover", options = list(container = "body")),

          # Altered (Cutblock 0-10 Years Core)
          sliderInput(inputId = "altered_cutblock_0_10_years_core",
                      label = tags$span(
                        "Altered (Cutblock 0-10 Years Core)",
                        bsButton("bs_acut0core", label = "", icon = icon("info"),
                                 style = "info", size = "extra-small")),
                      min = 0,
                      max = 100,
                      value = 7.5,
                      step = 0.5),
          bsPopover(id = "bs_acut0core",
                    title = paste0(tags$b("Effect:"), tags$br(), "Lower altered increases ranking"),
                    content = paste0(tags$b("Description:"), tags$br(), "Proportion of core range temporarily altered by cutblocks <10 years old. Add weight here to further emphasize recently altered forest that will soon become forest age selected by moose."),
                    placement = "right", trigger = "hover", options = list(container = "body")),

          # Altered (Cutblock 0-10 Years Matrix)
          sliderInput(inputId = "altered_cutblock_0_10_years_matrix",
                      label = tags$span(
                        "Altered (Cutblock 0-10 Years Matrix)",
                        bsButton("bs_acut0matrix", label = "", icon = icon("info"),
                                 style = "info", size = "extra-small")),
                      min = 0,
                      max = 100,
                      value = 7.5,
                      step = 0.5),
          bsPopover(id = "bs_acut0matrix",
                    title = paste0(tags$b("Effect:"), tags$br(), "Lower altered increases ranking"),
                    content = paste0(tags$b("Description:"), tags$br(), "Proportion of matrix range temporarily altered by cutblocks <10 years old. Add weight here to further emphasize recently altered forest that will soon become forest age selected by moose."),
                    placement = "right", trigger = "hover", options = list(container = "body")),

          # Altered (Fire <40 Years Core)
          sliderInput(inputId = "altered_fire_40_years_core",
                      label = tags$span(
                        "Altered (Fire <40 Years Core)",
                        bsButton("bs_afire40core", label = "", icon = icon("info"),
                                 style = "info", size = "extra-small")),
                      min = 0,
                      max = 100,
                      value = 0,
                      step = 0.5),
          bsPopover(id = "bs_afire40core",
                    title = paste0(tags$b("Effect:"), tags$br(), "Lower altered increases ranking"),
                    content = paste0(tags$b("Description:"), tags$br(), "Proportion of core range temporarily altered by fire < 40 years old."),
                    placement = "right", trigger = "hover", options = list(container = "body")),

          # Altered (Fire <40 Years Matrix)
          sliderInput(inputId = "altered_fire_40_years_matrix",
                      label = tags$span(
                        "Altered (Fire <40 Years Matrix)",
                        bsButton("bs_afire40matrix", label = "", icon = icon("info"),
                                 style = "info", size = "extra-small")),
                      min = 0,
                      max = 100,
                      value = 0,
                      step = 0.5),
          bsPopover(id = "bs_afire40matrix",
                    title = paste0(tags$b("Effect:"), tags$br(), "Lower altered increases ranking"),
                    content = paste0(tags$b("Description:"), tags$br(), "Proportion of matrix range temporarily altered by fire < 40 years old."),
                    placement = "right", trigger = "hover", options = list(container = "body")),

          # Altered (Fire 0-10 Years Core)
          sliderInput(inputId = "altered_fire_0_10_years_core",
                      label = tags$span(
                        "Altered (Fire 0-10 Years Core)",
                        bsButton("bs_afire0core", label = "", icon = icon("info"),
                                 style = "info", size = "extra-small")),
                      min = 0,
                      max = 100,
                      value = 5,
                      step = 0.5),
          bsPopover(id = "bs_afire0core",
                    title = paste0(tags$b("Effect:"), tags$br(), "Lower altered increases ranking"),
                    content = paste0(tags$b("Description:"), tags$br(), "Proportion of core range temporarily altered by fire <10 years old. Add weight here to further emphasize recently altered forest that will soon become forest age selected by moose."),
                    placement = "right", trigger = "hover", options = list(container = "body")),

          # Altered (Fire 0-10 Years Matrix)
          sliderInput(inputId = "altered_fire_0_10_years_matrix",
                      label = tags$span(
                        "Altered (Fire 0-10 Years Matrix)",
                        bsButton("bs_afire0matrix", label = "", icon = icon("info"),
                                 style = "info", size = "extra-small")),
                      min = 0,
                      max = 100,
                      value = 5,
                      step = 0.5),
          bsPopover(id = "bs_afire0matrix",
                    title = paste0(tags$b("Effect:"), tags$br(), "Lower altered increases ranking"),
                    content = paste0(tags$b("Description:"), tags$br(), "Proportion of matrix range temporarily altered by fire <10 years old. Add weight here to further emphasize recently altered forest that will soon become forest age selected by moose."),
                    placement = "right", trigger = "hover", options = list(container = "body")),

          # Altered (Pests <40 Years Core)
          sliderInput(inputId = "altered_pests_40_years_core",
                      label = tags$span(
                        "Altered (Pests <40 Years Core)",
                        bsButton("bs_apest40core", label = "", icon = icon("info"),
                                 style = "info", size = "extra-small")),
                      min = 0,
                      max = 100,
                      value = 0,
                      step = 0.5),
          bsPopover(id = "bs_apest40core",
                    title = paste0(tags$b("Effect:"), tags$br(), "Lower altered increases ranking"),
                    content = paste0(tags$b("Description:"), tags$br(), "Proportion of core range temporarily altered by pest forest clearing < 40 years old."),
                    placement = "right", trigger = "hover", options = list(container = "body")),

          # Altered (Pests <40 Years Matrix)
          sliderInput(inputId = "altered_pests_40_years_matrix",
                      label = tags$span(
                        "Altered (Pests <40 Years Matrix)",
                        bsButton("bs_apest40matrix", label = "", icon = icon("info"),
                                 style = "info", size = "extra-small")),
                      min = 0,
                      max = 100,
                      value = 0,
                      step = 0.5),
          bsPopover(id = "bs_apest40matrix",
                    title = paste0(tags$b("Effect:"), tags$br(), "Lower altered increases ranking"),
                    content = paste0(tags$b("Description:"), tags$br(), "Proportion of matrix range temporarily altered by pest forest clearing < 40 years old."),
                    placement = "right", trigger = "hover", options = list(container = "body")),

          # Altered (Pests 0-10 Years Core)
          sliderInput(inputId = "altered_pests_0_10_years_core",
                      label = tags$span(
                        "Altered (Pests 0-10 Years Core)",
                        bsButton("bs_apest0core", label = "", icon = icon("info"),
                                 style = "info", size = "extra-small")),
                      min = 0,
                      max = 100,
                      value = 0,
                      step = 0.5),
          bsPopover(id = "bs_apest0core",
                    title = paste0(tags$b("Effect:"), tags$br(), "Lower altered increases ranking"),
                    content = paste0(tags$b("Description:"), tags$br(), "Proportion of core range temporarily altered by pest forest clearing < 10 years old. Add weight here to further emphasize young altered that will soon become forest age selected by moose."),
                    placement = "right", trigger = "hover", options = list(container = "body")),

          # Altered (Pests 0-10 Years Matrix)
          sliderInput(inputId = "altered_pests_0_10_years_matrix",
                      label = tags$span(
                        "Altered (Pests 0-10 Years Matrix)",
                        bsButton("bs_apest0matrix", label = "", icon = icon("info"),
                                 style = "info", size = "extra-small")),
                      min = 0,
                      max = 100,
                      value = 0,
                      step = 0.5),
          bsPopover(id = "bs_apest0matrix",
                    title = paste0(tags$b("Effect:"), tags$br(), "Lower altered increases ranking"),
                    content = paste0(tags$b("Description:"), tags$br(), "Proportion of matrix range temporarily altered by pest forest clearing < 10 years old. Add weight here to further emphasize young altered that will soon become forest age selected by moose."),
                    placement = "right", trigger = "hover", options = list(container = "body")),

          width = 12)),

      width = 3

    ),

    mainPanel(
      fluidRow(
        tabsetPanel(
          tabPanel("Map",
                   leafletOutput(outputId = "herds",
                               width = "100%",
                               height = 850)),
          tabPanel("Plot", tags$br(),
                   plotOutput(outputId = "plot",
                              width = "60%",
                              height = 500)),
          tabPanel("Score Summary",
                   tags$br(),
                   DTOutput(outputId = "score",
                            width = "45%",
                            height = 700),
                   tags$br(), tags$br()),
          tabPanel("Value Summary",
                   tags$br(),
                   DTOutput(outputId = "value",
                            width = "70%",
                            height = 700))
      ), align = "center"),

      width = 9

    )
  )
)
