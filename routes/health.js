const express = require('express');
const router = express.Router();
const { Pool } = require('pg');

const pool = new Pool({
  connectionString: process.env.DB_URL,
  ssl: { rejectUnauthorized: false }
});

// Endpoint de base
router.get('/', (req, res) => {
  res.json({ status: 'ok' });
});

// Endpoint pour tester la connexion DB
router.get('/db', async (req, res) => {
  try {
    await pool.query('SELECT 1');
    res.json({ status: 'ok', db: true });
  } catch (err) {
    console.error('Erreur DB :', err);
    res.status(500).json({ status: 'error', db: false });
  }
});

module.exports = router;
