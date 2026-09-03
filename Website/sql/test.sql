-- =============================================================
-- Connect-Sphere: Database Verification Script
-- Run this in Supabase SQL Editor to verify everything is set up correctly.
-- Each section outputs PASS or FAIL with details.
-- =============================================================

-- Helper: Create a temp table to collect test results
CREATE TEMP TABLE IF NOT EXISTS _test_results (
  test_name text,
  status text,
  detail text
);

-- Helper macro (using DO blocks for each check)

-- =====================
-- 1. TABLES
-- =====================
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='profiles') THEN
    INSERT INTO _test_results VALUES ('Table: profiles', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Table: profiles', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='posts') THEN
    INSERT INTO _test_results VALUES ('Table: posts', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Table: posts', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='comments') THEN
    INSERT INTO _test_results VALUES ('Table: comments', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Table: comments', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='likes') THEN
    INSERT INTO _test_results VALUES ('Table: likes', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Table: likes', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='bookmarks') THEN
    INSERT INTO _test_results VALUES ('Table: bookmarks', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Table: bookmarks', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='shares') THEN
    INSERT INTO _test_results VALUES ('Table: shares', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Table: shares', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='followers') THEN
    INSERT INTO _test_results VALUES ('Table: followers', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Table: followers', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='follow_requests') THEN
    INSERT INTO _test_results VALUES ('Table: follow_requests', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Table: follow_requests', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='conversations') THEN
    INSERT INTO _test_results VALUES ('Table: conversations', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Table: conversations', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='conversation_participants') THEN
    INSERT INTO _test_results VALUES ('Table: conversation_participants', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Table: conversation_participants', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='messages') THEN
    INSERT INTO _test_results VALUES ('Table: messages', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Table: messages', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='notifications') THEN
    INSERT INTO _test_results VALUES ('Table: notifications', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Table: notifications', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='stories') THEN
    INSERT INTO _test_results VALUES ('Table: stories', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Table: stories', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='story_reactions') THEN
    INSERT INTO _test_results VALUES ('Table: story_reactions', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Table: story_reactions', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='communities') THEN
    INSERT INTO _test_results VALUES ('Table: communities', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Table: communities', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='community_members') THEN
    INSERT INTO _test_results VALUES ('Table: community_members', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Table: community_members', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='community_posts') THEN
    INSERT INTO _test_results VALUES ('Table: community_posts', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Table: community_posts', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='community_post_comments') THEN
    INSERT INTO _test_results VALUES ('Table: community_post_comments', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Table: community_post_comments', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='community_post_likes') THEN
    INSERT INTO _test_results VALUES ('Table: community_post_likes', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Table: community_post_likes', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='collaboration_invites') THEN
    INSERT INTO _test_results VALUES ('Table: collaboration_invites', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Table: collaboration_invites', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='collaboration_notifications') THEN
    INSERT INTO _test_results VALUES ('Table: collaboration_notifications', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Table: collaboration_notifications', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='privacy_settings') THEN
    INSERT INTO _test_results VALUES ('Table: privacy_settings', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Table: privacy_settings', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='user_reports') THEN
    INSERT INTO _test_results VALUES ('Table: user_reports', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Table: user_reports', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='user_bans') THEN
    INSERT INTO _test_results VALUES ('Table: user_bans', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Table: user_bans', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='user_blocks') THEN
    INSERT INTO _test_results VALUES ('Table: user_blocks', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Table: user_blocks', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='comment_likes') THEN
    INSERT INTO _test_results VALUES ('Table: comment_likes', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Table: comment_likes', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='payment_orders') THEN
    INSERT INTO _test_results VALUES ('Table: payment_orders', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Table: payment_orders', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='payments') THEN
    INSERT INTO _test_results VALUES ('Table: payments', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Table: payments', 'FAIL', 'Missing');
  END IF;
END $$;

-- =====================
-- 2. CRITICAL COLUMNS
-- =====================
DO $$
BEGIN
  -- posts.is_archived (patched)
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='posts' AND column_name='is_archived') THEN
    INSERT INTO _test_results VALUES ('Column: posts.is_archived', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Column: posts.is_archived', 'FAIL', 'Run patch_schema.sql');
  END IF;

  -- messages.is_read (patched)
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='messages' AND column_name='is_read') THEN
    INSERT INTO _test_results VALUES ('Column: messages.is_read', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Column: messages.is_read', 'FAIL', 'Run patch_schema.sql');
  END IF;

  -- profiles.is_moderator
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='profiles' AND column_name='is_moderator') THEN
    INSERT INTO _test_results VALUES ('Column: profiles.is_moderator', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Column: profiles.is_moderator', 'FAIL', 'Run moderation_schema.sql');
  END IF;

  -- profiles.banned_until
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='profiles' AND column_name='banned_until') THEN
    INSERT INTO _test_results VALUES ('Column: profiles.banned_until', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Column: profiles.banned_until', 'FAIL', 'Run moderation_schema.sql');
  END IF;

  -- profiles.verification_score
  IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='public' AND table_name='profiles' AND column_name='verification_score') THEN
    INSERT INTO _test_results VALUES ('Column: profiles.verification_score', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Column: profiles.verification_score', 'FAIL', 'Missing from schema');
  END IF;
END $$;

-- =====================
-- 3. RLS POLICIES
-- =====================
DO $$
BEGIN
  -- profiles INSERT policy
  IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename='profiles' AND policyname='Users can insert their own profile') THEN
    INSERT INTO _test_results VALUES ('RLS: profiles INSERT', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('RLS: profiles INSERT', 'FAIL', 'Run patch_schema.sql');
  END IF;

  -- profiles SELECT policy
  IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename='profiles' AND policyname='Public profiles are viewable by everyone') THEN
    INSERT INTO _test_results VALUES ('RLS: profiles SELECT', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('RLS: profiles SELECT', 'FAIL', 'Missing');
  END IF;

  -- profiles UPDATE policy
  IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename='profiles' AND policyname='Users can update own profile') THEN
    INSERT INTO _test_results VALUES ('RLS: profiles UPDATE', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('RLS: profiles UPDATE', 'FAIL', 'Missing');
  END IF;

  -- privacy_settings INSERT
  IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename='privacy_settings' AND policyname='Users can insert their own privacy settings') THEN
    INSERT INTO _test_results VALUES ('RLS: privacy_settings INSERT', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('RLS: privacy_settings INSERT', 'FAIL', 'Run patch_schema.sql');
  END IF;

  -- posts INSERT
  IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename='posts' AND policyname='Users can insert their own posts') THEN
    INSERT INTO _test_results VALUES ('RLS: posts INSERT', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('RLS: posts INSERT', 'FAIL', 'Missing');
  END IF;

  -- posts SELECT
  IF EXISTS (SELECT 1 FROM pg_policies WHERE tablename='posts' AND policyname='Public posts are viewable by everyone') THEN
    INSERT INTO _test_results VALUES ('RLS: posts SELECT', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('RLS: posts SELECT', 'FAIL', 'Missing');
  END IF;
END $$;

-- =====================
-- 4. FUNCTIONS
-- =====================
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_proc WHERE proname='get_home_feed') THEN
    INSERT INTO _test_results VALUES ('Function: get_home_feed', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Function: get_home_feed', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM pg_proc WHERE proname='get_all_suggestions') THEN
    INSERT INTO _test_results VALUES ('Function: get_all_suggestions', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Function: get_all_suggestions', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM pg_proc WHERE proname='handle_new_user') THEN
    INSERT INTO _test_results VALUES ('Function: handle_new_user', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Function: handle_new_user', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM pg_proc WHERE proname='handle_new_follower') THEN
    INSERT INTO _test_results VALUES ('Function: handle_new_follower', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Function: handle_new_follower', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM pg_proc WHERE proname='handle_lost_follower') THEN
    INSERT INTO _test_results VALUES ('Function: handle_lost_follower', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Function: handle_lost_follower', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM pg_proc WHERE proname='update_comment_count') THEN
    INSERT INTO _test_results VALUES ('Function: update_comment_count', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Function: update_comment_count', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM pg_proc WHERE proname='update_like_count') THEN
    INSERT INTO _test_results VALUES ('Function: update_like_count', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Function: update_like_count', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM pg_proc WHERE proname='update_save_count') THEN
    INSERT INTO _test_results VALUES ('Function: update_save_count', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Function: update_save_count', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM pg_proc WHERE proname='update_share_count') THEN
    INSERT INTO _test_results VALUES ('Function: update_share_count', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Function: update_share_count', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM pg_proc WHERE proname='refresh_profile_ban_state') THEN
    INSERT INTO _test_results VALUES ('Function: refresh_profile_ban_state', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Function: refresh_profile_ban_state', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM pg_proc WHERE proname='manage_follow_counts') THEN
    INSERT INTO _test_results VALUES ('Function: manage_follow_counts', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Function: manage_follow_counts', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM pg_proc WHERE proname='get_mutual_count') THEN
    INSERT INTO _test_results VALUES ('Function: get_mutual_count', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Function: get_mutual_count', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM pg_proc WHERE proname='get_or_create_conversation_with_user') THEN
    INSERT INTO _test_results VALUES ('Function: get_or_create_conversation_with_user', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Function: get_or_create_conversation_with_user', 'FAIL', 'Missing');
  END IF;
END $$;

-- =====================
-- 5. TRIGGERS
-- =====================
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.triggers WHERE event_object_table='followers' AND trigger_name='on_new_follow') THEN
    INSERT INTO _test_results VALUES ('Trigger: on_new_follow', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Trigger: on_new_follow', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.triggers WHERE event_object_table='followers' AND trigger_name='on_unfollow') THEN
    INSERT INTO _test_results VALUES ('Trigger: on_unfollow', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Trigger: on_unfollow', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.triggers WHERE event_object_table='comments' AND trigger_name='comments_after_change') THEN
    INSERT INTO _test_results VALUES ('Trigger: comments_after_change', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Trigger: comments_after_change', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.triggers WHERE event_object_table='likes' AND trigger_name='likes_after_change') THEN
    INSERT INTO _test_results VALUES ('Trigger: likes_after_change', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Trigger: likes_after_change', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.triggers WHERE event_object_table='bookmarks' AND trigger_name='bookmarks_after_change') THEN
    INSERT INTO _test_results VALUES ('Trigger: bookmarks_after_change', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Trigger: bookmarks_after_change', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.triggers WHERE event_object_table='shares' AND trigger_name='shares_after_change') THEN
    INSERT INTO _test_results VALUES ('Trigger: shares_after_change', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Trigger: shares_after_change', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM information_schema.triggers WHERE event_object_table='auth.users' AND trigger_name='on_auth_user_created') THEN
    INSERT INTO _test_results VALUES ('Trigger: on_auth_user_created', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Trigger: on_auth_user_created', 'FAIL', 'Run patch_schema.sql');
  END IF;
END $$;

-- =====================
-- 6. ENUM TYPES
-- =====================
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_type WHERE typname='privacy_level') THEN
    INSERT INTO _test_results VALUES ('Enum: privacy_level', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Enum: privacy_level', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM pg_type WHERE typname='reaction_type') THEN
    INSERT INTO _test_results VALUES ('Enum: reaction_type', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Enum: reaction_type', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM pg_type WHERE typname='collab_status') THEN
    INSERT INTO _test_results VALUES ('Enum: collab_status', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Enum: collab_status', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM pg_type WHERE typname='member_role') THEN
    INSERT INTO _test_results VALUES ('Enum: member_role', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Enum: member_role', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM pg_type WHERE typname='membership_status') THEN
    INSERT INTO _test_results VALUES ('Enum: membership_status', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Enum: membership_status', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM pg_type WHERE typname='membership_type') THEN
    INSERT INTO _test_results VALUES ('Enum: membership_type', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Enum: membership_type', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM pg_type WHERE typname='report_category') THEN
    INSERT INTO _test_results VALUES ('Enum: report_category', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Enum: report_category', 'FAIL', 'Missing');
  END IF;

  IF EXISTS (SELECT 1 FROM pg_type WHERE typname='report_status') THEN
    INSERT INTO _test_results VALUES ('Enum: report_status', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Enum: report_status', 'FAIL', 'Missing');
  END IF;
END $$;

-- =====================
-- 7. REALTIME
-- =====================
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname='supabase_realtime' AND tablename='messages') THEN
    INSERT INTO _test_results VALUES ('Realtime: messages', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Realtime: messages', 'FAIL', 'Run: ALTER PUBLICATION supabase_realtime ADD TABLE messages;');
  END IF;

  IF EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname='supabase_realtime' AND tablename='conversation_participants') THEN
    INSERT INTO _test_results VALUES ('Realtime: conversation_participants', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Realtime: conversation_participants', 'FAIL', 'Run: ALTER PUBLICATION supabase_realtime ADD TABLE conversation_participants;');
  END IF;

  IF EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname='supabase_realtime' AND tablename='notifications') THEN
    INSERT INTO _test_results VALUES ('Realtime: notifications', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Realtime: notifications', 'FAIL', 'Run: ALTER PUBLICATION supabase_realtime ADD TABLE notifications;');
  END IF;

  IF EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname='supabase_realtime' AND tablename='followers') THEN
    INSERT INTO _test_results VALUES ('Realtime: followers', 'PASS', '');
  ELSE
    INSERT INTO _test_results VALUES ('Realtime: followers', 'FAIL', 'Run: ALTER PUBLICATION supabase_realtime ADD TABLE followers;');
  END IF;
END $$;

-- =====================
-- RESULTS
-- =====================
SELECT
  test_name AS "Test",
  status AS "Status",
  detail AS "Detail"
FROM _test_results
ORDER BY
  CASE status WHEN 'FAIL' THEN 0 ELSE 1 END,
  test_name;

-- Summary
SELECT
  status,
  COUNT(*) AS count
FROM _test_results
GROUP BY status;

-- Cleanup
DROP TABLE IF EXISTS _test_results;
