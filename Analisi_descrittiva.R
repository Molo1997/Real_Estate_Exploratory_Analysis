

setwd("C:/Users/monte/OneDrive/My Drive/OneDrive/Desktop/Corso ProfessionAI/ProfessionAI_progetto_2")
cartella_progetto = getwd()
file<- "realestate_texas.csv"
dati <- read.csv(file, header = TRUE)


#tipo di dati e perimetro
str(dati)
dim(dati)
N=dim(dati)[1]
  
#selezione variabili numeriche e dtype stringa
variabili_da_analizzare <- names(dati)[sapply(dati, is.numeric)]
variabili_categoriali <- names(dati)[sapply(dati, is.character)]
variabili_da_analizzare <- c('sales','volume', 'median_price', 'listings', 'months_inventory')

#freq assolute e relative della variabile categorica
distr_freq_list <- lapply(dati['city'], function(x) {
  freq_ass <- table(x)
  freq_rel <- table(x)/N
  cbind(freq_ass, freq_rel)
})

distr_freq_dataframe <- as.data.frame(distr_freq_list)

#selezione variabili numeriche da analizzare e indici di posizione (media, mediana, quantili)

summary_dataframe <- as.data.frame(summary(dati[, variabili_da_analizzare]))

#selezione variabili da analizzare e indici di variabilità (intervallo di variazione, differenza interquartile)
nalisi_variabilità <- lapply(dati[variabili_da_analizzare], function(x) {
  iqr <- IQR(x)
  variance <- var(x)
  media <- mean(x)
  deviation <- sd(x) 
  intervallo_variazione <- (deviation / media) * 100
  c(Intervallo_Variazione = intervallo_variazione, IQR = iqr, Varianza = variance, SD = deviation, Media = media)
})
analisi_variabilita_dataframe <- as.data.frame(do.call(rbind, analisi_variabilità))

#selezione variabili da analizzare e forma della distribuzione (asimmetria, curtosi)
library(moments)
skewness(dati[variabili_da_analizzare])
kurtosis(dati[variabili_da_analizzare])-3

#Dividi in classi, distribuzione di frequenze, boxplot e calcola l’indice di Gini
num_valori_unici <- sapply(dati, function(x) length(unique(x)))

MIN <- min(dati$volume)
MAX <- max(dati$volume)

lunghezza_cl <- cut(dati$volume,
                    breaks = c(0, 20, 40, 60, 80, 100))
lunghezza_cl
N <- nrow(dati)
ni<-table(lunghezza_cl)
fi<-ni/N
Ni<-cumsum(ni)
Fi<-Ni/N
cbind(ni,fi,Ni,Fi)


distr_freq_lungh_cl<-as.data.frame(cbind(ni,fi,Ni,Fi))

library(ggplot2)

ggplot(data = distr_freq_lungh_cl)+
  geom_col(    
    aes(x=rownames(distr_freq_lungh_cl),
        y=ni),
    col="blue",
    fill="darkblue")+
  labs(x="Volume in classi",
       y="Frequenze assolute",
       title="Grafico a barre")+
  theme_bw()+
  scale_y_continuous(breaks = seq(0,100,10))

gini.index <- function(x){
  ni = table(x)
  fi = ni/length(x)
  fi2 = fi^2
  J = length(table(x))
  
  gini = 1-sum(fi2)
  gini.norm = gini/((J-1)/J)
  
  return(gini.norm)
}

lunghezza_cl <- cut(dati$volume,
                    breaks = c(0, 20, 40, 60, 80, 100))


table(lunghezza_cl)/length(lunghezza_cl)

gini.index(lunghezza_cl)

prob_beaumont <- prop.table(table(dati$city))["Beaumont"]
print(prob_beaumont)
prob_luglio <- prop.table(table(dati$month))[7] 
print(prob_luglio)
filtro_dicembre_2012 <- dati$month == 12 & dati$year == 2012
prob_dicembre_2012 <- prop.table(table(filtro_dicembre_2012))[TRUE]
print(prob_dicembre_2012)

# colonna che indichi prezzo medio
dati$prezzo_medio <- dati$volume*1000000 / dati$sales


# colonna che dia un’idea di “efficacia” degli annunci di vendita
dati$efficacia_annunci <- dati$sales / dati$listings
min_val <- min(dati$efficacia_annunci)
max_val <- max(dati$efficacia_annunci)
dati$efficacia_annunci_normalizzata <- (dati$efficacia_annunci - min_val) / (max_val - min_val)*100

#summary(), o semplicemente media e deviazione standard,
#di alcune variabili a tua scelta, condizionatamente alla città, agli anni e ai mesi

library(dplyr)

summary_stats <- dati %>%
  group_by(city, year) %>%
  summarise(
    mean_sales = mean(sales, na.rm = TRUE),
    sd_sales = sd(sales, na.rm = TRUE),
    var_sales = var(sales, na.rm = TRUE),
    mean_listings = mean(listings, na.rm = TRUE),
    sd_listings = sd(listings, na.rm = TRUE),
    var_listings = var(listings, na.rm = TRUE),
  )
print(summary_stats)
View(summary_stats)

#ggplot2 - confrontare la distribuzione del prezzo mediano delle case tra le varie città
library(ggplot2)
ggplot(data = dati)+
  geom_boxplot(    
    aes(x=city,
        y=median_price,
        fill= dati$city))+
  labs(x="città",
       y="distribuzione prezzo mediano",
       title="Boxplot città-P mediano")+
  theme_bw()

#ggplot2 - confrontare la distribuzione del valore totale delle vendite tra le varie città ma anche tra i vari anni
ggplot(data = dati, aes(x = city, y = volume, fill = factor(year))) +
  geom_boxplot() +
  labs(x = "Città",
       y = "Distribuzione del valore totale delle vendite",
       fill = "Anno",
       title = "Confronto della distribuzione del volume delle vendite per città e anno") +
  theme_bw()

# Grafico a barre sovrapposte per confrontare il totale delle vendite nei vari mesi/anno e città
nomi_mesi <- c("Gen", "Feb", "Mar", "Apr", "Mag", "Giu", "Lug", "Ago", "Set", "Ott", "Nov", "Dic")

ggplot(data = dati, aes(x = factor(month), y = sales, fill = factor(year))) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(x = "Mese",
       y = "Totale vendite",
       fill = "Anno",
       title = "Confronto totale delle vendite per mese, anno e città") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_x_discrete(labels = nomi_mesi) +
  facet_wrap(~ city)


# Grafico a barre sovrapposte per il totale normalizzato delle vendite per mese e città
dati_norm <- merge(dati, max_sales, by = c("year", "city"))

# Vendite normalizzate in diversi modi
# metodo z-score:
mean_sales <- mean(dati$sales)
sd_sales <- sd(dati$sales)
dati_norm$norm_sales <- (dati$sales - mean_sales) / sd_sales

#metodo max-min scaler
min_sales <- min(dati$sales)
max_sales <- max(dati$sales)
dati_norm$norm_sales <- (dati$sales - min_sales) / (max_sales - min_sales)

ggplot(data = dati, aes(x = factor(month), y = dati_norm$norm_sales, fill = factor(year))) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(x = "Mese",
       y = "Totale vendite normalizzate",
       fill = "Anno",
       title = "Confronto normalizzato delle vendite per mese e città") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_x_discrete(labels = nomi_mesi) +
  facet_wrap(~ city) 

#line chart di una variabile a tua scelta per fare confronti commentati fra città e periodi storici

dati$anno_mese <- as.Date(paste(dati$anno_mese, "01", sep = "-"))
ggplot(data = dati, aes(x = anno_mese, y = sales, color = city)) +
  geom_line(size = 1) +  
  labs(x = "Mese - Anno",
       y = "Totale vendite",
       color = "Città",
       title = "Confronto totale delle vendite per mese e città") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position = "bottom") +
  scale_x_date(date_labels = "%b %Y", date_breaks = "1 month") 



