
# A GGPLOT2 TUTORIAL FOR BEAUTIFUL PLOTTING IN R -------------------------------------------------------------------------------------------
# Autoria do script: Jeanne Franco ---------------------------------------------------------------------------------------------------------
# Data: 21/03/2022 -------------------------------------------------------------------------------------------------------------------------
# Referência: https://www.cedricscherer.com/2019/08/05/a-ggplot2-tutorial-for-beautiful-plotting-in-r/ -------------------------------------

# Pacotes necessários ----------------------------------------------------------------------------------------------------------------------

# install CRAN packages
install.packages(c("tidyverse", "colorspace", "corrr",  "cowplot",
                   "ggdark", "ggforce", "ggrepel", "ggridges", "ggsci",
                   "ggtext", "ggthemes", "grid", "gridExtra", "patchwork",
                   "rcartocolor", "scico", "showtext", "shiny",
                   "plotly", "highcharter", "echarts4r"))

# install from GitHub since not on CRAN
install.packages(devtools)
devtools::install_github("JohnCoene/charter")

# Dataset ----------------------------------------------------------------------------------------------------------------------------------

## Os dados são do National Morbidity and Mortality Air Pollution Study (NMMAPS). Para tornar
## a manipulação dos dados mais fácil, nós estamos limitando para Chicago and 1997–2000. 

chic <- readr::read_csv("https://raw.githubusercontent.com/z3tt/ggplot-courses/master/data/chicago-nmmaps.csv")
View(chic)

tibble::glimpse(chic)
