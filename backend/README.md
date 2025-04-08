# Supabase Configuration

This project uses Supabase as a database. Here's how to set up the local environment.

## Prerequisites

- Docker and Docker Compose
- Git

## Installing Supabase locally

1. Clone the Supabase project

```bash
git clone https://github.com/supabase/supabase
cd supabase/docker
```

2. Copy the example configuration file

```bash
cp .env.example .env
```

3. Start Supabase

```bash
docker-compose up -d
```

Supabase will be available at `http://localhost:8000`.

## Database Configuration

1. Log in to the Supabase interface at `http://localhost:8000`
2. Use the default credentials (see .env file)

3. Retrieve your anonymous key from the interface (API section)

4. Import the SQL script to create the cars table:

```sql
-- Create cars table
CREATE TABLE IF NOT EXISTS cars (
  id SERIAL PRIMARY KEY,
  brand TEXT NOT NULL,
  model TEXT NOT NULL,
  image_path TEXT NOT NULL,
  answer TEXT NOT NULL
);

-- Insert demo data
INSERT INTO cars (brand, model, image_path, answer) VALUES
  ('Porsche', '911 GT3', 'assets/images/cars/porsche_911_gt3.webp', 'Porsche 911 GT3'),
  ('Ferrari', '488 Pista', 'assets/images/cars/ferrari_488_pista.webp', 'Ferrari 488 Pista'),
  ('Lamborghini', 'Huracan', 'assets/images/cars/lamborghini_huracan.jpg', 'Lamborghini Huracan'),
  ('McLaren', '720S', 'assets/images/cars/mcLaren 720S.jpg', 'McLaren 720S'),
  ('Aston Martin', 'DB11', 'assets/images/cars/aston_martin_db11.jpg', 'Aston Martin DB11');
```

## Flutter Application Configuration

1. Copy the `.env.example` file to `.env` in the `frontend` folder:

```bash
cd frontend
cp .env.example .env
```

2. Update the `.env` file with your Supabase anonymous key:

```
SUPABASE_URL=http://localhost:8000
SUPABASE_ANON_KEY=your-anon-key
```

3. Launch the Flutter application:

```bash
flutter run
```

The application will automatically use the environment variables defined in the `.env` file. 