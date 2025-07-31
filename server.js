// server/server.js
const express = require('express');
const cors = require('cors');
const morgan = require('morgan');
const path = require('path');

// Import des routes
const cardsRoutes = require('./routes/cards.routes');
const usersRoutes = require('./routes/users.routes'); // exemple futur

console.log('cardsRoutes =', cardsRoutes);
console.log('usersRoutes =', usersRoutes);

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(morgan('dev')); // Logger simple

// Routes API
app.use('/api/cards', cardsRoutes);
app.use('/api/users', usersRoutes); // placeholder pour expansion

// Route de test
app.get('/api/ping', (req, res) => {
  res.json({ message: 'pong 🏓' });
});

// Gestion des erreurs 404
app.use((req, res, next) => {
  res.status(404).json({ error: 'Route non trouvée' });
});

// Gestion des erreurs serveur
app.use((err, req, res, next) => {
  console.error('Erreur interne :', err.stack);
  res.status(500).json({ error: 'Erreur serveur' });
});

// Lancement du serveur
app.listen(port, () => {
  console.log(`✅ Serveur Express démarré sur http://localhost:${port}`);
});
