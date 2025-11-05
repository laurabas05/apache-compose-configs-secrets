#!/bin/sh
set -e

echo "Content-Type: text/html; charset=utf-8"
echo ""

if [ ! -f /run/secrets/pg_pass ]; then
  echo "<p><strong>Error:</strong> No se encontró el secreto <code>pg_pass</code>.</p>"
  exit 0
fi

PGPASSWORD="$(cat /run/secrets/pg_pass)"
export PGPASSWORD

export PGOPTIONS='--client-min-messages=warning'

psql -X -q -h db -U usuario -d ejemplo <<'SQL'
CREATE TABLE IF NOT EXISTS mensajes (
    id SERIAL PRIMARY KEY,
    contenido TEXT NOT NULL,
    creado_en TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()
);

INSERT INTO mensajes (contenido)
SELECT 'Hola desde PostgreSQL'
WHERE NOT EXISTS (SELECT 1 FROM mensajes);
SQL

QUERY_RESULT="$(psql -X -q -h db -U usuario -d ejemplo -At -F $'\t' \
  -c "SELECT id, contenido, to_char(creado_en, 'YYYY-MM-DD HH24:MI') AS creado FROM mensajes ORDER BY id;")"

unset PGPASSWORD

if [ -z "$QUERY_RESULT" ]; then
  echo "<p>No hay mensajes que mostrar.</p>"
  exit 0
fi

cat <<'HTML'
<table border="1" cellpadding="6" cellspacing="0">
  <thead>
    <tr>
      <th>ID</th>
      <th>Contenido</th>
      <th>Creado</th>
    </tr>
  </thead>
  <tbody>
HTML

echo "$QUERY_RESULT" | while IFS="$(printf '\t')" read -r id contenido creado; do
  printf '    <tr><td>%s</td><td>%s</td><td>%s</td></tr>\n' \
    "$(printf '%s' "$id" | sed 's/&/&amp;/g; s/</&lt;/g; s/>/&gt;/g')" \
    "$(printf '%s' "$contenido" | sed 's/&/&amp;/g; s/</&lt;/g; s/>/&gt;/g')" \
    "$(printf '%s' "$creado" | sed 's/&/&amp;/g; s/</&lt;/g; s/>/&gt;/g')"
done

cat <<'HTML'
  </tbody>
</table>
HTML
