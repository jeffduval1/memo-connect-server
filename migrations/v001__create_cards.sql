-- Extensions nécessaires (Neon → pgcrypto recommandé, pas uuid-ossp)
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS cards (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  -- Contenu de base
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  content_type TEXT NOT NULL CHECK (content_type IN ('note','qa','snippet','markdown','html')),

  -- Métadonnées source
  source_title TEXT,
  source_url TEXT,
  source_domain TEXT,

  -- Organisation
  tags TEXT[] NOT NULL DEFAULT '{}',
  category_id UUID NULL
);

-- Index
CREATE INDEX IF NOT EXISTS idx_cards_title ON cards (title);
CREATE INDEX IF NOT EXISTS idx_cards_source_domain ON cards (source_domain);
CREATE INDEX IF NOT EXISTS idx_cards_updated_at ON cards (updated_at DESC);
CREATE INDEX IF NOT EXISTS idx_cards_tags_gin ON cards USING GIN (tags);

-- Trigger pour updated_at
CREATE OR REPLACE FUNCTION set_updated_at() RETURNS trigger AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END $$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_cards_updated ON cards;
CREATE TRIGGER trg_cards_updated
BEFORE UPDATE ON cards
FOR EACH ROW EXECUTE PROCEDURE set_updated_at();
