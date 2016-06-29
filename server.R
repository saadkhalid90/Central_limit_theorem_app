## loading necessary libraries
library(shiny) 

## Professor Doru's plot function (modified to graph samples and sample means together)
over.hist.pop.sample_combined<-function(Pop,Sam,mean_Sam,step=5,color="red",title="",drawmean=FALSE) {
  NP<-length(Pop)
  NS<-length(Sam)
  N_MS<-length(mean_Sam)
  ra<-range(c(floor(range(Pop)),ceiling(range(Pop))))
  lr<-ra[1]
  ur<-ra[2]
  histP<-hist(Pop,breaks=(lr:ur),plot=FALSE)
  plot(range(lr,ur),range(0,max(histP$counts)),t="n",
       bty="n",xlab="",ylab="",main=title)
  segments(lr,0,ur,0,col="black")
  for(i in lr:ur) segments(i,0,i,max(histP$counts),col="grey")
  plot(histP,add=TRUE)
  histS<-hist(Sam,breaks=(lr:ur),plot=FALSE)
  X<-NULL
  H<-NULL
  X_MS<-NULL
  H_MS<-NULL
  H[-lr+lr:ur]<-1
  H_MS[-lr+lr:ur]<-1
  for(i in 1:NS) {
    X[i]<-if(Sam[i]<0) trunc(Sam[i])-0.5 else trunc(Sam[i])+0.5
  }
  f<-step*NP/(NS*10)
  for(i in 1:NS) {
    points(x=X[i],y=H[X[i]+0.5-lr],col=color,pch=19)
    H[X[i]+0.5-lr]<-H[X[i]+0.5-lr]+f
  }
  
  for(i in 1:N_MS) {
    X_MS[i]<-if(mean_Sam[i]<0) trunc(mean_Sam[i])-0.5 else trunc(mean_Sam[i])+0.5
  }
  f_ms<-step*NP/(N_MS*10)
  for(i in 1:N_MS) {
    points(x=X_MS[i],y=H_MS[X_MS[i]+0.5-lr],col="blue",pch=18)
    H_MS[X_MS[i]+0.5-lr]<-H_MS[X_MS[i]+0.5-lr]+f_ms
  }
  if(drawmean==TRUE) {
    abline(v=mean(Sam),col=color,lwd=3,lty=6)
    abline(v=mean(mean_Sam),col="blue",lwd=2)
    mean(Sam)
  }
}

## setting parameters for he simulation 
set.seed(42) # sets the point at which random numbers are read (like in Table B) 
NP<-100000 # the number of observations in the population
mu<-3 # the population mean
sigma<-4 # the population standard deviation
Pop<-rnorm(NP,mu,sigma)
Pop<-c(Pop,-Pop)
ns<-50

## simulation params 
delay <- 0.25
n_sims <- 50
maxIter <- n_sims

## Server function for the app
shinyServer(function(input, output, session) {
  runSimPlot <- reactive({
    if (input$action %% 2 == 1){
      vals <- reactiveValues(Sam = NULL, SAVEMEANS = NULL, counter = 0)

      # Do the actual computation here.
      observe({
        isolate({
          # This is where we do the expensive computing
          vals$Sam <- sample(Pop,ns)
          vals$SAVEMEANS <- c(vals$SAVEMEANS, mean(vals$Sam))
  
          vals$counter <- vals$counter + 1
          #print(vals$counter)
          #print(input$action)
          
        })

        # If we're not done yet, then schedule this block to execute again ASAP.
        # Note that we can be interrupted by other reactive updates to, for
        # instance, update a text output.
        samp <- vals$Sam
        save_means <- vals$SAVEMEANS
        
        if (isolate(vals$counter) < maxIter){
          invalidateLater(250)
        }
        ##return(over.hist.pop.sample_combined(Pop,isolate(vals$Sam),isolate(vals$SAVEMEANS),step=2,color="red",
        ##                                     title="Overlaid Histograms for Population and Sample",drawmean=TRUE))
        ##print(input$action)
      })
      print(input$action)
      print(isolate(vals$Sam))
      
      return(over.hist.pop.sample_combined(Pop,samp,save_means,step=2,color="red",
                                           title="Overlaid Histograms for Population and Sample",drawmean=TRUE))
      # return(over.hist.pop(Pop,step=2,color="red",
      #                                      title="Overlaid Histograms for Population and Sample",drawmean=TRUE))
      
    }
    else {
      print(input$action)

      return(over.hist.pop(Pop,step=2,color="red",
                           title="Overlaid Histograms for Population and Sample",drawmean=TRUE))
    }
  })

  output$SampleMeanPlot <- renderPlot({
    runSimPlot() 
  })
})