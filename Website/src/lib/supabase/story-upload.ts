// src/lib/supabase/story-upload.ts
import { createClient } from "./client"; // Use your provided client utility

const STORY_BUCKET = "stories";
const EXPIRATION_HOURS = 24;

export async function uploadStory(file: File, userId: string) {
  const supabase = createClient();
  const fileExtension = file.name.split(".").pop();
  const timestamp = Date.now();
  const filePath = `${userId}/${timestamp}.${fileExtension}`;

  // Calculate expiration time (24 hours from now)
  const expiresAt = new Date(timestamp + EXPIRATION_HOURS * 60 * 60 * 1000).toISOString();

  // 1. Upload file to Storage
  const { error: uploadError } = await supabase.storage
    .from(STORY_BUCKET)
    .upload(filePath, file);

  if (uploadError) {
    throw new Error(`Storage upload failed: ${uploadError.message}`);
  }

  // 2. Get the public URL
  const { data: urlData } = supabase.storage
    .from(STORY_BUCKET)
    .getPublicUrl(filePath);

  if (!urlData.publicUrl) {
    // Clean up uploaded file if URL generation fails
    await supabase.storage.from(STORY_BUCKET).remove([filePath]);
    throw new Error("Could not generate public URL for story media.");
  }

  // 3. Insert record into the 'stories' table
  const { data: story, error: dbError } = await supabase
    .from("stories")
    .insert([
      {
        user_id: userId,
        media_url: urlData.publicUrl,
        media_type: file.type.startsWith("video/") ? "video" : "image",
        expires_at: expiresAt,
      },
    ])
    .select()
    .single();

  if (dbError) {
    // Clean up uploaded file if DB insert fails
    await supabase.storage.from(STORY_BUCKET).remove([filePath]);
    throw new Error(`DB insert failed: ${dbError.message}`);
  }

  return story;
}