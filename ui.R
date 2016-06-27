shinyUI(fluidPage(
  
  # Copy the line below to make an action button
  actionButton("action", label = "Run/ Stop Simulation"),
  
  hr(),
  mainPanel(
    plotOutput("SampleMeanPlot"),
    plotOutput("SampleDistPlot")
  )
))