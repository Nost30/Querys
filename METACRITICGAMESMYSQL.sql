
CREATE DATABASE ReviewJuegos;
SELECT DATE_FORMAT(release_date, '%d/%m/%Y') AS fecha_formateada FROM metacritic_games;


-- Crea la tabla metacritic_games
CREATE TABLE metacritic_games (
    game VARCHAR(100) NOT NULL,
    platform VARCHAR(50) NOT NULL,
    developer VARCHAR(100),
    genre VARCHAR(50),
    number_players VARCHAR(50),
    rating VARCHAR(50),
    release_date DATE NULL,
    positive_critics TINYINT NOT NULL,
    neutral_critics TINYINT NOT NULL,
    negative_critics TINYINT NOT NULL,
    positive_users SMALLINT NOT NULL,
    neutral_users SMALLINT NOT NULL,
    negative_users SMALLINT NOT NULL,
    metascore TINYINT NOT NULL,
    user_score TINYINT NOT NULL
);

SELECT release_date FROM metacritic_games;

-- Crea la tabla Plataforma
CREATE TABLE Plataforma (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    NombrePlataforma VARCHAR(50) NOT NULL UNIQUE,
    IdUsuarioCrea INT,
    FechaCrea DATETIME DEFAULT CURRENT_TIMESTAMP,
    IdUsuarioModifica INT,
    FechaModifica DATETIME,
    Estatus BIT DEFAULT 1
);

-- Crea la tabla Genero
CREATE TABLE Genero (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Genero VARCHAR(50) UNIQUE,
    IdUsuarioCrea INT,
    FechaCrea DATETIME DEFAULT CURRENT_TIMESTAMP,
    IdUsuarioModifica INT,
    FechaModifica DATETIME,
    Estatus BIT DEFAULT 1
);

-- Crea la tabla Desarrolladora
CREATE TABLE Desarrolladora (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Desarrolladora VARCHAR(100),
    IdUsuarioCrea INT,
    FechaCrea DATETIME DEFAULT CURRENT_TIMESTAMP,
    IdUsuarioModifica INT,
    FechaModifica DATETIME,
    Estatus BIT DEFAULT 1
);

-- Crea la tabla Juego
CREATE TABLE Juego (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    NombreJuego VARCHAR(100),
    IdGenero INT,
    IdDesarrolladora INT,
    IdPlataforma INT,
    FechaLanzamiento VARCHAR(60) NULL,
    NumeroJugadores VARCHAR(50),
    Metascore TINYINT,
    PuntajeUsuario TINYINT,
    IdUsuarioCrea INT,
    FechaCrea DATETIME DEFAULT CURRENT_TIMESTAMP,
    IdUsuarioModifica INT,
    FechaModifica DATETIME,
    Estatus BIT DEFAULT 1
);

-- Crea la tabla Review
CREATE TABLE Review (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    IdJuego INT,
    Clasificacion VARCHAR(50),
    ReviewsPositivas SMALLINT,
    ReviewNeutras SMALLINT,
    ReviewNegativas SMALLINT,
    IdUsuarioCrea INT,
    FechaCrea DATETIME DEFAULT CURRENT_TIMESTAMP,
    IdUsuarioModifica INT,
    FechaModifica DATETIME,
    Estatus BIT DEFAULT 1
);

-- Agrega la restricción de clave externa FK_JuegoGenero
ALTER TABLE Juego
ADD CONSTRAINT FK_JuegoGenero
FOREIGN KEY (IdGenero)
REFERENCES Genero(Id);

-- Agrega la restricción de clave externa FK_JuegoPlataforma
ALTER TABLE Juego
ADD CONSTRAINT FK_JuegoPlataforma
FOREIGN KEY (IdPlataforma)
REFERENCES Plataforma(Id);

-- Agrega la restricción de clave externa FK_JuegoDesarrolladora
ALTER TABLE Juego
ADD CONSTRAINT FK_JuegoDesarrolladora
FOREIGN KEY (IdDesarrolladora)
REFERENCES Desarrolladora(Id);

-- Agrega la restricción de clave externa FK_ReviewsJuego
ALTER TABLE Review
ADD CONSTRAINT FK_ReviewsJuego
FOREIGN KEY (IdJuego)
REFERENCES Juego(Id);


CREATE TABLE Usuario (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    username VARCHAR(50) NOT NULL,
    Password VARCHAR(50) NOT NULL,
    Estatus BIT DEFAULT b'1'
);

-- LAVES FORANEAS
ALTER TABLE Plataforma
ADD CONSTRAINT FK_PlataformaUsuarioCrea
FOREIGN KEY (IdUsuarioCrea)
REFERENCES Usuario(Id);

ALTER TABLE Plataforma
ADD CONSTRAINT FK_PlataformaUsuarioModifica
FOREIGN KEY (IdUsuarioModifica)
REFERENCES Usuario(Id);

ALTER TABLE Genero
ADD CONSTRAINT FK_GenerosUsuarioCrea
FOREIGN KEY (IdUsuarioCrea)
REFERENCES Usuario(Id);

ALTER TABLE Genero
ADD CONSTRAINT FK_GenerosUsuarioModifica
FOREIGN KEY (IdUsuarioModifica)
REFERENCES Usuario(Id);

ALTER TABLE Desarrolladora
ADD CONSTRAINT FK_DesarrolladorasUsuarioCrea
FOREIGN KEY (IdUsuarioCrea)
REFERENCES Usuario(Id);

ALTER TABLE Desarrolladora
ADD CONSTRAINT FK_DesarrolladorasUsuarioModifica
FOREIGN KEY (IdUsuarioModifica)
REFERENCES Usuario(Id);

ALTER TABLE Juego
ADD CONSTRAINT FK_JuegoUsuarioCrea
FOREIGN KEY (IdUsuarioCrea)
REFERENCES Usuario(Id);

ALTER TABLE Juego
ADD CONSTRAINT FK_JuegoUsuarioModifica
FOREIGN KEY (IdUsuarioModifica)
REFERENCES Usuario(Id);

ALTER TABLE Review
ADD CONSTRAINT FK_ReviewUsuarioCrea
FOREIGN KEY (IdUsuarioCrea)
REFERENCES Usuario(Id);

ALTER TABLE Review
ADD CONSTRAINT FK_ReviewUsuarioModifica
FOREIGN KEY (IdUsuarioModifica)
REFERENCES Usuario(Id);

-- INDICES
CREATE INDEX IX_Usuario ON Usuario(Id);

CREATE INDEX IX_Plataforma ON Plataforma(Id);

CREATE INDEX IX_Genero ON Genero(Id);

CREATE INDEX IX_Desarrolladora ON Desarrolladora(Id);

CREATE INDEX IX_Juego ON Juego(Id);

CREATE INDEX IX_Review ON Review(Id);


-- INSERTAR DATOS A USUARIO
INSERT INTO Usuario (Nombre, username, Password)
VALUES ('Admin', 'admin', SHA1('Admin'));

-- Verificar la longitud del hash SHA1
SELECT LENGTH(SHA1('Admin'));

-- Verificar los datos insertados en Usuario
SELECT * FROM Usuario;


-- INSERTAR DATOS A TABLA PLATAFORMA
INSERT INTO Plataforma (NombrePlataforma, IdUsuarioCrea)
SELECT DISTINCT platform, 1 FROM metacritic_games;

-- Verificar los datos insertados en Plataforma
SELECT * FROM Plataforma;

-- Reiniciar la identidad de Plataforma
ALTER TABLE Plataforma AUTO_INCREMENT = 1;


-- INSERTAR DATOS A TABLA GENERO
INSERT INTO Genero (Genero, IdUsuarioCrea)
SELECT DISTINCT genre, 1 FROM metacritic_games;

-- Verificar los datos insertados en Genero
SELECT * FROM Genero;

-- Reiniciar la identidad de Genero
ALTER TABLE Genero AUTO_INCREMENT = 1;


-- INSERTAR DATOS A TABLA DESARROLLADORA
INSERT INTO Desarrolladora (Desarrolladora, IdUsuarioCrea)
SELECT DISTINCT developer, 1 FROM metacritic_games;

-- Verificar los datos insertados en Desarrolladora
SELECT * FROM Desarrolladora;

-- Reiniciar la identidad de Desarrolladora
ALTER TABLE Desarrolladora AUTO_INCREMENT = 1;


-- INSERTAR DATOS A TABLA JUEGO
INSERT INTO Juego(NombreJuego, IdGenero, IdDesarrolladora, IdPlataforma, FechaLanzamiento, NumeroJugadores, Metascore, PuntajeUsuario, IdUsuarioCrea)
SELECT DISTINCT metacritic_games.game, Genero.Id, Desarrolladora.Id, Plataforma.Id, metacritic_games.release_date, metacritic_games.number_players, metacritic_games.metascore, metacritic_games.user_score, 1
FROM metacritic_games
INNER JOIN Desarrolladora ON Desarrolladora.Desarrolladora = metacritic_games.developer
INNER JOIN Plataforma ON Plataforma.NombrePlataforma = metacritic_games.platform
INNER JOIN Genero ON Genero.Genero = metacritic_games.genre;

SELECT * FROM Juego;

-- Eliminar datos de la tabla Juego y reiniciar el contador de identidad
DELETE FROM Juego;
ALTER TABLE Juego AUTO_INCREMENT = 1;

-- VERIFICAR LOS DATOS INSERTADOS
SELECT * FROM Juego;

-- REINICIAR EL AUTOINCREMENTO DEL ID
ALTER TABLE Juego AUTO_INCREMENT = 1;

-- INSERTAR DATOS EN REVIEW
INSERT INTO Review (IdJuego, Clasificacion, ReviewsPositivas, ReviewNeutras, ReviewNegativas, IdUsuarioCrea)
SELECT DISTINCT j.Id, mg.rating, mg.positive_users, mg.neutral_users, mg.negative_users, 1
FROM metacritic_games mg
INNER JOIN Juego j ON j.NombreJuego = mg.game;

-- Verificar los datos insertados en Review
SELECT * FROM Review;

-- CREAR VISTA
CREATE VIEW VW_JuegoReview AS
SELECT 
    J.Id AS IdJuego,
    J.NombreJuego,
    G.Genero,
    P.NombrePlataforma AS Plataforma,
    D.Desarrolladora,
    J.Metascore,
    J.NumeroJugadores
FROM 
    Juego J
JOIN 
    Genero G ON J.IdGenero = G.Id
LEFT JOIN 
    Plataforma P ON J.IdPlataforma = P.Id
LEFT JOIN 
    Desarrolladora D ON J.IdDesarrolladora = D.Id;


-- ELIMNAR VISTA DROP VIEW VW_JuegoReview;

DELIMITER //

CREATE PROCEDURE SP_AgregarJuego(
    IN p_NombreJuego NVARCHAR(100),
    IN p_IdGenero INT,
    IN p_IdDesarrolladora INT,
    IN p_IdPlataforma INT,
    IN p_FechaLanzamiento DATE,
    IN p_NumeroJugadores NVARCHAR(50),
    IN p_Metascore TINYINT,
    IN p_PuntajeUsuario TINYINT,
    IN p_IdUsuarioCrea INT
)
BEGIN
    INSERT INTO Juego (NombreJuego, IdGenero, IdDesarrolladora, IdPlataforma, FechaLanzamiento, NumeroJugadores, Metascore, PuntajeUsuario, IdUsuarioCrea)
    VALUES (p_NombreJuego, p_IdGenero, p_IdDesarrolladora, p_IdPlataforma, p_FechaLanzamiento, p_NumeroJugadores, p_Metascore, p_PuntajeUsuario, p_IdUsuarioCrea);
END//

DELIMITER ;

-- ACTUALIZAR JUEGO
DELIMITER //

CREATE PROCEDURE SP_ActualizarJuego(
    IN p_IdJuego INT,
    IN p_NombreJuego NVARCHAR(100),
    IN p_IdGenero INT,
    IN p_IdDesarrolladora INT,
    IN p_IdPlataforma INT,
    IN p_FechaLanzamiento DATE,
    IN p_NumeroJugadores NVARCHAR(50),
    IN p_Metascore TINYINT,
    IN p_PuntajeUsuario TINYINT,
    IN p_IdUsuarioModifica INT
)
BEGIN
    UPDATE Juego
    SET NombreJuego = p_NombreJuego,
        IdGenero = p_IdGenero,
        IdDesarrolladora = p_IdDesarrolladora,
        IdPlataforma = p_IdPlataforma,
        FechaLanzamiento = p_FechaLanzamiento,
        NumeroJugadores = p_NumeroJugadores,
        Metascore = p_Metascore,
        PuntajeUsuario = p_PuntajeUsuario,
        IdUsuarioModifica = p_IdUsuarioModifica,
        FechaModifica = CURRENT_DATE()
    WHERE Id = p_IdJuego;
END//

DELIMITER ;

-- ELIMINAR JUEGO
DELIMITER //

CREATE PROCEDURE SP_EliminarJuego(
    IN p_IdJuego INT
)
BEGIN
    -- Desactivar las restricciones de clave externa temporalmente
    SET @disable_foreign_key_checks = CONCAT('SET FOREIGN_KEY_CHECKS=0');
    PREPARE disable_fk_checks FROM @disable_foreign_key_checks;
    EXECUTE disable_fk_checks;

    -- Eliminar el juego de la tabla Review
    DELETE FROM Review WHERE IdJuego = p_IdJuego;

    -- Eliminar el juego de la tabla Juego
    DELETE FROM Juego WHERE Id = p_IdJuego;

    -- Activar las restricciones de clave externa nuevamente
    SET @enable_foreign_key_checks = CONCAT('SET FOREIGN_KEY_CHECKS=1');
    PREPARE enable_fk_checks FROM @enable_foreign_key_checks;
    EXECUTE enable_fk_checks;
END//

DELIMITER ;



