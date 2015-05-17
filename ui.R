# ui.R

shinyUI(fluidPage(
  titlePanel("GAMSAT Score Estimator"),

  sidebarLayout(
    sidebarPanel(
        p("Please enter all results in as raw marks, not percentages."),
        p("If you haven't completed a test, please leave the mark as zero. Note that this will reduce the certainty of your score estimate."),
        h4("Acer Practice Test 1 (Green)"),
        sliderInput("pt1s1", label="Section 1", 0, 75, value=0, step = NULL, round = FALSE, ticks = FALSE, animate = FALSE),
        sliderInput("pt1s3", label="Section 3", 0, 110, value=0, step = NULL, round = FALSE, ticks = FALSE, animate = FALSE),
        h4("Acer Practice Test 2 (Purple)"),            
        sliderInput("pt2s1", label="Section 1", 0, 75, value=0, step = NULL, round = FALSE, ticks = FALSE, animate = FALSE),
        sliderInput("pt2s3", label="Section 3", 0, 110, value=0, step = NULL, round = FALSE, ticks = FALSE, animate = FALSE),
        h4("Acer Magical Essay Machine"),
        sliderInput("essay", label="Enter both lower and upper bounds", 0, 100, value=c(0,0), step = NULL, round = FALSE, ticks = FALSE, animate = FALSE)
    ),
    mainPanel(
        tabsetPanel(
            tabPanel("Summary",
                p("Please note that this is only an estimate based of the marks that other PagingDr students have achieved on the practice exams and the real GAMSAT. There is no guarantee that you will perform similarly to the prediction of this tool. For more information, please refer to the PagingDr thread found at:", a(href="http://pagingdr.net/forum/index.php?topic=6109", "http://pagingdr.net/forum/index.php?topic=6109"), "."),
                p(withMathJax("This also has the assumption that you have done the practice exams under exam conditions. Extreme low or high (\\(\\ge80\\%\\)) marks are likely to be less reliable as well.")),
                h5("Further explanation:"),
                p(withMathJax("Estimated scores are given as \\(x (y-z)\\), where \\(x\\) is the fit value from the regression, and \\(y\\) and \\(z\\) are the 95th prediction intervals. i.e. With a result of 60 (50-70), it is 95% likely (given the model) that you could achieve a score between 50 and 70 on that section.")),
                fluidRow(
                    column(3, h5("Section 1:")),
                    column(3, textOutput("s1"))
                ),
                fluidRow(
                    column(3, h5("Section 2:")),
                    column(3, textOutput("s2"))
                ),
                fluidRow(
                    column(3, h5("Section 3:")),
                    column(3, textOutput("s3"))
                ),
                br(),
                fluidRow(
                    column(3, h4("Overall:")),
                    column(3, h4(textOutput("overall")))
                ),
                plotOutput("overallplot")
            ),
            tabPanel("Section 1",
                p("Please note that this is only an estimate based of the marks that other PagingDr students have achieved on the practice exams and the real GAMSAT. There is no guarantee that you will perform similarly to the prediction of this tool. For more information, please refer to the PagingDr thread found at:", a(href="http://pagingdr.net/forum/index.php?topic=6109", "http://pagingdr.net/forum/index.php?topic=6109"), "."),
                plotOutput("s1plot")
            ),
            tabPanel("Section 3",
                p("Please note that this is only an estimate based of the marks that other PagingDr students have achieved on the practice exams and the real GAMSAT. There is no guarantee that you will perform similarly to the prediction of this tool. For more information, please refer to the PagingDr thread found at:", a(href="http://pagingdr.net/forum/index.php?topic=6109", "http://pagingdr.net/forum/index.php?topic=6109"), "."),
                plotOutput("s3plot")
            ), 
            tabPanel("Numeric/Regression Details",
                     p("Depending on the practice exam marks that you have available for input, a different regression model will have been used. Generally, the more data you have, the more accurate these results will be."),
                     p("For those familar with R, the following may provide more details. Full source code (and pull requests if there's something that you'd like to fix) can be found at https://bitbucket.com/chesftc/gamsat_predictor/"),
                     h4("Section 1:"),
                     p("The following linear regression model was used:"),
                     verbatimTextOutput("s1lmsummary"),
                     h4("Section 2:"),
                     p("For section 2, the Acer Magical Essay Marking Machine's score is used directly without transformation."),
                     h4("Section 3:"),
                     p("The following linear regression model was used:"),
                     verbatimTextOutput("s3lmsummary"),
                     h4("Overall Score:"),
                     p("Your overall score was calculated using the following equation (including for both upper and lower bounds):"),
                     withMathJax(p("$$\\text{Score}=\\dfrac{(\\text{S1}+\\text{S2}+\\text{S3}\\times2)}{4}$$")),
                     p("Conversion of a score to a percentile rank is based on the 2015 Acer plot, which is approximately equivalent to the following:"),
                     withMathJax(p("$$\\text{Percentile}=\\dfrac{100}{1+e^{-k(x-x_0)}},$$"), p("where \\(x=\\text{Overall Score}, x_0=58\\text{ (i.e. the 50th percentile)}, k=0.2275\\)"))
            )
        )
    )
  ),
helpText("Copyright 2015, under the AGPL. For more information, please email", a(href='mailto:gamsatcalc@fearthecow.net', 'gamsatcalc@fearthecow.net'), ". This tool is not affiliated in any way with ACER, GEMSAS, any university, or preparation course.")
)
)
