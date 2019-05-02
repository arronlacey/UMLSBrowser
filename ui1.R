ui1 <- shinyUI(fluidPage(
  
  
  # Application title
  h3("Welcome to the Unified Medical Language System Browser."),
  h5("This browser uses UMLS credentials to log in. The browser can be used to map terms between different coding systems
     or rapidly construct case definitions."),
  h6("Contact Arron Lacey at a.s.lacey@swansea.ac.uk"),
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      textInput("user", "User",""),
      passwordInput("password", "Password",""),
      actionButton("login", "Login")
      
    ),
    mainPanel(
      tableOutput("table")
    )
  )
  ))

