USE [MetacriticGames]
GO

/****** Object:  Table [dbo].[metacritic_games]    Script Date: 20/04/2024 23:26:45 ******/
SET ANSI_NULLS ON
GO
	
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[metacritic_games](
	[game] [nvarchar](100) NOT NULL,
	[platform] [nvarchar](50) NOT NULL,
	[developer] [nvarchar](100) NULL,
	[genre] [nvarchar](50) NULL,
	[number_players] [nvarchar](50) NULL,
	[rating] [nvarchar](50) NULL,
	[release_date] [date] NOT NULL,
	[positive_critics] [tinyint] NOT NULL,
	[neutral_critics] [tinyint] NOT NULL,
	[negative_critics] [tinyint] NOT NULL,
	[positive_users] [smallint] NOT NULL,
	[neutral_users] [smallint] NOT NULL,
	[negative_users] [smallint] NOT NULL,
	[metascore] [tinyint] NOT NULL,
	[user_score] [tinyint] NOT NULL
) ON [PRIMARY]
GO

SELECT * FROM [dbo].[metacritic_games]


--CREA LA TABLA PLATAFORMA
CREATE TABLE Plataforma (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    NombrePlataforma NVARCHAR(50) NOT NULL UNIQUE,
	IdUsuarioCrea INT,
    FechaCrea DATETIME DEFAULT GETDATE(),
    IdUsuarioModifica INT NULL,
    FechaModifica DATETIME DEFAULT NULL,
	Estatus BIT DEFAULT 1
);
GO

--CREA LA TABLA GENERO
CREATE TABLE Genero (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Genero NVARCHAR(50) NULL UNIQUE,
	IdUsuarioCrea INT,
    FechaCrea DATETIME DEFAULT GETDATE(),
    IdUsuarioModifica INT NULL,
    FechaModifica DATETIME DEFAULT NULL,
	Estatus BIT DEFAULT 1
);
GO

--CREA LA TABLA DESARROLLADORA
CREATE TABLE Desarrolladora (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Desarrolladora NVARCHAR(100) NULL,
	IdUsuarioCrea INT,
    FechaCrea DATETIME DEFAULT GETDATE(),
    IdUsuarioModifica INT NULL,
    FechaModifica DATETIME DEFAULT NULL,
	Estatus BIT DEFAULT 1
);
GO

--CREA LA TABLA JUEGO
CREATE TABLE Juego (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    NombreJuego NVARCHAR(100) NULL,
    IdGenero INT,
	IdDesarrolladora INT,
	IdPlataforma INT NULL,
    FechaLanzamiento DATE NULL,
	NumeroJugadores NVARCHAR(50) NULL,
    Metascore TINYINT NULL,
    PuntajeUsuario TINYINT NULL,
	IdUsuarioCrea INT,
    FechaCrea DATETIME DEFAULT GETDATE(),
    IdUsuarioModifica INT NULL,
    FechaModifica DATETIME DEFAULT NULL,
    Estatus BIT DEFAULT 1
);
GO

--CREA LA TABLA REVIEW
CREATE TABLE Review (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    IdJuego INT NULL,
    Clasificacion NVARCHAR(50) NULL,
	ReviewsPositivas SMALLINT,
	ReviewNeutras SMALLINT NULL,
	ReviewNegativas SMALLINT NULL,
	IdUsuarioCrea INT,
    FechaCrea DATETIME DEFAULT GETDATE(),
    IdUsuarioModifica INT NULL,
    FechaModifica DATETIME DEFAULT NULL,
    Estatus BIT DEFAULT 1
);
GO


--LLAVES FORANEAS DE JUEGO-GENERO y JUEGO-PLATAFORMA

ALTER TABLE Juego
ADD CONSTRAINT  FK_JuegoGenero
FOREIGN KEY  (IdGenero)
REFERENCES Genero(Id)
GO

ALTER TABLE Juego
ADD CONSTRAINT  FK_JuegoPlataforma
FOREIGN KEY  (IdPlataforma)
REFERENCES Plataforma(Id)
GO

ALTER TABLE Juego
ADD CONSTRAINT  FK_JuegoDesarrolladora
FOREIGN KEY  (IdDesarrolladora)
REFERENCES Desarrolladora(Id)
GO

ALTER TABLE Review
ADD CONSTRAINT  FK_ReviewsJuego
FOREIGN KEY  (IdJuego)
REFERENCES Juego(Id)
GO



--CREA TABLA USUARIO
CREATE TABLE Usuario
(
 Id INT IDENTITY(1,1) PRIMARY KEY,
 Nombre VARCHAR(50) NOT NULL,
 username VARCHAR(50) NOT NULL,
 Password VARCHAR(50) NOT NULL,
 Estatus BIT DEFAULT 1
)
GO

--AGREGAR LLAVES FORANEAS DE USUARIO EN CADA TABLA
ALTER TABLE Plataforma
ADD CONSTRAINT  FK_PlataformaUsuarioCrea
FOREIGN KEY  (IdUsuarioCrea)
REFERENCES usuario(id)
GO

ALTER TABLE Plataforma
ADD CONSTRAINT  FK_PlataformaUsuarioModifica
FOREIGN KEY  (IdUsuarioModifica)
REFERENCES usuario(id)
GO


ALTER TABLE Genero
ADD CONSTRAINT  FK_GenerosUsuarioCrea
FOREIGN KEY  (IdUsuarioCrea)
REFERENCES usuario(id)
GO

ALTER TABLE Genero
ADD CONSTRAINT  FK_GenerosUsuarioModifica
FOREIGN KEY  (IdUsuarioModifica)
REFERENCES usuario(id)
GO


ALTER TABLE Desarrolladora
ADD CONSTRAINT  FK_DesarrolladorasUsuarioCrea
FOREIGN KEY  (IdUsuarioCrea)
REFERENCES usuario(id)
GO

ALTER TABLE Desarrolladora
ADD CONSTRAINT  FK_DesarrolladorasUsuarioModifica
FOREIGN KEY  (IdUsuarioModifica)
REFERENCES usuario(id)
GO


ALTER TABLE Juego
ADD CONSTRAINT  FK_JuegoUsuarioCrea
FOREIGN KEY  (IdUsuarioCrea)
REFERENCES usuario(id)
GO

ALTER TABLE Juego
ADD CONSTRAINT  FK_JuegoUsuarioModifica
FOREIGN KEY  (IdUsuarioModifica)
REFERENCES usuario(id)
GO


ALTER TABLE Review
ADD CONSTRAINT  FK_ReviewUsuarioCrea
FOREIGN KEY  (IdUsuarioCrea)
REFERENCES usuario(id)
GO

ALTER TABLE Review
ADD CONSTRAINT  FK_ReviewUsuarioModifica
FOREIGN KEY  (IdUsuarioModifica)
REFERENCES usuario(id)
GO

--INDICES
CREATE INDEX IX_Usuario ON Usuario(id)
GO
CREATE INDEX IX_Plataforma ON Plataforma(Id)
GO
CREATE INDEX IX_Genero ON Genero(Id)
GO
CREATE INDEX IX_Desarrolladora ON Desarrolladora(Id)
GO
CREATE INDEX IX_Juego ON Juego(Id)
GO
CREATE INDEX IX_Review ON Review(Id)
GO

--POBLAR

--INSERTAR DATOS A USUARIO
INSERT INTO Usuario(Nombre,username,Password)
VALUES('Admin','admin', CONVERT(NVARCHAR(50),HashBYTES('SHA1','Admin'),2))

select CONVERT(NVARCHAR(50),HashBYTES('SHA1','Admin'),2)
length

SELECT* FROM Usuario


--INSERTAR DATOS A TABLA PLATAFORMA
INSERT INTO Plataforma(NombrePlataforma,IdUsuarioCrea)
SELECT DISTINCT [platform],1 FROM [dbo].[metacritic_games]

SELECT * FROM Plataforma

DELETE FROM Plataforma
DBCC CHECKIDENT ('Plataforma', RESEED, 0)
GO

--INSERTAR DATOS A TABLA GENERO
INSERT INTO Genero(Genero,IdUsuarioCrea)
SELECT DISTINCT [genre],1 FROM [dbo].[metacritic_games]

SELECT * FROM Genero

DELETE FROM Genero
DBCC CHECKIDENT ('Genero', RESEED, 0)
GO

--INSERTAR DATOS A TABLA DESARROLLADORA
INSERT INTO Desarrolladora(Desarrolladora,IdUsuarioCrea)
SELECT DISTINCT [developer],1 FROM [dbo].[metacritic_games]

SELECT * FROM Desarrolladora

DELETE FROM Desarrolladora
DBCC CHECKIDENT ('Desarrolladora', RESEED, 0)
GO

--INSERTAR DATOS A TABLA JUEGO
INSERT INTO Juego(NombreJuego,IdGenero,IdDesarrolladora,IdPlataforma,FechaLanzamiento,NumeroJugadores,Metascore,PuntajeUsuario,IdUsuarioCrea)
SELECT DISTINCT metacritic_games.game,Genero.Id,Desarrolladora.Id,Plataforma.Id,metacritic_games.release_date,
metacritic_games.number_players,metacritic_games.metascore,metacritic_games.user_score,1
	FROM [dbo].[metacritic_games]
inner join Desarrolladora ON Desarrolladora.Desarrolladora=metacritic_games.developer
inner join Plataforma ON Plataforma.NombrePlataforma=metacritic_games.[platform]
inner join Genero ON Genero.Genero =metacritic_games.genre

SELECT * FROM Juego 

DELETE FROM Juego
DBCC CHECKIDENT ('Juego', RESEED, 0)
GO

--INSERTAR DATOS A TABLA REVIEW
INSERT INTO Review(IdJuego,Clasificacion,ReviewsPositivas,ReviewNeutras,ReviewNegativas,IdUsuarioCrea)
SELECT DISTINCT Juego.Id,metacritic_games.rating, metacritic_games.positive_users,metacritic_games.neutral_users,metacritic_games.negative_users,1 FROM metacritic_games
INNER JOIN Juego ON Juego.NombreJuego=metacritic_games.game

SELECT * FROM Review

DELETE FROM Review
DBCC CHECKIDENT ('Review', RESEED, 0)
GO

--CREA VISTA

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
    Desarrolladora D ON J.IdDesarrolladora = D.Id

--BORRAR VISTA DROP VIEW VW_JuegoReview

--PROCEDIMIENTOS ALMACENADOS

--AGREGAR NUEVO JUEGO
CREATE PROCEDURE SP_AgregarJuego
    @NombreJuego NVARCHAR(100),
    @IdGenero INT,
    @IdDesarrolladora INT,
    @IdPlataforma INT,
    @FechaLanzamiento DATE,
    @NumeroJugadores NVARCHAR(50),
    @Metascore TINYINT,
    @PuntajeUsuario TINYINT,
    @IdUsuarioCrea INT
AS
BEGIN
    INSERT INTO Juego (NombreJuego, IdGenero, IdDesarrolladora, IdPlataforma, FechaLanzamiento, NumeroJugadores, Metascore, PuntajeUsuario, IdUsuarioCrea)
    VALUES (@NombreJuego, @IdGenero, @IdDesarrolladora, @IdPlataforma, @FechaLanzamiento, @NumeroJugadores, @Metascore, @PuntajeUsuario, @IdUsuarioCrea);
END;
GO


--ACTUALIZAR DATOS DE UN JUEGO
CREATE PROCEDURE SP_ActualizarJuego
    @IdJuego INT,
    @NombreJuego NVARCHAR(100),
    @IdGenero INT,
    @IdDesarrolladora INT,
    @IdPlataforma INT,
    @FechaLanzamiento DATE,
    @NumeroJugadores NVARCHAR(50),
    @Metascore TINYINT,
    @PuntajeUsuario TINYINT,
    @IdUsuarioModifica INT
AS
BEGIN
    UPDATE Juego
    SET NombreJuego = @NombreJuego,
        IdGenero = @IdGenero,
        IdDesarrolladora = @IdDesarrolladora,
        IdPlataforma = @IdPlataforma,
        FechaLanzamiento = @FechaLanzamiento,
        NumeroJugadores = @NumeroJugadores,
        Metascore = @Metascore,
        PuntajeUsuario = @PuntajeUsuario,
        IdUsuarioModifica = @IdUsuarioModifica,
        FechaModifica = GETDATE()
    WHERE Id = @IdJuego;
END
GO


--ELIMINAR UN JUEGO
CREATE PROCEDURE SP_EliminarJuego
    @IdJuego INT
AS
BEGIN
    -- Desactivar las restricciones de clave externa temporalmente
    EXEC sp_msforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL';

    -- Eliminar el juego de la tabla Review
    DELETE FROM Review WHERE IdJuego = @IdJuego;

    -- Eliminar el juego de la tabla Juego
    DELETE FROM Juego WHERE Id = @IdJuego;

    -- Activar las restricciones de clave externa nuevamente
    EXEC sp_msforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL';
END;
GO












