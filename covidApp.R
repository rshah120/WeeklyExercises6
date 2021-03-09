
library(shiny)
library(tidyverse)
library(COVID19)

covid19 <- read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv")

ui <- fluidPage(
  sliderInput(inputId = "date", 
              label = "Date",
              min = min(covid19$date), 
              max = max(covid19$date), 
              value = c(min(covid19$date),
                        max(covid19$date)),
              sep = " "),
  selectInput("state", 
              "state", 
              multiple = TRUE,
              choices = list(AL = "Alabama", AK = "Alaska", AZ = "Arizona", 
                             AR = "Arkansas", CA = "California", CO = "Colorado", 
                             CT = "Connecticut", DE = "Delaware", FL = "Florida",
                             GA = "Georgia", HI = "Hawaii", ID = "Idaho",
                             IL = "Illinois", IN = "Indiana", IA = "Iowa",
                             KS = "Kansas", KY = "Kentucky", LA = "Louisiana",
                             ME = "Maine", MD = "Maryland", MA = "Massachusetts",
                             MI = "Michigan", MN = "Minnesota", MS = "Mississippi",
                             MO = "Missouri", MT = "Montana", NE = "Nebraska",
                             NV = "Nevada", NH = "New Hampshire", NJ = "New Jersey",
                             NM = "New Mexico", NY = "New York", NC = "North Carolina",
                             ND = "North Dakota", OH = "Ohio", OK = "Oklahoma",
                             OR = "Oregon", PA = "Pennsylvania", RI = "Rhode Island",
                             SC = "South Carolina", SD = "South Dakota",
                             TN = "Tennessee", TX = "Texas", UT = "Utah", VT = "Vermont",
                             VA = "Virginia", WA = "Washington", WV = "West Virginia",
                             WI = "Wisconsin", WY = "Wyoming", DC = "District of Columbia",
                             Guam = "Guam", Mariana = "Northern Mariana Islands",
                             PR = "Puerto Rico", VI = "Virgin Islands")),
  submitButton(text = "Create my plot!"),
  plotOutput(outputId = "covidplot")
)

server <- function(input, output) {
  output$covidplot <- renderPlot({
    covid19 %>% 
      group_by(state) %>%
      filter(cases > 20) %>%
      ggplot() + 
      geom_line(aes(x = date, y = cases, group = input$state)) +
      scale_x_continuous(limits = input$date) +
      scale_y_log10() +
      theme_minimal()
  })
}

shinyApp(ui = ui, server = server)

