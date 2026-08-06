-- Script de inicialización base de datos de Nutrición
CREATE TABLE IF NOT EXISTS usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    rol VARCHAR(20) DEFAULT 'paciente',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO usuarios (nombre, email, rol) 
VALUES ('Administrador', 'admin@nutricion.com', 'admin')
ON CONFLICT (email) DO NOTHING;
