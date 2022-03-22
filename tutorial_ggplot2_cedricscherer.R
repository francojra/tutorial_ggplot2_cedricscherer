
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

# O pacote ggplot2 -------------------------------------------------------------------------------------------------------------------------

## O ggplot2 é um sistema para criar gráficos declarativamente, baseado na gramática de gráficos.
## Você promove os dados, chama o ggplot2 para mapear as variáveis no aesthetics, quais primitivas
## gráficas usar e ele cuida dos detalhes.

## O ggplot é construído de alguns elementos básicos:

## - Data: os dados brutos que você deseja plotar.
## - Geometries geom_: as formas geométicas que representam os dados (tipo de gráfico).
## - Aesthetics aes(): estética dos objetos geométricos e estatísticos (variáveis), como posição,
## cor, tamanho e forma.
## - Scales scale_: intervalo de dados para plortar nos eixos, transformações de log, raiz quadrada,
## e valores de fator para cores.
## - Statistical transformations stat_: resumos estatísticos dos dados, como quantis, médias,
## somas, intervalos de confiança, erros padrão, etc.
## - Coordinate system coord_: a transformação usada para mapear coordenadas de dados no plano
## retângulo.
## - Facets facet_: arranjo dos dados em uma rede de gráficos.
## - Visual themes theme(): os padrões visuais gerais de uma plotagem, como plano de fundo, grades, 
## eixos, tipo de letra padrão, tamanhos e cores.

## O número de elementos pode variar dependendo de como você agrupa eles e de qual a sua pergunta.

# O básico do ggplot2 ----------------------------------------------------------------------------------------------------------------------



