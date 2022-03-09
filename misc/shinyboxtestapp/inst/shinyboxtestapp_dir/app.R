library(ggplot2)
library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
    titlePanel("Old Faithful Geyser Data"),

    sidebarLayout(
        sidebarPanel(
            sliderInput("binwidth",
                        "Width of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),

        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        ggplot(data = faithful, aes(x = waiting)) + 
            geom_histogram(binwidth = input$binwidth)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
