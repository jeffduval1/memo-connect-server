const express = require('express');
const router = express.Router();

// Exemple : GET /api/cards
router.get('/', (req, res) => {
  res.json({ message: 'Bienvenue sur l’API des cartes 🎴' });
});

// Tu pourras ajouter d’autres routes ici plus tard :
// router.post('/', ...);
// router.put('/:id', ...);
// router.delete('/:id', ...);

module.exports = router;
