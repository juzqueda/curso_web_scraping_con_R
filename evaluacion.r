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

# precio <- as.numeric(gsub("[^0-9]", "", precios))  

# precio


# Se extraén las ubicaciones

ubicacion <- contenedor |>
  html_elements(".item-address") |>
  html_text()

ubicacion


# Se extra el tipo de alquiler ofrecido

tipo <- contenedor |>
  html_elements(".item-amenities.item-amenities-with-icons") |>
  html_elements(".h-type") |>
  html_text()

tipo


# Se extraén los tamaños de los alquileres en metros cuadrados

# area <- contenedor |>
#   html_elements(".item-amenities.item-amenities-with-icons") |>
#   html_elements(".h-area") |>
#   html_text()

# area <- as.numeric(gsub("[^0-9]", "", area))  

# area

area <- contenedor |>
  html_elements(".item-amenities.item-amenities-with-icons") 

area_num <- sapply(area, function(cont) {
  element <- cont %>% html_element(".h-area")
  
  if (length(element) > 0) {
    # Se extrae el texto
    text <- html_text(element)
    num <- as.numeric(gsub("[^0-9]", "", text)) # Se elimina caracteres no numéricos
    ifelse(is.na(num), 0, num) # Para manejar los posibles faltantes NA
  } else {
    0
  }
})

area_num

# conviene pasar el vector a tipo caracter para poder agregar el mensaje no informado en los casos que se convirtieron a cero

area_num <- ifelse(area_num == 0, "No informado", as.character(area_num))

area_num

# Se evalua si el alquiler tiene dormitorios

dormitorio <- contenedor |>
  html_elements(".item-amenities.item-amenities-with-icons")

dormitorio



resultados <- sapply(dormitorio, function(contenedor) {elemento <- contenedor |>
    html_element(".h-beds")
    ifelse(length(elemento) > 0, "sí", "no")})
  
resultados  



### Se extrae el número de dormitorios por alquiler ofrecido


num_dormitorios <- sapply(dormitorio, function(contenedor) {
  elemento <- contenedor %>% html_element(".h-beds")
  
  if (length(elemento) > 0) {
    texto <- html_text(elemento)
    numero <- as.numeric(gsub("[^0-9]", "", texto)) # 
    ifelse(is.na(numero), 0, numero) 
  } else {
    0
  }
})

num_dormitorios


# Se construye una tabla "dataframe" con los datos extraidos 



alq_leona <- data.frame(
  ofrecimientos = nombre_alq,
  tipo = tipo,
  dormitorios = num_dormitorios,
  area = area_num,
  ubicacion = ubicacion,
  precio = precios,
  url = sub_url_2
)

# Ver las primeras filas de la tabla
head(alq_leona)


