# Setup
- `pg_lsclusters` lists all clusters on machine
- systemd service likely installed on Linux: `sudo systemctl status postgresql`
- To login as postgres role: `sudo -u postgres psql`

# Environment
Commands like `psql` and `pg_ctl` will pick up these env vars:
- PGDATA: database location
- PGHOST: hostname (localhost or 127.0.0.1 for same machine)
- PGPORT: port number
- PGUSER: postgres user

# Roles
- psql: `\du` list roles
## Reset password
- SQL: `ALTER USER postgres WITH PASSWORD 'new_password'`

# psql
- Uses env vars when present: PGDATABASE, PGHOST, PGPORT and/or PGUSER
- Do not read the start-up file: `-X` or `--no-psqlrc`
- Set unaligned mode with `--no-align` or `\a`
- list databases `psql --list` or `\l`
- connect to db `psql --dbname=<name>` or `\c DBNAME`
- list schemas `\dn`
- list roles `\du`

# Date and time
https://www.postgresql.org/docs/current/datatype-datetime.html
- `TIMESTAMP WITH TIME ZONE` (SQL standard) is equivalent to `TIMESTAMPZ` (postgres alias)

## Current timestamp
- `CURRENT_TIMESTAMP` is a function that is from the SQL standard and doesn't have trailing parens
- `now()` is equivalent, but don't confuse function with `now` which is a constant
- Common pattern: `created TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP`
