CREATE USER 'exporter'@'%' IDENTIFIED BY 'password' WITH MAX_USER_CONNECTIONS 3;
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'%';

CREATE USER 'grafana'@'%' IDENTIFIED BY 'grafana';
GRANT SELECT ON TP1_AT.* TO 'grafana'@'%';
GRANT SELECT ON sylius_address.* TO 'grafana'@'%';
GRANT SELECT ON mysql.* TO 'grafana'@'%';