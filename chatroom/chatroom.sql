-- mysqladmin -u root password
-- toor

CREATE DATABASE chatroom;
USE chatroom;
CREATE TABLE groups(
    id INT NOT NULL,
    name VARCHAR(32) NOT NULL,
    PRIMARY KEY(id)
);
CREATE TABLE users(
    id VARCHAR(16) NOT NULL,
    name VARCHAR(32) NOT NULL,
    surname VARCHAR(32),
    password VARCHAR(128) NOT NULL,
    PRIMARY KEY(id)
);
CREATE TABLE messages(
    user VARCHAR(16) NOT NULL,
    guild INT NOT NULL,
    timedate DATETIME NOT NULL,
    txt VARCHAR(128) NOT NULL,
    FOREIGN KEY(user) REFERENCES users(id),
    FOREIGN KEY(guild) REFERENCES groups(id)
);
CREATE TABLE partecipants(
    user VARCHAR(16) NOT NULL,
    guild INT NOT NULL,
    FOREIGN KEY(user) REFERENCES users(id),
    FOREIGN KEY(guild) REFERENCES groups(id)
);
