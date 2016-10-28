
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(DT)
library(visNetwork)

shinyServer(function(input, output, session) {
  
  session$sendCustomMessage(type="readCookie",
                            message=list(name='org.sagebionetworks.security.user.login.token'))

  foo <- observeEvent(input$cookie, {

  synapseClient::synapseLogin(sessionToken=input$cookie)
    
    source("load.R")
    
    network <- reactive({
      input$refresh
      
      coexpr <- isolate(input$coexpression)
      net <- all.networks[[input$diffstate]]

      edges <- net$edge %>% 
        select(from=feature, to=target, coexpression) %>% 
        filter(from %in% input$feature | to %in% input$feature,
               to != "NONE", from != "NONE",
               between(coexpression, coexpr[1], coexpr[2]))

      nodes <- net$node %>%
        filter(feature %in% edges$from | feature %in% edges$to,
               feature != "NONE") %>% 
        mutate(id=feature, label=feature) %>% 
        left_join(assayShapes)
      
      list(edges=edges, nodes=nodes)
    })
    

    output$diffstate <- renderUI({
      selectInput("diffstate", label='Differentiation State',
                  choices=names(all.networks), selected="DE", selectize=TRUE)
    })
    
    output$feature <- renderUI({
      selectInput("feature", label='Feature',
                  choices=all.networks[[input$diffstate]]$node$feature, 
                  selectize=TRUE, multiple = TRUE)
    })
    
    
    output$edgeDataTable <- DT::renderDataTable({
      network <- network()
      
      DT::datatable(network$edges,
                    style='bootstrap', options=list(dom = 'tp', pageLength=5))
    })

    output$nodeDataTable <- DT::renderDataTable({
      network <- network()
      
      DT::datatable(network$nodes %>% select(-id, -label, -enrich.fdr, -enrich.score, -shape),
                    style='bootstrap', options=list(dom = 'tp', pageLength=5))
    })
    
    output$plot <- renderVisNetwork({
      network <- network()
      
      edges <- network$edges
      nodes <- network$nodes
      
      visNetwork(nodes=nodes, edges=edges) %>% visEdges(arrows='to')
    })
    
  })
  
})