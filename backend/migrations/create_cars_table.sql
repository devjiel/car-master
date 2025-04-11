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
INSERT INTO manufacturers (id, name, country, logo_url, description, founding_year) VALUES
  ('33b2d0c3-172b-4867-8d9a-cfda5a9e90c5', 'Porsche', 'Germany', '', 'Porsche is a German automobile manufacturer specializing in high-performance sports cars and SUVs.', 1931),
  ('adfd2bcf-e1ee-453c-8c58-197287ca4f62', 'Ferrari', 'Italy', '', 'Ferrari is an Italian luxury sports car manufacturer based in Maranello.', 1939),
  ('ffe4148b-4b91-43b6-8e14-c5ea797707df', 'Lamborghini', 'Italy', '', 'Lamborghini is an Italian luxury sports car manufacturer based in Sant''Agata Bolognese.', 1963);

-- Countries table
CREATE TABLE countries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL UNIQUE,
  code TEXT NOT NULL UNIQUE, -- ISO country code
  flag_url TEXT
);

-- Insert countries
INSERT INTO countries (id, name, code, flag_url) VALUES
  ('2349bdef-4863-4752-86f0-4e46ea2fde48', 'Germany', 'DE', 'assets/images/flags/germany.png'),
  ('44b2d0c3-172b-4867-8d9a-cfda5a9e90c5', 'Italy', 'IT', 'assets/images/flags/italy.png'),
  ('55b2d0c3-172b-4867-8d9a-cfda5a9e90c5', 'United States', 'US', 'assets/images/flags/united_states.png');

-- Body styles table
CREATE TABLE body_styles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL UNIQUE,
  description TEXT,
  icon_url TEXT
);

-- Insert body styles
INSERT INTO body_styles (id, name, description, icon_url) VALUES
  ('66ed89d8-02ae-4811-82cf-5fcfc01b817e', 'Coupe', 'A two-door vehicle with a sloping roofline and a fixed rear window.', 'assets/images/body_styles/coupe.png'),
  ('77ed89d8-02ae-4811-82cf-5fcfc01b817e', 'Convertible', 'A two-door vehicle with a retractable roof.', 'assets/images/body_styles/convertible.png'),
  ('88ed89d8-02ae-4811-82cf-5fcfc01b817e', 'Sedan', 'A four-door vehicle with a fixed roof.', 'assets/images/body_styles/sedan.png');

  -- Car encyclopedia entries table
CREATE TABLE car_encyclopedia_entries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  short_description TEXT NOT NULL,
  description TEXT NOT NULL,
  manufacturer_id UUID REFERENCES manufacturers(id),
  year TEXT NOT NULL,
  country_id UUID REFERENCES countries(id),
  designer_names JSONB, -- Array of names
  body_style_id UUID REFERENCES body_styles(id),
  -- Technical specifications
  engine TEXT NOT NULL,
  power TEXT NOT NULL,
  torque TEXT NOT NULL,
  drivetrain TEXT NOT NULL,
  acceleration TEXT,
  top_speed TEXT NOT NULL,
  dimensions TEXT NOT NULL,
  weight TEXT NOT NULL,
  additional_specs JSONB, -- Key-value pairs for model-specific specs
  -- Historical context
  history TEXT,
  notable_facts JSONB, -- Array of facts
  awards JSONB -- Array of awards
);

-- Insert car encyclopedia entries
INSERT INTO car_encyclopedia_entries (id, short_description, description, manufacturer_id, year, country_id, body_style_id, engine, power, torque, drivetrain, acceleration, top_speed, dimensions, weight, additional_specs, history, notable_facts, awards) VALUES
  ('123e4567-e89b-12d3-a456-426614174000', 'Porsche 911 GT3', 'The Porsche 911 GT3 is a high-performance sports car that combines racing heritage with road-legal capabilities.', '33b2d0c3-172b-4867-8d9a-cfda5a9e90c5', '2017', '2349bdef-4863-4752-86f0-4e46ea2fde48', '66ed89d8-02ae-4811-82cf-5fcfc01b817e', 'Inline-6', '493 hp', '339 lb-ft', 'Rear-wheel drive', '3.2 s', '193 mph', '172.8 in x 73.8 in x 49.8 in', '3,381 lbs', '{"0-60 mph": "3.2 s", "0-100 km/h": "3.4 s", "Top speed": "193 mph"}', 'The Porsche 911 GT3 was introduced in 2017 as a successor to the GT2 RS.', '{}', '{"Car of the Year": "Winner of the 2017 Car of the Year award in the United States"}'),
  ('223e4567-e89b-12d3-a456-426614174001', 'Ferrari 488 Pista', 'The Ferrari 488 Pista is a track-focused supercar that represents the pinnacle of Ferrari''s V8-powered berlinetta legacy.', 'adfd2bcf-e1ee-453c-8c58-197287ca4f62', '2018', '44b2d0c3-172b-4867-8d9a-cfda5a9e90c5', '66ed89d8-02ae-4811-82cf-5fcfc01b817e', 'Twin-turbo V8', '710 hp', '568 lb-ft', 'Rear-wheel drive', '2.85 s', '211 mph', '181.9 in x 77.8 in x 47.7 in', '3,053 lbs', '{"0-60 mph": "2.85 s", "0-100 km/h": "2.95 s", "Top speed": "211 mph"}', 'The 488 Pista is the direct successor to Ferrari''s V8-engined special series - the 458 Speciale, 430 Scuderia and 360 Challenge Stradale.', '{"Weight reduction": "Extensive use of carbon fiber reduced weight by 90 kg compared to the standard 488 GTB", "Engine": "Most powerful V8 in Ferrari history at launch"}', '{"Engine of the Year": "International Engine of the Year Award 2019", "Best Driver''s Car": "Motor Trend Best Driver''s Car 2019"}'),
  ('323e4567-e89b-12d3-a456-426614174002', 'Lamborghini Huracán', 'The Lamborghini Huracán is a high-performance supercar that combines Italian flair with cutting-edge technology.', 'ffe4148b-4b91-43b6-8e14-c5ea797707df', '2014', '44b2d0c3-172b-4867-8d9a-cfda5a9e90c5', '66ed89d8-02ae-4811-82cf-5fcfc01b817e', 'V10', '602 hp', '413 lb-ft', 'All-wheel drive', '2.9 s', '201 mph', '175.6 in x 75.7 in x 45.9 in', '3,135 lbs', '{"0-60 mph": "2.9 s", "0-100 km/h": "3.2 s", "Top speed": "201 mph"}', 'The Huracán was introduced in 2014 as a successor to the highly successful Lamborghini Gallardo.', '{"Production": "First Lamborghini to use a dual-clutch transmission", "Technology": "Features innovative Lamborghini Dynamic Steering system"}', '{"Design": "Red Dot Award for Best Design 2014", "Performance Car": "Top Gear Performance Car of the Year 2014"}');

-- Encyclopedia images table
CREATE TABLE car_encyclopedia_images (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  encyclopedia_entry_id UUID REFERENCES car_encyclopedia_entries(id),
  image_url TEXT NOT NULL,
  caption TEXT,
  display_order INTEGER NOT NULL
);

-- Create quiz_cars table
CREATE TABLE IF NOT EXISTS quiz_cars (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  brand TEXT NOT NULL,
  model TEXT NOT NULL,
  image_url TEXT NOT NULL,
  answer TEXT NOT NULL,
  encyclopedia_entry_id UUID REFERENCES car_encyclopedia_entries(id)
);

-- Insert quiz_cars
INSERT INTO quiz_cars (brand, model, image_url, answer) VALUES
  ('Porsche', '911 GT3', 'assets/images/cars/porsche_911_gt3.webp', 'Porsche 911 GT3'),
  ('Ferrari', '488 Pista', 'assets/images/cars/ferrari_488_pista.webp', 'Ferrari 488 Pista'),
  ('Lamborghini', 'Huracan', 'assets/images/cars/lamborghini_huracan.jpg', 'Lamborghini Huracan'),
  ('McLaren', '720S', 'assets/images/cars/mcLaren 720S.jpg', 'McLaren 720S'),
  ('Aston Martin', 'DB11', 'assets/images/cars/aston_martin_db11.jpg', 'Aston Martin DB11');

-- Add indexes for efficient lookups and joins
CREATE INDEX idx_quiz_cars_encyclopedia_entry_id ON quiz_cars(encyclopedia_entry_id);
CREATE INDEX idx_car_encyclopedia_entries_quiz_car_id ON car_encyclopedia_entries(id);
CREATE INDEX idx_car_encyclopedia_entries_manufacturer_id ON car_encyclopedia_entries(manufacturer_id);
CREATE INDEX idx_car_encyclopedia_entries_country_id ON car_encyclopedia_entries(country_id);
CREATE INDEX idx_car_encyclopedia_entries_body_style_id ON car_encyclopedia_entries(body_style_id);