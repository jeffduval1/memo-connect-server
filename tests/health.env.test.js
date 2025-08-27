require('dotenv-flow').config({
    node_env: 'test',
    purge_dotenv: true
  });
const request = require('supertest');
const express = require('express');
const healthRoutes = require('../routes/health');

const app = express();
app.use('/api/health', healthRoutes);

describe('GET /api/health/env', () => {
  it('should return env info without secrets', async () => {
    const res = await request(app).get('/api/health/env');

    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty('status', 'ok');
    expect(res.body).toHaveProperty('env');
    expect(res.body).toHaveProperty('port');
    expect(res.body).not.toHaveProperty('DB_URL');
    expect(res.body).not.toHaveProperty('JWT_SECRET');
  });
});
