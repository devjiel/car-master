-- Disable RLS
ALTER TABLE storage.objects DISABLE ROW LEVEL SECURITY;

-- Drop trigger and function
DROP TRIGGER IF EXISTS tr_delete_encyclopedia_images ON car_encyclopedia_entries;
DROP FUNCTION IF EXISTS delete_encyclopedia_images();

-- Drop policies
DROP POLICY IF EXISTS "Public Access" ON storage.objects;

-- Empty the bucket before dropping it
DO $$
BEGIN
    DELETE FROM storage.objects WHERE bucket_id = 'encyclopedia_images';
END $$;

-- Drop the bucket
DELETE FROM storage.buckets WHERE id = 'encyclopedia_images'; 