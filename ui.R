
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shinydashboard)
library(visNetwork)

dashboardPage(
  dashboardHeader(title = "PCBC Network Explorer"),
  
  dashboardSidebar(  
    sidebarMenu(
        uiOutput("diffstate"),
        uiOutput("feature"),
        sliderInput("fdr", "FDR", min=0, max=0.05, step=0.005, value=0.05, round=TRUE)
        )
  ),
  
  dashboardBody(
    
    tags$head(
      singleton(
        includeScript("www/readCookie.js")
      )
    ),
    
    fluidRow(
      box(width=8,
          status = "info", solidHeader = TRUE,
          title = "Network",
          visNetworkOutput("plot", height="500px")
      ),
      box(width=8,
          DT::dataTableOutput("edgeDataTable")
      ),
      box(width=8,
          DT::dataTableOutput("nodeDataTable")
      )
    )
  )
)