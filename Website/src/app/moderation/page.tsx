import { Suspense } from "react";
import { ModeratorDashboard } from "@/components/moderation/moderator-dashboard";
import { Skeleton } from "@/components/ui/skeleton";
import { createServerClient } from "@/lib/supabase/server";
import { redirect } from "next/navigation";

export default async function ModerationPage() {
  const supabase = await createServerClient();
  const { data: { user } } = await supabase.auth.getUser();

  if (!user) redirect("/login");

  const { data: profile } = await supabase
    .from("profiles")
    .select("is_moderator")
    .eq("id", user.id)
    .maybeSingle();

  if (!profile?.is_moderator) redirect("/feed");

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">Moderator Console</h1>
        <p className="mt-2 text-muted-foreground">
          Review new reports, apply account restrictions, and keep the community safe.
        </p>
      </div>
      <Suspense
        fallback={
          <div className="space-y-4">
            <Skeleton className="h-16 w-full" />
            <Skeleton className="h-32 w-full" />
            <Skeleton className="h-64 w-full" />
          </div>
        }
      >
        <ModeratorDashboard />
      </Suspense>
    </div>
  );
}
