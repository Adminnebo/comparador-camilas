-- ============================================================
--  Panel de evaluación Camila — tabla de puntuaciones + permisos
--  Ejecutá TODO este archivo en el SQL Editor de Supabase.
-- ============================================================

-- 1) Tabla donde se guardan las estrellas de cada respuesta.
--    Una fila por (mensaje, variante, evaluador).
create table if not exists public.camila_ratings (
  id           uuid primary key default gen_random_uuid(),
  message_id   bigint not null,                       -- id de la fila en tu tabla de mensajes
  variante     text   not null check (variante in ('actual','paralela')),
  estrellas    int    not null check (estrellas between 1 and 5),
  evaluador    text   not null default 'anonimo',     -- quién puntuó (nombre libre)
  comentario   text,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now(),
  unique (message_id, variante, evaluador)
);

create index if not exists camila_ratings_message_idx
  on public.camila_ratings (message_id);

-- Mantener updated_at al día
create or replace function public.touch_camila_ratings()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end $$;

drop trigger if exists trg_touch_camila_ratings on public.camila_ratings;
create trigger trg_touch_camila_ratings
  before update on public.camila_ratings
  for each row execute function public.touch_camila_ratings();

-- 2) Permisos (RLS). El panel usa la anon key (pública), así que
--    habilitamos lectura de mensajes y lectura/escritura de puntuaciones.
alter table public.camila_ratings enable row level security;

drop policy if exists camila_ratings_select on public.camila_ratings;
create policy camila_ratings_select on public.camila_ratings
  for select using (true);

drop policy if exists camila_ratings_insert on public.camila_ratings;
create policy camila_ratings_insert on public.camila_ratings
  for insert with check (true);

drop policy if exists camila_ratings_update on public.camila_ratings;
create policy camila_ratings_update on public.camila_ratings
  for update using (true) with check (true);

-- 3) Lectura de la tabla de mensajes desde el panel.
--    >>> Cambiá  <TABLA_MENSAJES>  por el nombre real de tu tabla <<<
--    Si RLS ya está activo y no hay policy de lectura, el panel no verá nada.
--
-- alter table public.<TABLA_MENSAJES> enable row level security;
-- drop policy if exists camila_mensajes_select on public.<TABLA_MENSAJES>;
-- create policy camila_mensajes_select on public.<TABLA_MENSAJES>
--   for select using (true);
