# TP 5 - Importer une base de données MySQL en MariaDB

## Mise en place du lab

Pour tester l'import d'une base dans MariaDB, il faut un container docker avec MySQL et un autre avec MariaDB, ainsi que leur instancier un dossier commun qui sera ici "backups" (Cf le docker-compose [ici](./files/docker-compose.yml))

## Création d'une backup sur MySQL

On commence par lancer le docker-compose ci-dessus, puis exécuter la commande `docker exec -it <nom_du_container> sh`, ici `docker exec -it files_mysql_1 sh` afin de se connecter au container mysql. Puis `mysql -uroot -p` puis entrer le mot de passe pour se connecter (celui précisé dans le docker-compose). Une fois dedans, on va créer une base de données `users` avec la commande `CREATE DATABASE users;`, puis `USE users` afin d'y accèder. On y créée ensuite une table userList avec deux champs comme ci-suivant : `CREATE TABLE userList (firstname varchar(255), lastname varchar(255));`, puis on y insère des données "aléatoires" afin d'avoir quelques lignes à backup, avec la commande `INSERT INTO userList VALUES ("Theo", "VICENTE"), ("Martin", "PETIT"), ("Gabriel", "FOUGEROLLE");`. Une fois fait, on peut sortir de MySQL avec la commande `exit`, puis on utilise la commande `mysqldump -uroot -p<mot_de_passe> users > /backups/export.sql` pour créer une sauvegarde de la base de données dans le dossier dans le dossier backups à la racine.

## Import de la backup sur MariaDB

On se déconnecte du container MySQL pour aller sur le container MariaDB avec `docker exec -it files_mariadb_1 sh`, puis on se connecte à la base de données avec `mysql -uroot -p` afin de créer la base de données de réception avec `CREATE DATABASE users;`. Une fois fait, on "téléverse" ? "Télécharge" ? Bref, on charge l'export dans mariadb avec la commande `mysql -uroot -p users < /backups/export.sql` (il faut quand même rentrer le mot de passe). Et boum, on a bien les données présentes sur l'autre base de données :
```
MariaDB [users]> select * from userList;
+-----------+------------+
| firstname | lastname   |
+-----------+------------+
| Theo      | VICENTE    |
| Martin    | PETIT      |
| Gabriel   | FOUGEROLLE |
+-----------+------------+
3 rows in set (0.000 sec)
```