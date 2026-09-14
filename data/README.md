# Dataset Setup

This project was developed using the SQL Murder Mystery dataset imported into **MySQL Workbench**.

The local import file used for the project was:

```text
sql-murder-mystery-mysql.sql
```

After importing the database, the SQL scripts in `../queries/` assume the database name is:

```sql
sql_murder_mystery
```

If your database has a different name, update the first line of each query file:

```sql
USE sql_murder_mystery;
```

## Tables Used

- `crime_scene_report`
- `drivers_license`
- `facebook_event_checkin`
- `get_fit_now_check_in`
- `get_fit_now_member`
- `income`
- `interview`
- `person`
- `solution`

The repository focuses on the SQL analysis and investigation scripts rather than duplicating the full database dump.