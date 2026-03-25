# 📚 Personal Library (Swift + Hummingbird)

Une application web complète développée en **Swift** avec le framework **Hummingbird**, permettant de gérer une bibliothèque personnelle avec :

- Interface web (HTML/CSS)
- API REST
- Authentification utilisateur
- Base de données SQLite
- Documentation Swagger

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
- Tri (titre, note, favoris)

### 📊 Statistiques
- Nombre total de livres
- Nombre de livres lus
- Nombre de favoris
- Moyenne des notes

### 🔐 Authentification
- Inscription (register)
- Connexion (login)
- Session via cookie
- Logout
- Protection des routes

### 🌙 UI moderne
- Dark mode
- Messages de succès
- Interface responsive (PicoCSS)

---

## 🌐 API REST
# 📚 Personal Library (Swift + Hummingbird)

Une application web complète développée en **Swift** avec le framework **Hummingbird**, permettant de gérer une bibliothèque personnelle avec :

- Interface web (HTML/CSS)
- API REST
- Authentification utilisateur
- Base de données SQLite
- Documentation Swagger

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
- Tri (titre, note, favoris)

### 📊 Statistiques
- Nombre total de livres
- Nombre de livres lus
- Nombre de favoris
- Moyenne des notes

### 🔐 Authentification
- Inscription (register)
- Connexion (login)
- Session via cookie
- Logout
- Protection des routes

### 🌙 UI moderne
- Dark mode
- Messages de succès
- Interface responsive (PicoCSS)

---

## 🌐 API REST

Base URL :/api/books

### Endpoints

| Méthode | Route              | Description              |
|--------|--------------------|--------------------------|
| GET    | /api/books         | Liste des livres         |
| POST   | /api/books         | Ajouter un livre         |
| GET    | /api/books/{id}    | Détail d’un livre        |
| DELETE | /api/books/{id}    | Supprimer un livre       |

---

## 📘 Swagger (Documentation API)

Accessible ici : 
### Endpoints

| Méthode | Route              | Description              |
|--------|--------------------|--------------------------|
| GET    | /api/books         | Liste des livres         |
| POST   | /api/books         | Ajouter un livre         |
| GET    | /api/books/{id}    | Détail d’un livre        |
| DELETE | /api/books/{id}    | Supprimer un livre       |

---

## 📘 Swagger (Documentation API)

Accessible ici :

### Endpoints

| Méthode | Route              | Description              |
|--------|--------------------|--------------------------|
| GET    | /api/books         | Liste des livres         |
| POST   | /api/books         | Ajouter un livre         |
| GET    | /api/books/{id}    | Détail d’un livre        |
| DELETE | /api/books/{id}    | Supprimer un livre       |

---

## 📘 Swagger (Documentation API)

Accessible ici :/swagger

Permet de :
- tester les endpoints
- voir la structure JSON
- documenter l’API

---

## 🛠️ Stack technique

- Swift
- Hummingbird (serveur web)
- SQLite
- HTML / CSS (PicoCSS)
- OpenAPI / Swagger

---

## ▶️ Lancer le projet

```bash
./build.sh
./run.sh

Puis ouvrir : http://localhost:8080

ou (Codespaces) :https://xxxxx.app.github.dev

Authentification
Aller sur /register
Créer un compte
Se connecter via /login
Accéder à l’application

Structure du projet
Sources/App/
├── main.swift        → Routes + API + Auth
├── Database.swift    → SQLite
├── Models.swift      → Book / User
├── Views.swift       → HTML UI

Limites actuelles
Mot de passe non chiffré (dev uniquement)
Pas de JWT (session simple)
Pas de pagination API
Pas de validation avancée

Améliorations possibles
Hash des mots de passe (bcrypt)
JWT Auth
Pagination API
Frontend React
Docker
Déploiement cloud

Auteur

Projet réalisé par belkacemi hanafi nazim dans le cadre d’un apprentissage Swift backend + web.



Base URL :
