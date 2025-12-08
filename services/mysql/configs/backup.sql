DROP DATABASE IF EXISTS backup;
CREATE DATABASE backup;
USE backup;

CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    correo VARCHAR(80)
);

INSERT INTO usuarios (nombre, correo) VALUES
('Laura Pérez', 'laura.perez@example.com'),
('Carlos Martín', 'carlos.martin@example.com'),
('Ana López', 'ana.lopez@example.com'),
('Javier Torres', 'javier.torres@example.com'),
('Marta Ruiz', 'marta.ruiz@example.com'),
('Sergio Molina', 'sergio.molina@example.com'),
('Paula Santos', 'paula.santos@example.com'),
('David Romero', 'david.romero@example.com'),
('Julia Navarro', 'julia.navarro@example.com'),
('Andrés Vega', 'andres.vega@example.com');
