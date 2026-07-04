#!/bin/bash

# Iniciar servicios
service mysql start
service apache2 start

# Esperar a que MySQL esté listo (máximo 30 segundos)
echo "Esperando a que MySQL esté disponible..."
for i in {1..30}; do
    if mysql -e "SELECT 1" &>/dev/null; then
        break
    fi
    sleep 1
done

# Configurar base de datos con charset explícito y usuario
# Agregamos CHARACTER SET utf8mb4 al crear la base de datos
mysql -e "CREATE DATABASE IF NOT EXISTS biblioteca_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -e "CREATE USER IF NOT EXISTS 'biblioteca_user'@'%' IDENTIFIED BY 'secret123';"
mysql -e "GRANT ALL PRIVILEGES ON biblioteca_db.* TO 'biblioteca_user'@'%';"
mysql -e "FLUSH PRIVILEGES;"

# Crear tabla e insertar datos (con sintaxis y codificación corregida)
mysql biblioteca_db <<EOF
SET NAMES 'utf8mb4';
DROP TABLE IF EXISTS libros;

CREATE TABLE libros (
  id INT AUTO_INCREMENT PRIMARY KEY,
  titulo VARCHAR(100) NOT NULL,
  autor VARCHAR(100) NOT NULL,
  anio_publicacion INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO libros (titulo, autor, anio_publicacion) VALUES
  ('Cien años de soledad', 'Gabriel García Márquez', 1967),
  ('El principito', 'Antoine de Saint-Exupéry', 1943),
  ('1984', 'George Orwell', 1949),
  ('Don Quijote de la Mancha', 'Miguel de Cervantes', 1605);
EOF

# Mantener el contenedor vivo
tail -f /dev/null