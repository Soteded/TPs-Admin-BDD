DROP DATABASE IF EXISTS TP7;
CREATE DATABASE TP7;
USE TP7;

DROP TABLE IF EXISTS clients;

CREATE TABLE clients (
    nom VARCHAR(255),
    prenom VARCHAR(255),
    naissance DATE,
    cp INT(5)
);

INSERT INTO clients VALUES ("Michel", "Oui", "1998-02-11", "33000"), ("enfin", "non", "1956-08-06", "33000"), ("amid", "aled", "1998-06-24", "33000");

SELECT * FROM clients;