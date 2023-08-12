INSERT INTO pgadmin.server (user_id, servergroup_id, name, host, port, maintenance_db, username, connection_params)
  SELECT 1, 1, 'cicdlab-dbserver', 'cicdlab-dbserver', 5432, 'postgres', 'postgres', '{"sslmode": "prefer", "connect_timeout": 10, "sslcert": "<STORAGE_DIR>/.postgresql/postgresql.crt", "sslkey": "<STORAGE_DIR>/.postgresql/postgresql.key"}'
  WHERE NOT EXISTS (
    SELECT 1
    FROM pgadmin.server
    WHERE user_id=1 AND servergroup_id=1 AND name='cicdlab-dbserver' AND host='cicdlab-dbserver'
  );