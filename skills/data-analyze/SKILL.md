---
name: data-analyze
description: Analyze a data file and generate statistical insights and visualizations. (Skill importada do OpenJarvis; parâmetros: data_path.)
---

# data-analyze

Analyze a data file and generate statistical insights and visualizations.

## Parâmetros
- `data_path`: extraia do pedido do usuário; se faltar, pergunte.

## Passos (ordem original do OpenJarvis; adapte com bom senso)
1. leia o arquivo {data_path} com Read → guarde o resultado como `raw_data`.
2. raciocine (sem ferramentas): Parse the raw data and compute summary statistics: row count, column names, data types, min/max/mean for numeric columns, and missing value counts: {raw_data} → guarde o resultado como `data_stats`.
3. raciocine (sem ferramentas): Analyze the data statistics and identify patterns, trends, outliers, and correlations. Data overview: {data_stats}. Raw sample: {raw_data} → guarde o resultado como `analysis`.
4. raciocine (sem ferramentas): Generate a data analysis report with sections: Dataset Overview, Key Statistics, Patterns and Trends, Outliers, and Recommendations: {analysis} → guarde o resultado como `report`.

Entregue o resultado final de forma concisa. Só persista na memória fatos duráveis; nunca segredos.
