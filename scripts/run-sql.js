// server/scripts/run-sql.js
const { Client } = require("pg");
const fs = require("fs");
const path = require("path");

// Récupère le fichier SQL en argument (ex: v001__create_cards.sql)
const file = process.argv[2];
if (!file) {
  console.error("❌ Usage: node scripts/run-sql.js <migration-file.sql>");
  process.exit(1);
}

const sqlPath = path.resolve(__dirname, "..", "migrations", file);
const sql = fs.readFileSync(sqlPath, "utf-8");

// Connexion à Neon via DATABASE_URL
const client = new Client({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }, // Neon requiert SSL
});

(async () => {
  try {
    await client.connect();
    console.log(`🚀 Running migration: ${file}`);
    await client.query(sql);
    console.log("✅ Migration executed successfully.");
  } catch (err) {
    console.error("❌ Migration failed:", err);
  } finally {
    await client.end();
  }
})();
