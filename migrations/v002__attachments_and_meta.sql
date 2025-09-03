-- v002_attachments_and_meta.sql
-- Étend cards avec meta JSONB + tables attachments et card_attachments
BEGIN;

-- 1) Colonne meta sur cards
ALTER TABLE public.cards
  ADD COLUMN IF NOT EXISTS meta JSONB NOT NULL DEFAULT '{}'::jsonb;

-- Index GIN sur meta pour les futures recherches
CREATE INDEX IF NOT EXISTS idx_cards_meta_gin ON public.cards USING GIN (meta);

-- 2) Table attachments (référence de fichiers, pas de binaire)
CREATE TABLE IF NOT EXISTS public.attachments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  filename      TEXT      NOT NULL,
  mime          TEXT      NOT NULL,
  size_bytes    INTEGER   NOT NULL CHECK (size_bytes >= 0 AND size_bytes <= 20000000),
  checksum      TEXT,
  storage_key   TEXT      NOT NULL UNIQUE,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 3) Table de liaison carte ↔ pièce jointe
CREATE TABLE IF NOT EXISTS public.card_attachments (
  card_id       UUID NOT NULL REFERENCES public.cards(id) ON DELETE CASCADE,
  attachment_id UUID NOT NULL REFERENCES public.attachments(id) ON DELETE RESTRICT,
  position      INTEGER NOT NULL DEFAULT 0 CHECK (position >= 0),
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (card_id, attachment_id)
);

-- Index utile pour l'ordre d’affichage
CREATE INDEX IF NOT EXISTS idx_card_attachments_card_pos
  ON public.card_attachments (card_id, position);

-- 4) Trigger: maintenir updated_at de card_attachments
CREATE OR REPLACE FUNCTION set_card_attachments_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END $$;

DROP TRIGGER IF EXISTS trg_card_attachments_touch ON public.card_attachments;
CREATE TRIGGER trg_card_attachments_touch
BEFORE UPDATE ON public.card_attachments
FOR EACH ROW EXECUTE FUNCTION set_card_attachments_updated_at();

-- 5) Triggers: bumper cards.updated_at si les liaisons changent
CREATE OR REPLACE FUNCTION bump_card_updated_at_from_attachments()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
  _card_id UUID;
BEGIN
  _card_id := COALESCE(NEW.card_id, OLD.card_id);
  UPDATE public.cards SET updated_at = now() WHERE id = _card_id;
  RETURN NULL;
END $$;

DROP TRIGGER IF EXISTS trg_bump_cards_on_card_attachments_ins ON public.card_attachments;
CREATE TRIGGER trg_bump_cards_on_card_attachments_ins
AFTER INSERT ON public.card_attachments
FOR EACH ROW EXECUTE FUNCTION bump_card_updated_at_from_attachments();

DROP TRIGGER IF EXISTS trg_bump_cards_on_card_attachments_upd ON public.card_attachments;
CREATE TRIGGER trg_bump_cards_on_card_attachments_upd
AFTER UPDATE ON public.card_attachments
FOR EACH ROW EXECUTE FUNCTION bump_card_updated_at_from_attachments();

DROP TRIGGER IF EXISTS trg_bump_cards_on_card_attachments_del ON public.card_attachments;
CREATE TRIGGER trg_bump_cards_on_card_attachments_del
AFTER DELETE ON public.card_attachments
FOR EACH ROW EXECUTE FUNCTION bump_card_updated_at_from_attachments();

COMMIT;
