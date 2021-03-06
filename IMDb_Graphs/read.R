require(data.table)
require(stringr)
require(countrycode)

# Lectura de la informaci�n.
d <-  fread("data.csv", na.strings = "N/A", encoding = "UTF-8")

# Criterio de �xito. �Qu� valor creen que deber�a ser?
success <- 7

# Limpiammos y preparamos la informaci�n:
d$Runtime <- as.numeric(d$Runtime) # Hay pel�culas que tienen su duraci�n en formato texto.
d$Success <- "Success"
d[d$imdbRating < success, Success := "Fail"]
rm(success)

# En vista que hay m�s de un valor en cada vector, elegimos el primero por simplicidad.
first.element <- function(x){
  factor(sapply(str_split(x,','), "[", 1))
}
# Utilizamos el paquete data.table por eficiencia en la manipulaci�n de datos. No genera copias en la informaci�n.
d[, Genre := first.element(Genre)]
d[, Country := first.element(Country)]
d[, Language := first.element(Language)]
d[, Actors := first.element(Actors)]
d[, Director := first.element(Director)]
rm(first.element)

# Ordenar los niveles en g�nero de mayor a menor cantidad.
niveles <- d[!is.na(Genre), .N, by = .(Genre)][order(-N)]$Genre
d$Genre <- factor(d$Genre, levels = niveles) ; rm(niveles)

# Determinar el orden:
suc <- d[!is.na(Country) & Success %in% "Success", .N, keyby = .(Country)]
tot <- d[!is.na(Country), .N, keyby = .(Country)]
levels <- suc[tot]
levels[is.na(N), N := 0]
levels <- levels[, prop := 100*N/i.N][order(-prop)]
d$Country <- factor(d$Country, levels = levels$Country)
rm(suc, tot, levels)

# Barplot de idiomas
# Determinar el orden:
suc <- d[!is.na(Language) & Success %in% "Success", .N, keyby = .(Language)]
tot <- d[!is.na(Language), .N, keyby = .(Language)]
levels <- suc[tot]
levels[is.na(N), N := 0]
levels <- levels[, prop := 100*N/i.N][order(-prop)]
d$Language <- factor(d$Language, levels = levels$Language)
rm(suc, tot, levels)

d$Country_Code <- countrycode(d$Country,'country.name','iso3c') #Country Code Variable
