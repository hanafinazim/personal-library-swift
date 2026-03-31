# 📚 Personal Library (Swift + Hummingbird)

Une application web complète développée en **Swift** avec le framework **Hummingbird**, permettant de gérer une bibliothèque personnelle.

---

## 🚀 Fonctionnalités

### 📖 Gestion des livres
- Ajouter un livre
- Modifier un livre
- Supprimer un livre
- Marquer comme lu
- Ajouter aux favoris

### 🔍 Recherche & filtres
- Recherche par titre, auteur ou genre
- Filtre par note
- Filtre favoris
- Filtre lu / non lu
- Tri des livres

### 📊 Statistiques
- Nombre total de livres
- Nombre de livres lus
- Nombre de favoris
- Moyenne des notes

### 🔐 Authentification web
- Inscription (`/register`)
- Connexion (`/login`)
- Déconnexion (`/logout`)
- Session via cookie
- Protection des routes

### 🔐 Authentification API (JWT)
- Endpoint `/api/login`
- Génération d’un token JWT
- Protection des routes API avec Bearer Token

### 🌙 Interface utilisateur
- Dark mode
- Messages de succès
- Interface simple et responsive (PicoCSS)

### 📘 Documentation API
- Swagger UI
- OpenAPI JSON

---
# 📚 Personal Library (Swift + Hummingbird)

Une application web complète développée en **Swift** avec le framework **Hummingbird**, permettant de gérer une bibliothèque personnelle.

---

## 🚀 Fonctionnalités

### 📖 Gestion des livres
- Ajouter un livre
- Modifier un livre
- Supprimer un livre
- Marquer comme lu
- Ajouter aux favoris

### 🔍 Recherche & filtres
- Recherche par titre, auteur ou genre
- Filtre par note
- Filtre favoris
- Filtre lu / non lu
- Tri des livres

### 📊 Statistiques
- Nombre total de livres
- Nombre de livres lus
- Nombre de favoris
- Moyenne des notes

### 🔐 Authentification web
- Inscription (`/register`)
- Connexion (`/login`)
- Déconnexion (`/logout`)
- Session via cookie
- Protection des routes

### 🔐 Authentification API (JWT)
- Endpoint `/api/login`
- Génération d’un token JWT
- Protection des routes API avec Bearer Token

### 🌙 Interface utilisateur
- Dark mode
- Messages de succès
- Interface simple et responsive (PicoCSS)

### 📘 Documentation API
- Swagger UI
- OpenAPI JSON

---

## 🌐 API REST

### Base URL
## 🌐 API REST

### Base URL
/api/books


### Endpoints

| Méthode | Route              | Description |
|--------|--------------------|-------------|
| POST   | `/api/login`       | Obtenir un token JWT |
| GET    | `/api/books`       | Liste des livres |
| POST   | `/api/books`       | Ajouter un livre |
| GET    | `/api/books/{id}`  | Détail d’un livre |
| DELETE | `/api/books/{id}`  | Supprimer un livre |

---

## 📘 Swagger

Accessible ici : /swagger
OpenAPI : /openapi.json

## 🛠️ Stack technique

- Swift
- Hummingbird
- SQLite
- JWTKit
- HummingbirdBcrypt
- HTML / CSS (PicoCSS)
- Swagger / OpenAPI

---

## ▶️ Lancer le projet

```bash
./build.sh
./run.sh
Puis ouvrir :http://localhost:8080

🔐 Authentification API
Obtenir un token
curl -X POST http://127.0.0.1:8080/api/login \
-H "Content-Type: application/json" \
-d '{"username":"aziz","password":"motdepasse"}'

Utiliser le token
curl http://127.0.0.1:8080/api/books \
-H "Authorization: Bearer TON_TOKEN"

Structure du projet
Sources/App/
├── main.swift        # Routes + API + JWT + Swagger
├── Database.swift    # SQLite + logique métier
├── Models.swift      # Book, User, JWT
└── Views.swift       # HTML UI

Sécurité
Mots de passe hashés avec Bcrypt
API sécurisée avec JWT
Sessions web avec cookies

Limites
Pas de pagination
Pas de rôles utilisateur
Pas de refresh token JWT
Secret JWT en dur (dev uniquement)

Améliorations possibles
Pagination API
Rôles utilisateur (admin)
Refresh token
Dockerisation
Déploiement cloud
Frontend React
Tests unitaires

Auteur
Projet réalisé par belkacemi hanafi nazim
### Base URL
