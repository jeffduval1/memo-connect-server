let cards = [
    { id: 1, title: "Première carte", content: "Ceci est un mock" },
    { id: 2, title: "Deuxième carte", content: "Encore un mock" }
  ];
  
  class CardModel {
    static findAll() {
      return cards;
    }
    static findById(id) {
      return cards.find(c => c.id === Number(id));
    }
    static create(data) {
      const newCard = { id: Date.now(), ...data };
      cards.push(newCard);
      return newCard;
    }
    static update(id, data) {
      const index = cards.findIndex(c => c.id === Number(id));
      if (index === -1) return null;
      cards[index] = { ...cards[index], ...data };
      return cards[index];
    }
    static delete(id) {
      const index = cards.findIndex(c => c.id === Number(id));
      if (index === -1) return null;
      return cards.splice(index, 1)[0];
    }
  }
  
  module.exports = CardModel;
  