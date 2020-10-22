CREATE USER IF NOT EXISTS 'replicant'@'%' IDENTIFIED BY 'password';

GRANT replication slave ON *.* TO replicant;

FLUSH privileges;