require(data.table)
require(stringr)

#Read Data
d <-  fread("data.csv", na.strings = "N/A", encoding = "UTF-8")

# Success Value. What do you think it should be?
success <- 7

# Clean up data:
d$Runtime <- as.numeric(d$Runtime) # It is neccesary since there are string values where it should be a number.
d$Success <- "Success"
d[d$imdbRating < success, Success := "Fail"]
rm(success)

# Use first element on vectors:
first.element <- function(x){
  factor(sapply(str_split(x,','), "[", 1))
}
d[, Genre := first.element(Genre)]
d[, Country := first.element(Country)]
d[, Language := first.element(Language)]
d[, Actors := first.element(Actors)]
d[, Director := first.element(Director)]
rm(first.element)

# Ordenar los niveles de la variable categórica para proyectarlos en orden
d$Genre <- factor(d$Genre, levels = d[!is.na(Genre), .N, by = .(Genre)][order(-N)]$Genre)

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

# d$Country_Code <- countrycode(d$Country,'country.name','iso3c') #Country Code Variable