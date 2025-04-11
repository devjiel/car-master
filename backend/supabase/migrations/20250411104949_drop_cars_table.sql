-- Drop encyclopedia images first
DROP TABLE IF EXISTS car_encyclopedia_images CASCADE;

-- Drop car encyclopedia entries and related tables
DROP TABLE IF EXISTS car_encyclopedia_entries CASCADE;
DROP TABLE IF EXISTS quiz_cars CASCADE;

-- Drop reference tables
DROP TABLE IF EXISTS manufacturers CASCADE;
DROP TABLE IF EXISTS body_styles CASCADE;
DROP TABLE IF EXISTS segments CASCADE;
DROP TABLE IF EXISTS countries CASCADE;

-- Drop indexes
DROP INDEX IF EXISTS idx_car_encyclopedia_entries_manufacturer_id;
DROP INDEX IF EXISTS idx_car_encyclopedia_entries_body_style_id;
DROP INDEX IF EXISTS idx_car_encyclopedia_entries_segment_id;
DROP INDEX IF EXISTS idx_quiz_cars_manufacturer_id;