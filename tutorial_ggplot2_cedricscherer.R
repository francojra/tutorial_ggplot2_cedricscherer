
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

## Pacote alternativo para baixar fontes:

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

# Trabalhando com legendas -----------------------------------------------------------------------------------------------------------------

## Nós iremos colorir o gráfico de acordo com as estações. Nós mapearemas a variável
## estação para a estética de cor. O padrão do ggplot2 automaticamente adiciona a legenda
## quando mapeamos a variável no aesthetic (aes). 

ggplot(chic,
  aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)")

# Retirando a legenda do gráfico -----------------------------------------------------------------------------------------------------------

## A forma mais fácil é usar theme(legend.position = "none"):

ggplot(chic,
       aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(legend.position = "none")

## Você também pode utilizar guides(color = "none") ou scale_color_discrete(guide = "none")
## em alguns casos específicos. Enquanto o exemplo acima remove todas as legendas, você
## pode remover legendas particulares e manter outras usando o guides. 

ggplot(chic,
       aes(x = date, y = temp,
           color = season, shape = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  guides(color = "none")

# Removendo títulos da legenda -------------------------------------------------------------------------------------------------------------

## Nós usamos o argumento element_blank para remover.

ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(legend.title = element_blank())

## Você pode alcançar o mesmo resultado estabelecendo NULL para legenda.
## Exemplo: scale_color_discrete(name = NULL) ou labs(color = NULL). 

ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)", color = NULL) 

ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  scale_color_discrete(name = NULL)

# Mudando a posição da legenda -------------------------------------------------------------------------------------------------------------

## Se você quiser mudar a posição da legenda que por padrão fica na direita, você
## pode usar o argumento legend.position no theme. Possíveis posições são top, bottom,
## right and left.

ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(legend.position = "top")

## Você também pode colocar a legenda dentro do painel especificando um vetor x e y,
## variando de 0 (esquerda e abaixo) a 1 (dieita e topo).

ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)",
       color = NULL) +
  theme(legend.position = c(.15, .15),
        legend.background = element_rect(fill = "transparent"))

## O background da legenda com preenchimento trasnparente permite não
## esconder os dados.

# Mudando a direção da legenda -------------------------------------------------------------------------------------------------------------

## A direção padrão do ggplot2 é vertical, mas horizontal quando escolhemos opções
## de 'bottom' and 'top'. Nós também temos a opção de escolher a direção:

ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(legend.position = c(.5, .97),
        legend.background = element_rect(fill = "transparent")) +
  guides(color = guide_legend(direction = "horizontal"))

# Mudando o estilo do título da legenda ----------------------------------------------------------------------------------------------------

## Você pode mudar a aparência do título da legenda por ajustar o elemento theme.

ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(legend.title = element_text(family = "Playfair",
                                    color = "chocolate",
                                    size = 14, face = "bold"))

# Mudando o título da legenda --------------------------------------------------------------------------------------------------------------

## O caminho mais fácil para mudar o título da legenda é usar a camada labs().

ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)",
       color = "Seasons\nindicated\nby colors:") +
  theme(legend.title = element_text(family = "Playfair",
                                    color = "chocolate",
                                    size = 14, face = "bold"))

## O título da legenda também pode ser modificado usando scale_color_discrete(name = "title")
## ou guides(color = guide_legend("title")).

ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(legend.title = element_text(family = "Playfair",
                                    color = "chocolate",
                                    size = 14, face = "bold")) +
  scale_color_discrete(name = "Seasons\nindicated\nby colors:")

# Adicionando novas fontes ao Windows ------------------------------------------------------------------------------------------------------

library(extrafont)
font_import()
loadfonts(device = "win")

ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)",
       color = "Seasons\nindicated\nby colors:") +
  theme(legend.title = element_text(family = "serif",
                                    color = "chocolate",
                                    size = 14, face = "bold"))

## Vendo quais fontes disponíveis
windowsFonts()

ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)",
       color = "Seasons\nindicated\nby colors:") +
  theme(legend.title = element_text(family = "mono",
                                    color = "chocolate",
                                    size = 14, face = "bold"))

ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)",
       color = "Seasons\nindicated\nby colors:") +
  theme(legend.title = element_text(family = "Playfair",
                                    color = "chocolate",
                                    size = 14, face = "bold"))

# Mudando a ordem dos elementos da legenda -------------------------------------------------------------------------------------------------

chic$season <-
  factor(chic$season,
         levels = c("Winter", "Spring", "Summer", "Autumn"))

ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)")

# Mudando os rótulos da legenda ------------------------------------------------------------------------------------------------------------

## Nós substituimos estações pelos meses, através do vetor de nomes em 
## scale_color_discrete().

ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  scale_color_discrete(
    name = "Seasons:",
    labels = c("Mar—May", "Jun—Aug", "Sep—Nov", "Dec—Feb")) +
  theme(legend.title = element_text(
    family = "mono", color = "chocolate", size = 14, face = 2))

# Mudando o background da caixa da legenda --------------------------------------------------------------------------------------------------

## Para mudar a cor do background da legenda, nós usamos a camada de tema com
## o elemento legend.key:

ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(legend.key = element_rect(fill = "darkgoldenrod1"),
        legend.title = element_text(family = "Playfair",
                                    color = "chocolate",
                                    size = 14, face = 2)) +
  scale_color_discrete("Seasons:")

## Se quiser se livrar das caixas da legenda, você pode usar fill = NA ou 
## fill = "transparent".

# Mudando o tamanho dos símbolos da legenda ------------------------------------------------------------------------------------------------

## O tamanho padrão dos símbolos da legenda podem ser pequenos, especialmente sem as
## caixas. Para rsolver isso, nós usamos o overrride da camada guides().

ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(legend.key = element_rect(fill = NA),
        legend.title = element_text(color = "chocolate",
                                    size = 14, face = 2)) +
  scale_color_discrete("Seasons:") +
  guides(color = guide_legend(override.aes = list(size = 5)))

# Deixar uma camada fora da legenda --------------------------------------------------------------------------------------------------------

## Aqui você tem dois geoms mapeados para a mesma variável, com cores para a estética
## da camada de pontos e outra camada chamada rug. Por padrão, ambos são representados
## na legenda.

ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  geom_rug()

## Dentro do geom_rug ou point você pode usar o show.legende = FALSE para desativar
## uma das legendas.

ggplot(chic, aes(x = date, y = temp, color = season)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)") +
  geom_rug(show.legend = FALSE)

# Adicionando legendas manualmente ---------------------------------------------------------------------------------------------------------

## {ggplot2} will not add a legend automatically unless you map aesthetics 
## (color, size etc.) to a variable

## ggplot2 não adiciona legenda automaticamente, isso acontece apenas quando você
## determina no aesthetic cor, preenchimento ou tamanho como uma variável.

ggplot(chic, aes(x = date, y = o3)) +
  geom_line(color = "gray") +
  geom_point(color = "darkorange2") +
  labs(x = "Year", y = "Ozone")

## Para adicionar uma legenda nesse caso, nós podemos definir uma string dentro
## das camadas de ponto e linha do exemplo abaixo. Nesse caso ela não ocorre como
## uma variável, mas uma string. Então na escala de cor, nós adicionamos a legenda.

ggplot(chic, aes(x = date, y = o3)) +
  geom_line(aes(color = "line")) +
  geom_point(aes(color = "points")) +
  labs(x = "Year", y = "Ozone") +
  scale_color_discrete(name = "Type:")

## Entretanto, nós queremos as cores cinza e laranja. Para mudar a cor de acordo com
## a que desejamos nós colocamos a camada scale_color_manual. Adicionalmente, nós
## detalhamos na legenda, através do guide(), pontos como laranja e linha como cinza.

ggplot(chic, aes(x = date, y = o3)) +
  geom_line(aes(color = "line")) +
  geom_point(aes(color = "points")) +
  labs(x = "Year", y = "Ozone") +
  scale_color_manual(name = NULL,
                     guide = "legend",
                     values = c("points" = "darkorange2",
                                "line" = "gray")) +
  guides(color = guide_legend(override.aes = list(linetype = c(1, 0),
                                                  shape = c(NA, 16))))

# Usando outros estilos de legenda ---------------------------------------------------------------------------------------------------------

## O padrão da legenda para variáveis categóricas como season é o guide_legend(), como visto
## nos exemplos anteriores. Se você mapeia uma variável contínua no aesthetic, o padrão
## utilizado não é o guide_legend() mas o guide_colorbar() ou guide_colourbar().

ggplot(chic,
       aes(x = date, y = temp, color = temp)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)", color = "Temperature (°F)")

## Entretanto, ao usar o guide_legend, você pode forçar a legenda para mostrar cores discretas
## para cada valor numérico.

ggplot(chic,
       aes(x = date, y = temp, color = temp)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)", color = "Temperature (°F)") +
  guides(color = guide_legend())

## Ou você pode usar escalas binned na legenda.

ggplot(chic,
       aes(x = date, y = temp, color = temp)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)", color = "Temperature (°F)") +
  guides(color = guide_bins())

## Ou escalas agrupadas como barras de cores discretas.

ggplot(chic,
       aes(x = date, y = temp, color = temp)) +
  geom_point() +
  labs(x = "Year", y = "Temperature (°F)", color = "Temperature (°F)") +
  guides(color = guide_colorsteps())

# Trabalhando com background e linhas de grid ----------------------------------------------------------------------------------------------

## Existem formas de você mudar toda a aparência do seu gráfico com uma função, mas você também
## pode mudar apenas alguns dos elementos do background.

# Mudando a cor do painel ------------------------------------------------------------------------------------------------------------------

## Para mudar a cor do preenchimento do background da área do painel (área onde a geometria
## do gráfico é 'plotada'), você utiliza o argumento panel.background.

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "#1D8565", size = 2) +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(panel.background = element_rect(
    fill = "#64D2AA", color = "#64D2AA", size = 2))

## No seguinte exemplo, eu ilustrei usando uma cor semitransparente para o preenchimento (fill)
## usando o panel.border, e a mesma cor anterior para o contorno do painel.

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "#1D8565", size = 2) +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(panel.border = element_rect(
    fill = "#64D2AA99", color = "#64D2AA", size = 2)
  )

# Mudando as linhas do grid ----------------------------------------------------------------------------------------------------------------

## Existem dois tipos de linhas de grid: linhas maiores associadas aos ticks, e linhas menores
## entre as maiores. Você pode mudar todas essas usando panel.grid, ou apenas uma delas usando
## panel.grid.minor e panel.grid.major.

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(panel.grid.major = element_line(color = "gray10", size = .5),
        panel.grid.minor = element_line(color = "#64D2AA", size = .25))

## Você pode especificar ainda mais as linhas dos grids para os quatro diferentes níveis.

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(panel.grid.major = element_line(size = .5, linetype = "dashed"),
        panel.grid.minor = element_line(size = .25, linetype = "dotted"),
        panel.grid.major.x = element_line(color = "red1"),
        panel.grid.major.y = element_line(color = "blue1"),
        panel.grid.minor.x = element_line(color = "red4"),
        panel.grid.minor.y = element_line(color = "blue4"))

## Você pode remover algumas ou todas as linhas do grid.

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(panel.grid.minor = element_blank())

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(panel.grid = element_blank())

# Mudando o espaçamento das linhas de grid -------------------------------------------------------------------------------------------------

## Depois, você pode definir os limites entre ambos os grids, major and minor.

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  scale_y_continuous(breaks = seq(0, 100, 10),
                     minor_breaks = seq(0, 100, 2.5)) 

# Mudando a cor do background do gráfico ---------------------------------------------------------------------------------------------------

## Similarmente ao background do painel do gráfico com fill, para modificar o background
## do gráfico, você utiliza plot.background enquanto no anterior você usou panel.background.

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(plot.background = element_rect(fill = "gray60",
                                       color = "gray30", size = 2))

## Você pode alcançar uma única cor de background por estabelecer as mesmas cores em plot.background
## e panel.background. Ou você pode estabelecer o preenchimento do panel.background como NA ou
## "transparent", e o blackground do plot preenche todo o gráfico.

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(panel.background = element_rect(fill = NA),
        plot.background = element_rect(fill = "gray60",
                                       color = "gray30", size = 2))

# Trabalhando com margens ------------------------------------------------------------------------------------------------------------------

## As vezes é necessário adicionar algum espaço as margens do gráfico. Similar aos exemplos
## anteriores, nós podemos usar a camada theme() com o argumento plot.margin. Vamos agora
## adicionar espaço nas margens da direita e esquerda. O argumento plot.margin permite usar
## diversas unidades de medida (cm, polegadas, etc.), mas ela requer que as unidades sejam
## definidas com o pacote grid. Você pode usar o mesmo valor para todos os lados do gráfico com
## rep(x, 4) ou definir distâncias particulares.

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "firebrick") +
  labs(x = "Year", y = "Temperature (°F)") +
  theme(plot.background = element_rect(fill = "gray60"),
        plot.margin = margin(t = 1, r = 3, b = 1, l = 8, unit = "cm"))

# Trabalhando com múltiplos paineis do gráfico ---------------------------------------------------------------------------------------------

## O pacote ggplot2 tem duas funções para criar múltiplos painéis chamado facets. Eles 
## apresentam algumas diferenças, o facet_wrap cria essencialmente uma faixa de gráficos
## baseados em uma única variável enquanto o facet_grid pode abranger duas variáveis.

# Criando um grid de múltiplas janelas com duas variáveis ----------------------------------------------------------------------------------

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "orangered", alpha = .3) +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +
  labs(x = "Year", y = "Temperature (°F)") +
  facet_grid(year ~ season)

## Para mudar as variáveis das linhas e colunas, basta colocar facet_grid(year ~ season) 
## ou facet_grid(season ~ year).

# Criando múltiplas janelas do gráfico com uma variável ------------------------------------------------------------------------------------

## facet_wrap cria uma faceta com uma variável usando um til na frente facet_wrap(~ variable). 
## A aparência dos subplots é controlada por ncol e nrow.

g <-
  ggplot(chic, aes(x = date, y = temp)) +
    geom_point(color = "chartreuse4", alpha = .3) +
    labs(x = "Year", y = "Temperature (°F)") +
    theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))

g + facet_wrap(~ year)

## Adicionalmente, você pode arranjar os plots em uma única linha.

g + facet_wrap(~ year, nrow = 1)

## Ou mesmo como um grid assimétrico de gráficos.

g + facet_wrap(~ year, ncol = 3) + theme(axis.title.x = element_text(hjust = .15))

# Permitir que os eixos vagueiem livres ----------------------------------------------------------------------------------------------------

## O padrão do ggplot2 separa as janelas dos gráficos com as escalas equivalentes. Mas
## algumas vezes você quer que as escalas dos painéis sejam associadas ao conjunto de dados
## de cada variável. Você pode fazer isso usando o argumento scales = "free".

g + facet_wrap(~ year, nrow = 2, scales = "free")

## Note que tanto a escala de x como de y é diferente para cada janela do gráfico.

# Use facet_wrap com duas variáveis --------------------------------------------------------------------------------------------------------

g + facet_wrap(year ~ season, nrow = 4, scales = "free_x")

## Usando facet_wrap você ainda é capaz de controlar o desenho do grid: você pode rearranjar
## o número de gráficos por linhas e colunas, e pode também deixar todas as escalas dos eixos 
## livres. Em contraste, facet_grid irá tomar as escalas livres apenas para linhas ou colunas.

g + facet_grid(year ~ season, scales = "free_x")
g + facet_grid(year ~ season, scales = "free_y")

# Modificando o estilo das faixas dos gráficos ---------------------------------------------------------------------------------------------

## Usando a camada theme(), você pode modificar a aparência do texto das faixas (título de cada
## faceta) e dos boxes.

g + facet_wrap(~ year, nrow = 1, scales = "free_x") +
  theme(strip.text = element_text(face = "bold", color = "chartreuse4",
                                  hjust = 0, size = 20),
        strip.background = element_rect(fill = "chartreuse3", linetype = "dotted"))

## As seguintes duas funções adaptadas a partir desta resposta por Claus Wilke, o autor do pacote
## ggtext, permite destacar rótulos específicos em combinação com element_textbox() que é promovido
## pelo ggtext.

#install.packages("ggtext")
library(ggtext)
library(rlang)

element_textbox_highlight <- function(..., hi.labels = NULL, hi.fill = NULL,
                                      hi.col = NULL, hi.box.col = NULL, hi.family = NULL) {
  structure(
    c(element_textbox(...),
      list(hi.labels = hi.labels, hi.fill = hi.fill, hi.col = hi.col, hi.box.col = hi.box.col, hi.family = hi.family)
    ),
    class = c("element_textbox_highlight", "element_textbox", "element_text", "element")
  )
}

element_grob.element_textbox_highlight <- function(element, label = "", ...) {
  if (label %in% element$hi.labels) {
    element$fill <- element$hi.fill %||% element$fill
    element$colour <- element$hi.col %||% element$colour
    element$box.colour <- element$hi.box.col %||% element$box.colour
    element$family <- element$hi.family %||% element$family
  }
  NextMethod()
}

## Agora pode utilizá-lo e especificar, por exemplo, todos as faixas:

g + facet_wrap(year ~ season, nrow = 4, scales = "free_x") +
  theme(
    strip.background = element_blank(),
    strip.text = element_textbox_highlight(
      family = "Playfair", size = 12, face = "bold",
      fill = "white", box.color = "chartreuse4", color = "chartreuse4",
      halign = .5, linetype = 1, r = unit(5, "pt"), width = unit(1, "npc"),
      padding = margin(5, 0, 3, 0), margin = margin(0, 1, 3, 1),
      hi.labels = c("1997", "1998", "1999", "2000"),
      hi.fill = "chartreuse4", hi.box.col = "black", hi.col = "white"
    )
  )

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(aes(color = season == "Summer"), alpha = .3) +
  labs(x = "Year", y = "Temperature (°F)") +
  facet_wrap(~ season, nrow = 1) +
  scale_color_manual(values = c("gray40", "firebrick"), guide = "none") +
  theme(
    axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1),
    strip.background = element_blank(),
    strip.text = element_textbox_highlight(
      size = 12, face = "bold",
      fill = "white", box.color = "white", color = "gray40",
      halign = .5, linetype = 1, r = unit(0, "pt"), width = unit(1, "npc"),
      padding = margin(2, 0, 1, 0), margin = margin(0, 1, 3, 1),
      hi.labels = "Summer", hi.family = "Bangers",
      hi.fill = "firebrick", hi.box.col = "firebrick", hi.col = "white"
    )
  )

# Criando um painel com diferentes gráficos ------------------------------------------------------------------------------------------------

## Existem várias formas que os gráficos podem ser combinados. A abordagem mais fácil é usando
## o pacote patchwork do Thomas Lin Pedersen.

p1 <- ggplot(chic, aes(x = date, y = temp,
                       color = season)) +
        geom_point() +
        geom_rug() +
        labs(x = "Year", y = "Temperature (°F)")

p2 <- ggplot(chic, aes(x = date, y = o3)) +
        geom_line(color = "gray") +
        geom_point(color = "darkorange2") +
        labs(x = "Year", y = "Ozone")

library(patchwork)
p1 + p2

## Nós podemos mudar a posição dividindo os gráficos. Note que os gráficos ficam
## alinhados mesmo um apresentando legenda e o outro não.

p1 / p2

## Nós podemos deixar três gráficos alinhados.

(g + p2) / p1

## Alternativamente, o pacote cowplot do Claus Wilke promove funcionalidade para alinhar 
## múltiplos gráficos (e muitas outras boas funcionalidades). Nesse caso ele alinha a 
## legenda aos outros gráficos sem legenda.

library(cowplot)
plot_grid(plot_grid(g, p1), p2, ncol = 1)

## Outro pacote usado é o gridExtra.

library(gridExtra)
grid.arrange(g, p1, p2,
             layout_matrix = rbind(c(1, 2), c(3, 3)))

## A mesma ideia de definir um layout pode ser usada com patchwork que permite criar 
## composições complexas.

layout <- "
AABBBB#
AACCDDE
##CCDD#
##CC###
"

p2 + p1 + p1 + g + p2 +
  plot_layout(design = layout)

# Trabalhando com cores --------------------------------------------------------------------------------------------------------------------

## Para aplicações simples, trabalhar com cores no ggplot2 é fácil. Para aplicações mais
## avançadas talvez seja necessário ter em mãos o livro do Hadley. Outra boa fonte é o 
## R Cookbook e o color section in the R Graph Galery por Yan Holtz.

## Existem duas principais diferenças quanto a cores no ggplot2. Ambos argumentos color e fill.
## Elas podem ser assinadas para uso de cores simples e para variáveis com diferentes categorias.

# Especificando cores simples --------------------------------------------------------------------------------------------------------------

## Nós podemos especificar uma cor na camada geom.

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(color = "steelblue", size = 2) +
  labs(x = "Year", y = "Temperature (°F)")

## Nós também podemos definir uma cor (col) e um preenchimento (fill) para a geometria do gráfico.

ggplot(chic, aes(x = date, y = temp)) +
  geom_point(shape = 21, size = 2, stroke = 1,
             color = "#3cc08f", fill = "#c08f3c") +
  labs(x = "Year", y = "Temperature (°F)")

# Atribuindo cores as variáveis ------------------------------------------------------------------------------------------------------------

## No ggplot2 cores atribuídas a variáveis são definidas na camada de scale_color_* ou scale_fill_*
## Para usar cores nos seus dados, você deve conhecer se suas variáveis são contínuas ou categóricas.
## A paleta de cores deverá ser escolhida dependendo do tipo de variável, com sequencial e divergente
## cores sendo usadas para variáveis contínuas, e cores qualitativas usadas para variáveis categóricas.


