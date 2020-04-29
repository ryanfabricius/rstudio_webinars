Web Scraping Part 2
================

Scrape data from the web (non API) Rstudio Essentials Watched 4/28/20

I have no experience with web scraping before these two webinars.

``` r
# load libraries
library(rvest)
library(xml2)
library(stringr)
library(dplyr)
```

There is a basic workflow when web scraping.

1.  Download the HTML and turn it into an XML file with read\_html()  
2.  Extract specific nodes with html\_nodes()  
3.  Extract content from nodes with html\_text(), html\_name(),
    html\_attrs(), html\_children\_(), html\_table()

The website has changed since the Webinar was created. The example in
the video ended up not working. After learning more about rvest, HTML,
and CSS, I was able to retrieve the cast with the following code.

``` r
# 1. Downlload HTML, convert to XML
frozen <- read_html("http://www.imdb.com/title/tt2294629/")

# 2. Extract specific nodes with html_nodes()
# Each cast name was now encoded as a hyperlink with no CSS in the source code
# Using html_nodes I will extract all links
links <- html_nodes(frozen, "a")

# 3. Extract content from nodes
links.content <- html_text(links)
links.content[190:230]
```

    ##  [1] " Kristen Bell\n"        "Anna"                   ""                      
    ##  [4] " Idina Menzel\n"        "Elsa"                   ""                      
    ##  [7] " Jonathan Groff\n"      "Kristoff"               ""                      
    ## [10] " Josh Gad\n"            "Olaf"                   ""                      
    ## [13] " Santino Fontana\n"     "Hans"                   ""                      
    ## [16] " Alan Tudyk\n"          "Duke"                   ""                      
    ## [19] " Ciarán Hinds\n"        "Pabbie"                 "Grandpa"               
    ## [22] ""                       " Chris Williams\n"      "Oaken"                 
    ## [25] ""                       " Stephen J. Anderson\n" "Kai"                   
    ## [28] ""                       " Maia Wilson\n"         "Bulda"                 
    ## [31] ""                       " Edie McClurg\n"        ""                      
    ## [34] " Robert Pine\n"         "Bishop"                 ""                      
    ## [37] " Maurice LaMarche\n"    "King"                   ""                      
    ## [40] " Livvy Stubenrauch\n"   "Young Anna"

After looking through some of the content, I realized that the cast
names started at lines 290 and ended at 230. Using these indices, and
the knowledge that each character string begins with a space, the names
are easily retrievable with string manipulation.

``` r
# Create list of indices to extract cast from links.content
name.indices <- seq(190, 230, 3)

# Extract Cast and surrounding area in between
cast.raw <- links.content[name.indices]

# Narrow cast.raw to only cast memebers
cast.raw.retrieved <- str_subset(cast.raw, "^ ")
cast.raw.retrieved
```

    ##  [1] " Kristen Bell\n"      " Idina Menzel\n"      " Jonathan Groff\n"   
    ##  [4] " Josh Gad\n"          " Santino Fontana\n"   " Alan Tudyk\n"       
    ##  [7] " Ciarán Hinds\n"      " Robert Pine\n"       " Maurice LaMarche\n" 
    ## [10] " Livvy Stubenrauch\n"

Now that only cast members are retrieved, I can clean up the strings for
the final product

``` r
# Eliminate space in front of names and \n at the end
cast <- cast.raw.retrieved %>% 
  str_replace("^ ", "") %>% 
  str_replace("\n", "")

# View cast
cast
```

    ##  [1] "Kristen Bell"      "Idina Menzel"      "Jonathan Groff"   
    ##  [4] "Josh Gad"          "Santino Fontana"   "Alan Tudyk"       
    ##  [7] "Ciarán Hinds"      "Robert Pine"       "Maurice LaMarche" 
    ## [10] "Livvy Stubenrauch"

I will do the same exercise again, but this time I will use
selectorGadget. SelectorGadget is an extension in chrome that displays
the css selectors for the item on the screen your mouse is hovering
over.

``` r
# Css selector for cast names
css <- "td a"

# Extract nodes using css selector
cast.css.selected <- html_nodes(frozen, css = css)

# View content from selected nodes
html_text(cast.css.selected)
```

    ##  [1] ""                       " Kristen Bell\n"        "Anna"                  
    ##  [4] ""                       " Idina Menzel\n"        "Elsa"                  
    ##  [7] ""                       " Jonathan Groff\n"      "Kristoff"              
    ## [10] ""                       " Josh Gad\n"            "Olaf"                  
    ## [13] ""                       " Santino Fontana\n"     "Hans"                  
    ## [16] ""                       " Alan Tudyk\n"          "Duke"                  
    ## [19] ""                       " Ciarán Hinds\n"        "Pabbie"                
    ## [22] "Grandpa"                ""                       " Chris Williams\n"     
    ## [25] "Oaken"                  ""                       " Stephen J. Anderson\n"
    ## [28] "Kai"                    ""                       " Maia Wilson\n"        
    ## [31] "Bulda"                  ""                       " Edie McClurg\n"       
    ## [34] ""                       " Robert Pine\n"         "Bishop"                
    ## [37] ""                       " Maurice LaMarche\n"    "King"                  
    ## [40] ""                       " Livvy Stubenrauch\n"   "Young Anna"            
    ## [43] ""                       " Eva Bella\n"           "Young Elsa"

The content displayed was the same as the content in cast.raw. Using
selectorGadget saved me the time looking through the source code and
searching for the indices in the list of links.
