CREATE DATABASE TiendaDeProductosDeportivos;
GO

USE TiendaDeProductosDeportivos;
GO


CREATE TABLE Categoria (
    CategoriaID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100) NOT NULL
);
GO

CREATE TABLE Genero (
    GeneroID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(50) NOT NULL
);
GO

CREATE TABLE Marca (
    MarcaID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100) NOT NULL
);
GO


CREATE TABLE TallaRopa (
    TallaID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(10) NOT NULL
);
GO

CREATE TABLE TallaCalzado (
    TallaID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(10) NOT NULL
);
GO


CREATE TABLE Peso (
    PesoID INT PRIMARY KEY IDENTITY(1,1),
    Valor DECIMAL(5,2) NOT NULL, -- 
    Unidad VARCHAR(10) NOT NULL DEFAULT 'kg' 
);
GO

CREATE TABLE Color (
    ColorID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(50) NOT NULL
);
GO

CREATE TABLE Producto (
    ProductoID INT PRIMARY KEY IDENTITY(1,1),
    CategoriaID INT FOREIGN KEY REFERENCES Categoria(CategoriaID),
    GeneroID INT,
    Titulo VARCHAR(100) NOT NULL,
    MarcaID INT FOREIGN KEY REFERENCES Marca(MarcaID),
    PesoID INT,
    TallaRopaID INT FOREIGN KEY REFERENCES TallaRopa(TallaID),
    TallaCalzadoID INT FOREIGN KEY REFERENCES TallaCalzado(TallaID),
    ColorID INT FOREIGN KEY REFERENCES Color(ColorID),
    Precio DECIMAL(10, 2) NOT NULL,
    Disponibilidad BIT NOT NULL,
    Stock INT NOT NULL
);
GO


-- Crear un trigger para actualizar la disponibilidad según el stock
CREATE TRIGGER ActualizarDisponibilidad
ON Producto
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE Producto
    SET Disponibilidad = CASE
        WHEN Stock > 0 THEN 1 -- Disponible
        ELSE 0 -- No disponible
    END
    WHERE ProductoID IN (SELECT ProductoID FROM inserted);
END;
GO



INSERT INTO Categoria (Nombre) VALUES 
('Ropa Deportiva'),
('Calzado Deportivo'),
('Equipos de Gimnasio'),
('Accesorios Deportivos');
GO

INSERT INTO Genero (Nombre) VALUES 
('Hombre'),
('Mujer'),
('Unisex');
GO

INSERT INTO Marca (Nombre) VALUES 
('Nike'),
('Adidas'),
('Puma'),
('Reebok'),
('Under Armour'),
('Bowflex'),
('Rogue Fitness'),
('Onnit');
GO

INSERT INTO TallaRopa (Nombre) VALUES 
('S'),
('M'),
('L'),
('XL');
GO

INSERT INTO TallaCalzado (Nombre) VALUES 
('38'),
('39'),
('40'),
('41'),
('42'),
('43'),
('44'),
('45');
GO

INSERT INTO Peso (Valor, Unidad) VALUES 
(1.00, 'kg'),
(2.00, 'kg'),
(5.00, 'kg'),
(10.00, 'kg'),
(15.00, 'kg'),
(20.00, 'kg'),
(25.00, 'kg'),
(30.00, 'kg');
GO

INSERT INTO Color (Nombre) VALUES 
('Negro'),
('Blanco'),
('Rojo'),
('Azul'),
('Verde'),
('Gris'),
('Morado'),
('Amarillo');
GO

INSERT INTO Producto (CategoriaID, GeneroID, Titulo, MarcaID, PesoID, TallaRopaID, TallaCalzadoID, ColorID, Precio, Disponibilidad, Stock) VALUES
-- Ropa Deportiva
(1, 1, 'Camiseta Deportiva Nike', 1, NULL, (SELECT TallaID FROM TallaRopa WHERE Nombre = 'M'), NULL, (SELECT ColorID FROM Color WHERE Nombre = 'Rojo'), 29.99, 1, 15),  
(1, 2, 'Pantalones Cortos Adidas', 2, NULL, (SELECT TallaID FROM TallaRopa WHERE Nombre = 'L'), NULL, (SELECT ColorID FROM Color WHERE Nombre = 'Negro'), 34.99, 1, 0),    
(1, 3, 'Chaqueta Deportiva Puma', 3, NULL, (SELECT TallaID FROM TallaRopa WHERE Nombre = 'XL'), NULL, (SELECT ColorID FROM Color WHERE Nombre = 'Azul'), 59.99, 1, 20),     
(1, 1, 'Sudadera Under Armour', 4, NULL, (SELECT TallaID FROM TallaRopa WHERE Nombre = 'M'), NULL, (SELECT ColorID FROM Color WHERE Nombre = 'Gris'), 49.99, 1, 5),   

-- Calzado Deportivo
(2, 1, 'Zapatillas de Correr Nike', 1, NULL, NULL, (SELECT TallaID FROM TallaCalzado WHERE Nombre = '39'), (SELECT ColorID FROM Color WHERE Nombre = 'Verde'), 89.99, 1, 10),  
(2, 2, 'Botas de Fútbol Adidas', 2, NULL, NULL, (SELECT TallaID FROM TallaCalzado WHERE Nombre = '40'), (SELECT ColorID FROM Color WHERE Nombre = 'Rojo'), 99.99, 1, 0), 
(2, 3, 'Zapatillas de Entrenamiento Reebok', 3, NULL, NULL, (SELECT TallaID FROM TallaCalzado WHERE Nombre = '41'), (SELECT ColorID FROM Color WHERE Nombre = 'Negro'), 79.99, 1, 12),  
(2, 2, 'Sandalias Deportivas Puma', 2, NULL, NULL, (SELECT TallaID FROM TallaCalzado WHERE Nombre = '42'), (SELECT ColorID FROM Color WHERE Nombre = 'Blanco'), 39.99, 1, 15),  

-- Equipos de Gimnasio
(3, 3, 'Pesas de Mano 5 kg', 5, NULL, NULL, NULL, (SELECT ColorID FROM Color WHERE Nombre = 'Gris'), 49.99, 1, 18), 
(3, 3, 'Banco de Entrenamiento', 6, NULL, NULL, NULL, (SELECT ColorID FROM Color WHERE Nombre = 'Negro'), 149.99, 1, 8),       
(3, 3, 'Rueda de Abdominales', 7, NULL, NULL, NULL, (SELECT ColorID FROM Color WHERE Nombre = 'Verde'), 24.99, 1, 50),   

-- Accesorios Deportivos
(4, 3, 'Muñequera de Protección', 1, NULL, NULL, NULL, (SELECT ColorID FROM Color WHERE Nombre = 'Azul'), 14.99, 1, 30),      
(4, 3, 'Soga para Saltar', 2, NULL, NULL, NULL, (SELECT ColorID FROM Color WHERE Nombre = 'Negro'), 12.99, 1, 40),   
(4, 3, 'Tirantes para Levantamiento de Pesas', 5, NULL, NULL, NULL, (SELECT ColorID FROM Color WHERE Nombre = 'Gris'), 19.99, 1, 20),   
(4, 3, 'Botella de Agua', 8, NULL, NULL, NULL, (SELECT ColorID FROM Color WHERE Nombre = 'Naranja'), 9.99, 1, 100),   
(4, 3, 'Toalla Deportiva', 3, NULL, NULL, NULL, (SELECT ColorID FROM Color WHERE Nombre = 'Amarillo'), 15.99, 1, 25),   


(1, 1, 'Leggings Nike', 1, NULL, (SELECT TallaID FROM TallaRopa WHERE Nombre = 'S'), NULL, (SELECT ColorID FROM Color WHERE Nombre = 'Negro'), 39.99, 1, 12),  
(1, 2, 'Camiseta de Compresión Adidas', 2, NULL, (SELECT TallaID FROM TallaRopa WHERE Nombre = 'L'), NULL, (SELECT ColorID FROM Color WHERE Nombre = 'Blanco'), 29.99, 1, 10),  
(1, 1, 'Chaqueta de Running Under Armour', 4, NULL, (SELECT TallaID FROM TallaRopa WHERE Nombre = 'XL'), NULL, (SELECT ColorID FROM Color WHERE Nombre = 'Azul'), 64.99, 1, 8),  
(2, 3, 'Zapatillas de Baloncesto Nike', 1, NULL, NULL, (SELECT TallaID FROM TallaCalzado WHERE Nombre = '44'), (SELECT ColorID FROM Color WHERE Nombre = 'Rojo'), 99.99, 0, 0),  
(2, 2, 'Zapatillas de Trail Adidas', 2, NULL, NULL, (SELECT TallaID FROM TallaCalzado WHERE Nombre = '42'), (SELECT ColorID FROM Color WHERE Nombre = 'Verde'), 79.99, 1, 12);  
GO


-- prueba trigger

select * from Producto
WHERE ProductoID = 4;



-- Disminuir el stock de un producto a cero para probar el trigger
UPDATE Producto
SET Stock = 0
WHERE ProductoID = 4;

select * from Producto
where ProductoID=4





