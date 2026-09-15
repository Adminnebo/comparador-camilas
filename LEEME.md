# Panel de evaluación de Camila

Panel de **solo lectura** para comparar dos versiones de Camila y puntuarlas con estrellas.

- Cada conversación se muestra como línea de tiempo.
- Mensaje del **cliente** arriba.
- Respuesta de Camila en dos columnas: **Camila Actual** (izquierda, `respuesta_camila_original`)
  y **Camila Paralela** (derecha, `mensaje`).
- Estrellas (1–5) en cada respuesta. Se guardan en Supabase.
- Arriba se ve el promedio de cada Camila y cuál va ganando.

## Puesta en marcha (2 pasos)

1. **Crear la tabla de puntuaciones.** En Supabase → SQL Editor, ejecutá
   `supabase-setup.sql`. (Si tu tabla de mensajes tiene RLS activo, descomentá y
   completá el bloque final para permitir su lectura.)

2. **Configurar el panel.** Abrí `index.html` con un editor y completá el bloque
   `CONFIG` del inicio:
   - `supabaseUrl` — URL del proyecto (Settings → API)
   - `supabaseKey` — la **anon public** key
   - `tablaMensajes` — el nombre real de tu tabla de mensajes

Luego abrí `index.html` en el navegador (doble clic) o subilo a cualquier hosting
estático (Netlify, Vercel, Railway, GitHub Pages).

## Notas
- Poné tu nombre arriba a la derecha: cada evaluador guarda sus propias estrellas.
- El panel usa la **anon key** (pública). Las policies del `.sql` permiten lectura
  de puntuaciones y escritura de estrellas a cualquiera con el link. Si el panel es
  para un cliente externo, tenelo en cuenta.
- Si ves “No pude leer los datos”: revisá el nombre de la tabla, la anon key y que
  exista una policy de `select` sobre la tabla de mensajes.
