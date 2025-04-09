library(tidyverse)
library(purrr)
library(rvest)


#######

# Leer la página web
url <- "https://www.leonainmobiliaria.com.ar/estado/en-alquiler/"
pagina <- read_html(url)

# Seleccionar el contenedor principal
contenedor <- pagina %>%
  html_nodes(".listing-view.list-view.card-deck")  # Clases separadas por puntos

contenedor

# Se guardan los titulos o nombre de los alquileres ofrecidos

alquileres <- contenedor %>%
html_nodes(".item-title") 

alquileres

nombre_alq <- alquileres %>%
  html_text2()  # Extrae el valor del atributo "item-title"

nombre_alq


sub_url <- contenedor %>%
  html_nodes("h2.item-title a") %>%  # Selecciona los elementos <a> dentro de <h2 class="item-title">
  html_attr("href") 

sub_url

class(sub_url)

# convertir urls en vector

urls_vector <- unlist(sub_url)

sub_url[1]


# Se guardan los número de habitaciones

habitaciones <- contenedor %>%
  html_nodes(".item-amenities.item-amenities-with-icons")

habitaciones_num <- habitaciones %>%
  html_nodes(".h-beds")

####
