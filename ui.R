
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
        
        uiOutput("diffstate"),
        
        uiOutput("comparison"),

        conditionalPanel("input.comparison != 'All'",
                         checkboxInput("nontf", "Include non-TF genes", value = FALSE)),
        
        sliderInput("fdr", "FDR", min=0, max=0.05, step=0.005, value=0.05, round=TRUE),
        
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