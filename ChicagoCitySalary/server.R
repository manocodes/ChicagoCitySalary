library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)
library(data.table)

SalaryData = read.csv("Salary.csv", stringsAsFactors = FALSE)

agencies = table(SalaryData$AgencyTitle)

CleanSalaryData = SalaryData %>%
        gather(Year, Salary, Salary2010:Salary2013) %>%
        mutate(Year = as.numeric(gsub("\\D","", Year))) %>%
        group_by(AgencyTitle, Year) %>%
        summarise(AvgSalary = mean(Salary))

shinyServer(function(input, output) {
        
        minvalue = reactive({input$slider1[1]})
        maxvalue = reactive({input$slider1[2]})
    
        output$select <- renderUI({
                selectInput("select", "Select Agency",  names(agencies))
        })
        
        agency = reactive({input$select})
    
        output$data = renderTable({    
        CleanSalaryData = CleanSalaryData %>%
                 filter(Year >= as.numeric(minvalue()) & Year <= as.numeric(maxvalue())) 
        
                if ( !is.null(agency()))
                {
                        CleanSalaryData = CleanSalaryData %>%
                                filter(AgencyTitle == agency()) 
                }else{
                        CleanSalaryData
                }
        })
        
        output$text1 = renderText({
                label = paste("Salary Datails for Year ", 
                              minvalue(), " to ", 
                              maxvalue() , sep="")
        })
        
        output$plot = renderPlot ({
                
                if (!is.null(agency()))
                {
                CleanSalaryData = CleanSalaryData %>%
                        filter(Year >= as.numeric(minvalue()) & Year <= as.numeric(maxvalue())) %>%
                        filter(AgencyTitle == agency())
                
                ggplot(CleanSalaryData, aes(x=as.factor(Year), y=AvgSalary, fill=as.factor(Year))) + 
                        geom_bar(stat="identity") +
                        labs(x="Year", y="Average Salary")
                }
        })
        
        
        })
