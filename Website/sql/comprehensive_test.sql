-- =============================================================
-- Connect-Sphere: Comprehensive Database Test Script
-- Run AFTER public_schema.sql, moderation_schema.sql, and patch_schema.sql
-- =============================================================

DROP TABLE IF EXISTS _test_results;
CREATE TEMP TABLE _test_results (
  test_name TEXT,
  status TEXT,
  detail TEXT
);

-- =============================================================
-- 1. TABLES (28 actual tables)
-- =============================================================
DO $$
DECLARE
  tbl TEXT;
  tbls TEXT[] := ARRAY[
    'profiles', 'posts', 'comments', 'likes', 'bookmarks', 'shares',
    'followers', 'follow_requests', 'conversations', 'conversation_participants',
    'messages', 'notifications', 'stories', 'story_reactions',
    'communities', 'community_members', 'community_posts',
    'community_post_comments', 'community_post_likes',
    'collaboration_invites', 'collaboration_notifications',
    'privacy_settings', 'user_reports', 'user_bans', 'user_blocks',
    'comment_likes', 'payment_orders', 'payments'
  ];
BEGIN
  FOREACH tbl IN ARRAY tbls LOOP
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name=tbl) THEN
      INSERT INTO _test_results VALUES ('Table: ' || tbl, 'PASS', '');
    ELSE
      INSERT INTO _test_results VALUES ('Table: ' || tbl, 'FAIL', 'Missing');
    END IF;
  END LOOP;
END $$;

-- =============================================================
-- 2. CRITICAL COLUMNS
-- =============================================================
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='posts' AND column_name='is_archived') THEN
    INSERT INTO _test_results VALUES ('Column: posts.is_archived', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Column: posts.is_archived', 'FAIL', 'Run patch_schema.sql');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='messages' AND column_name='is_read') THEN
    INSERT INTO _test_results VALUES ('Column: messages.is_read', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Column: messages.is_read', 'FAIL', 'Run patch_schema.sql');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='profiles' AND column_name='is_moderator') THEN
    INSERT INTO _test_results VALUES ('Column: profiles.is_moderator', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Column: profiles.is_moderator', 'FAIL', 'Run moderation_schema.sql');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='profiles' AND column_name='banned_until') THEN
    INSERT INTO _test_results VALUES ('Column: profiles.banned_until', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Column: profiles.banned_until', 'FAIL', 'Run moderation_schema.sql');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='stories' AND column_name='media_type') THEN
    INSERT INTO _test_results VALUES ('Column: stories.media_type', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Column: stories.media_type', 'FAIL', 'Run patch_schema.sql');
  END IF;
END $$;

-- =============================================================
-- 3. ENUM TYPES (9 actual enums from public_schema.sql)
-- =============================================================
DO $$
DECLARE
  en TEXT;
  enums TEXT[] := ARRAY[
    'collab_status', 'member_role', 'membership_status', 'membership_type',
    'privacy_level', 'reaction_type', 'report_category', 'report_status', 'request_status'
  ];
BEGIN
  FOREACH en IN ARRAY enums LOOP
    IF EXISTS (SELECT 1 FROM pg_type t JOIN pg_namespace n ON t.typnamespace=n.oid WHERE n.nspname='public' AND t.typname=en) THEN
      INSERT INTO _test_results VALUES ('Enum: ' || en, 'PASS', '');
    ELSE
      INSERT INTO _test_results VALUES ('Enum: ' || en, 'FAIL', 'Missing enum type');
    END IF;
  END LOOP;
END $$;

-- =============================================================
-- 4. FUNCTIONS (actual functions from public_schema.sql)
-- =============================================================
DO $$
DECLARE
  fn TEXT;
  fns TEXT[] := ARRAY[
    'handle_new_user', 'handle_new_follower', 'handle_lost_follower',
    'manage_follow_counts', 'get_home_feed', 'get_all_suggestions',
    'get_or_create_conversation_with_user', 'get_mutual_count',
    'refresh_profile_ban_state', 'update_comment_count',
    'update_like_count', 'update_save_count', 'update_share_count',
    'update_collaborator_count', 'update_community_member_count',
    'update_community_post_count', 'update_community_post_comment_count',
    'update_community_post_like_count', 'update_comment_like_count'
  ];
BEGIN
  FOREACH fn IN ARRAY fns LOOP
    IF EXISTS (SELECT 1 FROM pg_proc WHERE proname=fn) THEN
      INSERT INTO _test_results VALUES ('Function: ' || fn, 'PASS', '');
    ELSE
      INSERT INTO _test_results VALUES ('Function: ' || fn, 'FAIL', 'Missing function');
    END IF;
  END LOOP;
END $$;

-- =============================================================
-- 5. TRIGGERS (actual triggers from public_schema.sql)
-- =============================================================
DO $$
DECLARE
  tg TEXT;
  trigger_names TEXT[] := ARRAY[
    'on_auth_user_created',
    'on_new_follow', 'on_unfollow',
    'likes_after_change', 'comments_after_change',
    'bookmarks_after_change', 'shares_after_change',
    'comment_likes_after_change',
    'community_members_after_change',
    'community_posts_after_change',
    'community_post_comments_after_change',
    'community_post_likes_after_change',
    'user_bans_after_change_trg', 'user_bans_after_delete_trg',
    'user_reports_after_insert', 'user_reports_after_status_change',
    'on_collab_invite_created', 'on_collab_invite_updated'
  ];
BEGIN
  FOREACH tg IN ARRAY trigger_names LOOP
    IF EXISTS (SELECT 1 FROM pg_trigger WHERE tgname=tg) THEN
      INSERT INTO _test_results VALUES ('Trigger: ' || tg, 'PASS', '');
    ELSE
      INSERT INTO _test_results VALUES ('Trigger: ' || tg, 'FAIL', 'Missing trigger');
    END IF;
  END LOOP;
END $$;

-- =============================================================
-- 6. RLS POLICIES (critical ones)
-- =============================================================
DO $$
DECLARE
  pol_name TEXT;
  expected_policies TEXT[] := ARRAY[
    'Users can insert their own profile',
    'Users can insert their own privacy settings',
    'stories_insert'
  ];
BEGIN
  FOREACH pol_name IN ARRAY expected_policies LOOP
    IF EXISTS (SELECT 1 FROM pg_policies WHERE schemaname='public' AND policyname=pol_name) THEN
      INSERT INTO _test_results VALUES ('RLS: ' || pol_name, 'PASS', '');
    ELSE
      INSERT INTO _test_results VALUES ('RLS: ' || pol_name, 'FAIL', 'Missing policy');
    END IF;
  END LOOP;
END $$;

-- =============================================================
-- 7. REALTIME PUBLICATIONS
-- =============================================================
DO $$
DECLARE
  tbl TEXT;
  rt_tables TEXT[] := ARRAY['messages', 'conversation_participants', 'notifications', 'followers'];
BEGIN
  FOREACH tbl IN ARRAY rt_tables LOOP
    IF EXISTS (
      SELECT 1 FROM pg_publication_tables
      WHERE pubname='supabase_realtime' AND tablename=tbl
    ) THEN
      INSERT INTO _test_results VALUES ('Realtime: ' || tbl, 'PASS', '');
    ELSE
      INSERT INTO _test_results VALUES ('Realtime: ' || tbl, 'FAIL', 'Not in supabase_realtime');
    END IF;
  END LOOP;
END $$;

-- =============================================================
-- 8. STORAGE BUCKETS
-- =============================================================
DO $$
DECLARE
  bucket TEXT;
  buckets TEXT[] := ARRAY['stories', 'avatars', 'media'];
BEGIN
  FOREACH bucket IN ARRAY buckets LOOP
    IF EXISTS (SELECT 1 FROM storage.buckets WHERE id=bucket AND name=bucket) THEN
      INSERT INTO _test_results VALUES ('Storage bucket: ' || bucket, 'PASS', '');
    ELSE
      INSERT INTO _test_results VALUES ('Storage bucket: ' || bucket, 'FAIL', 'Create in Supabase Storage dashboard');
    END IF;
  END LOOP;
END $$;

-- =============================================================
-- 9. STORAGE RLS POLICIES
-- =============================================================
DO $$
DECLARE
  pol_name TEXT;
  storage_policies TEXT[] := ARRAY[
    'Authenticated users can upload stories',
    'Anyone can view stories',
    'Users can delete their own stories',
    'Authenticated users can upload media',
    'Anyone can view media',
    'Users can delete their own media',
    'Authenticated users can upload avatars',
    'Anyone can view avatars',
    'Users can delete their own avatars'
  ];
BEGIN
  FOREACH pol_name IN ARRAY storage_policies LOOP
    IF EXISTS (
      SELECT 1 FROM pg_policies
      WHERE schemaname='storage' AND tablename='objects' AND policyname=pol_name
    ) THEN
      INSERT INTO _test_results VALUES ('Storage RLS: ' || pol_name, 'PASS', '');
    ELSE
      INSERT INTO _test_results VALUES ('Storage RLS: ' || pol_name, 'FAIL', 'Run patch_schema.sql storage section');
    END IF;
  END LOOP;
END $$;

-- =============================================================
-- 10. FOREIGN KEYS
-- =============================================================
DO $$
DECLARE
  fk_count INT;
BEGIN
  SELECT count(*) INTO fk_count
  FROM information_schema.table_constraints
  WHERE constraint_type='FOREIGN KEY' AND table_schema='public';

  IF fk_count >= 20 THEN
    INSERT INTO _test_results VALUES ('Foreign Keys: ' || fk_count || ' total', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Foreign Keys: ' || fk_count || ' total', 'WARN', 'Only ' || fk_count || ' FKs');
  END IF;
END $$;

-- =============================================================
-- RESULTS
-- =============================================================
SELECT
  test_name AS "Test",
  status AS "Status",
  detail AS "Detail"
FROM _test_results
ORDER BY
  CASE status WHEN 'FAIL' THEN 0 WHEN 'WARN' THEN 1 ELSE 2 END,
  test_name;

SELECT status, count(*) AS total FROM _test_results GROUP BY status ORDER BY status;
