
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(DT)
library(rcytoscapejs)
library(synapseClient)

shinyServer(function(input, output, session) {

  session$sendCustomMessage(type="readCookie",
                            message=list(name='org.sagebionetworks.security.user.login.token'))

  
  foo <- observeEvent(input$cookie, {
    
    synapseLogin(sessionToken=input$cookie)
    
    source("load.R")    
    
    comparisonReactive <- reactive({
      tmp <- filter(edgeData, str_detect(Comparison, input$diffstate))
      return(unique(tmp$Comparison))
    })  
    
    
    networkReactive <- reactive({
      comparison <- input$comparison
      print(comparison)
      if (comparison == "All") {
        comparisons <- comparisonReactive()
      }
      else{
        comparisons <- comparison
      }
      
      tmp <- filter(edgeData,
                    # str_detect(Comparison, input$diffstate),
                    Comparison %in% comparisons,
                    fdr <= input$fdr)
      
      if (!input$nontf) {
        tmp <- filter(tmp, !(group == "nontf_mirna"))
      }
      else if (input$nontf & (comparison != "All"))  {
        tmp <- tmp
        # foo <- filter(tmp, !(group == "nontf_mirna"))
        # putback <- filter(tmp, group == "nontf_mirna", 
        #                   source %in% foo$source)
        # tmp <- rbind(foo, putback)
      }
      else {
        tmp <- filter(tmp, !(group == "nontf_mirna"))
      }    
      return(tmp)
    })
    
    
    nodeReactive <- reactive({
      net <- networkReactive()
      filter(nodeData, name %in% c(net$source, net$target))
    })
    
    output$diffstate <- renderUI({
      selectInput("diffstate", "Differentiation State", choices=diffStates)
    })
    
    output$comparison <- renderUI({
      selectInput("comparison", "Comparison", choices=c("All", comparisonReactive()))
    })
    
    output$edgeDataTable <- DT::renderDataTable({
      net <- networkReactive()
      
      if (!is.null(input$connectedNodes)) {
        net <- filter(net,
                      source %in% input$connectedNodes | target %in% input$connectedNodes)
      }
      
      DT::datatable(net,
                    style='bootstrap', options=list(dom = 'tp', pageLength=5))
    })
    
    output$plot <- renderRcytoscapejs({
      
      edges <- networkReactive()
      nodes <- nodeReactive()
      
      network <- createCytoscapeJsNetwork(nodes, edges)
      
      rcytoscapejs(network$nodes, network$edges, layout=input$layout, 
                   height='600px', highlightConnectedNodes=TRUE,
                   boxSelectionEnabled=TRUE)
    })
    
  })
  
})
