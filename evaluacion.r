library(tidyverse)
library(purrr)
library(rvest)


#######

# Leer la página web
url <- "https://www.leonainmobiliaria.com.ar/estado/en-alquiler/"

pagina <- read_html(url)


# Se selecciona el contenedor principal de los datos a extraer 

contenedor <- pagina %>%
  html_nodes(".listing-view.list-view.card-deck")  

contenedor

print(contenedor)


# Se guardan los titulos o nombres de los alquileres ofrecidos

alquileres <- contenedor %>%
  html_nodes(".item-title") 

alquileres

nombre_alq <- alquileres %>%
  html_text2()  

nombre_alq


# Se extraén las urls de los alquileres publicados

sub_url_2 <- contenedor %>%
  html_nodes(".item-title") |>
  html_element("a") |>
  html_attr("href")

sub_url_2 



# Se extraén los precios

precios <- contenedor %>%
  html_nodes(".item-listing-wrap") %>% 
  html_node(".item-body .item-price-wrap.hide-on-list .item-price") %>%
  html_text2()

precios




#######

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
