
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(DT)

shinyServer(function(input, output, session) {
  #maxInteractions <-  input$maxInteractions
  maxInteractions <- 50
  
  # if(nrow(network) <= maxInteractions) {
  #   maxInteractions <- nrow(network)
  # } else {
  #   maxInteractions <- maxInteractions
  # }
  
  # network <- network[1:maxInteractions, ]
  # 
  # edgeList <- network[, c("source","target")]
  # 
  # nodes <- unique(c(edgeList$source, edgeList$target))
  # 
  # id <- nodes
  # name <- nodes
  # addLinks <- TRUE
  # 
  # if(addLinks) {
  #   href <- paste0("https://www.google.com/search?q=", nodes)
  #   tooltip <- paste0("https://www.google.com/search?q=", nodes)
  #   nodeData <- data.frame(id, name, href, tooltip, stringsAsFactors=FALSE)
  # } else {
  #   nodeData <- data.frame(id, name, stringsAsFactors=FALSE)
  # }
  # 
  # nodeData$color <- rep("#888888", nrow(nodeData))
  # nodeData$color[which(grepl("[a-z]", nodes))] <- "#FF0000"
  
  
  # edgeData <- edgeList
  
  # NOTE: Reactive variables used as functions networkReactive()
  networkReactive <- reactive({
    if(is.null(input$connectedNodes)) {
      return(network)
    } else {
      t1 <- which(network$source %in% input$connectedNodes)
      t2 <- which(network$target %in% input$connectedNodes)
      idx <- unique(c(t1, t2))
      return(network[idx,])
    }
  })
  
  output$nodeDataTable <- DT::renderDataTable({
    tmp <- nodeData[which(id == input$clickedNode),]
    print(tmp)
    DT::datatable(tmp, 
                  filter=list(position='bottom', clear=FALSE), 
                  #style='bootstrap',
                  options=list(pageLength=5))
  })
  
  output$edgeDataTable <- DT::renderDataTable({
    DT::datatable(networkReactive(), filter='bottom', 
                  style='bootstrap', options=list(pageLength=5))
  })
  
  output$clickedNode = renderPrint({
    input$clickedNode
  })
  
  output$connectedNodes = renderPrint({
    input$connectedNodes
  })
  
  output$plot <- renderRcytoscapejs({
    network <- createCytoscapeJsNetwork(nodeData, edgeData)
    rcytoscapejs(network$nodes, network$edges)
    # cyNetwork <- createCytoscapeJsNetwork(nodeData, edgeData)
    # rcytoscapejs(nodeEntries=cyNetwork$nodes, edgeEntries=cyNetwork$edges)
  })
  
  observeEvent(input$saveImage, {
    # NOTE: Message cannot be an empty string "", nothing will happen    
    session$sendCustomMessage(type="saveImage", message="NULL")
  })
})

# library(shiny)
# 
# shinyServer(function(input, output) {
# 
#   output$threshold <- renderValueBox({
#     
#     valueBox(
#       value = formatC(input$edgeThreshold, digits = 1, format = "f"),
#       subtitle = "Edge threshold",
#       icon = icon("area-chart"),
#       color = if (input$edgeThreshold < 25) "yellow" else "red"
#     )
#   })
#   
#   output$edges <- renderValueBox({
#     valueBox(
#       value = edgeCount(),
#       subtitle = "Unique edges",
#       icon = icon("info-circle")
#     )
#   })
#   
#   output$nodes <- renderValueBox({
#     valueBox(
#       nodeCount(),
#       "Unique nodes",
#       icon = icon("info-circle")
#     )
#   })
#   
# })
