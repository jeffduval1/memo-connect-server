const cardsService = require('../services/cards.service');

exports.getAll = (req, res) => {
  res.json(cardsService.getAll());
};

exports.getOne = (req, res) => {
  const card = cardsService.getOne(req.params.id);
  if (!card) return res.status(404).json({ error: "Carte non trouvée" });
  res.json(card);
};

exports.create = (req, res) => {
  const newCard = cardsService.create(req.body);
  res.status(201).json(newCard);
};

exports.update = (req, res) => {
  const updatedCard = cardsService.update(req.params.id, req.body);
  if (!updatedCard) return res.status(404).json({ error: "Carte non trouvée" });
  res.json(updatedCard);
};

exports.delete = (req, res) => {
  const deletedCard = cardsService.delete(req.params.id);
  if (!deletedCard) return res.status(404).json({ error: "Carte non trouvée" });
  res.json(deletedCard);
};
