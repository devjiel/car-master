# Configuration de Supabase

Ce projet utilise Supabase comme base de données. Voici comment configurer l'environnement local.

## Prérequis

- Docker et Docker Compose
- Git

## Installation de Supabase en local

1. Clonez le projet Supabase

```bash
git clone https://github.com/supabase/supabase
cd supabase/docker
```

2. Copiez le fichier exemple de configuration

```bash
cp .env.example .env
```

3. Démarrez Supabase

```bash
docker-compose up -d
```

Supabase sera disponible à l'adresse `http://localhost:8000`.

## Configuration de la base de données

1. Connectez-vous à l'interface de Supabase à l'adresse `http://localhost:8000`
2. Utilisez les identifiants par défaut (cf. fichier .env)

3. Récupérez votre clé anonyme dans l'interface (API section)

4. Importez le script SQL pour créer la table des voitures:

```sql
-- Créer la table cars
CREATE TABLE IF NOT EXISTS cars (
  id SERIAL PRIMARY KEY,
  brand TEXT NOT NULL,
  model TEXT NOT NULL,
  image_path TEXT NOT NULL,
  answer TEXT NOT NULL
);

-- Insérer des données de démonstration
INSERT INTO cars (brand, model, image_path, answer) VALUES
  ('Porsche', '911 GT3', 'assets/images/cars/porsche_911_gt3.webp', 'Porsche 911 GT3'),
  ('Ferrari', '488 Pista', 'assets/images/cars/ferrari_488_pista.webp', 'Ferrari 488 Pista'),
  ('Lamborghini', 'Huracan', 'assets/images/cars/lamborghini_huracan.jpg', 'Lamborghini Huracan'),
  ('McLaren', '720S', 'assets/images/cars/mcLaren 720S.jpg', 'McLaren 720S'),
  ('Aston Martin', 'DB11', 'assets/images/cars/aston_martin_db11.jpg', 'Aston Martin DB11');
```

## Configuration de l'application Flutter

1. Copiez le fichier `.env.example` vers `.env` dans le dossier `frontend`:

```bash
cd frontend
cp .env.example .env
```

2. Modifiez le fichier `.env` avec votre clé anonyme Supabase:

```
SUPABASE_URL=http://localhost:8000
SUPABASE_ANON_KEY=votre-clé-anonyme
```

3. Lancez l'application Flutter:

```bash
flutter run
```

L'application utilisera automatiquement les variables d'environnement définies dans le fichier `.env`. 