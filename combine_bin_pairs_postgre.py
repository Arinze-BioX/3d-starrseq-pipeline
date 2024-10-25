#!/datacommons/ydiaolab/arinze/apps/miniconda_20220118/envs/ml_python/bin/python
import time
import psycopg2
import csv
import argparse

# Define the argument parser
parser = argparse.ArgumentParser(description=
"""Combine R1 and R2 fragments from 3D-STARRseq experiment bedpe 
(mapping to bins) into a single bin-pair. Arguments are --frag1 /path/to/bedpe/file1
--frag2 /path/to/bedpe/file2 --output /path/to/output/file , 
--database your_inner_db_name, --db_username your_chosen_database_username, 
--db_password your_chosen_database_password
The input files should have a common column which is the name of the mapped reads as the 4th column.""")

# Declare arguments
parser.add_argument('--frag1', action="store", dest='path1', default="")
parser.add_argument('--frag2', action="store", dest='path2', default="")
parser.add_argument('--output', action="store", dest='output_file', default="")
parser.add_argument('--database', action="store", dest='db_name', 
                    default="your_inner_db_name")
parser.add_argument('--db_username', action="store", dest='user', 
                    default="your_chosen_database_username")
parser.add_argument('--db_password', action="store", dest='password', 
                    default="your_chosen_database_password")

# Now, parsing the command line arguments and store the 
# values in the `args` variable
args = parser.parse_args()

path1=args.path1
path2=args.path2

#remove existing tables
def remove_table(table_name, db_name, user, password):
  try:
    with psycopg2.connect(
            database=db_name,
            user=user,
            password=password,
            host="localhost",
            port="5432"
        ) as conn:

        with conn.cursor() as cur:
            cur.execute(f"DROP TABLE {table_name};")
        conn.commit()
  except:
    print("Did not remove table before starting, probably because table did not exist")

#load input files to already created database
def load_data_to_postgres(tsv_file, table_name, db_name, user, password, host, port, column_names):
    """
    Loads data from a TSV file to a PostgreSQL table using the COPY command.

    Args:
        tsv_file (str): Path to the TSV file.
        table_name (str): Name of the PostgreSQL table.
        db_name (str): Name of the PostgreSQL database.
        user (str): PostgreSQL username.
        password (str): PostgreSQL password.
        host (str): PostgreSQL host.
        port (str): PostgreSQL port.
        column_names (str): names of columns for table.
    """

    with psycopg2.connect(
        database=db_name,
        user=user,
        password=password,
        host=host,
        port=port
    ) as conn:
        # Create empty tables
        with conn.cursor() as cur:
            column_defs = ', '.join(f"{col} TEXT" for col in column_names)
            cur.execute(f"CREATE TABLE {table_name} ({column_defs})")
            #cur.execute(f"CREATE TABLE {table2_name} ();")

        # Load data from TSV files to tables
        with conn.cursor() as cur:
            with open(tsv_file, 'r') as f:
                cur.copy_from(f, table_name, sep='\t')
        conn.commit()

#set names of columns for tables
table_names = ["Frag_chrom", "frag_start", "frag_end", "name", "count",
                "score","bin_chrom","bin_start","bin_end","overlap"]

#load tables to database
remove_table('frag1_table', args.db_name, 
                      args.user, args.password)
load_data_to_postgres(path1, 'frag1_table', args.db_name, 
                      args.user, args.password, 
                      "localhost", "5432",table_names)

remove_table('frag2_table', args.db_name, 
                      args.user, args.password)
load_data_to_postgres(path2, 'frag2_table', args.db_name, 
                      args.user, args.password, 
                      "localhost", "5432",table_names)

#Do the cross join combination of fragments
def cross_join_tables(db_name, user, password, host, port, table1, table2, needed_columns, new_table, output_file):
  """
  Creates a new table by cross joining two tables with a temporary table filtering by name.

  Args:
    table_name (str): Name of the PostgreSQL table.
    db_name (str): Name of the PostgreSQL database.
    user (str): PostgreSQL username.
    password (str): PostgreSQL password.
    host (str): PostgreSQL host.
    port (str): PostgreSQL port.
    table1: Name of the first table.
    table2: Name of the second table.
    needed_columns: list of column names to perfrom the cross join on.
    new_table: Name of the new table to be created.
  """  

  with psycopg2.connect(
        database=db_name,
        user=user,
        password=password,
        host=host,
        port=port
    ) as conn:
    with conn.cursor() as cur:
      # Create indexes on 'name' columns
      cur.execute(f"CREATE INDEX idx_{table1}_name ON {table1} (name)")
      cur.execute(f"CREATE INDEX idx_{table2}_name ON {table2} (name)")

      # Create new table with cross join and specified columns
      column1_str = ', '.join(f"t1.{col} as {col}_t1" for col in needed_columns)
      column2_str = ', '.join(f"t2.{col} as {col}_t2" for col in needed_columns)
      cur.execute(f"""
          CREATE TABLE {new_table} AS
          SELECT {column1_str}, {column2_str}
          FROM {table1} t1
          CROSS JOIN {table2} t2
          WHERE t1.name = t2.name;
      """)

      cur.execute(f"SELECT * FROM {new_table}")
      rows = cur.fetchall()
      with open(output_file, 'w', newline='') as csvfile:
          writer = csv.writer(csvfile, delimiter='\t')
          writer.writerows(rows)

  conn.commit()
  conn.close()

# Example usage:
needed_columns = table_names
#["name","score","bin_chrom","bin_start","bin_end","overlap"]
#cross_join_tables(db_name, user, password, host, port, table1, table2, needed_columns, new_table)

remove_table('combined_bin_pair', args.db_name, 
                      args.user, args.password)
start = time.time()
cross_join_tables(args.db_name, args.user, args.password, 
                "localhost", "5432", "frag1_table", 
                "frag2_table", needed_columns, "combined_bin_pair", args.output_file)
end = time.time()
print(f"It took {end - start} seconds to perform the cross join")


#remove created database tables
remove_table('frag1_table', args.db_name, 
                      args.user, args.password)
remove_table('frag2_table', args.db_name, 
                      args.user, args.password)
remove_table('combined_bin_pair', args.db_name, 
                      args.user, args.password)