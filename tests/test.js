const request = require('supertest');
const express = require('express');
const cardsRoutes = require('../routes/cards.routes');
const healthRoutes = require('../routes/health');

const app = express();
app.use(express.json());
app.use('/api/cards', cardsRoutes);
app.use('/api/health', healthRoutes);

describe('API Health', () => {
  it('GET /api/health should return status ok', async () => {
    const res = await request(app).get('/api/health');
    expect(res.statusCode).toBe(200);
    expect(res.body).toEqual({ status: 'ok' });
  });
});

describe('API Cards', () => {
  it('GET /api/cards should return an array', async () => {
    const res = await request(app).get('/api/cards');
    expect(res.statusCode).toBe(200);
    expect(Array.isArray(res.body)).toBe(true);
  });

  it('POST /api/cards should create a new card', async () => {
    const newCard = { title: "Nouvelle carte", content: "Ceci est un test" };
    const res = await request(app).post('/api/cards').send(newCard);
    expect(res.statusCode).toBe(201);
    expect(res.body).toMatchObject(newCard);
  });
});
