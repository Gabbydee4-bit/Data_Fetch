import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

users = pd.read_csv("\Users\adeku\Desktop\Fetch\USER_TAKEHOME.csv")
transactions = pd.read_csv("\Users\adeku\Desktop\Fetch\TRANSACTION_TAKEHOME.csv")
products = pd.read_csv("\Users\adeku\Desktop\Fetch\PRODUCTS_TAKEHOME.csv")


print(users.info())
print(transactions.info())
print(products.info())


print(users.isnull().sum())
print(transactions.isnull().sum())
print(products.isnull().sum())


print(f"Duplicate users: {users.duplicated().sum()}")
print(f"Duplicate transactions: {transactions.duplicated().sum()}")
print(f"Duplicate products: {products.duplicated().sum()}")


print(users.head())
print(transactions.head())
print(products.head())


plt.figure(figsize=(10,6))
sns.heatmap(users.isnull(), cmap='viridis', cbar=False, yticklabels=False)
plt.title('Missing Values in Users Data')
plt.show()

