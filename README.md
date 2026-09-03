# ConnectSphere

A full-stack social media platform built with Next.js and Supabase, featuring real-time messaging, communities, stories, creator analytics, and payment-gated communities via Razorpay.

## Features

- **Authentication** — Email/password signup, Google OAuth, profile completion flow
- **Feed** — Algorithmic home feed with infinite scroll, post creation with media upload
- **Posts** — Text/image/video posts, hashtags, collaborators, threads
- **Engagement** — Likes, comments (with replies), bookmarks, shares
- **Stories** — 24-hour expiring stories with reactions
- **Follow System** — Follow/unfollow, follow requests for private accounts, follower/following lists
- **Messaging** — Real-time 1-on-1 chat with image support, read receipts, block/unblock
- **Communities** — Free and paid communities, role-based access (owner, co-owner, admin, moderator, member)
- **Notifications** — Real-time notifications for likes, comments, follows, follow requests, collaboration invites
- **Moderation** — Report system, user bans, moderator dashboard
- **Profile** — Edit profile, privacy settings (public/private/followers), verification system
- **Analytics** — Creator dashboard with post performance, follower growth, and engagement metrics
- **Payments** — Razorpay integration for paid community memberships

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Next.js 15 (App Router, Turbopack), React, TypeScript |
| UI | shadcn/ui, Radix UI, Tailwind CSS |
| Backend | Supabase (PostgreSQL, Auth, Storage, Realtime) |
| Payments | Razorpay |
| AI | Google Genkit |

## Getting Started

### Prerequisites

- Node.js 18+
- A [Supabase](https://supabase.com) project
- A [Razorpay](https://razorpay.com) test account (optional, for paid communities)

### Installation

```bash
git clone https://github.com/202301469-wq/Connect-Sphere.git
cd Connect-Sphere/Website
npm install
```

### Environment Variables

Create `Website/.env.local`:

```env
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
GOOGLE_CLIENT_ID=your_google_oauth_client_id
GOOGLE_CLIENT_SECRET=your_google_oauth_client_secret
NEXT_PUBLIC_SUPABASE_MEDIA_BUCKET=media
NEXT_PUBLIC_SUPABASE_AVATAR_BUCKET=avatars
RAZORPAY_KEY_ID=rzp_test_your_key
RAZORPAY_KEY_SECRET=your_razorpay_secret
NEXT_PUBLIC_RAZORPAY_KEY_ID=rzp_test_your_key
```

### Database Setup

Run these SQL scripts in your Supabase SQL Editor in order:

1. `public_schema.sql` — Main schema (tables, functions, triggers, RLS policies)
2. `moderation_schema.sql` — Moderation additions (bans, reports)
3. `Website/sql/patch_schema.sql` — Patches and missing columns/policies
4. `Website/sql/test.sql` — Verify everything is set up correctly

### Storage Buckets

Create these buckets in Supabase Storage and set them to **public**:

- `avatars` — Profile pictures
- `media` — Post images/videos
- `stories` — Story uploads

The RLS policies for these buckets are created by `patch_schema.sql`.

### Run

```bash
npm run dev
```

The app runs at [http://localhost:9002](http://localhost:9002).

## Project Structure

```
Connect-Sphere/
├── Website/
│   ├── src/
│   │   ├── app/              # Next.js App Router pages
│   │   │   ├── (auth)/       # Login, signup, forgot password
│   │   │   ├── api/          # API routes (payments, messages, moderation)
│   │   │   ├── feed/         # Home feed
│   │   │   ├── profile/      # User profiles
│   │   │   ├── messages/     # Direct messaging
│   │   │   ├── communities/  # Community pages
│   │   │   └── notifications/
│   │   ├── components/       # React components
│   │   │   ├── feed/         # Posts, stories, comments, engagement
│   │   │   ├── messages/     # Chat layout
│   │   │   ├── communities/  # Community cards, payments
│   │   │   ├── profile/      # Profile header, edit form
│   │   │   ├── moderation/   # Moderator dashboard
│   │   │   └── ui/           # shadcn/ui components
│   │   ├── lib/              # Utilities, types, Supabase clients
│   │   └── hooks/            # Custom React hooks
│   └── sql/                  # Database scripts
├── public_schema.sql         # Full database schema
├── moderation_schema.sql     # Moderation schema additions
└── Docs/                     # Project documentation
```

## Test Accounts

To make a user a moderator (for `/moderation` page access):

```sql
UPDATE profiles SET is_moderator = true WHERE username = 'your_username';
```

## License

This project is for academic purposes.
