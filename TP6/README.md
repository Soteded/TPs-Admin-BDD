# MariaDB - Réplication de données

## Docker-compose.yml qui lance deux instances MariaDB

Exemple d'un fichier docker-compose de base pour lancer deux instances MariaDB :

```docker
version:  '3.7'

services:
    mariaMaster:
        image: mariadb:10.4
        restart: on-failure
        environment:
            MYSQL_ROOT_PASSWORD: password

    mariaSlave:
        image: mariadb:10.4
        restart: on-failure
        environment:
            MYSQL_ROOT_PASSWORD: password
```

## Ajout des fichiers .cnf pour les serveurs Master et Slave

Fichier docker-compose qui permet d'ajouter les fichiers de configuration aux instances sus-créées :

```docker
version:  '3.7'

services:
    mariaMaster:
        image: mariadb:10.4
        restart: on-failure
        environment:
            MYSQL_ROOT_PASSWORD: password
        volumes:
            - ./config/master.cnf:/etc/mysql/mariadb.conf.d/master.cnf

    mariaSlave:
        image: mariadb:10.4
        restart: on-failure
        environment:
            MYSQL_ROOT_PASSWORD: password
        volumes:
            - ./config/slave.cnf:/etc/mysql/mariadb.conf.d/slave.cnf
```

Fichier de configuration de la machine "master" :
```conf
[mariadb]
log-bin
server_id=1
log-basename=master1
binlog-format=mixed
```

Fichier de configuration de la machine "slave" :
```conf
[mariadb]
server_id=2
```

> /!\ Il faut bien veiller à ce que les fichiers de configuration soit en lecture seule, sinon MariaDB ne les considèrera pas.

## Scripts

Mise à jour du docker-compose pour ajouter les scripts nécessaire à la mise en place de l'utilisateur de réplication sur le container `master` et du script de connexion sur le container `slave`. De plus, j'ai mis en place la configuration réseau commune aux containers pour qu'ils puissent communiquer entre eux.

```docker
version:  '3.7'

services:
    mariaMaster:
        image: mariadb:10.4
        restart: on-failure
        environment:
            MYSQL_ROOT_PASSWORD: password
        networks:
            MSNetwork:
                aliases:
                    - master.rep
        volumes:
            - ./config/master.cnf:/etc/mysql/mariadb.conf.d/master.cnf
            - ./scripts/master.sql:/docker-entrypoint-initdb.d/master.sql
        ports:
            - 3306

    mariaSlave:
        image: mariadb:10.4
        restart: on-failure
        environment:
            MYSQL_ROOT_PASSWORD: password
        networks:
            MSNetwork:
                aliases:
                    - slave.rep
        volumes:
            - ./config/slave.cnf:/etc/mysql/mariadb.conf.d/slave.cnf
            - ./scripts/slave.sql:/docker-entrypoint-initdb.d/slave.sql
networks:
    MSNetwork:
```

Script lancé sur le container `master.rep` :
```sql
CREATE USER IF NOT EXISTS 'replicant'@'%' IDENTIFIED BY 'password';

GRANT replication slave ON *.* TO replicant;

FLUSH privileges;
```

Script lancé sur le container `slave.rep` :
```sql
CHANGE MASTER TO
MASTER_HOST='master.rep',
MASTER_USER='replicant',
MASTER_PASSWORD='password',
MASTER_PORT=3306,
MASTER_LOG_FILE='master1-bin.000006',
MASTER_LOG_POS=344,
MASTER_CONNECT_RETRY=10;

START SLAVE;
```

> /!\ Il faut faire attention au *`MASTER_LOG_FILE`* du script du slave. On peut le vérifier grâce à la commande **`SHOW MASTER STATUS;`** dans la console MySQL du master, puis il faut arrêter le slave avec la commande **`STOP SLAVE;`** , puis relancer le script avec le nouveau *`MASTER_LOG_FILE`*, et enfin relancer le slave avec **`START SLAVE;`**. On peut ensuite vérifier l'état de la connexion entre les containers avec la commande SQL **`SHOW SLAVE STATUS;`**.

On peut tester ensuite le bon fonctionnement de la connexion en créant une base de données dans le container `master.rep` et voir qu'elle apparait bien dans `slave.rep`.