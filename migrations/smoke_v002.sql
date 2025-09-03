-- INSERT card (respecte NOT NULL)
INSERT INTO cards (title, content, content_type, source_domain, tags)
VALUES ('SMOKE_V002_CARD', '', 'note', 'example.com', ARRAY['smoke','attachments'])
RETURNING id;

-- INSERT attachment (idempotent)
INSERT INTO attachments (filename, mime, size_bytes, checksum, storage_key)
VALUES ('example.txt', 'text/plain', 12, 'd41d8cd98f00b204e9800998ecf8427e', 'smoke/example.txt')
ON CONFLICT (storage_key) DO NOTHING;

-- Récupérer l’attachment (fonctionne 1re et n-ième exécution)
SELECT id, filename, mime, size_bytes, storage_key
FROM attachments
WHERE storage_key = 'smoke/example.txt'
ORDER BY created_at DESC
LIMIT 1;

-- Lier attachment ↔ card (idempotent)
INSERT INTO card_attachments (card_id, attachment_id, position)
SELECT c.id, a.id, 0
FROM (SELECT id FROM cards WHERE title = 'SMOKE_V002_CARD' ORDER BY created_at DESC LIMIT 1) c
CROSS JOIN (SELECT id FROM attachments WHERE storage_key = 'smoke/example.txt' ORDER BY created_at DESC LIMIT 1) a
ON CONFLICT (card_id, attachment_id) DO NOTHING
RETURNING card_id, attachment_id, position;

-- Mettre à jour meta JSONB de la carte
UPDATE cards
SET meta = jsonb_set(COALESCE(meta, '{}'::jsonb), '{source}', '"smoke"'::jsonb)
WHERE id = (SELECT id FROM cards WHERE title = 'SMOKE_V002_CARD' ORDER BY created_at DESC LIMIT 1)
RETURNING id, meta;

-- SELECT par domaine (comme v001)
SELECT id, title FROM cards
WHERE source_domain = 'example.com'
ORDER BY updated_at DESC
LIMIT 10;

-- SELECT par tag (comme v001)
SELECT id, title FROM cards
WHERE 'smoke' = ANY(tags)
ORDER BY updated_at DESC
LIMIT 10;

-- Vérifier la liaison (ordre par position)
SELECT ca.card_id, ca.attachment_id, ca.position
FROM card_attachments ca
JOIN cards c ON c.id = ca.card_id
WHERE c.title = 'SMOKE_V002_CARD'
ORDER BY ca.position ASC;

-- (Optionnel) Changer la position pour valider la mise à jour
UPDATE card_attachments
SET position = 1
WHERE (card_id, attachment_id) IN (
  SELECT ca.card_id, ca.attachment_id
  FROM card_attachments ca
  JOIN cards c ON c.id = ca.card_id
  JOIN attachments a ON a.id = ca.attachment_id
  WHERE c.title = 'SMOKE_V002_CARD' AND a.storage_key = 'smoke/example.txt'
)
RETURNING card_id, attachment_id, position;

-- Vérifier meta (clé)
SELECT id, title FROM cards
WHERE meta ? 'source'
ORDER BY updated_at DESC
LIMIT 10;

-- Vérifier meta (paire clé/valeur)
SELECT id, title FROM cards
WHERE meta @> '{"source":"smoke"}'
ORDER BY updated_at DESC
LIMIT 10;

-- UPDATE test — bumper updated_at (comme v001)
UPDATE cards
SET title = 'SMOKE_V002_CARD_v2'
WHERE title = 'SMOKE_V002_CARD'
RETURNING id, created_at, updated_at;

-- Vérifier l’index GIN sur meta (sanity check non bloquant)
SELECT indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'public' AND tablename = 'cards' AND indexname = 'idx_cards_meta_gin';
