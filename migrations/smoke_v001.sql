-- INSERT test
INSERT INTO cards (title, content, content_type, source_domain, tags)
VALUES ('Hello', 'World', 'note', 'example.com', ARRAY['angular','express'])
RETURNING id;

-- SELECT par domaine
SELECT id, title FROM cards WHERE source_domain = 'example.com'
ORDER BY updated_at DESC
LIMIT 10;

-- SELECT par tag
SELECT id, title FROM cards WHERE 'angular' = ANY(tags)
ORDER BY updated_at DESC
LIMIT 10;

-- UPDATE test
UPDATE cards SET title = 'Hello v2'
WHERE title = 'Hello'
RETURNING id, created_at, updated_at;
