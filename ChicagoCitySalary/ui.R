library(shiny)

#shinyUI(fluidPage(
#        tabsetPanel(
navbarPage("Chicago City",
           tabPanel( "Salary",(
                   # Sidebar with a slider input for number of bins
                   sidebarLayout(
                           sidebarPanel( h3("Chicago City Salary Info"),
                                         sliderInput("slider1","Select the Salary Year",
                                                     2010, 2013, value=c(2011, 2012)),
                                         uiOutput("select"),
                                         submitButton("Submit"),
                                         tags$br(),
                                         tags$a(href="mailto:mano.net@gmail.com?Subject=Feedback%20From%20DataScience%20Students..",
                                                "Email Mano with your feedback..")
                           ),
                           mainPanel( h2(textOutput("text1")),
                                      h3(textOutput("text2")),
                                      tableOutput("data"),
                                      plotOutput("plot")
                           )
                   )
           )),
           tabPanel( "Other Details", "Coming soon.."),
           tabPanel( "Misc", "Coming soon..")
)
#))
