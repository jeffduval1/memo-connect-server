const request = require('supertest');
const express = require('express');
const healthRoutes = require('../routes/health');

const app = express();
app.use('/api/health', healthRoutes);

describe('API Health', () => {
  it('GET /api/health should return status ok', async () => {
    const res = await request(app).get('/api/health');
    expect(res.statusCode).toBe(200);
    expect(res.body).toEqual({ status: 'ok' });
  });
});
