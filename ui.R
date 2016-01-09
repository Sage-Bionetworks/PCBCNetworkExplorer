
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shinydashboard)

dashboardPage(
  dashboardHeader(title = "PCBC Network Explorer"),
  dashboardSidebar(
    sliderInput("edgeThreshold", "Threshold on edges",
                min = 0, max = 50, value = 3, step = 0.1
    ),
    sidebarMenu(
      menuItem("Network", tabName = "dashboard"),
      menuItem("Nodes and edges", tabName = "rawdata")
    )
  ),
  dashboardBody(
    # tags$head(tags$script(src="cyjs.js")),
    
    tabItems(
      tabItem("dashboard",
              fluidRow(
                valueBoxOutput("threshold"),
                valueBoxOutput("edges"),
                valueBoxOutput("nodes")
              ),
              fluidRow(
                box(width=12,
                  status = "info", solidHeader = TRUE,
                  title = "Network",
                  rcytoscapejsOutput("plot", height="600px")
                )
              ),
              fluidRow(
                box(
                  width = 6, status = "info", solidHeader = TRUE,
                  title = "Nodes",
                  dataTableOutput("nodeDataTable")
                ),
                box(
                  width = 6, status = "info", solidHeader = TRUE,
                  title = "Edges",
                  dataTableOutput("edgeDataTable")
                )
              )
              
      ),
      tabItem("rawdata"
              # numericInput("maxrows", "Rows to show", 25),
              # verbatimTextOutput("rawtable"),
              # downloadButton("downloadCsv", "Download as CSV")
      )
    )
  )
)
