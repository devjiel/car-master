-- Création de la table cars
CREATE TABLE IF NOT EXISTS cars (
  id SERIAL PRIMARY KEY,
  brand TEXT NOT NULL,
  model TEXT NOT NULL,
  image_path TEXT NOT NULL,
  answer TEXT NOT NULL
);

-- Insertion des données de démonstration
INSERT INTO cars (brand, model, image_path, answer) VALUES
  ('Porsche', '911 GT3', 'assets/images/cars/porsche_911_gt3.webp', 'Porsche 911 GT3'),
  ('Ferrari', '488 Pista', 'assets/images/cars/ferrari_488_pista.webp', 'Ferrari 488 Pista'),
  ('Lamborghini', 'Huracan', 'assets/images/cars/lamborghini_huracan.jpg', 'Lamborghini Huracan'),
  ('McLaren', '720S', 'assets/images/cars/mcLaren 720S.jpg', 'McLaren 720S'),
  ('Aston Martin', 'DB11', 'assets/images/cars/aston_martin_db11.jpg', 'Aston Martin DB11'); 