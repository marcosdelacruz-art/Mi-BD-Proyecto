-- Creación de la base de datos
CREATE DATABASE IF NOT EXISTS control_agricola;
USE control_agricola;

-- 1. Tabla Socio
CREATE TABLE Socio (
    Id_Socio INT AUTO_INCREMENT PRIMARY KEY,
    Nombres_Apellidos VARCHAR(150) NOT NULL,
    DNI_RUC VARCHAR(20) NOT NULL UNIQUE,
    Codigo_Socio VARCHAR(50) NOT NULL UNIQUE,
    Telefono VARCHAR(20),
    Direccion TEXT,
    Estado_Certificacion VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

-- 2. Tabla Parcela
CREATE TABLE Parcela (
    Id_Parcela INT AUTO_INCREMENT PRIMARY KEY,
    Nombre_Ubicacion VARCHAR(100) NOT NULL,
    Area_Hectareas DECIMAL(10, 2) NOT NULL,
    Codigo_Trazabilidad_Parcela VARCHAR(50) NOT NULL UNIQUE,
    Coordenadas_GPS VARCHAR(100),
    Id_Socio INT NOT NULL,
    CONSTRAINT fk_parcela_socio FOREIGN KEY (Id_Socio) REFERENCES Socio(Id_Socio) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 3. Tabla Producto
CREATE TABLE Producto (
    Id_Producto INT AUTO_INCREMENT PRIMARY KEY,
    Nombre_Producto VARCHAR(100) NOT NULL,
    Variedad VARCHAR(50),
    Tipo_Certificacion VARCHAR(50)
) ENGINE=InnoDB;

-- 4. Tabla Calibre
CREATE TABLE Calibre (
    Id_Calibre INT AUTO_INCREMENT PRIMARY KEY,
    Codigo_Calibre VARCHAR(50) NOT NULL,
    Rango_Peso_Gramos VARCHAR(50) NOT NULL,
    Destino_Uso VARCHAR(50),
    Id_Producto INT NOT NULL,
    CONSTRAINT fk_calibre_producto FOREIGN KEY (Id_Producto) REFERENCES Producto(Id_Producto) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 5. Tabla Recepcion_Cosecha
CREATE TABLE Recepcion_Cosecha (
    Id_Recepcion INT AUTO_INCREMENT PRIMARY KEY,
    Fecha_Hora_Entrega DATETIME NOT NULL,
    Codigo_Lote_Ingreso VARCHAR(50) NOT NULL UNIQUE,
    Estado_Calidad VARCHAR(50) NOT NULL,
    Observaciones TEXT,
    Id_Socio INT NOT NULL,
    Id_Parcela INT NOT NULL,
    CONSTRAINT fk_recepcion_socio FOREIGN KEY (Id_Socio) REFERENCES Socio(Id_Socio) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_recepcion_parcela FOREIGN KEY (Id_Parcela) REFERENCES Parcela(Id_Parcela) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 6. Tabla Detalle_Recepcion_Cosecha
CREATE TABLE Detalle_Recepcion_Cosecha (
    Id_Detalle_Recepcion INT AUTO_INCREMENT PRIMARY KEY,
    Cantidad_Kilos DECIMAL(10, 2) NOT NULL,
    Precio_Unidad_Establecido DECIMAL(10, 2),
    Monto_Total_Pago DECIMAL(10, 2),
    Id_Recepcion INT NOT NULL,
    Id_Producto INT NOT NULL,
    Id_Calibre INT NOT NULL,
    CONSTRAINT fk_detalle_recepcion FOREIGN KEY (Id_Recepcion) REFERENCES Recepcion_Cosecha(Id_Recepcion) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_detalle_producto FOREIGN KEY (Id_Producto) REFERENCES Producto(Id_Producto) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_detalle_calibre FOREIGN KEY (Id_Calibre) REFERENCES Calibre(Id_Calibre) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 7. Tabla Almacén
CREATE TABLE Almacen (
    Id_Almacen INT AUTO_INCREMENT PRIMARY KEY,
    Nombre_Almacen VARCHAR(100) NOT NULL,
    Ubicacion TEXT,
    Capacidad_M3 DECIMAL(10, 2)
) ENGINE=InnoDB;

-- 8. Tabla Inventario_Stock
CREATE TABLE Inventario_Stock (
    Id_Inventario INT AUTO_INCREMENT PRIMARY KEY,
    Codigo_Lote_Origen VARCHAR(50),
    Cantidad_Disponible_Kilos DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    Fecha_Ultima_Actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    Id_Almacen INT NOT NULL,
    Id_Producto INT NOT NULL,
    Id_Calibre INT NOT NULL,
    CONSTRAINT fk_inventario_almacen FOREIGN KEY (Id_Almacen) REFERENCES Almacen(Id_Almacen) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_inventario_producto FOREIGN KEY (Id_Producto) REFERENCES Producto(Id_Producto) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_inventario_calibre FOREIGN KEY (Id_Calibre) REFERENCES Calibre(Id_Calibre) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;