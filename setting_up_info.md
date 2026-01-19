## Sources

Both marketing data and bulk files are already generated and ready to use.

Marketing data:

`dataSourcesGenerator\python_scripts\generating_data\marketing_data.csv`

Bulk files:

`dataSourcesGenerator\python_scripts\generating_data\generating_bulk_files\data`

You need to create soruce database, for consistency you can call it same as me - `database_travel_agency`. Then you need to populate it with bulk files.

To create database use:

`dataSourcesGenerator\BULK_loading\creating_database.sql`

To populate database use:

`dataSourcesGenerator\BULK_loading\load_database.sql`

**NOTE**: You need to change path to bulk files in `load_database.sql` file to your local path. I don't know if it works with relative path

## Warehouse

You need to create data warehouse, for consistency you can call it same as me - `warehouse_travel_agency`.

To create data warehouse use:

`ETL\task\sql_queries\warehouse_make_delete\create_statements.sql`

Then you need to populate it with ETL process. To do that:

1. Load const dimensions:
  
- `ETL\task\sql_queries\loading_tables\const\load_date.sql`

- `ETL\task\sql_queries\loading_tables\const\load_junk.sql`

2. Load other dimensions:

- `ETL\task\sql_queries\loading_tables\dim\load_clients.sql`

- `ETL\task\sql_queries\loading_tables\dim\load_marketing_data.sql`

NOTE: Again, you need to change path to `marketing_data.csv` file in `load_marketing_data.sql` file to your local path.

- `ETL\task\sql_queries\loading_tables\dim\load_trips.sql` 

3. Load fact table:

- `ETL\task\sql_queries\loading_tables\fact\load_rezerwacja_fact_corrected.sql`

- `ETL\task\sql_queries\loading_tables\fact\load_kampania_fact.sql`

