import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# 1. Cargar el archivo CSV y ver las primeras filas
file_path = 'DatosCaudalesBesos.csv'
df = pd.read_csv(file_path, encoding='latin1')

# Mostrar las primeras filas para revisar los datos
print(df.head())

# 2. Convertir la columna 'Dia' en formato de fecha
df['Fecha'] = pd.to_datetime(df['Dia'], format='%m/%d/%Y')

# Convertir 'Estacio' a un tipo categórico (equivalente a factor en R)
df['Estacio'] = df['Estacio'].astype('category')
print("Estaciones únicas:", df['Estacio'].unique())

# 3. Análisis estadístico básico
# Cálculo de estadísticas descriptivas de los caudales
mean_valor = df['Valor'].mean()
median_valor = df['Valor'].median()
min_valor = df['Valor'].min()
max_valor = df['Valor'].max()
q1_valor = df['Valor'].quantile(0.25)
q3_valor = df['Valor'].quantile(0.75)
std_valor = df['Valor'].std()

# Imprimir los resultados de estadísticas descriptivas
print(f"Media: {mean_valor}")
print(f"Mediana: {median_valor}")
print(f"Mínimo: {min_valor}")
print(f"Máximo: {max_valor}")
print(f"Cuartil 1 (Q1): {q1_valor}")
print(f"Cuartil 3 (Q3): {q3_valor}")
print(f"Desviación Estándar: {std_valor}")

# 4. Análisis por estación
# Agrupar por estación y calcular estadísticas
df_grouped = df.groupby('Estacio')['Valor'].agg(['mean', 'median', 'max', 'min', 'std'])
print("\nEstadísticas por Estación:")
print(df_grouped)

# 5. Visualización - Boxplot de caudales por estación
plt.figure(figsize=(10, 6))
df.boxplot(column='Valor', by='Estacio', grid=False)
plt.title('Distribución de Caudales por Estación')
plt.suptitle('')  # Eliminar el título extra generado automáticamente
plt.xlabel('Estación')
plt.ylabel('Caudal (m³/s)')
plt.show()

# 6. Curva de duración de caudal
# Ordenar los datos de caudal de mayor a menor
df_sorted = df.sort_values(by='Valor', ascending=False).reset_index(drop=True)

# Calcular la probabilidad de excedencia
df_sorted['Excedencia'] = (df_sorted.index + 1) / len(df_sorted)

# Graficar la curva de duración de caudal
plt.plot(df_sorted['Valor'], df_sorted['Excedencia'], drawstyle='steps-post')
plt.xlabel('Caudal (m³/s)')
plt.ylabel('Probabilidad de Excedencia')
plt.title('Curva de Duración de Caudal')
plt.grid(True)
plt.show()

# 7. Cálculo del periodo de retorno para un caudal objetivo
caudal_objetivo = 14  # Definir el caudal objetivo en m³/s

# Crear una función de distribución empírica usando los datos ordenados
funcion_ecdf = np.sort(df_sorted['Valor'])

# Calcular la probabilidad de que el caudal supere el valor objetivo
probabilidad_superar = np.sum(funcion_ecdf > caudal_objetivo) / len(funcion_ecdf)

# Calcular el periodo de retorno
periodo_retorno = 1 / probabilidad_superar

# Imprimir el periodo de retorno
print(f"El periodo de retorno para un caudal superior a {caudal_objetivo} m³/s es aproximadamente: {periodo_retorno} días")
