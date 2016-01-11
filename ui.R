
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shinydashboard)

dashboardPage(
  dashboardHeader(title = "PCBC Network Explorer"),
  
  dashboardSidebar(disable = TRUE),
  
  dashboardBody(
    fluidRow(
      box(
        width = 5, status = "info", solidHeader = FALSE,
        
        h3("Options"),
        
        selectInput("diffstate", label='Differentiation State',
                    choices=diffStates, selectize=TRUE),
        
        uiOutput("comparison"),
        
        selectInput("layout", label='Layout',
                    choices=list(`Force directed`="cose", Tree="dagre"), 
                    selectize=TRUE),
        
        tags$hr(),
        
        h3("Edges"),
        
        DT::dataTableOutput("edgeDataTable")
      ),
      box(width=7,
          status = "info", solidHeader = TRUE,
          title = "Network",
          rcytoscapejs::rcytoscapejsOutput("plot", height="500px")
      )
    )
  )
)