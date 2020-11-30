DROP DATABASE IF EXISTS TP1_AT;
CREATE DATABASE TP1_AT;
USE TP1_AT;

DROP TABLE IF EXISTS clients;

CREATE TABLE clients (
    nom VARCHAR(255),
    prenom VARCHAR(255),
    naissance DATE,
    cp INT(5)
);

INSERT INTO clients VALUES ("Antoine", "THYS", "1999-07-16", "33520"), ("Bob", "TRUC", "2000-04-14", "33000"), ("Eve", "MACHIN", "1998-06-24", "33000");

SELECT * FROM clients;
