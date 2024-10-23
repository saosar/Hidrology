import pandas as pd
import plotly.express as px

# 1. CARGA DEL FICHERO DE DATOS
file_path = "./DatosCaudalesBesos.csv"  # Cambia esto por la ruta de tu archivo si es diferente
TotalDat = pd.read_csv(file_path, encoding='latin1')

# 2. Modificación de los tipos de datos y creación de nuevas variables
TotalDat['Estacio'] = TotalDat['Estacio'].astype('category')  # Convertir 'Estacio' a categoría

# Renombrar con nombres cortos las estaciones
nuevos_nombres = {
    'Aforament - Castellar del Vallès': "Castellar",
    'Aforament - Aiguafreda (riu)': "Aiguafreda",
    'Aforament - Montornès del Vallès (el Mogent)': "Montornes",
    'Aforament - Santa Perpètua de Mogoda': "Santa_Perpetua",
    'Aforament - Santa Coloma de Gramenet (riu)': "Santa_Coloma",
    'Aforament - Lliçà de Vall': "Llica_de_Vall",
    'Aforament - Montcada i Reixac (el Ripoll)': "Montcada_Reixac",
    'Aforament - la Garriga': "La_Garriga"
}
TotalDat['Estacio'] = TotalDat['Estacio'].replace(nuevos_nombres)

# Asegurarse de que la columna 'Dia' esté en formato de fecha
TotalDat['Fecha'] = pd.to_datetime(TotalDat['Dia'], format="%m/%d/%Y")

# Extraer el año correctamente
TotalDat['Year'] = TotalDat['Fecha'].dt.year

# Cambiar el orden de las estaciones (personalizado)
estaciones_orden = ['Castellar', 'Santa_Coloma', 'Montornes', 'Santa_Perpetua', 'Montcada_Reixac', 'Llica_de_Vall', 'Aiguafreda', 'La_Garriga']
TotalDat['Estacio'] = pd.Categorical(TotalDat['Estacio'], categories=estaciones_orden, ordered=True)

# 6. Contar el número de datos por estación y por año
tabla_contingencia = TotalDat.groupby(['Estacio', 'Year']).size().reset_index(name='Count')

# Crear el gráfico interactivo con Plotly
fig = px.bar(tabla_contingencia, x='Year', y='Count', color='Estacio', 
             title="Número de datos para cada estación por año", 
             labels={"Count": "Número de Datos", "Year": "Año", "Estacio": "Estación"},
             barmode='group',  # Puedes usar 'stack' para barras apiladas o 'group' para barras agrupadas
             text='Count', hover_name="Estacio")

# Personalizar el diseño del gráfico
fig.update_layout(
    xaxis_title="Año",
    yaxis_title="Número de Datos",
    legend_title="Estaciones",
    bargap=0.2,
    hovermode="x unified"
)

# Mostrar el gráfico interactivo
fig.show()
