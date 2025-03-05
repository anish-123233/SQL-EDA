import os
import pandas as pd
from sqlalchemy import create_engine

# PostgreSQL connection setup
engine = create_engine('postgresql://postgres:sql@localhost:5432/music')

# Directory containing CSV files
directory_path = r'C:\Anish\music store data'

# Loop through each CSV file in the directory
for filename in os.listdir(directory_path):
    if filename.endswith(".csv"):  # Check for CSV files
        file_path = os.path.join(directory_path, filename)

        # Read the CSV file into a DataFrame
        df = pd.read_csv(file_path)

        # Generate a table name based on the file name (remove file extension)
        table_name = os.path.splitext(filename)[0]

        # Write the DataFrame to PostgreSQL
        df.to_sql(table_name, engine, if_exists='replace', index=False)
        print(f"Imported {table_name} from {filename} into PostgreSQL")

# Close the connection to PostgreSQL
engine.dispose()
