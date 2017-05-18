#you can run code up here, as long as it will not need to be rerun
#First read in the data from a file
bballdata<-read.csv("NBAShots.csv",header=TRUE,stringsAsFactors = FALSE)

shinyServer(function(input, output,session) {
  
  #get player data for only times specified
  getData<-reactive({
    name<-input$player
    timevalues<-input$time
    
    playerdata<-bballdata[(bballdata$PlayerName==name)&(bballdata$TimeShot>=timevalues[1])&(bballdata$TimeShot<=timevalues[2]),]
    playerdata
  })
  
  #create plot
  output$shotChart<-renderPlot({
    
    #Fancy image on plot stuff
    #Get image
    isolate(ima <- readPNG("court.png"))
    
    #Set up the plot area
    isolate(plot(x=-25:25,ylim=c(-2.2,38.2),xlim=c(-25.0,25.0),type='n',xlab="horizontal direction (ft)",ylab="vertical direction (ft)",main="Shot Locations"))
    
    #Get the plot information so the image will fill the plot box, and draw it
    isolate(lim <- par())
    isolate(rasterImage(ima, lim$usr[1], lim$usr[3], lim$usr[2], lim$usr[4]))
    isolate(grid())
    
    
    #Now plot shots
    playerdata<-getData()
    
    col<-rep("black",length(playerdata$ShotMadeDummy))
    if (input$color){
      col[which(playerdata$ShotMadeDummy==1)]<-"Red"
    }
    lines(x=playerdata$X,y=playerdata$Y,col=col,type="p")
    #add legend if color-coded
    if (input$color){
      legend(x="topright",legend=c("Missed Shot","Made Shot"),col=c("Black","Red"),pch=16)
    }
  })
  
  #create output of observations    
  output$observations<-renderDataTable({
    playerdata<-getData()
    select(playerdata,PlayerName,Period, MinutesRemaining, SecondsRemaining, ShotResult, TimeShot)
  })
  
  #update slider
  observe({
    name<-input$player

    playerdata<-bballdata[(bballdata$PlayerName==name),]
    max<-ceiling(max(playerdata$TimeShot))
    updateSliderInput(session,"time",max=max,value=c(0,max))
  })
})