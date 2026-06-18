# 🇹🇩 TchadOpportunité

> Plateforme numérique de référence pour le recrutement, la mise en relation professionnelle et les services au Tchad.

---

## 📱 Présentation

**TchadOpportunité** est une application mobile moderne qui connecte :
- 👤 **Clients** — à la recherche de prestataires qualifiés
- 🔧 **Prestataires** — qui proposent leurs compétences et services
- 🏢 **Entreprises** — qui recrutent des talents et publient des offres
- ⚙️ **Administrateurs** — qui supervisent la plateforme

---

## 🛠️ Technologies

### Frontend
- **Flutter** (Dart) + Riverpod
- Google Maps API
- Firebase Authentication
- Socket.io (temps réel)
- Cloudinary (stockage images)
- Hive + SharedPreferences (cache local)

### Backend
- **Node.js** + Express.js
- **PostgreSQL** + Prisma ORM
- Socket.io
- Firebase Admin SDK
- Cloudinary

---

## 🚀 Fonctionnalités

- ✅ Authentification (Email/Password + Google)
- ✅ 4 rôles : Client, Prestataire, Entreprise, Admin
- ✅ Multilingue : Français, Anglais, Arabe (RTL)
- ✅ Mode clair / Mode sombre
- ✅ Offres d'emploi (CRUD + candidatures)
- ✅ Messagerie temps réel (Socket.io)
- ✅ Carte interactive (Google Maps)
- ✅ Système d'avis et notations
- ✅ Favoris (offres, prestataires)
- ✅ Notifications (centre + push)
- ✅ Upload photos (Cloudinary)
- ✅ Profils différenciés par rôle

---

## ⚙️ Installation

### Prérequis
- Flutter SDK (dernière version stable)
- Node.js 18+
- PostgreSQL 14+
- Compte Firebase
- Compte Cloudinary
- Clé API Google Maps

### Backend

```bash
cd tchadopportunite_backend
npm install
cp .env.example .env
# Remplir les variables dans .env
npx prisma migrate dev
npm run dev
```

### Flutter

```bash
cd flutter_app
flutter pub get
flutter run
```

---

## 🔐 Variables d'environnement

Copie `.env.example` vers `.env` et remplis les valeurs :

```
PORT=3000
DATABASE_URL=postgresql://...
JWT_SECRET=...
FIREBASE_PROJECT_ID=...
CLOUDINARY_CLOUD_NAME=...
```

---

## 📁 Structure du projet

```
tchadopportunite/
├── src/                    # Backend Node.js
│   ├── controllers/        # Logique métier
│   ├── routes/             # Routes API
│   ├── middlewares/        # Auth, validation
│   ├── config/             # Firebase, Cloudinary, JWT
│   └── sockets/            # Socket.io
├── prisma/                 # Schema + migrations PostgreSQL
├── lib/                    # Application Flutter
│   ├── core/               # Config, thème, routes, services
│   └── features/           # Modules (auth, jobs, messaging...)
└── .env.example            # Variables d'environnement
```

---

## 📡 API Endpoints

| Méthode | Route | Description |
|---------|-------|-------------|
| POST | `/api/auth/register` | Inscription |
| POST | `/api/auth/login` | Connexion |
| GET | `/api/jobs` | Liste des offres |
| POST | `/api/jobs` | Créer une offre |
| POST | `/api/jobs/:id/apply` | Postuler |
| GET | `/api/messages/conversations` | Conversations |
| GET | `/api/notifications` | Notifications |
| POST | `/api/upload/photo` | Upload photo |
| GET | `/api/favorites` | Mes favoris |
| POST | `/api/reviews` | Laisser un avis |

---

## 👨‍💻 Auteur

**Ali Alifa** — [@alkhassimalifa-jpg](https://github.com/alkhassimalifa-jpg)

---

## 📄 Licence

Ce projet est privé et propriétaire. Tous droits réservés © 2026 TchadOpportunité.