import { createClient } from "./client";
import type { Story, UserProfile } from '@/lib/types';

// Define the grouped structure for the frontend
export interface StoryGroup {
  profile: UserProfile;
  isOwner: boolean;
  stories: Story[];
}

export async function fetchActiveStories(currentUserId: string): Promise<StoryGroup[]> {
  const supabase = createClient();
  const now = new Date().toISOString();

  try {
    // 1. Get IDs of users the current user follows
    // Using 'followers' table and removing the non-existent 'status' filter
    const { data: followsData, error: followsError } = await supabase
      .from('followers')
      .select('following_id')
      .eq('follower_id', currentUserId);

    if (followsError) {
      return [];
    }

    // Safely map the returned objects to an array of IDs
    const followingUserIds = (followsData || [])
      .map(f => f.following_id)
      .filter((id): id is string => typeof id === 'string'); // Ensure only valid strings are included

    console.log("FETCH_STORIES: Found following IDs:", followingUserIds);

    // Include the current user's ID to ensure they see their own story
    const relevantUserIds = [...followingUserIds, currentUserId];


    // 2. Fetch stories: Filter by relevant users AND ensure expires_at is in the future
    const { data: stories, error: storiesError } = await supabase
      .from('stories')
      .select(`
        *,
        author:profiles(id, username, avatar_url, display_name) 
      `)
      .in('user_id', relevantUserIds)
      .gt('expires_at', now)
      .order('created_at', { ascending: false });


    if (storiesError) {
      return [];
    }


    // 3. Group stories by user
    const storiesByUser = (stories || []).reduce((acc, story) => {
      const userId = story.user_id;
      if (!acc[userId]) {
        acc[userId] = {
          profile: story.author,
          isOwner: userId === currentUserId,
          stories: []
        };
      }
      acc[userId].stories.push(story);
      return acc;
    }, {} as Record<string, StoryGroup>);

    return Object.values(storiesByUser);

  } catch (error) {
    return [];
  }
}