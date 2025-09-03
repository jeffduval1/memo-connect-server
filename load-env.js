// server/load-env.js
const fs = require('fs');
const path = require('path');
const dotenv = require('dotenv');

const envPath = path.resolve(__dirname, '../utils/.env.development');

function loadEnvFile(filePath) {
  if (!fs.existsSync(filePath)) {
    console.error('[env-loader] File not found:', filePath);
    return {};
  }
  const raw = fs.readFileSync(filePath);        // Buffer brut
  // 1) Essai UTF-8
  let text = raw.toString('utf8');
  let conf = dotenv.parse(text);
  if (Object.keys(conf).length > 0) return conf;

  // 2) Essai UTF-16 LE (classique Notepad Windows)
  try {
    text = raw.toString('utf16le');
    conf = dotenv.parse(text);
    if (Object.keys(conf).length > 0) return conf;
  } catch (_) {}

  return {};
}

const conf = loadEnvFile(envPath);
Object.entries(conf).forEach(([k, v]) => (process.env[k] = v));

console.log('[env-loader] file =', envPath);
console.log('[env-loader] keys  =', Object.keys(conf));
