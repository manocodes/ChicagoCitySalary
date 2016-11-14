library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)

#a public dataset i retrieved from data.gov which contains salaries of chicago
#city employees for year 2010 to 2013.
SalaryData = read.csv("Salary.csv", stringsAsFactors = FALSE)

#here i'm retriving the list of agencies for filtering data
agencies = table(SalaryData$AgencyTitle)

#using dplyr and tidyr to clean and tidy the data and summarise the data by agency.
#for example Salary2010 into Year and Salary columns.
CleanSalaryData = SalaryData %>%
        gather(Year, Salary, Salary2010:Salary2013) %>%
        mutate(Year = as.numeric(gsub("\\D","", Year))) %>%
        group_by(AgencyTitle, Year) %>%
        summarise(AvgSalary = mean(Salary))

shinyServer(function(input, output) {
        
        #identify the range of years to filter the data.
        minvalue = reactive({input$slider1[1]})
        maxvalue = reactive({input$slider1[2]})
    
        #dynamically build a dropdown list with agencies.
        output$select <- renderUI({
                selectInput("select", "Select Agency",  names(agencies))
        })
        
        #selecting the agency to filter the data, this will be empty in the first load
        agency = reactive({input$select})
    
        #render the data table. First time it will load all data and second time
        #we will have to specify an agency..
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
        
        #Title for data
        output$text1 = renderText({
                label = paste("Salary Datails for Year ", 
                              minvalue(), " to ", 
                              maxvalue() , sep="")
        })
        
        #plot to compare the salaries when an agency is selected.
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
