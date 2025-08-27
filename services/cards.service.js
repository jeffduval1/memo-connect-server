const CardModel = require('../models/card.model');

class CardsService {
  getAll() { return CardModel.findAll(); }
  getOne(id) { return CardModel.findById(id); }
  create(data) { return CardModel.create(data); }
  update(id, data) { return CardModel.update(id, data); }
  delete(id) { return CardModel.delete(id); }
}

module.exports = new CardsService();
