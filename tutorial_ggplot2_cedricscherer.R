
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
## - Aesthetics aes(): estética dos objetos geométricos e estatísticos, como posição (variáveis x e y),
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

#library(ggplot2)
library(tidyverse)

## De acordo com os elementos básicos, o ggplot necessita de três coisas essenciais para formar
## gráfico: os dados, a estética e a geometria. Sempre começamos chamando a função ggplot(data = dados),
## que basicamente informa ao ggplot2 os nossos dados. Na maioria dos casos você plota duas variáveis
## x e y. Essa é a estética posicional e assim nós adicionamos aes(x = var1, y = var2) ao ggplot().
## Em alguns casos, nós especificamos apenas um variável e outros casos três variáveis.

## Tudo que for relacionado a variável de um conjunto de dados deve estar dentro do aes().

(g <- ggplot(chic, aes(x = date, y = temp))) # Apenas um painel com as variáveis é criado.

## Por nomear o gráfico em um objeto 'g', as próximas camadas do ggplot2 podem ser adicionadas a esse
## objeto.

g + geom_point() # Gráfico de dispersão

g + geom_line() # Gráfico de linha

## Nós podemos combinar várias camadas no mesmo gráfico do ggplot2.

g + geom_line() + geom_point()

# Modificando propriedades da geometria ----------------------------------------------------------------------------------------------------

## Dentro da função geom_* você pode acrescentar atributos estéticos de cor, forma e tamanho.
## Vamos tornar todos os pontos em diamantes com cor fire-red.

g + geom_point(color = "firebrick", shape = "diamond", size = 2)

## ggplot2 entende cor como color, colour ou col.

## Cada propriedade dentro da função geom_* são chamadas de argumentos.

g + geom_point(color = "firebrick", shape = "diamond", size = 2) +
    geom_line(color = "firebrick", linetype = "dotted", size = .3)

# Modificando o tema padrão do ggplot2 -----------------------------------------------------------------------------------------------------

## Para estabelecer um mesmo tema de gráfico para todos os plots produzidos em seguida,
## podemos utilizar a função theme_set(). Devemos observar se as cores dos pontos
## fornecem um contraste melhor para visualização no novo tema.

theme_set(theme_bw())

g + geom_point(color = "firebrick")

## A função theme() customiza vários elementos particulares do tema, é um comando
## essencial para modificar textos dos eixos, retângulos, linhas, etc.

# Trabalhando com eixos --------------------------------------------------------------------------------------------------------------------

## Para modificar os nomes dos eixos, nós utilizamos a função labs() e promovemos um
## cadeia de caracteres (textos) para cada variável x e y.

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)")

## Nós também podemos adicionar os nomes dos eixos utilizando as funções xlab() e ylab().

## O ggplot2 também permite adicionar superescrito aos títulos dos eixos.

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", 
       y = expression(paste("Temperature (", degree ~ F, ")"^"(Hey, why should we use metric units?!)")))
