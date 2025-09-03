-- INSERT card (respecte NOT NULL connus : content, content_type, etc.)
INSERT INTO cards (title, content, content_type, source_domain, tags)
VALUES ('SMOKE_V002_CARD', '', 'note', 'example.com', ARRAY['smoke','attachments'])
RETURNING id;

-- INSERT attachment (référence de fichier, pas de binaire)
INSERT INTO attachments (filename, mime, size_bytes, checksum, storage_key)
VALUES ('example.txt', 'text/plain', 12, 'd41d8cd98f00b204e9800998ecf8427e', 'smoke/example.txt')
RETURNING id;

-- Lier la pièce jointe à la carte via des critères simples et stables
INSERT INTO card_attachments (card_id, attachment_id, position)
SELECT c.id, a.id, 0
FROM cards c
JOIN attachments a ON a.storage_key = 'smoke/example.txt'
WHERE c.title = 'SMOKE_V002_CARD';

-- UPDATE du meta JSONB sur la carte (vérifier l’index GIN posé en v002)
UPDATE cards
SET meta = jsonb_set(COALESCE(meta, '{}'::jsonb), '{source}', '"smoke"'::jsonb)
WHERE title = 'SMOKE_V002_CARD'
RETURNING id, meta;

-- SELECT de vérification : attachment par storage_key
SELECT id, filename, mime, size_bytes, storage_key
FROM attachments
WHERE storage_key = 'smoke/example.txt'
ORDER BY created_at DESC
LIMIT 1;

-- SELECT de vérification : attachments d’une carte (ordre par position)
SELECT ca.card_id, ca.attachment_id, ca.position
FROM card_attachments ca
JOIN cards c ON c.id = ca.card_id
WHERE c.title = 'SMOKE_V002_CARD'
ORDER BY ca.position ASC;

-- UPDATE de l’attachment order (ex. position -> 1) pour valider le trigger/timestamps
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

-- UPDATE de la carte (doit bumper updated_at via trigger si défini sur les liaisons)
UPDATE cards
SET title = 'SMOKE_V002_CARD_v2'
WHERE title = 'SMOKE_V002_CARD'
RETURNING id, created_at, updated_at;
