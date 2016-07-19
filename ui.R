shinyUI(fluidPage(
  # distribution type specification
  selectInput("dist_type", label = "Select Population distribution", 
              choices = list("Normal" = 1, "Bi-modal" = 2, "Uniform" = 3), 
              selected = 1, width = '225px'),
  
  conditionalPanel(
    condition = "input.dist_type == 1",
    div(div(style="display:inline-block", sliderInput("sigma", "Standard Deviation:",
                                                      min = 2, max = 7, value = 4, step = 0.5, width = '225px')),
        div(style="display:inline-block", sliderInput("mu", "Mean:",
                                                      min = -5, max = 5, value = 0 , step = 1, width = '225px')),
        div(style="display:inline-block", sliderInput("samp_size", "Sample Size:",
                                                      min = 10, max = 100, value = 50, step = 5, width = '225px')))
    ),
  conditionalPanel(
    condition = "input.dist_type == 2",
    div(div(style="display:inline-block", sliderInput("sigma_1", "Sigma 1",
                                                      min = 0.5, max = 2.5, value = 2, step = 0.5, width = '225px')),
        div(style="display:inline-block", sliderInput("sigma_2", "Sigma 2",
                                                      min = 0.5, max = 2.5, value = 2 , step = 0.5, width = '225px')),
        div(style="display:inline-block", sliderInput("mean_bimodal;", "Mu",
                                                      min = -8, max = 8, value = c(-4,4) , step = 0.5, width = '225px')),
        div(style="display:inline-block", sliderInput("samp_size_bm", "Sample Size:",
                                                      min = 10, max = 100, value = 50, step = 5, width = '225px')))
  ),
  conditionalPanel(
    condition = "input.dist_type == 3",
    div(div(style="display:inline-block", sliderInput("range", "Min/Max:",
                                                      min = 0, max = 20, value = c(0,20), step = 1, width = '225px')),
        div(style="display:inline-block", sliderInput("samp_size_uni", "Sample Size:",
                                                      min = 10, max = 100, value = 50, step = 5, width = '225px')))
  ),
  # 
  # Copy the line below to make an action button
  
  actionButton("action", label = "Run/Reset Simulation"),

  hr(),
  mainPanel(
    div(plotOutput(width = '75%' ,"SampleMeanPlot"))
  )
))

# shinyUI(pageWithSidebar(
# 
#   # Copy the line below to make an action button
#   sidebarPanel(
#   sliderInput("sigma", "Standard Deviation:", 
#               min = 2, max = 5, value = 4, step = 0.5),
#   sliderInput("mu", "Mean:", 
#               min = -5, max = 5, value = 0 , step = 1),
#   sliderInput("samp_size", "Sample Size:", 
#               min = 10, max = 100, value = 50, step = 5), 
#   actionButton("action", label = "Run/ Stop Simulation")
#   ),
#   # Show a plot of the generated distribution
#   hr(),
#   mainPanel(
#     plotOutput("SampleMeanPlot")
#   )
# ))