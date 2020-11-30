# TP7 - Cluster Galera

## Mise en place du docker-compose

Configuration du docker-compose pour le serveur qui lancera le cluster Galera :

```docker
maria1:
    container_name: clusterMaster
    image: mariadb:10.4
    restart: on-failure
    environment:
        MYSQL_ROOT_PASSWORD: password
    volumes:
        - ./shared/master:/var/lib/mysql
        - ./config/master.cnf:/etc/mysql/conf.d/galera.cnf
        - ./scripts/db.sql:/entrypoint.d/
    networks:
        ClusterNetwork:
            aliases:
                - master.localhost
    command: --wsrep-new-cluster
    ports:
        - 3306
        - 4444
        - 4567
        - 4568
```

Configuration du docker-compose pour les deux autres serveurs du cluster :

```docker
maria2:
    container_name: clusterSlave1
    image: mariadb:10.4
    restart: on-failure
    environment:
        MYSQL_ROOT_PASSWORD: password
    volumes:
        - ./shared/slave1:/var/lib/mysql
        - ./config/slave1.cnf:/etc/mysql/conf.d/galera.cnf
    networks:
        ClusterNetwork:
            aliases:
                - slave1.localhost
    ports:
        - 3306
        - 4444
        - 4567
        - 4568
```

## Les fichiers de conf :

Fichier de conf "classique" que l'on importe dans chacune des machines (il faut seulement adapter)

```conf
[mysqld]
wsrep_node_address="master.localhost"
wsrep_node_name="node1"
wsrep_cluster_address="gcomm://master.localhost,slave1.localhost,slave2.localhost"

wsrep_provider=/usr/lib/libgalera_smm.so
binlog_format=ROW
default_storage_engine=InnoDB
innodb_autoinc_lock_mode=2
innodb_doublewrite=1
query_cache_size=0
wsrep_on=ON
```