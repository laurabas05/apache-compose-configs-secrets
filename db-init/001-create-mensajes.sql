CREATE TABLE IF NOT EXISTS mensajes (
    id SERIAL PRIMARY KEY,
    contenido TEXT NOT NULL,
    creado_en TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()
);

INSERT INTO mensajes (contenido)
SELECT 'Primer registro desde init.sql'
WHERE NOT EXISTS (SELECT 1 FROM mensajes);
