const express = require('express');
const router = express.Router();

// Route de test
router.get('/', (req, res) => {
  res.json({ message: 'Liste des utilisateurs (temporaire)' });
});

module.exports = router;