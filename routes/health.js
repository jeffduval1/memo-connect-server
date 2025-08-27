const express = require('express');
const router = express.Router();
const { Pool } = require('pg');

const pool = new Pool({
  connectionString: process.env.DB_URL,
  ssl: { rejectUnauthorized: false }
});

// GET /api/health
router.get('/', (req, res) => {
  res.json({ status: 'ok' });
});

// GET /api/health/env
router.get('/env', (req, res) => {
  res.json({
    status: 'ok',
    env: process.env.NODE_ENV,
    port: process.env.PORT
  });
});

// GET /api/health/db
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
