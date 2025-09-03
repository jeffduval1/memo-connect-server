-- smoke_v002.sql
-- Vérifie insertion attachment + liaison + update meta + EXPLAIN sur meta
BEGIN;

-- 1) Créer une carte d’essai
INSERT INTO public.cards (id, title, created_at, updated_at)
VALUES (gen_random_uuid(), 'Card v002 smoke', now(), now())
RETURNING id \gset

-- 2) Créer une pièce jointe
INSERT INTO public.attachments (filename, mime, size_bytes, checksum, storage_key)
VALUES ('example.txt', 'text/plain', 12, 'd41d8cd98f00b204e9800998ecf8427e',
        concat('cards/', :'id', '/attachments/example.txt'))
RETURNING id \gset

-- 3) Lier la pièce jointe à la carte
INSERT INTO public.card_attachments (card_id, attachment_id, position)
VALUES (:'id', :'id1', 0);

-- 4) MAJ du meta
UPDATE public.cards
SET meta = jsonb_set(meta, '{source}', '"manual"')
WHERE id = :'id';

-- 5) EXPLAIN : test rapide de l’index GIN sur meta
EXPLAIN SELECT id FROM public.cards WHERE meta ? 'source';

-- 6) Vérifier que updated_at de la carte a bougé à cause de la liaison
SELECT updated_at FROM public.cards WHERE id = :'id';

-- Pas de persistance en base pour le smoke
ROLLBACK;
