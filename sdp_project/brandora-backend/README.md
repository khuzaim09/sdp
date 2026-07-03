# Brandora Backend — AI Digital Marketing API

## 🚀 Quick Start

```bash
# 1. Install dependencies
cd brandora-backend
npm install

# 2. Configure environment
cp .env.example .env
# Edit .env with your real API keys

# 3. Add Firebase Service Account
# Download from Firebase Console → Project Settings → Service Accounts
# Save as: src/config/serviceAccountKey.json

# 4. Run development server
npm run dev
```

## 📋 API Endpoints

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | `/auth/signup` | ❌ | Register + free trial |
| POST | `/auth/login` | ❌ | Login, get JWT |
| POST | `/auth/forgot-password` | ❌ | Password reset email |
| GET | `/auth/profile` | ✅ | Get user profile |
| PUT | `/auth/profile` | ✅ | Update profile |
| GET | `/subscription/plans` | ❌ | View all plans |
| POST | `/subscription/upgrade` | ✅ | Upgrade plan |
| GET | `/subscription/status` | ✅ | Subscription status |
| POST | `/ai/generate-business` | ✅ | Business ideas |
| POST | `/ai/generate-post` | ✅ | Social media post |
| POST | `/ai/generate-plan` | ✅ | Marketing plan |
| POST | `/ai/generate-hashtags` | ✅ | Hashtags |
| POST | `/chat/new` | ✅ | New chat session |
| POST | `/chat/message` | ✅ | Send message |
| GET | `/chat/history` | ✅ | Chat history |
| DELETE | `/chat/:chatId` | ✅ | Delete chat |
| POST | `/social/create-post` | ✅ | Save post draft |
| POST | `/social/schedule-post` | ✅ | Schedule post |
| POST | `/social/publish-post` | ✅ | Publish (simulated) |
| GET | `/social/posts` | ✅ | Get all posts |
| GET | `/analytics` | ✅ | Analytics data |
| POST | `/website/generate` | ✅ | Generate website |
| GET | `/website/my-websites` | ✅ | My websites |
| POST | `/logo/generate` | ✅ | Generate logo |
| GET | `/logo/my-logos` | ✅ | My logos |

## 🏗️ Tech Stack
- Node.js + Express.js
- Firebase Admin SDK (Firestore + Auth + Storage)
- OpenAI GPT-4o-mini + HuggingFace fallback
- JWT Authentication
- Canvas (logo generation)

## 📦 Deployment (Render.com)
1. Push to GitHub
2. Create Render Web Service
3. Build Command: `npm install`
4. Start Command: `node server.js`
5. Add all env vars in Render dashboard
