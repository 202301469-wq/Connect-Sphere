-- =============================================================
-- Connect-Sphere: Patch migration
-- Run AFTER public_schema.sql and moderation_schema.sql
-- Fixes schema mismatches between the SQL dump and the TypeScript code
-- =============================================================

-- 0. Storage bucket RLS policies
--    Supabase storage buckets need INSERT/SELECT/DELETE policies on storage.objects.
--    Without these, uploads fail with "new row violates row level security policy".

-- Stories bucket policies
DROP POLICY IF EXISTS "Authenticated users can upload stories" ON storage.objects;
CREATE POLICY "Authenticated users can upload stories"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'stories' AND auth.uid()::text = (string_to_array(name, '/'))[1]);

DROP POLICY IF EXISTS "Anyone can view stories" ON storage.objects;
CREATE POLICY "Anyone can view stories"
  ON storage.objects FOR SELECT
  TO public
  USING (bucket_id = 'stories');

DROP POLICY IF EXISTS "Users can delete their own stories" ON storage.objects;
CREATE POLICY "Users can delete their own stories"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (bucket_id = 'stories' AND auth.uid()::text = (string_to_array(name, '/'))[1]);

-- Media bucket policies (for post images/videos)
DROP POLICY IF EXISTS "Authenticated users can upload media" ON storage.objects;
CREATE POLICY "Authenticated users can upload media"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'media' AND auth.uid()::text = (string_to_array(name, '/'))[1]);

DROP POLICY IF EXISTS "Anyone can view media" ON storage.objects;
CREATE POLICY "Anyone can view media"
  ON storage.objects FOR SELECT
  TO public
  USING (bucket_id = 'media');

DROP POLICY IF EXISTS "Users can delete their own media" ON storage.objects;
CREATE POLICY "Users can delete their own media"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (bucket_id = 'media' AND auth.uid()::text = (string_to_array(name, '/'))[1]);

-- Avatars bucket policies
DROP POLICY IF EXISTS "Authenticated users can upload avatars" ON storage.objects;
CREATE POLICY "Authenticated users can upload avatars"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'avatars' AND auth.uid()::text = (string_to_array(name, '/'))[1]);

DROP POLICY IF EXISTS "Anyone can view avatars" ON storage.objects;
CREATE POLICY "Anyone can view avatars"
  ON storage.objects FOR SELECT
  TO public
  USING (bucket_id = 'avatars');

DROP POLICY IF EXISTS "Users can delete their own avatars" ON storage.objects;
CREATE POLICY "Users can delete their own avatars"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (bucket_id = 'avatars' AND auth.uid()::text = (string_to_array(name, '/'))[1]);

-- 1. Add missing INSERT RLS policies
--    profiles and privacy_settings have no INSERT policy, so the
--    complete-profile form and the handle_new_user() trigger fail.
DROP POLICY IF EXISTS "Users can insert their own profile" ON public.profiles;
CREATE POLICY "Users can insert their own profile"
  ON public.profiles FOR INSERT
  WITH CHECK (auth.uid() = id);

DROP POLICY IF EXISTS "Users can insert their own privacy settings" ON public.privacy_settings;
CREATE POLICY "Users can insert their own privacy settings"
  ON public.privacy_settings FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Ensure the auth trigger exists to auto-create profiles on signup
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- 1. Add missing column: posts.is_archived
--    The feed, profile, and settings pages filter by this column.
ALTER TABLE public.posts
  ADD COLUMN IF NOT EXISTS is_archived boolean DEFAULT false NOT NULL;

-- 1b. Add missing column: stories.media_type
--    The story upload stores 'image' or 'video' to distinguish media types.
ALTER TABLE public.stories
  ADD COLUMN IF NOT EXISTS media_type text DEFAULT 'image' NOT NULL;

-- 2. Add missing column: messages.is_read
--    The get_or_create_conversation_with_user() function and TypeScript types reference this.
ALTER TABLE public.messages
  ADD COLUMN IF NOT EXISTS is_read boolean DEFAULT false NOT NULL;

-- 3. Fix manage_follow_counts() trigger function
--    The original references NEW.status / OLD.status on the followers table,
--    but the followers table has no 'status' column. Simplify to always update counts.
CREATE OR REPLACE FUNCTION public.manage_follow_counts()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        UPDATE profiles
        SET following_count = COALESCE(following_count, 0) + 1
        WHERE id = NEW.follower_id;

        UPDATE profiles
        SET follower_count = COALESCE(follower_count, 0) + 1
        WHERE id = NEW.following_id;

        RETURN NEW;

    ELSIF (TG_OP = 'DELETE') THEN
        UPDATE profiles
        SET following_count = GREATEST(COALESCE(following_count, 0) - 1, 0)
        WHERE id = OLD.follower_id;

        UPDATE profiles
        SET follower_count = GREATEST(COALESCE(follower_count, 0) - 1, 0)
        WHERE id = OLD.following_id;

        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$$;

-- 4. Fix get_or_create_conversation_with_user() to not reference messages.is_read
--    (which we just added, but the function also has other issues with column refs)
--    Rewrite to be robust:
CREATE OR REPLACE FUNCTION public.get_or_create_conversation_with_user(other_user_id uuid)
RETURNS TABLE(id integer, created_at timestamp with time zone, participants json, last_message json, unread_count integer)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    found_conversation_id int;
BEGIN
    -- Find existing conversation
    SELECT cp1.conversation_id INTO found_conversation_id
    FROM conversation_participants AS cp1
    JOIN conversation_participants AS cp2 ON cp1.conversation_id = cp2.conversation_id
    WHERE cp1.user_id = auth.uid() AND cp2.user_id = other_user_id;

    -- If not found, create a new one
    IF found_conversation_id IS NULL THEN
        INSERT INTO conversations DEFAULT VALUES
        RETURNING conversations.id INTO found_conversation_id;

        INSERT INTO conversation_participants (conversation_id, user_id)
        VALUES (found_conversation_id, auth.uid()), (found_conversation_id, other_user_id);
    END IF;

    -- Return the full conversation object
    RETURN QUERY
    SELECT
        c.id,
        c.created_at,
        (SELECT json_agg(p_json)
         FROM (
             SELECT p.id, p.display_name, p.username, p.avatar_url
             FROM conversation_participants cp
             JOIN profiles p ON cp.user_id = p.id
             WHERE cp.conversation_id = c.id
         ) p_json
        ) AS participants,
        (SELECT json_build_object(
            'id', m.id,
            'content', m.content,
            'created_at', m.created_at,
            'sender', (SELECT json_build_object('id', s.id, 'display_name', s.display_name, 'username', s.username, 'avatar_url', s.avatar_url) FROM profiles s WHERE s.id = m.sender)
          )
         FROM messages m
         WHERE m.conversation_id = c.id
         ORDER BY m.created_at DESC
         LIMIT 1
        ) AS last_message,
        (SELECT count(*)::int FROM messages m WHERE m.conversation_id = c.id AND m.is_read = false AND m.sender <> auth.uid()) as unread_count
    FROM conversations c
    WHERE c.id = found_conversation_id;
END;
$$;

-- 5. Enable Realtime on required tables (idempotent)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname='supabase_realtime' AND tablename='messages') THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE messages;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname='supabase_realtime' AND tablename='conversation_participants') THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE conversation_participants;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname='supabase_realtime' AND tablename='notifications') THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE notifications;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname='supabase_realtime' AND tablename='followers') THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE followers;
  END IF;
END $$;
