-- ==========================================
-- ASSORIPA - BANCO DE DADOS
-- ==========================================

-- 1. Tabela dos animais
create table if not exists public.dogs (
    id uuid primary key default gen_random_uuid(),

    name text not null,

    age text,

    gender text,

    description text,

    photo_url text,

    status text not null default 'disponivel',

    created_at timestamptz not null default now()
);


-- 2. Segurança da tabela
alter table public.dogs enable row level security;


-- 3. Visitantes podem visualizar os animais
create policy "Public can view dogs"
on public.dogs
for select
to anon, authenticated
using (true);


-- 4. Administrador logado pode cadastrar animais
create policy "Authenticated can insert dogs"
on public.dogs
for insert
to authenticated
with check (true);


-- 5. Administrador logado pode alterar animais
create policy "Authenticated can update dogs"
on public.dogs
for update
to authenticated
using (true)
with check (true);


-- 6. Administrador logado pode excluir animais
create policy "Authenticated can delete dogs"
on public.dogs
for delete
to authenticated
using (true);


-- ==========================================
-- ARMAZENAMENTO DAS FOTOS
-- ==========================================

-- Criar área pública para as fotos
insert into storage.buckets
(id, name, public)
values
('dogs', 'dogs', true)
on conflict (id) do nothing;


-- Visitantes podem visualizar fotos
create policy "Public can view dog photos"
on storage.objects
for select
to anon, authenticated
using (
    bucket_id = 'dogs'
);


-- Usuários autenticados podem enviar fotos
create policy "Authenticated can upload dog photos"
on storage.objects
for insert
to authenticated
with check (
    bucket_id = 'dogs'
);


-- Usuários autenticados podem atualizar fotos
create policy "Authenticated can update dog photos"
on storage.objects
for update
to authenticated
using (
    bucket_id = 'dogs'
)
with check (
    bucket_id = 'dogs'
);


-- Usuários autenticados podem excluir fotos
create policy "Authenticated can delete dog photos"
on storage.objects
for delete
to authenticated
using (
    bucket_id = 'dogs'
);
