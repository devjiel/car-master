-- Create a new bucket for encyclopedia images
INSERT INTO storage.buckets (id, name, public)
VALUES ('encyclopedia_images', 'encyclopedia_images', true);

-- Enable public access to read images
CREATE POLICY "Public Access"
ON storage.objects FOR SELECT
USING (bucket_id = 'encyclopedia_images');

-- Add a trigger to automatically delete old images when encyclopedia entries are deleted
CREATE OR REPLACE FUNCTION delete_encyclopedia_images()
RETURNS TRIGGER AS $$
BEGIN
  SET search_path = '';  -- Reset search_path for security
  DELETE FROM storage.objects
  WHERE bucket_id = 'encyclopedia_images'
  AND name LIKE OLD.id || '/%';
  RETURN OLD;
END;
$$ LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = '';  -- Set default search_path to empty

CREATE TRIGGER tr_delete_encyclopedia_images
BEFORE DELETE ON car_encyclopedia_entries
FOR EACH ROW
EXECUTE FUNCTION delete_encyclopedia_images();

-- Add RLS policies
ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY; 