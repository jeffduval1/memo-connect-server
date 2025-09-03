-- v002_down.sql
-- Rollback de v002 : supprime la zone attachments/meta
BEGIN;

-- Supprimer triggers d’abord
DROP TRIGGER IF EXISTS trg_bump_cards_on_card_attachments_del ON public.card_attachments;
DROP TRIGGER IF EXISTS trg_bump_cards_on_card_attachments_upd ON public.card_attachments;
DROP TRIGGER IF EXISTS trg_bump_cards_on_card_attachments_ins ON public.card_attachments;
DROP FUNCTION IF EXISTS bump_card_updated_at_from_attachments();

DROP TRIGGER IF EXISTS trg_card_attachments_touch ON public.card_attachments;
DROP FUNCTION IF EXISTS set_card_attachments_updated_at();

-- Drop des tables de liaison puis fichiers
DROP TABLE IF EXISTS public.card_attachments;
DROP TABLE IF EXISTS public.attachments;

-- Retrait des index et colonne meta
DROP INDEX IF EXISTS idx_cards_meta_gin;
ALTER TABLE public.cards DROP COLUMN IF EXISTS meta;

COMMIT;
