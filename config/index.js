console.log('NODE_ENV =', process.env.NODE_ENV);
const { cleanEnv, str, port } = require('envalid');
require('dotenv-flow').config({
    node_env: process.env.NODE_ENV,
    purge_dotenv: true,
    silent: false
  });

const env = cleanEnv(process.env, {
  PORT: port({ default: 3000 }),
  DB_URL: str(),
  JWT_SECRET: str(),
});

module.exports = {
  port: env.PORT,
  dbUrl: env.DB_URL,
  jwtSecret: env.JWT_SECRET,
  nodeEnv: process.env.NODE_ENV || 'development'
};
