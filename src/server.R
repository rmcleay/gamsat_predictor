library(ggplot2)

# Read in the datafile
data <- read.csv(file="gamsatlr.csv");
S1Mean <- (data$PT1S1 + data$PT2S1)/2
S3Mean <- (data$PT1S3 + data$PT2S3)/2
data<-cbind(data, S1Mean, S3Mean)
attach(data)


# Percentile functions
k<-0.2275
xo <- 58

logitcurve <- function(x) {
    100/(1+exp(1)^(-1*k*(x-xo)))	
}

x <- seq(35,85)
y <- logitcurve(x)

curve <- data.frame(x=x,y=y)

shinyServer(function(input, output) {

    gets1lm <- reactive({
        if (input$pt1s1 > 0 && input$pt2s1 == 0) {
            s1lm <- lm(S1 ~ PT1S1)
        } else if (input$pt1s1 == 0 && input$pt2s1 > 0) {
            s1lm <- lm(S1 ~ PT2S1)
        } else {
            s1lm <- lm(S1 ~ S1Mean)
        }
    })


    gets3lm <- reactive({
        if (input$pt1s3 > 0 && input$pt2s3 == 0) {
            s3lm <- lm(S3 ~ PT1S3)
        } else if (input$pt1s3 == 0 && input$pt2s3 > 0) {
            s3lm <- lm(S3 ~ PT2S3)
        } else {
            s3lm <- lm(S3 ~ S3Mean)
        }
    })

    
    output$s1lmsummary <- renderText({
        lm <- gets1lm()
        paste(capture.output(summary.lm(lm)),collapse="\n")
    })

    output$s3lmsummary <- renderText({
        lm <- gets3lm()
        paste(capture.output(summary.lm(lm)),collapse="\n")
    })

    results <- reactive({
        newdata <-data.frame(PT1S1=(input$pt1s1), PT1S3=(input$pt1s3), PT2S1=(input$pt2s1), PT2S3=(input$pt2s3), S1Mean=((input$pt1s1+input$pt2s1)/2), S3Mean=((input$pt1s3+input$pt2s3)/2))

        r<-data.frame(s1=c(0,0,0),s2=c(0,0,0),s3=c(0,0,0),overall=c(0,0,0))

        lm <- gets1lm()
        if (input$pt1s1 != 0 || input$pt2s1 != 0) {
            pred <- predict(lm, newdata, interval='predict')
            r$s1 <- c(pred[1], pred[2], pred[3])
        }
        
        if (input$essay[1] !=0 & input$essay[2] !=0) {
            r$s2 <- c((input$essay[1]+input$essay[2])/2, input$essay[1], input$essay[2])
        }

        lm <- gets3lm()
        if (input$pt1s3 != 0 || input$pt2s3 != 0) {
            pred <- predict(lm, newdata, interval='predict')
            r$s3 <- c(pred[1], pred[2], pred[3])
        }

        if (r$s1[1] != 0 & r$s2[1] != 0 & r$s3[1] != 0) {
            r$overall <- c(
                (r$s1[1] + r$s2[1] + r$s3[1]*2)/4,
                (r$s1[2] + r$s2[2] + r$s3[2]*2)/4,
                (r$s1[3] + r$s2[3] + r$s3[3]*2)/4
            )
        }
        return(r)
    })

    #
    # Put the text output in the form
    #

    getS1 <- reactive({
        r <- round(results())
        if (r$s1[1] == 0) {
            return("-")
        } else {
            paste(r$s1[1], " (", r$s1[2], "-", r$s1[3], ")", sep='')
        }
    })
    getS2 <- reactive({
        r <- round(results())
        if (r$s2[1] == 0) {
            return("-")
        } else {
            paste(r$s2[1], " (", r$s2[2], "-", r$s2[3], ")", sep='')
        }
    })
    
    getS3 <- reactive({
        r <- round(results())
        if (r$s3[1] == 0) {
            return("-")
        } else {
            paste(r$s3[1], " (", r$s3[2], "-", r$s3[3], ")", sep='')
        }
    })
    getOverall <- reactive({
        r <- round(results())
        if (r$overall[1] == 0) {
            return("-")
        } else {
            paste(r$overall[1], " (", r$overall[2], "-", r$overall[3], ")", sep='')
        }
    })
    
    output$s1 <- renderText(getS1())
    output$s2 <- renderText(getS2())
    output$s3 <- renderText(getS3())
    output$overall <- renderText(getOverall())

    # Plots

    # A reactive expression with the ggvis plot
    output$s1plot <- renderPlot({
        r <- round(results())
        p <- ggplot(data, aes(S1Mean, S1)) + geom_point() + xlab("Mean S1 Practice Score") + ylab("Predicted GAMSAT S1 Score (SE)")
        if (input$pt1s1 > 0 && input$pt2s1 == 0) {
            p <- ggplot(data, aes(PT1S1, S1)) + geom_point() + xlab("acer pt1 s1 practice score") + ylab("predicted gamsat s1 score (se)")
        } else if (input$pt1s1 == 0 && input$pt2s1 > 0) {
            p <- ggplot(data, aes(PT2S1, S1)) + geom_point() + xlab("Acer PT2 S1 Practice Score") + ylab("Predicted GAMSAT S1 Score (SE)")
        }
        lm <- gets1lm()
        p <- p + stat_smooth(method='lm')

        if (input$pt1s1 > 0 && input$pt2s1 > 0) {
            p <- p + geom_pointrange(mapping=aes_string(x=(input$pt1s1+input$pt2s1)/2, y=r$s1[1], ymin=r$s1[2], ymax=r$s1[3]), colour='green') + ggtitle(paste("Estimated Score:", getS1()))
        } else if (input$pt1s1 > 0 && input$pt2s1 == 0) {
            p <- p + geom_pointrange(mapping=aes_string(x=input$pt1s1, y=r$s1[1], ymin=r$s1[2], ymax=r$s1[3]), colour='green') + ggtitle(paste("Estimated Score:", getS1()))
        } else if (input$pt1s1 == 0 && input$pt2s1 > 0) {
            p <- p + geom_pointrange(mapping=aes_string(x=input$pt2s1, y=r$s1[1], ymin=r$s1[2], ymax=r$s1[3]), colour='green') + ggtitle(paste("Estimated Score:", getS1()))
        }

        print(p)
    })

    output$s3plot <- renderPlot({
        r <- round(results())
        p <- ggplot(data, aes(S3Mean, S3)) + geom_point() + xlab("Mean S3 Practice Score") + ylab("Predicted GAMSAT S3 Score (SE)")
        if (input$pt1s3 > 0 && input$pt2s3 == 0) {
            p <- ggplot(data, aes(PT1S3, S3)) + geom_point() + xlab("Acer PT1 S3 Practice Score") + ylab("Predicted GAMSAT S3 Score (SE)")
        } else if (input$pt1s3 == 0 && input$pt2s3 > 0) {
            p <- ggplot(data, aes(PT2S3, S3)) + geom_point() + xlab("Acer PT2 S3 Practice Score") + ylab("Predicted GAMSAT S3 Score (SE)")
        }
        
        s3lm <- gets3lm()
        p <- p + stat_smooth(method='lm')

        if (input$pt1s3 > 0 && input$pt2s3 > 0) {
            p <- p + geom_pointrange(mapping=aes_string(x=(input$pt1s3+input$pt2s3)/2, y=r$s3[1], ymin=r$s3[2], ymax=r$s3[3]), colour='green') + ggtitle(paste("Estimated Score:", getS3()))
        } else if (input$pt1s3 > 0 && input$pt2s3 == 0) {
            p <- p + geom_pointrange(mapping=aes_string(x=input$pt1s3, y=r$s3[1], ymin=r$s3[2], ymax=r$s3[3]), colour='green') + ggtitle(paste("Estimated Score:", getS3()))
        } else if (input$pt1s3 == 0 && input$pt2s3 > 0) {
            p <- p + geom_pointrange(mapping=aes_string(x=input$pt2s3, y=r$s3[1], ymin=r$s3[2], ymax=r$s3[3]), colour='green') + ggtitle(paste("Estimated Score:", getS3()))
        }

        print(p)
    })

    output$overallplot <- renderPlot({
        r <- round(results())
        p <- ggplot(curve, aes(x,y)) + geom_line() + xlab("Estimated GAMSAT Score") + ylab("Estimated Percentile")

        if (r$overall[1] != 0) {
            p <- p + geom_pointrange(mapping=aes_string(x=r$overall[1], y=logitcurve(r$overall[1]), ymin=logitcurve(r$overall[2]), ymax=logitcurve(r$overall[3])), colour='green')
            p <- p + geom_point(mapping=aes_string(x=r$overall[1], y=logitcurve(r$overall[1])), colour='blue')
            p <- p + geom_segment(aes_string(x=r$overall[2], xend=r$overall[3], y=logitcurve(r$overall[1]), yend=logitcurve(r$overall[1])), colour='blue')
            p <- p + ggtitle(paste("Estimated Percentile: ", round(logitcurve(r$overall[1]),1), " (", round(logitcurve(r$overall[2]),1), "-", round(logitcurve(r$overall[3]),1), ")", sep=""))

        }
        print(p)
    })

  }
)
