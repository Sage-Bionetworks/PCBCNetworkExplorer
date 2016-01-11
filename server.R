
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(DT)
library(rcytoscapejs)

shinyServer(function(input, output, session) {
  comparisonReactive <- reactive({
    tmp <- filter(edgeData, str_detect(Comparison, input$diffstate))
    return(unique(tmp$Comparison))
  })  
  
  networkReactive <- reactive({
    comparison <- input$comparison

    if (comparison == "All") {
      comparisons <- comparisonReactive()
    }
    else{
      comparisons <- comparison
    }
    
    print(sprintf("Comparisons in netReact = %s", comparisons))
    
    tmp <- filter(edgeData,
                  # str_detect(Comparison, input$diffstate),
                  Comparison %in% comparisons)
    
    return(tmp)
  })

  
  nodeReactive <- reactive({
    net <- networkReactive()
    filter(nodeData, name %in% c(net$source, net$target))
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