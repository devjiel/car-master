-- Insert manufacturers
INSERT INTO manufacturers (id, name, country, logo_url, description, founding_year) VALUES
  ('33b2d0c3-172b-4867-8d9a-cfda5a9e90c5', 'Porsche', 'Germany', '', 'Porsche is a German automobile manufacturer specializing in high-performance sports cars and SUVs.', 1931),
  ('adfd2bcf-e1ee-453c-8c58-197287ca4f62', 'Ferrari', 'Italy', '', 'Ferrari is an Italian luxury sports car manufacturer based in Maranello.', 1939),
  ('ffe4148b-4b91-43b6-8e14-c5ea797707df', 'Lamborghini', 'Italy', '', 'Lamborghini is an Italian luxury sports car manufacturer based in Sant''Agata Bolognese.', 1963);

-- Insert countries
INSERT INTO countries (id, name, code, flag_url) VALUES
  ('2349bdef-4863-4752-86f0-4e46ea2fde48', 'Germany', 'DE', 'assets/images/flags/germany.png'),
  ('44b2d0c3-172b-4867-8d9a-cfda5a9e90c5', 'Italy', 'IT', 'assets/images/flags/italy.png'),
  ('55b2d0c3-172b-4867-8d9a-cfda5a9e90c5', 'United States', 'US', 'assets/images/flags/united_states.png');

-- Insert body styles
INSERT INTO body_styles (id, name, description, icon_url) VALUES
  ('66ed89d8-02ae-4811-82cf-5fcfc01b817e', 'Coupe', 'A two-door vehicle with a sloping roofline and a fixed rear window.', 'assets/images/body_styles/coupe.png'),
  ('77ed89d8-02ae-4811-82cf-5fcfc01b817e', 'Convertible', 'A two-door vehicle with a retractable roof.', 'assets/images/body_styles/convertible.png'),
  ('88ed89d8-02ae-4811-82cf-5fcfc01b817e', 'Sedan', 'A four-door vehicle with a fixed roof.', 'assets/images/body_styles/sedan.png');

-- Insert car encyclopedia entries
INSERT INTO car_encyclopedia_entries (id, name, short_description, description, manufacturer_id, year, country_id, body_style_id, engine, power, torque, drivetrain, acceleration, top_speed, dimensions, weight, additional_specs, history, notable_facts, awards, default_image_url) VALUES
  ('123e4567-e89b-12d3-a456-426614174000', 'Porsche 911 GT3', 'Porsche 911 GT3 short description', 'The Porsche 911 GT3 is a high-performance sports car that combines racing heritage with road-legal capabilities.', '33b2d0c3-172b-4867-8d9a-cfda5a9e90c5', '2017', '2349bdef-4863-4752-86f0-4e46ea2fde48', '66ed89d8-02ae-4811-82cf-5fcfc01b817e', 'Inline-6', '493 hp', '339 lb-ft', 'Rear-wheel drive', '3.2 s', '193 mph', '172.8 in x 73.8 in x 49.8 in', '3,381 lbs', '{"0-60 mph": "3.2 s", "0-100 km/h": "3.4 s", "Top speed": "193 mph"}', 'The Porsche 911 GT3 was introduced in 2017 as a successor to the GT2 RS.', '{}', '{"Winner of the 2017 Car of the Year award in the United States"}', 'http://localhost:8000/storage/v1/object/public/encyclopedia_images/porsche_911_gt3.png'),
  
  ('223e4567-e89b-12d3-a456-426614174001', 'Ferrari 488 Pista', 'Ferrari 488 Pista short description', 'The Ferrari 488 Pista is a track-focused supercar that represents the pinnacle of Ferrari''s V8-powered berlinetta legacy.', 'adfd2bcf-e1ee-453c-8c58-197287ca4f62', '2018', '44b2d0c3-172b-4867-8d9a-cfda5a9e90c5', '66ed89d8-02ae-4811-82cf-5fcfc01b817e', 'Twin-turbo V8', '710 hp', '568 lb-ft', 'Rear-wheel drive', '2.85 s', '211 mph', '181.9 in x 77.8 in x 47.7 in', '3,053 lbs', '{"0-60 mph": "2.85 s", "0-100 km/h": "2.95 s", "Top speed": "211 mph"}', 'The 488 Pista is the direct successor to Ferrari''s V8-engined special series - the 458 Speciale, 430 Scuderia and 360 Challenge Stradale.', '{"Extensive use of carbon fiber reduced weight by 90 kg compared to the standard 488 GTB", "Most powerful V8 in Ferrari history at launch"}', '{"International Engine of the Year Award 2019", "Motor Trend Best Driver''s Car 2019"}', 'http://localhost:8000/storage/v1/object/public/encyclopedia_images/ferrari_488_pista.png'),
  
  ('323e4567-e89b-12d3-a456-426614174002', 'Lamborghini Huracán', 'Lamborghini Huracán short description', 'The Lamborghini Huracán is a high-performance supercar that combines Italian flair with cutting-edge technology.', 'ffe4148b-4b91-43b6-8e14-c5ea797707df', '2014', '44b2d0c3-172b-4867-8d9a-cfda5a9e90c5', '66ed89d8-02ae-4811-82cf-5fcfc01b817e', 'V10', '602 hp', '413 lb-ft', 'All-wheel drive', '2.9 s', '201 mph', '175.6 in x 75.7 in x 45.9 in', '3,135 lbs', '{"0-60 mph": "2.9 s", "0-100 km/h": "3.2 s", "Top speed": "201 mph"}', 'The Huracán was introduced in 2014 as a successor to the highly successful Lamborghini Gallardo.', '{"First Lamborghini to use a dual-clutch transmission", "Features innovative Lamborghini Dynamic Steering system"}', '{"Red Dot Award for Best Design 2014", "Top Gear Performance Car of the Year 2014"}', 'http://localhost:8000/storage/v1/object/public/encyclopedia_images/lamborghini_huracan.png');

-- Insert quiz_cars
INSERT INTO quiz_cars (brand, model, image_url, answer) VALUES
  ('Porsche', '911 GT3', 'assets/images/cars/porsche_911_gt3.webp', 'Porsche 911 GT3'),
  ('Ferrari', '488 Pista', 'assets/images/cars/ferrari_488_pista.webp', 'Ferrari 488 Pista'),
  ('Lamborghini', 'Huracan', 'assets/images/cars/lamborghini_huracan.jpg', 'Lamborghini Huracan'),
  ('McLaren', '720S', 'assets/images/cars/mcLaren 720S.jpg', 'McLaren 720S'),
  ('Aston Martin', 'DB11', 'assets/images/cars/aston_martin_db11.jpg', 'Aston Martin DB11');