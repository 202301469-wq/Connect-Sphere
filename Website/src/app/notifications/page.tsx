import { AppShell } from "@/components/app-shell";
import { NotificationList } from "@/components/notifications/notification-list";
import { createServerClient } from "@/lib/supabase/server";
import { redirect } from "next/navigation";
import CollabInvites from "@/components/notifications/collab-invites";
import { FollowRequests } from "@/components/feed/follow-requests";

export default async function NotificationsPage() {
  const supabase = await createServerClient();

  const { data: { user } } = await supabase.auth.getUser();

  if (!user) {
    redirect('/login');
  }

  return (
    <AppShell>
      <h1 className="text-3xl font-bold tracking-tight mb-8">Notifications</h1>
      
      <div className="space-y-6">
        <FollowRequests currentUserId={user.id} />
        <CollabInvites />
        <NotificationList />
      </div>
    </AppShell>
  );
}