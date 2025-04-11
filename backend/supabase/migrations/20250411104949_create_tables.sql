-- Manufacturers table
CREATE TABLE IF NOT EXISTS manufacturers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL UNIQUE,
  country TEXT NOT NULL,
  logo_url TEXT,
  description TEXT,
  founding_year INTEGER
);

-- Countries table
CREATE TABLE countries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL UNIQUE,
  code TEXT NOT NULL UNIQUE, -- ISO country code
  flag_url TEXT
);

-- Body styles table
CREATE TABLE body_styles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL UNIQUE,
  description TEXT,
  icon_url TEXT
);

-- Car encyclopedia entries table
CREATE TABLE car_encyclopedia_entries (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  short_description TEXT NOT NULL,
  default_image_url TEXT NOT NULL,
  description TEXT NOT NULL,
  manufacturer_id UUID REFERENCES manufacturers(id) NOT NULL,
  year VARCHAR(4) NOT NULL,
  country_id UUID REFERENCES countries(id) NOT NULL,
  designer_names TEXT[] DEFAULT '{}',
  body_style_id UUID REFERENCES body_styles(id) NOT NULL,
  engine VARCHAR(255) NOT NULL,
  power VARCHAR(100) NOT NULL,
  torque VARCHAR(100) NOT NULL,
  drivetrain VARCHAR(100) NOT NULL,
  acceleration VARCHAR(100) NOT NULL,
  top_speed VARCHAR(100) NOT NULL,
  dimensions VARCHAR(100) NOT NULL,
  weight VARCHAR(100) NOT NULL,
  additional_specs JSONB DEFAULT '{}',
  history TEXT NOT NULL,
  notable_facts TEXT[] DEFAULT '{}',
  awards TEXT[] DEFAULT '{}'
);

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

-- Add indexes for efficient lookups and joins
CREATE INDEX idx_quiz_cars_encyclopedia_entry_id ON quiz_cars(encyclopedia_entry_id);
CREATE INDEX idx_car_encyclopedia_entries_quiz_car_id ON car_encyclopedia_entries(id);
CREATE INDEX idx_car_encyclopedia_entries_manufacturer_id ON car_encyclopedia_entries(manufacturer_id);
CREATE INDEX idx_car_encyclopedia_entries_country_id ON car_encyclopedia_entries(country_id);
CREATE INDEX idx_car_encyclopedia_entries_body_style_id ON car_encyclopedia_entries(body_style_id);

-- Create index on name for faster searches and sorting
CREATE INDEX idx_car_encyclopedia_entries_name ON car_encyclopedia_entries(name);