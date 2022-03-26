
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

# Aumenta o espaço entre os eixos e os títulos do eixos ------------------------------------------------------------------------------------

## Para modificar elementos dos eixos nós utilizamos a função theme(), e dentro dessa função
## usamos o argumento element_text() para modificar os títulos dos eixos x e y.

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(axis.title.x = element_text(vjust = 0, size = 15),
        axis.title.y = element_text(vjust = 2, size = 15))

## Os argumentos axis.title de x e y foram usados para modificar os títulos através do
## element_text, e o vjust foi usado para mudar o espaçamento do tírulo da linha do eixo.
## Ele se refere a um alinhamento vertical que normalmente varia entre 0 e 1.

## Você também pode modificar a distância alterando as margens do texto.

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(axis.title.x = element_text(margin = margin(t = 17), size = 15),
        axis.title.y = element_text(margin = margin(r = 17), size = 15))

## Os rótulos t e r se referem a 'top' e 'right', respectivamente. Você também 
## pode especificar outras margens como margin(t, r, b, l). Para o eixo x utilizamos
## top ou bottom, e para o eixo y utilizamos right ou left.

# Modificando a estética dos títulos dos eixos ---------------------------------------------------------------------------------------------

## Novamente, nós usamos a função theme() par alterar a estética dos títulos no argumento axis.title
## dos eixos x (axis.title.x) e y (axis.title.y). E dento do argumento element_text
## nós alteramos as cores, tamanhos e tipo de letra desses títulos.

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(axis.title = element_text(size = 15, color = "firebrick",
                                  face = "italic"))

## Usando apenas o axis.text podemos alterar os títulos de ambos os eixos x e y ao mesmo tempo.
## O argumento face pode ser usado como 'bold' para colocar em negrito.

## Nós podemos alterar as propriedades de apenas um dos eixos. 

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(axis.title = element_text(color = "sienna", size = 15, face = "bold"),
        axis.title.y = element_text(face = "bold.italic"))

## Em axis.title.y nós adicionamos a propriedade de negrito e itálico, acima das
## propriedades já definidas de cor e tamanho.

# Modificando a estética dos textos dos eixos (textos da linha) ----------------------------------------------------------------------------

## Nós podemos usar a função theme() também para modificar os textos (aqui números)
## escritos nas linhas dos eixos usando o argumento axis.text.

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(axis.text = element_text(color = "dodgerblue", size = 12),
        axis.text.x = element_text(face = "italic"))

# Rotacionando os textos dos eixos ---------------------------------------------------------------------------------------------------------

## Você pode rotacionar os textos dos eixos usando o argumento angle(), juntamente com o 
## hjust para ajuste horizontal (0 = left, 1 = right) e vjust para ajuste vertical 
## (0 = top, 1 = bottom).

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(axis.text.x = element_text(angle = 50, vjust = 1, hjust = 1, size = 12))

# Removendo ticks e textos dos eixos -------------------------------------------------------------------------------------------------------

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(axis.ticks.y = element_blank(),
        axis.text.y = element_blank())

## Se quiser se ver livre de um elemento temático, o elemento é sempre element_blank().

# Removendo títulos dos eixos --------------------------------------------------------------------------------------------------------------

## Você pode usar o element_blank(), mas o caminho mais fácil para remover os rótulos
## é usando o argumento NULL em labs().

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = NULL, y = "")

## Note que o NULL remove o elemento, assim como o element_blank(), enquanto
## quotes vazios irá manter o espaço para o título mas sem imprimir nada.

# Intervalos dos limites dos eixos ---------------------------------------------------------------------------------------------------------

## As vezes você pode querer limitar os intervalos dos eixos ao padrão do ggplot2, você
## pode fazer isso no gráfico sem manipular a tabela de dados.

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  ylim(c(0, 50))

## Alternativamente você pode usar scale_y_continuous(limits = c(0, 50)) ou
## coord_cartesian(ylim = c(0, 50)). O primeiro remove todos os pontos de dados fora do intervalo, 
## enquanto o segundo ajusta a área visível e é semelhante a ylim = c(0, 50). Existe
## uma pequena diferença entre essas funções, apesar dos valores serem os mesmos, repare:

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  scale_y_continuous(limits = c(0, 50))

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  coord_cartesian(ylim = c(0, 50))

## Você deve ter notado que no primeiro exemplo existe uma espaço vazio na borda
## superior do gráfico, enquanto no segundo exemplo os pontos vão além do eixo y.

# Forçando seu plot a apresentar a origem --------------------------------------------------------------------------------------------------

chic_high <- dplyr::filter(chic, temp > 25, o3 > 20)

ggplot(chic_high, aes(x = temp, y = o3)) +
  geom_point(color = "darkcyan") +
  labs(x = "Temperature higher than 25°F",
       y = "Ozone higher than 20 ppb") +
  expand_limits(x = 0, y = 0)

## Você obterá os mesmos resultados usando coord_cartesian(xlim = c(0, NA), ylim = c(0, NA)).

## Nós podemos forçar literalmente o R a começar do início.

ggplot(chic_high, aes(x = temp, y = o3)) +
  geom_point(color = "darkcyan") +
  labs(x = "Temperature higher than 25°F",
       y = "Ozone higher than 20 ppb") +
  expand_limits(x = 0, y = 0) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  coord_cartesian(clip = "off")

## O argumento clip = "off" em qualquer sistema de coordenadas, sempre começando por coord_*, 
## permite fazer o desenho fora da área do painel.

# Eixos com a mesma escala -----------------------------------------------------------------------------------------------------------------

## A função coord_equal é um sistema de coordenadas com uma proporção específicada representando
## o número de unidades sobre o eixo y equivalente a uma unidade sobre o eixo x. O padrão, ratio = 1,
## assegura que uma unidade no eixo x tenha o mesmo comprimento que uma unidade no eixo y.

ggplot(chic, aes(x = temp, y = temp + rnorm(nrow(chic), sd = 20))) +
  geom_point(color = "sienna") +
  labs(x = "Temperature (°F)", y = "Temperature (°F) + random noise") +
  xlim(c(0, 100)) + ylim(c(0, 150)) +
  coord_fixed()

## Proporções maiores que 1 faz unidades sobre o eixo y maiores que unidades sobre o eixo x,
## e vice versa:

ggplot(chic, aes(x = temp, y = temp + rnorm(nrow(chic), sd = 20))) +
  geom_point(color = "sienna") +
  labs(x = "Temperature (°F)", y = "Temperature (°F) + random noise") +
  xlim(c(0, 100)) + ylim(c(0, 150)) +
  coord_fixed(ratio = 1/5)

# Use uma função para alterar rótulos ------------------------------------------------------------------------------------------------------

## Por vezes é útil alterar um pouco as suas etiquetas, talvez adicionando unidades 
## ou sinais de percentagem sem as adicionar aos seus dados. Neste caso, pode usar uma função:

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = NULL) +
  scale_y_continuous(label = function(x) {return(paste(x, "Degrees Fahrenheit"))})

# Trabalhando com títulos ------------------------------------------------------------------------------------------------------------------

## Adicionar um título ao gráfico com ggtitle()

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  ggtitle("Temperatures in Chicago")

## Alternativamente você pode usar labs(). Com essa função você pode adicionar vários argumentos
## como subtítulos, tags, fontes, etc.

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)",
       title = "Temperatures in Chicago",
       subtitle = "Seasonal pattern of daily temperatures from 1997 to 2001",
       caption = "Data: NMMAPS",
       tag = "Fig. 1")

# Fazer um título negrito e acrescentar um espaço na linha de base -------------------------------------------------------------------------

## Para modificar as propriedades de um elemento do tema, nós usamos a função theme(), 
## com ela modificamos elementos de textos com axis.title e axis.text, modificando tipo de letra 
## e as margens.

## Todas as seguintes modificações dos elementos do tema trabalham não apenas para o título, mas 
## para outros rótulos como plot.subtitle, plot.caption, plot.caption, legend.title, legend.text, 
## e axis.title e axis.text.

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)",
       title = "Temperatures in Chicago") +
  theme(plot.title = element_text(face = "bold",
                                  margin = margin(10, 0, 10, 0),
                                  size = 14))

# Ajustando posições do título -------------------------------------------------------------------------------------------------------------

## O alinhamento geral (direita, centro e esquerda) é controlado pelo hjust (ajuste horizontal)
## Para ajustar o alinhamento vertical, usamos vjust.

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = NULL,
       title = "Temperatures in Chicago",
       caption = "Data: NMMAPS") +
  theme(plot.title = element_text(hjust = 1, size = 16, face = "bold.italic"))

## Desde 2019, o utilizador é capaz de especificar o alinhamento do título, subtítulo, 
## e legenda com base na área do painel (o padrão) ou a margem da parcela através de 
## plot.title.position e plot.caption.position. Essa é a melhor escolha 
## na maioria dos casos e muitas pessoas ficaram muito felizes com essa 
## nova característica, uma vez que especialmente com etiquetas de eixo y muito longas 
## o alinhamento parece horrível:

(g <- ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  scale_y_continuous(label = function(x) {return(paste(x, "Degrees Fahrenheit"))}) +
  labs(x = "Year", y = NULL,
       title = "Temperatures in Chicago between 1997 and 2001 in Degrees Fahrenheit",
       caption = "Data: NMMAPS") +
  theme(plot.title = element_text(size = 14, face = "bold.italic"),
        plot.caption = element_text(hjust = 0)))

g + theme(plot.title.position = "plot",
          plot.caption.position = "plot")

# Usando fontes não tradicionais nos títulos -----------------------------------------------------------------------------------------------

## Você também pode utilizar diferentes fontes e não somente a padrão fornecida pelo R.
## Existem vários pacotes que ajudam você a baixar fontes. Aqui eu uso o pacote showtext
## que facilita o uso de diversos tipo de fontes (TrueType, OpenType, Type 1, web fonts, 
## etc.) nos gráficos. Após carregar o pacote, você necessita adicionar as fontes. Eu
## regularmente uso o Google fonts que pode ser importado com a função font_add_google(), mas
## você também pode adicionar outra fonte com font_add().

library(showtext)
font_add_google("Playfair Display", ## name of Google font
                "Playfair")  ## name that will be used in R
font_add_google("Bangers", "Bangers")

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)",
       title = "Temperatures in Chicago",
       subtitle = "Daily temperatures in °F from 1997 to 2001") +
  theme(plot.title = element_text(family = "Bangers", hjust = .5, size = 25),
        plot.subtitle = element_text(family = "Playfair", hjust = .5, size = 15))

## Você também pode estabelecer essas fontes para todos os elementos dos seus gráficos.
## Estarei usando a fonte Roboto Condensed para todos os seguintes gráficos.

font_add_google("Roboto Condensed", "Roboto Condensed")
theme_set(theme_bw(base_size = 12, base_family = "Roboto Condensed"))

## Pacote alternativo para baixar fontes

devtools::install_github('r-lib/ragg')
library(ragg)

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)",
       title = "Temperatures in Chicago",
       subtitle = "Daily temperatures in °F from 1997 to 2001") +
  theme(plot.title = element_text(family = "fancy_font", hjust = .5, size = 25),
        plot.subtitle = element_text(family = "fancy_font", hjust = .5, size = 15))

# Mudando o espaçamento entre múltiplas linhas do texto ------------------------------------------------------------------------------------

## Você pode usar o argumento lineheight para mudar o espaçamento entre linhas. Nesse
## exemplo, eu tenho deixado as linhas mais unidas (lineheight < 1).

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  ggtitle("Temperatures in Chicago\nfrom 1997 to 2001") +
  theme(plot.title = element_text(lineheight = .8, size = 16))


