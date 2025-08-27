# 🧠 Memo-Connect – Backend Express.js

> API REST construite avec Node.js et Express  
> Gère les données de cartes, utilisateurs (à venir), et communications avec le frontend Angular.

> 🛠️ Ce projet est en développement continu. Des fonctionnalités sont encore en cours d’implémentation, et l’architecture peut évoluer. N’hésitez pas à suivre son avancement ou proposer des contributions !
---

## ⚙️ Fonctionnalités

- API REST pour les cartes de révision
- Architecture modulaire (routes, contrôleurs, middlewares)
- Connexion prévue à MongoDB
- Authentification à venir (JWT)
- Tests à venir (unitaires et intégration)

---

## 🚀 Démarrage rapide

### 1. Cloner le dépôt (ou accéder au dossier /server si le projet est déjà cloné)

```bash
git clone https://github.com/ton-utilisateur/memo-connect-server.git
cd memo-connect-server
```

### 2. Installer les dépendances

```bash
npm install
```

### 3. Lancer le serveur local

```bash
node server.js
```

Le serveur sera disponible à l’adresse suivante :  
👉 http://localhost:3000

> Il est utilisé par le frontend Angular (port 4200) pour effectuer les appels API.

---

## 🔗 Exemple de routes API

- `GET /api/cards` → Retourne un message de test ou les cartes (selon l’implémentation)
- `POST /api/cards` → Ajouter une carte
- `PUT /api/cards/:id` → Modifier une carte
- `DELETE /api/cards/:id` → Supprimer une carte

> Toutes les routes sont définies dans le fichier `/routes/cards.routes.js`

---

## 📁 Structure du projet

```
server/
├── controllers/       → Logique métier (à venir)
├── routes/            → Fichiers de routes Express
│   └── cards.routes.js
├── middlewares/       → Middleware personnalisés (à venir)
├── models/            → Schémas de données (MongoDB)
├── utils/             → Fonctions utilitaires (à venir)
├── server.js          → Point d’entrée du serveur
└── README.md          → Ce fichier
```

---

## 🧪 Tests

Des tests unitaires et de routes seront ajoutés avec Jest ou Supertest.  
(Non encore inclus pour l’instant.)

---

## 🔐 Authentification

À venir :  
- Authentification par JSON Web Tokens (JWT)  
- Middleware de vérification d’accès

---

## 📌 Statut du projet

🧩 Ce projet est en **développement continu**.  
Des fonctionnalités majeures sont en cours d’implémentation côté backend (authentification, base de données, sécurité, tests…).

---
## Base de données (PostgreSQL Neon)

MemoConnect utilise **PostgreSQL hébergé sur Neon**.  
Cela permet d’avoir une base de données cloud disponible partout, sans dépendre de Docker ou d’une installation locale.

### Configuration

Les informations de connexion sont fournies via les variables d’environnement.  
Crée un fichier `.env` à la racine de `server/` (non versionné) en t’inspirant de `.env.example`.

Exemple `.env` :
```env
PORT=3000
DB_URL=postgresql://USER:PASSWORD@HOST:5432/DBNAME?sslmode=require


## 📫 Contact

Développé par **Jean-François Duval**  
💼 [LinkedIn](https://www.linkedin.com/in/jean-francois-duval-web)  
📧 [jfduval.web@outlook.com](mailto:jfduval.web@outlook.com)
