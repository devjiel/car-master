-- Create quiz_cars table
CREATE TABLE IF NOT EXISTS quiz_cars (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  brand TEXT NOT NULL,
  model TEXT NOT NULL,
  image_url TEXT NOT NULL,
  answer TEXT NOT NULL
);

-- Insert quiz_cars
INSERT INTO quiz_cars (brand, model, image_url, answer) VALUES
  ('Porsche', '911 GT3', 'assets/images/cars/porsche_911_gt3.webp', 'Porsche 911 GT3'),
  ('Ferrari', '488 Pista', 'assets/images/cars/ferrari_488_pista.webp', 'Ferrari 488 Pista'),
  ('Lamborghini', 'Huracan', 'assets/images/cars/lamborghini_huracan.jpg', 'Lamborghini Huracan'),
  ('McLaren', '720S', 'assets/images/cars/mcLaren 720S.jpg', 'McLaren 720S'),
  ('Aston Martin', 'DB11', 'assets/images/cars/aston_martin_db11.jpg', 'Aston Martin DB11');

-- Manufacturers table
CREATE TABLE IF NOT EXISTS manufacturers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL UNIQUE,
  country TEXT NOT NULL,
  logo_url TEXT,
  description TEXT,
  founding_year INTEGER
);

-- Insert manufacturers
INSERT INTO manufacturers (name, country, logo_url, description, founding_year) VALUES
  ('Porsche', 'Germany', '', 'Porsche is a German automobile manufacturer specializing in high-performance sports cars and SUVs.', 1931),
  ('Ferrari', 'Italy', '', 'Ferrari is an Italian luxury sports car manufacturer based in Maranello.', 1939),
  ('Lamborghini', 'Italy', '', 'Lamborghini is an Italian luxury sports car manufacturer based in Sant''Agata Bolognese.', 1963);

-- Countries table
CREATE TABLE countries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL UNIQUE,
  code TEXT NOT NULL UNIQUE, -- ISO country code
  flag_url TEXT
);

-- Insert countries
INSERT INTO countries (name, code, flag_url) VALUES
  ('Germany', 'DE', 'assets/images/flags/germany.png'),
  ('Italy', 'IT', 'assets/images/flags/italy.png'),
  ('United States', 'US', 'assets/images/flags/united_states.png');

