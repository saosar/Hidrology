# Solución Ejercicio Propuesto Master Hidrología

# 1. CARGA DEL FICHERO DE DATOS
setwd("C:/Users/sarao/Desktop/UAH/202425/1HidrologiaSuperficial/T1Estadistica/Estadística_Anexo I/")
TotalDat <- read.csv("./DatosCaudalesBesos.csv")

# 2. Inspección de los datos
str(TotalDat)     # Estructura de los datos
head(TotalDat)    # Ver las primeras filas
names(TotalDat)   # Ver los nombres de las variables

# 3. Modificación de los tipos de datos y creación nuevas variables
TotalDat$Estacio <- as.factor(TotalDat$Estacio)  # Convertir 'Estacio' a factor
unique(TotalDat$Estacio)  # Ver los valores únicos de la variable 'Estacio'

# 3.1 Renombrar con nombres cortos las estaciones de aforo y medida
# Nombres actuales
levels(TotalDat$Estacio)

# Definir los nuevos nombres cortos
nuevos_nombres <- c("Llica_de_Vall", 
                    "Santa_Perpetua", 
                    "Montornes", 
                    "Aiguafreda", 
                    "La_Garriga", 
                    "Montcada_Reixac", 
                    "Santa_Coloma", 
                    "Castellar")

# Asignar los nuevos nombres a los niveles del factor 'Estacio'
levels(TotalDat$Estacio) <- nuevos_nombres
head(TotalDat)

############################
# 3.2 Asegurarse de que la columna 'Dia' esté en formato de fecha
TotalDat$Fecha <- as.Date(TotalDat$Dia, format = "%m/%d/%Y")

# Extraer el año correctamente ahora que la columna 'Fecha' está en el formato correcto
TotalDat$year <- format(TotalDat$Fecha, "%Y")

# Verificar si se creó la columna 'year'
head(TotalDat)

#######################################
# Verificar los nuevos nombres de las estaciones
unique(TotalDat$Estacio)
str(TotalDat)
length(unique(TotalDat$Estacio))  # Ver cuántas estaciones únicas hay

# 3.3 Creación de nuevas variables (mes, año)
TotalDat$Mes <- as.numeric(format(TotalDat$Fecha, "%m"))  # Extraer el mes
TotalDat$Year <- as.numeric(format(TotalDat$Fecha, "%Y")) # Extraer el año

# 3.4 Mostrar las primeras filas para revisar las nuevas variables
head(TotalDat)

# 4. Cuántos datos tiene cada estación
table(TotalDat$Estacio)

#######################################
# 5 Detección y eliminación de datos duplicados
DF_Monitor <- TotalDat[TotalDat$Estacio == "Montornes", ]

# Ordenar el dataframe por la columna 'Fecha'
DF_Monitor <- DF_Monitor[order(DF_Monitor$Fecha), ]
head(DF_Monitor)

# Para eliminar las filas duplicadas
TotalDat <- unique(TotalDat)

# Ver la tabla de frecuencia para la variable 'Estacio'
table(TotalDat$Estacio)

# 5. Distribución del número de datos por estaciones y años
tabla_contingencia <- table(TotalDat$Estacio, TotalDat$year)

# Crear el gráfico de barras
barplot(tabla_contingencia, beside = TRUE,
        col = rainbow(nrow(tabla_contingencia)),
        main = "Número de datos para cada estación")

# Añadir la leyenda al gráfico
legend("topleft", legend = rownames(tabla_contingencia), 
       fill = rainbow(nrow(tabla_contingencia)), 
       title = "Estaciones", ncol = 1, cex = 0.5)

#########################################
# 5. Análisis estadístico de los caudales
mean(TotalDat$Valor, na.rm = TRUE)      # Media del caudal
median(TotalDat$Valor, na.rm = TRUE)    # Mediana del caudal
min(TotalDat$Valor, na.rm = TRUE)       # Mínimo valor del caudal
max(TotalDat$Valor, na.rm = TRUE)       # Máximo valor del caudal
quantile(TotalDat$Valor, 0.25, na.rm = TRUE)  # Primer cuartil (Q1)
quantile(TotalDat$Valor, 0.75, na.rm = TRUE)  # Tercer cuartil (Q3)
sd(TotalDat$Valor, na.rm = TRUE)        # Desviación estándar del caudal

# 6. Análisis descriptivo para cada grupo (por estación)
aggregate(Valor ~ Estacio, data = TotalDat, FUN = mean)   # Valor medio
aggregate(Valor ~ Estacio, data = TotalDat, FUN = median) # Valor mediano
aggregate(Valor ~ Estacio, data = TotalDat, FUN = max)    # Mayor caudal
aggregate(Valor ~ Estacio, data = TotalDat, FUN = min)    # Menor caudal
aggregate(Valor ~ Estacio, data = TotalDat, FUN = function(x) quantile(x, probs = 0.75))  # Tercer cuartil
aggregate(Valor ~ Estacio, data = TotalDat, FUN = function(x) quantile(x, probs = 0.95))  # Percentil 95
aggregate(Valor ~ Estacio, data = TotalDat, FUN = function(x) quantile(x, probs = 0.25))  # Primer cuartil

#########################
# Calcular el caudal mediano por estación y año
DF_Q_medianoAnual <- aggregate(Valor ~ Estacio + Year, data = TotalDat, FUN = median)

# Calcular el caudal medio por estación y año
DF_Q_mediaAnual <- aggregate(Valor ~ Estacio + Year, data = TotalDat, FUN = mean)

# Graficar los resultados usando ggplot2
library(ggplot2)
ggplot(DF_Q_mediaAnual, aes(x = factor(Year), y = Valor, fill = Estacio)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Caudal Promedio de Valor por Estación y Año",
       x = "Año", y = "Caudal Medio", fill = "Estación") +
  theme_minimal()

#################
# VARIABILIDAD
# Calcular la desviación estándar (variabilidad) de los datos por estación
aggregate(Valor ~ Estacio, data = TotalDat, FUN = sd)

# Graficar mediante un boxplot la distribución de los caudales para cada estación
par(cex.axis = 0.6)  # Reducir el tamaño de las etiquetas del eje
boxplot(Valor ~ Estacio, data = TotalDat, col = "lightblue", las = 2,
        main = "Distribución de los caudales para cada Estación",
        xlab = "", ylab = "Caudal (m³/s)")

# Graficar otro boxplot sin outliers
boxplot(Valor ~ Estacio, data = TotalDat, col = "lightblue", las = 2,
        main = "Distribución de los caudales para cada Estación (sin outliers)",
        xlab = "", ylab = "Caudal (m³/s)", outline = FALSE)

# Calcular el coeficiente de variación (CV) para cada estación
# Definiendo una función para calcular el CV
funcCV <- function(x) {
  return(sd(x) / mean(x))
}

# Aplicar la función CV a cada estación
cv <- aggregate(Valor ~ Estacio, data = TotalDat, FUN = funcCV)

# Graficar el coeficiente de variación mediante un gráfico de barras
barplot(cv$Valor, names.arg = cv$Estacio, col = "lightblue",
        ylim = c(0, max(cv$Valor) * 1.2), 
        main = "Coeficiente de Variación Total", 
        xlab = "", ylab = "CV", las = 2)

############################################
# NUEVA SECCIÓN - Análisis gráfico y estadístico adicional

# Boxplot de los valores de caudal
boxplot(DF_st$Valor, col = "cyan", xlab = "Nombre Estación", ylab = "Caudal", outline = TRUE)

# Añadir una línea horizontal en el valor medio
media <- mean(DF_st$Valor, na.rm = TRUE)
abline(h = media, col = "red", lty = 2)

# Histograma de la distribución estadística de los datos
par(mfrow = c(1, 2))  # Dividir la ventana gráfica en dos para mostrar dos gráficos juntos
hist(DF_st$Valor, breaks = 200)  # Histograma de los valores de caudal

# Filtrar valores menores de 5 y que no sean NA
st1_nout <- DF_st$Valor[DF_st$Valor < 5 & !is.na(DF_st$Valor)]

# Crear un nuevo histograma con los valores filtrados
hist(st1_nout, prob = TRUE)
lines(density(st1_nout), type = "l", lwd = 3, col = "red")

###############
# 4.3 Análisis de los caudales de una estación de aforo concreta

# Ver los nombres únicos de las estaciones
unique(TotalDat$Estacio)

# Seleccionar una estación en particular
nombreST <- "Llica_de_Vall"  # Puedes cambiar el nombre de la estación por cualquier otra

# Filtrar los datos para la estación seleccionada
DF_st <- subset(TotalDat, Estacio == nombreST)

# Calcular el valor mínimo y máximo del caudal en la estación seleccionada
min(DF_st$Valor)
max(DF_st$Valor)

# Ver la tabla de frecuencia de los caudales para la estación seleccionada
table(DF_st$Valor)

# Graficar un boxplot para los valores de caudal de la estación seleccionada
par(mfrow = c(1, 2))  # Dividir la ventana gráfica en dos
boxplot(DF_st$Valor, col = "cyan", xlab = nombreST, ylab = "Caudal", outline = TRUE)
boxplot(DF_st$Valor, col = "cyan", xlab = nombreST, ylab = "Caudal", outline = FALSE)  # Sin outliers


############################################
# 5. Evolución temporal de los caudales

# Ver los nombres únicos de las estaciones
unique(TotalDat$Estacio)

# Seleccionar una estación específica
nombreST <- "Castellar"  # Puedes cambiar el nombre de la estación según tus datos

# Filtrar los datos para la estación seleccionada
DF_St <- subset(TotalDat, Estacio == nombreST)

# Graficar la serie temporal de los valores de caudal
plot(DF_St$Valor, type = "l", xlab = "Observaciones", ylab = "Caudal (m³/s)", 
     main = paste("Evolución temporal de los caudales - Estación:", nombreST))

# Ordenar los datos de acuerdo a la fecha y volver a graficar
DF_St <- DF_St[order(DF_St$Fecha), ]
plot(DF_St$Valor, type = "l", xlab = "Días", ylab = "Caudal (m³/s)", 
     main = paste("Evolución temporal de los caudales ordenados - Estación:", nombreST))

# Calcular el cuantil 99% (Q99) para visualizar los valores más altos
q99 <- quantile(DF_St$Valor, 0.99, na.rm = TRUE)

# Añadir una línea para el cuantil 99% en la gráfica
abline(h = q99, col = "red", lty = 2)

# Agregar una leyenda para identificar la línea roja del cuantil 99%
legend("topright", legend = paste("Q99 =", round(q99, 2)), col = "red", lty = 2)


############################################!!!!!!!!!!!!!!! CURVA CAUDAL
# CURVA DE DURACIÓN DE CAUDAL Y PERIODO DE RETORNO

# 1. Ordenar los datos de caudal en orden descendente
# Esto es importante para que los valores más altos aparezcan primero.
sorted_caudal <- sort(DF_st$Valor, decreasing = TRUE)

# 2. Calcular la probabilidad de excedencia para cada valor de caudal
# La probabilidad de excedencia es la probabilidad de que un valor de caudal 
# específico sea igualado o superado en cualquier punto en el tiempo.
n <- length(sorted_caudal)  # El número total de observaciones
probabilidad_excedencia <- (1:n) / n  # Probabilidad de excedencia

# 3. Graficar la curva de duración de caudal
plot(sorted_caudal, probabilidad_excedencia, type = "s", 
     xlab = "Caudal", ylab = "Probabilidad de Excedencia", 
     main = "Curva de Duración de Caudal")

# Nota: El argumento `type = "s"` en `plot()` es importante porque asegura que 
# la curva de duración de caudal tenga un aspecto escalonado, lo cual es habitual 
# en este tipo de gráficas.

############################################
# Cálculo del periodo de retorno para un caudal objetivo

# 4. Definir un caudal objetivo para calcular el periodo de retorno
caudal_objetivo <- 14  # Definir el caudal objetivo en m³/s

# Usar la función ecdf() para crear una función de distribución empírica
funcion_ecdf <- ecdf(sorted_caudal)

# Calcular la probabilidad de que el caudal supere el valor del caudal objetivo
probabilidad_superar <- 1 - funcion_ecdf(caudal_objetivo)

# Calcular el periodo de retorno
periodo_retorno <- 1 / probabilidad_superar

# Imprimir el resultado
cat("El periodo de retorno para un caudal superior a", caudal_objetivo, 
    "m³/s es aproximadamente:", periodo_retorno, "días\n")

############################################
# NUEVA SECCIÓN - Análisis de caudales para una estación específica

# Ver los nombres únicos de las estaciones
unique(TotalDat$Estacio)

# Seleccionar una estación específica
nombreST <- "Llica_de_Vall"  # Puedes cambiar el nombre de la estación a la que desees analizar

# Filtrar los datos para la estación seleccionada
DF_st <- subset(TotalDat, Estacio == nombreST)

# Verificar si el objeto se creó correctamente
head(DF_st)

# Boxplot de los valores de caudal
boxplot(DF_st$Valor, col = "cyan", xlab = nombreST, ylab = "Caudal", outline = TRUE)

# Añadir una línea horizontal en el valor medio
media <- mean(DF_st$Valor, na.rm = TRUE)
abline(h = media, col = "red", lty = 2)


