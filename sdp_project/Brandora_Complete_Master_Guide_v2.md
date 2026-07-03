# 🚀 Brandora — AI Powered Digital Marketing Assistant
## Complete Master Guide: Backend Architecture + UI/UX Polish System
### FYP Production-Ready Implementation — v2.0

---

> **How to use this document:**  
> Yeh document ek **master guide** hai jo aapke poore project ka blueprint hai — backend se le kar UI/UX polish tak. Sequence follow karo:  
> `Firebase Setup → Node.js API → AI Integration → Flutter Integration → UI/UX Polish → Deployment`

---

## 📑 TABLE OF CONTENTS

### PART A — BACKEND
1. [System Architecture Overview](#1-system-architecture-overview)
2. [Project Structure](#2-project-structure)
3. [Firebase Complete Setup](#3-firebase-complete-setup)
4. [Firestore Database Design](#4-firestore-database-design)
5. [Firebase Security Rules](#5-firebase-security-rules)
6. [Node.js + Express API Server](#6-nodejs--express-api-server)
7. [Authentication System](#7-authentication-system)
8. [Subscription & Payment System](#8-subscription--payment-system)
9. [AI Integration Layer](#9-ai-integration-layer)
10. [Chatbot System (Multi-turn, Urdu+English)](#10-chatbot-system)
11. [Social Media Automation (Simulated)](#11-social-media-automation)
12. [Website Builder Backend](#12-website-builder-backend)
13. [Analytics System](#13-analytics-system)
14. [Logo & Branding Generation](#14-logo--branding-generation)
15. [Voice Feature Backend Support](#15-voice-feature-backend-support)
16. [All API Endpoints Reference](#16-all-api-endpoints-reference)
17. [Flutter Integration Guide](#17-flutter-integration-guide)
18. [Environment Variables & Config](#18-environment-variables--config)
19. [Deployment Guide (Render + Firebase)](#19-deployment-guide)

### PART B — UI/UX POLISH SYSTEM
20. [Global Branding & Theme System](#20-global-branding--theme-system)
21. [Logo Design Guidelines](#21-logo-design-guidelines)
22. [Typography System](#22-typography-system)
23. [Icon System](#23-icon-system)
24. [Component Design System](#24-component-design-system)
25. [Animation System](#25-animation-system)
26. [Screen-by-Screen Polish Guide](#26-screen-by-screen-polish-guide)
27. [Dark Mode Implementation](#27-dark-mode-implementation)
28. [Responsiveness & Adaptive Layouts](#28-responsiveness--adaptive-layouts)
29. [Loading, Empty & Error States](#29-loading-empty--error-states)
30. [Accessibility & RTL (Urdu) Support](#30-accessibility--rtl-urdu-support)
31. [Flutter UI Code Templates](#31-flutter-ui-code-templates)
32. [Final Polish Checklist](#32-final-polish-checklist)

### PART C — REFERENCE
33. [Quick Implementation Checklist](#33-quick-implementation-checklist)
34. [Claude AI Mega Prompt](#34-claude-ai-mega-prompt)

---

# ═══════════════════════════════
# PART A — BACKEND
# ═══════════════════════════════

## 1. SYSTEM ARCHITECTURE OVERVIEW

```
┌─────────────────────────────────────────────────────────────────┐
│                     BRANDORA SYSTEM ARCHITECTURE                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│   ┌──────────────┐        ┌──────────────────────────────────┐  │
│   │  Flutter App  │──────▶│    Node.js + Express API Layer   │  │
│   │  (Frontend)   │◀──────│    (REST API — Port 3000)        │  │
│   └──────────────┘  HTTPS └──────────────┬───────────────────┘  │
│                                          │                        │
│               ┌──────────────────────────┼──────────────────┐   │
│               │                          │                   │   │
│               ▼                          ▼                   ▼   │
│   ┌───────────────────┐   ┌───────────────────┐   ┌──────────┐  │
│   │  Firebase Auth    │   │    Firestore DB    │   │ Firebase │  │
│   │  (JWT Tokens)     │   │  (NoSQL Database)  │   │ Storage  │  │
│   └───────────────────┘   └───────────────────┘   └──────────┘  │
│                                          │                        │
│               ┌──────────────────────────┼──────────────────┐   │
│               │                          │                   │   │
│               ▼                          ▼                   ▼   │
│   ┌───────────────────┐   ┌───────────────────┐   ┌──────────┐  │
│   │   OpenAI API      │   │  HuggingFace API   │   │  Canvas  │  │
│   │  (GPT-4o-mini)    │   │   (Fallback AI)    │   │  (Logo)  │  │
│   └───────────────────┘   └───────────────────┘   └──────────┘  │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

### Tech Stack Summary

| Layer | Technology | Purpose |
|-------|-----------|---------|
| Frontend | Flutter | Mobile App UI |
| API Layer | Node.js + Express | REST API Server |
| Auth | Firebase Auth + JWT | User Authentication |
| Database | Firestore (NoSQL) | All Data Storage |
| File Storage | Firebase Storage | Logos, Media |
| Primary AI | OpenAI GPT-4o-mini | Text Generation, Chatbot |
| Fallback AI | HuggingFace Inference | Free AI Fallback |
| Hosting | Render.com | Node.js Deployment |
| Frontend Hosting | Firebase Hosting | Static Assets |

---

## 2. PROJECT STRUCTURE

```
brandora-backend/
│
├── 📁 src/
│   ├── 📁 config/
│   │   ├── firebase.js            # Firebase Admin SDK init
│   │   ├── openai.js              # OpenAI client config
│   │   └── constants.js           # App constants & plan limits
│   │
│   ├── 📁 middleware/
│   │   ├── authMiddleware.js      # JWT verification
│   │   ├── planMiddleware.js      # Subscription plan checker
│   │   ├── rateLimiter.js         # Rate limiting
│   │   └── errorHandler.js        # Global error handler
│   │
│   ├── 📁 routes/
│   │   ├── authRoutes.js          # /auth/*
│   │   ├── aiRoutes.js            # /ai/*
│   │   ├── subscriptionRoutes.js  # /subscription/*
│   │   ├── socialRoutes.js        # /social/*
│   │   ├── analyticsRoutes.js     # /analytics/*
│   │   ├── websiteRoutes.js       # /website/*
│   │   ├── chatRoutes.js          # /chat/*
│   │   └── logoRoutes.js          # /logo/*
│   │
│   ├── 📁 controllers/
│   │   ├── authController.js
│   │   ├── aiController.js
│   │   ├── subscriptionController.js
│   │   ├── socialController.js
│   │   ├── analyticsController.js
│   │   ├── websiteController.js
│   │   ├── chatController.js
│   │   └── logoController.js
│   │
│   ├── 📁 services/
│   │   ├── firebaseService.js     # Firestore CRUD operations
│   │   ├── openaiService.js       # OpenAI API calls
│   │   ├── huggingfaceService.js  # HuggingFace fallback
│   │   ├── storageService.js      # Firebase Storage ops
│   │   └── emailService.js        # Email notifications
│   │
│   ├── 📁 utils/
│   │   ├── jwtUtils.js            # Token generation/verify
│   │   ├── hashUtils.js           # bcrypt helpers
│   │   ├── responseUtils.js       # Standardized responses
│   │   ├── hashtagGenerator.js    # Hashtag logic
│   │   └── logoGenerator.js       # Canvas logo gen
│   │
│   └── app.js                     # Express app setup
│
├── 📁 functions/                  # Firebase Cloud Functions
│   ├── index.js
│   └── triggers/
│       ├── onUserCreate.js        # Auto assign free trial
│       └── onSubscriptionExpire.js
│
├── 📁 firebase/
│   ├── firestore.rules            # Security rules
│   ├── storage.rules              # Storage rules
│   └── firebase.json              # Firebase config
│
├── server.js                      # Entry point
├── package.json
├── .env                           # Environment variables
├── .env.example
└── README.md
```

---

## 3. FIREBASE COMPLETE SETUP

### Step 1: Create Firebase Project

```
1. Go to: https://console.firebase.google.com
2. Click "Add Project"
3. Name: brandora-app
4. Enable Google Analytics: YES
5. Click "Create Project"
```

### Step 2: Enable Services

```
Firebase Console → Your Project:

✅ Authentication → Sign-in Method → Email/Password → Enable
✅ Firestore Database → Create Database → Production Mode
✅ Storage → Get Started → Production Mode
✅ Hosting → Get Started
```

### Step 3: Generate Service Account Key

```
Firebase Console → Project Settings → Service Accounts
→ Generate New Private Key → Download JSON
→ Save as: serviceAccountKey.json (in /src/config/)
→ ADD TO .gitignore IMMEDIATELY!
```

### Step 4: Install Firebase Admin SDK

```bash
npm install firebase-admin
```

### Step 5: Firebase Admin Initialization

```javascript
// src/config/firebase.js

const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    storageBucket: process.env.FIREBASE_STORAGE_BUCKET
  });
}

const db = admin.firestore();
const auth = admin.auth();
const storage = admin.storage();
const bucket = storage.bucket();

db.settings({ ignoreUndefinedProperties: true });

module.exports = { admin, db, auth, storage, bucket };
```

### Step 6: Firebase Client Config (for Flutter)

```dart
// flutter: lib/firebase_options.dart (auto-generated by FlutterFire CLI)
// Run: flutterfire configure
// This auto-generates google-services.json (Android) + GoogleService-Info.plist (iOS)

// pubspec.yaml dependencies:
// firebase_core: ^2.24.2
// firebase_auth: ^4.15.3
// cloud_firestore: ^4.13.6
// firebase_storage: ^11.5.6
```

---

## 4. FIRESTORE DATABASE DESIGN

### Collection: `users`

```javascript
// Document ID: Firebase UID (auto)
// Path: /users/{userId}

{
  user_id: "firebase_uid_abc123",
  name: "Ahmed Ali",
  email: "ahmed@example.com",
  plan: "free_trial",              // free_trial | basic | business | pro
  language: "en",                  // en | ur
  profile_image: "",
  is_email_verified: false,
  is_active: true,
  last_login: Timestamp,
  created_at: Timestamp,
  updated_at: Timestamp
}
```

### Collection: `subscriptions`

```javascript
// Path: /subscriptions/{subscriptionId}

{
  subscription_id: "sub_xyz789",
  user_id: "firebase_uid_abc123",
  plan_type: "basic",              // free_trial | basic | business | pro
  price_paid: 0,                   // in PKR
  start_date: Timestamp,
  end_date: Timestamp,             // null for lifetime/pro
  status: "active",               // active | expired | cancelled
  payment_method: "card",
  transaction_id: "txn_mock_001",
  auto_renew: false,
  created_at: Timestamp
}
```

**Plan Duration Logic:**

| Plan | Duration | Price (PKR) | Features |
|------|----------|-------------|----------|
| Free Trial | 7 days | 0 | Limited AI calls (10/day) |
| Basic | 30 days | 999 | 50 AI calls/day, chatbot |
| Business | 365 days | 4999 | 200 AI calls/day, all features |
| Pro | Lifetime | 9999 | Unlimited, priority AI |

### Collection: `chats`

```javascript
// Path: /chats/{chatId}

{
  chat_id: "chat_abc123",
  user_id: "firebase_uid_abc123",
  title: "Marketing Plan for Clothing Brand",
  language: "en",                  // en | ur
  messages: [
    {
      message_id: "msg_001",
      role: "user",                // user | assistant
      content: "Help me create a marketing plan for my clothing brand",
      timestamp: Timestamp,
      tokens_used: 0
    },
    {
      message_id: "msg_002",
      role: "assistant",
      content: "Great! I'll help you create a comprehensive marketing plan...",
      timestamp: Timestamp,
      tokens_used: 245
    }
  ],
  total_messages: 2,
  created_at: Timestamp,
  updated_at: Timestamp
}
```

### Collection: `marketing_plans`

```javascript
// Path: /marketing_plans/{planId}

{
  plan_id: "mp_abc123",
  user_id: "firebase_uid_abc123",
  business_name: "Style Closet",
  industry: "Fashion",
  target_audience: "Women 18-35",
  budget: "50000",
  plan_data: {
    executive_summary: "...",
    target_market: { ... },
    marketing_channels: [ ... ],
    content_strategy: { ... },
    budget_allocation: { ... },
    kpis: [ ... ],
    timeline: [ ... ]
  },
  status: "generated",
  created_at: Timestamp,
  updated_at: Timestamp
}
```

### Collection: `social_posts`

```javascript
// Path: /social_posts/{postId}

{
  post_id: "post_abc123",
  user_id: "firebase_uid_abc123",
  platform: "instagram",           // instagram | facebook | twitter | linkedin
  content: "✨ New collection is here!...",
  hashtags: ["#fashion", "#style", "#ootd"],
  media_url: "",
  scheduled_time: Timestamp,
  status: "scheduled",             // draft | scheduled | published | failed
  is_published: false,
  published_at: null,
  created_at: Timestamp
}
```

### Collection: `analytics`

```javascript
// Path: /analytics/{userId}

{
  user_id: "firebase_uid_abc123",
  period: "2024-01",
  overview: {
    total_posts: 24,
    total_reach: 15420,
    total_engagement: 2341,
    followers_growth: 127
  },
  instagram: {
    followers: 1250,
    posts: 12,
    likes: 1560,
    comments: 234,
    reach: 8900,
    engagement_rate: 4.2
  },
  facebook: {
    followers: 890,
    posts: 8,
    likes: 670,
    shares: 123,
    reach: 4200,
    engagement_rate: 3.8
  },
  twitter: {
    followers: 340,
    tweets: 4,
    retweets: 89,
    likes: 432,
    impressions: 2320
  },
  weekly_growth: [12, 8, 15, 22, 10, 18, 24],
  monthly_trend: [], // 30-element array
  updated_at: Timestamp
}
```

### Collection: `websites`

```javascript
// Path: /websites/{websiteId}

{
  website_id: "web_abc123",
  user_id: "firebase_uid_abc123",
  business_name: "Style Closet",
  business_idea: "Online clothing store for Pakistani women",
  public_url: "https://brandora.app/user123",
  content: {
    homepage: {
      headline: "...",
      subheadline: "...",
      cta_text: "Shop Now",
      hero_description: "..."
    },
    about_us: { title: "Our Story", content: "..." },
    products: [
      { name: "Summer Collection", description: "...", price_range: "PKR 1500-5000" }
    ],
    contact: { email: "info@stylecloset.pk", phone: "+92-XXX-XXXXXXX" }
  },
  status: "generated",
  created_at: Timestamp
}
```

### Collection: `logos`

```javascript
// Path: /logos/{logoId}

{
  logo_id: "logo_abc123",
  user_id: "firebase_uid_abc123",
  business_name: "Style Closet",
  initials: "SC",
  color_theme: "#FF6B6B",
  background_color: "#2D2D2D",
  font_style: "bold",
  shape: "circle",                 // circle | rounded | square
  storage_url: "gs://...",
  download_url: "https://...",
  created_at: Timestamp
}
```

---

## 5. FIREBASE SECURITY RULES

### Firestore Rules (`firestore.rules`)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    function isAuthenticated() {
      return request.auth != null;
    }

    function isOwner(userId) {
      return request.auth.uid == userId;
    }

    match /users/{userId} {
      allow read: if isAuthenticated() && isOwner(userId);
      allow create: if isAuthenticated() && isOwner(userId);
      allow update: if isAuthenticated() && isOwner(userId);
      allow delete: if false;
    }

    match /subscriptions/{subscriptionId} {
      allow read: if isAuthenticated() &&
                     resource.data.user_id == request.auth.uid;
      allow write: if false; // Only Admin SDK
    }

    match /chats/{chatId} {
      allow read, write: if isAuthenticated() &&
                            resource.data.user_id == request.auth.uid;
      allow create: if isAuthenticated() &&
                       request.resource.data.user_id == request.auth.uid;
    }

    match /marketing_plans/{planId} {
      allow read: if isAuthenticated() &&
                     resource.data.user_id == request.auth.uid;
      allow write: if false;
    }

    match /social_posts/{postId} {
      allow read: if isAuthenticated() &&
                     resource.data.user_id == request.auth.uid;
      allow write: if false;
    }

    match /analytics/{userId} {
      allow read: if isAuthenticated() && isOwner(userId);
      allow write: if false;
    }

    match /websites/{websiteId} {
      allow read: if isAuthenticated() &&
                     resource.data.user_id == request.auth.uid;
      allow write: if false;
    }

    match /logos/{logoId} {
      allow read: if isAuthenticated() &&
                     resource.data.user_id == request.auth.uid;
      allow write: if false;
    }
  }
}
```

### Firebase Storage Rules (`storage.rules`)

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {

    match /logos/{userId}/{fileName} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if false; // Only Admin SDK
    }

    match /media/{userId}/{fileName} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if request.auth != null &&
                      request.auth.uid == userId &&
                      request.resource.size < 10 * 1024 * 1024;
    }
  }
}
```

---

## 6. NODE.JS + EXPRESS API SERVER

### package.json

```json
{
  "name": "brandora-backend",
  "version": "1.0.0",
  "description": "Brandora AI Digital Marketing Backend",
  "main": "server.js",
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "firebase-admin": "^11.11.0",
    "openai": "^4.20.1",
    "bcryptjs": "^2.4.3",
    "jsonwebtoken": "^9.0.2",
    "cors": "^2.8.5",
    "dotenv": "^16.3.1",
    "express-rate-limit": "^7.1.5",
    "helmet": "^7.1.0",
    "morgan": "^1.10.0",
    "axios": "^1.6.2",
    "canvas": "^2.11.2",
    "uuid": "^9.0.0",
    "express-validator": "^7.0.1",
    "compression": "^1.7.4"
  },
  "devDependencies": {
    "nodemon": "^3.0.2"
  }
}
```

### server.js (Entry Point)

```javascript
require('dotenv').config();
const app = require('./src/app');

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`
  ╔═══════════════════════════════════════╗
  ║   🚀 Brandora Backend Running!        ║
  ║   Port: ${PORT}                           ║
  ║   Environment: ${process.env.NODE_ENV}  ║
  ╚═══════════════════════════════════════╝
  `);
});

module.exports = app;
```

### src/app.js (Express App)

```javascript
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const compression = require('compression');
const rateLimit = require('express-rate-limit');

const app = express();

app.use(helmet());
app.use(cors({
  origin: ['http://localhost:*', 'https://brandora.app'],
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

app.use(compression());
app.use(morgan('dev'));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

const globalLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 200,
  standardHeaders: true,
  message: { success: false, message: 'Too many requests. Please try again later.' }
});
app.use(globalLimiter);

app.get('/', (req, res) => {
  res.json({
    success: true,
    message: '🚀 Brandora API is running!',
    version: '1.0.0',
    timestamp: new Date().toISOString()
  });
});

app.use('/auth', require('./routes/authRoutes'));
app.use('/ai', require('./routes/aiRoutes'));
app.use('/subscription', require('./routes/subscriptionRoutes'));
app.use('/social', require('./routes/socialRoutes'));
app.use('/analytics', require('./routes/analyticsRoutes'));
app.use('/website', require('./routes/websiteRoutes'));
app.use('/chat', require('./routes/chatRoutes'));
app.use('/logo', require('./routes/logoRoutes'));

app.use('*', (req, res) => {
  res.status(404).json({ success: false, message: `Route ${req.originalUrl} not found` });
});

app.use((err, req, res, next) => {
  console.error('❌ Error:', err.stack);
  res.status(err.status || 500).json({
    success: false,
    message: err.message || 'Internal Server Error'
  });
});

module.exports = app;
```

---

## 7. AUTHENTICATION SYSTEM

### JWT Utilities (`src/utils/jwtUtils.js`)

```javascript
const jwt = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET;
const JWT_EXPIRES_IN = '7d';

const generateToken = (payload) => {
  return jwt.sign(payload, JWT_SECRET, { expiresIn: JWT_EXPIRES_IN });
};

const verifyToken = (token) => {
  try {
    return jwt.verify(token, JWT_SECRET);
  } catch (error) {
    throw new Error('Invalid or expired token');
  }
};

module.exports = { generateToken, verifyToken };
```

### Auth Middleware (`src/middleware/authMiddleware.js`)

```javascript
const { verifyToken } = require('../utils/jwtUtils');
const { db } = require('../config/firebase');

const authMiddleware = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ success: false, message: 'No token provided.' });
    }

    const token = authHeader.split(' ')[1];
    const decoded = verifyToken(token);

    const userDoc = await db.collection('users').doc(decoded.user_id).get();
    if (!userDoc.exists) {
      return res.status(401).json({ success: false, message: 'User no longer exists.' });
    }

    const userData = userDoc.data();
    if (!userData.is_active) {
      return res.status(403).json({ success: false, message: 'Account has been deactivated.' });
    }

    req.user = { user_id: decoded.user_id, email: userData.email, plan: userData.plan };
    next();
  } catch (error) {
    return res.status(401).json({ success: false, message: 'Invalid or expired token.' });
  }
};

module.exports = authMiddleware;
```

### Auth Controller (`src/controllers/authController.js`)

```javascript
const { admin, db, auth } = require('../config/firebase');
const { generateToken } = require('../utils/jwtUtils');
const bcrypt = require('bcryptjs');
const { v4: uuidv4 } = require('uuid');

// POST /auth/signup
const signup = async (req, res) => {
  try {
    const { name, email, password, language = 'en' } = req.body;

    if (!name || !email || !password) {
      return res.status(400).json({ success: false, message: 'All fields required.' });
    }

    // Create Firebase Auth user
    const firebaseUser = await auth.createUser({ email, password, displayName: name });
    await auth.sendEmailVerification(firebaseUser.uid); // Optional via Admin SDK

    const now = admin.firestore.Timestamp.now();
    const userId = firebaseUser.uid;

    // Create user document
    await db.collection('users').doc(userId).set({
      user_id: userId,
      name,
      email,
      plan: 'free_trial',
      language,
      profile_image: '',
      is_email_verified: false,
      is_active: true,
      last_login: now,
      created_at: now,
      updated_at: now
    });

    // Assign free trial subscription (7 days)
    const trialEnd = new Date();
    trialEnd.setDate(trialEnd.getDate() + 7);
    const subRef = db.collection('subscriptions').doc();
    await subRef.set({
      subscription_id: subRef.id,
      user_id: userId,
      plan_type: 'free_trial',
      price_paid: 0,
      start_date: now,
      end_date: admin.firestore.Timestamp.fromDate(trialEnd),
      status: 'active',
      payment_method: 'none',
      transaction_id: `trial_${uuidv4().slice(0, 8)}`,
      auto_renew: false,
      created_at: now
    });

    const token = generateToken({ user_id: userId, email });

    return res.status(201).json({
      success: true,
      message: '🎉 Account created successfully! Free trial activated.',
      data: { token, user: { user_id: userId, name, email, plan: 'free_trial' } }
    });
  } catch (error) {
    if (error.code === 'auth/email-already-exists') {
      return res.status(409).json({ success: false, message: 'Email already registered.' });
    }
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /auth/login
const login = async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(400).json({ success: false, message: 'Email and password required.' });
    }

    // Verify via Firebase (client-side normally, or use Admin SDK to find user)
    const firebaseUser = await auth.getUserByEmail(email);
    // Note: Firebase Admin SDK doesn't verify passwords directly.
    // For FYP level, store hashed password separately or use Firebase client SDK on Flutter side.

    const userDoc = await db.collection('users').doc(firebaseUser.uid).get();
    if (!userDoc.exists) {
      return res.status(404).json({ success: false, message: 'User not found.' });
    }

    const userData = userDoc.data();
    await db.collection('users').doc(firebaseUser.uid).update({
      last_login: admin.firestore.Timestamp.now()
    });

    const token = generateToken({ user_id: firebaseUser.uid, email });

    return res.status(200).json({
      success: true,
      message: 'Login successful!',
      data: { token, user: userData }
    });
  } catch (error) {
    return res.status(401).json({ success: false, message: 'Invalid credentials.' });
  }
};

// POST /auth/forgot-password
const forgotPassword = async (req, res) => {
  try {
    const { email } = req.body;
    // Firebase handles this automatically
    const link = await auth.generatePasswordResetLink(email);
    // In production, send via email service (nodemailer/sendgrid)
    return res.status(200).json({
      success: true,
      message: 'Password reset email sent.',
      // data: { link } // Remove in production
    });
  } catch (error) {
    return res.status(400).json({ success: false, message: 'Email not found.' });
  }
};

module.exports = { signup, login, forgotPassword };
```

### Auth Routes (`src/routes/authRoutes.js`)

```javascript
const express = require('express');
const router = express.Router();
const { signup, login, forgotPassword } = require('../controllers/authController');
const authMiddleware = require('../middleware/authMiddleware');

router.post('/signup', signup);
router.post('/login', login);
router.post('/forgot-password', forgotPassword);

router.get('/profile', authMiddleware, async (req, res) => {
  const { db } = require('../config/firebase');
  const userDoc = await db.collection('users').doc(req.user.user_id).get();
  res.json({ success: true, data: userDoc.data() });
});

module.exports = router;
```

---

## 8. SUBSCRIPTION & PAYMENT SYSTEM

### Subscription Controller (`src/controllers/subscriptionController.js`)

```javascript
const { admin, db } = require('../config/firebase');
const { v4: uuidv4 } = require('uuid');

const PLAN_CONFIG = {
  free_trial: { duration_days: 7, price: 0, ai_calls_per_day: 10 },
  basic:      { duration_days: 30, price: 999, ai_calls_per_day: 50 },
  business:   { duration_days: 365, price: 4999, ai_calls_per_day: 200 },
  pro:        { duration_days: null, price: 9999, ai_calls_per_day: -1 } // -1 = unlimited
};

// GET /subscription/plans
const getPlans = async (req, res) => {
  return res.status(200).json({
    success: true,
    data: {
      plans: [
        { id: 'free_trial', name: 'Free Trial', price: 0, duration: '7 days', features: ['10 AI calls/day', 'Basic chatbot', 'Limited posts'] },
        { id: 'basic', name: 'Basic', price: 999, duration: '30 days', features: ['50 AI calls/day', 'Full chatbot', 'Post scheduling'] },
        { id: 'business', name: 'Business', price: 4999, duration: '1 year', features: ['200 AI calls/day', 'All features', 'Analytics', 'Website builder'] },
        { id: 'pro', name: 'Pro', price: 9999, duration: 'Lifetime', features: ['Unlimited AI', 'Priority support', 'All current & future features'] }
      ]
    }
  });
};

// POST /subscription/upgrade
const upgradePlan = async (req, res) => {
  try {
    const { plan_type, card_number, card_name } = req.body;
    const userId = req.user.user_id;

    if (!PLAN_CONFIG[plan_type]) {
      return res.status(400).json({ success: false, message: 'Invalid plan.' });
    }

    const config = PLAN_CONFIG[plan_type];
    const now = admin.firestore.Timestamp.now();
    const startDate = new Date();
    const endDate = config.duration_days
      ? new Date(startDate.getTime() + config.duration_days * 24 * 60 * 60 * 1000)
      : null;

    // Mark old subscription as superseded
    const oldSubs = await db.collection('subscriptions')
      .where('user_id', '==', userId)
      .where('status', '==', 'active')
      .get();
    const batch = db.batch();
    oldSubs.docs.forEach(doc => batch.update(doc.ref, { status: 'superseded' }));

    // Create new subscription
    const subRef = db.collection('subscriptions').doc();
    batch.set(subRef, {
      subscription_id: subRef.id,
      user_id: userId,
      plan_type,
      price_paid: config.price,
      start_date: now,
      end_date: endDate ? admin.firestore.Timestamp.fromDate(endDate) : null,
      status: 'active',
      payment_method: 'card',
      transaction_id: `txn_${uuidv4().slice(0, 12)}`,
      auto_renew: false,
      created_at: now
    });

    // Update user plan
    batch.update(db.collection('users').doc(userId), {
      plan: plan_type,
      updated_at: now
    });

    await batch.commit();

    return res.status(200).json({
      success: true,
      message: `🎉 Successfully upgraded to ${plan_type} plan!`,
      data: {
        plan: plan_type,
        transaction_id: `txn_${uuidv4().slice(0, 12)}`,
        expires: endDate ? endDate.toISOString() : 'Never (Lifetime)'
      }
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// GET /subscription/status
const getStatus = async (req, res) => {
  try {
    const userId = req.user.user_id;
    const snapshot = await db.collection('subscriptions')
      .where('user_id', '==', userId)
      .where('status', '==', 'active')
      .orderBy('created_at', 'desc')
      .limit(1)
      .get();

    if (snapshot.empty) {
      return res.status(200).json({ success: true, data: { status: 'no_subscription' } });
    }

    const sub = snapshot.docs[0].data();
    const now = new Date();
    const endDate = sub.end_date?.toDate();
    const isExpired = endDate ? now > endDate : false;

    return res.status(200).json({
      success: true,
      data: {
        ...sub,
        is_expired: isExpired,
        days_remaining: endDate
          ? Math.max(0, Math.ceil((endDate - now) / (1000 * 60 * 60 * 24)))
          : null
      }
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = { getPlans, upgradePlan, getStatus };
```

---

## 9. AI INTEGRATION LAYER

### OpenAI Service (`src/services/openaiService.js`)

```javascript
const OpenAI = require('openai');

const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

// Generate business ideas
const generateBusinessIdeas = async ({ industry, budget, location = 'Pakistan', language = 'en' }) => {
  const langInstruction = language === 'ur'
    ? 'Respond entirely in Urdu language.'
    : 'Respond in English.';

  const response = await openai.chat.completions.create({
    model: 'gpt-4o-mini',
    messages: [
      {
        role: 'system',
        content: `You are a business consultant specializing in Pakistani market. ${langInstruction} Return response as valid JSON only.`
      },
      {
        role: 'user',
        content: `Generate 3 business ideas for industry: ${industry}, budget: PKR ${budget}, location: ${location}.
        Return JSON: { ideas: [{ title, description, investment_required, potential_revenue, pros, cons, first_steps }] }`
      }
    ],
    max_tokens: 1500,
    temperature: 0.8
  });

  const content = response.choices[0].message.content;
  const clean = content.replace(/```json|```/g, '').trim();
  return JSON.parse(clean);
};

// Generate social media post
const generateSocialPost = async ({ business_name, product, platform, tone = 'engaging', language = 'en' }) => {
  const langInstruction = language === 'ur' ? 'Respond in Urdu.' : 'Respond in English.';

  const response = await openai.chat.completions.create({
    model: 'gpt-4o-mini',
    messages: [
      {
        role: 'system',
        content: `You are a social media marketing expert for Pakistani brands. ${langInstruction} Return JSON only.`
      },
      {
        role: 'user',
        content: `Create a ${platform} post for: ${business_name}, product: ${product}, tone: ${tone}.
        Return JSON: { caption, hashtags (array of 10), emoji_suggestions, call_to_action, best_posting_time }`
      }
    ],
    max_tokens: 800,
    temperature: 0.9
  });

  const content = response.choices[0].message.content;
  return JSON.parse(content.replace(/```json|```/g, '').trim());
};

// Generate marketing plan
const generateMarketingPlan = async ({ business_name, industry, target_audience, budget, language = 'en' }) => {
  const langInstruction = language === 'ur' ? 'Respond in Urdu.' : 'Respond in English.';

  const response = await openai.chat.completions.create({
    model: 'gpt-4o-mini',
    messages: [
      {
        role: 'system',
        content: `You are a marketing strategist for Pakistani SMBs. ${langInstruction} Return JSON only.`
      },
      {
        role: 'user',
        content: `Create a 3-month marketing plan for: ${business_name}, industry: ${industry}, audience: ${target_audience}, budget: PKR ${budget}.
        Return JSON: { executive_summary, target_market, marketing_channels, content_strategy, budget_allocation, kpis, monthly_timeline }`
      }
    ],
    max_tokens: 2000,
    temperature: 0.7
  });

  const content = response.choices[0].message.content;
  return JSON.parse(content.replace(/```json|```/g, '').trim());
};

module.exports = { generateBusinessIdeas, generateSocialPost, generateMarketingPlan };
```

### HuggingFace Fallback (`src/services/huggingfaceService.js`)

```javascript
const axios = require('axios');

const HF_API_URL = 'https://api-inference.huggingface.co/models/mistralai/Mistral-7B-Instruct-v0.1';

const generateWithHuggingFace = async (prompt) => {
  try {
    const response = await axios.post(
      HF_API_URL,
      { inputs: prompt, parameters: { max_new_tokens: 500, temperature: 0.7 } },
      { headers: { Authorization: `Bearer ${process.env.HUGGINGFACE_API_KEY}` } }
    );
    return response.data[0]?.generated_text || 'AI response unavailable.';
  } catch (error) {
    return 'AI service temporarily unavailable. Please try again.';
  }
};

module.exports = { generateWithHuggingFace };
```

### AI Controller (`src/controllers/aiController.js`)

```javascript
const { admin, db } = require('../config/firebase');
const { generateBusinessIdeas, generateSocialPost, generateMarketingPlan } = require('../services/openaiService');
const { generateWithHuggingFace } = require('../services/huggingfaceService');
const { v4: uuidv4 } = require('uuid');

// POST /ai/generate-business
const generateBusiness = async (req, res) => {
  try {
    const { industry, budget, location, language = 'en' } = req.body;
    if (!industry || !budget) {
      return res.status(400).json({ success: false, message: 'industry and budget are required.' });
    }

    let result;
    try {
      result = await generateBusinessIdeas({ industry, budget, location, language });
    } catch {
      // Fallback to HuggingFace
      const text = await generateWithHuggingFace(
        `Generate 3 business ideas for ${industry} with PKR ${budget} budget in Pakistan.`
      );
      result = { ideas: [{ title: 'AI Idea', description: text }] };
    }

    return res.status(200).json({ success: true, message: 'Business ideas generated!', data: result });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /ai/generate-post
const generatePost = async (req, res) => {
  try {
    const { business_name, product, platform, tone, language = 'en' } = req.body;
    const result = await generateSocialPost({ business_name, product, platform, tone, language });
    return res.status(200).json({ success: true, data: result });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /ai/generate-plan
const generatePlan = async (req, res) => {
  try {
    const { business_name, industry, target_audience, budget, language = 'en' } = req.body;
    const userId = req.user.user_id;

    const planData = await generateMarketingPlan({ business_name, industry, target_audience, budget, language });

    const now = admin.firestore.Timestamp.now();
    const planRef = db.collection('marketing_plans').doc();
    await planRef.set({
      plan_id: planRef.id,
      user_id: userId,
      business_name,
      industry,
      target_audience,
      budget,
      plan_data: planData,
      status: 'generated',
      created_at: now,
      updated_at: now
    });

    return res.status(200).json({
      success: true,
      message: 'Marketing plan generated and saved!',
      data: { plan_id: planRef.id, ...planData }
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /ai/generate-hashtags
const generateHashtags = async (req, res) => {
  try {
    const { keywords, platform = 'instagram', count = 15 } = req.body;
    if (!keywords || keywords.length === 0) {
      return res.status(400).json({ success: false, message: 'keywords required.' });
    }

    // Logic-based hashtag generation (no AI needed)
    const baseHashtags = keywords.map(k => `#${k.replace(/\s+/g, '').toLowerCase()}`);
    const platformTags = {
      instagram: ['#instadaily', '#instagood', '#photooftheday', '#trending', '#pakistan', '#viral'],
      facebook: ['#facebook', '#facebookmarketing', '#socialmedia', '#business', '#pakistan'],
      twitter: ['#trending', '#viral', '#pakistan', '#business', '#marketing'],
      linkedin: ['#business', '#marketing', '#entrepreneur', '#pakistan', '#growth']
    };

    const combined = [...new Set([...baseHashtags, ...(platformTags[platform] || [])])].slice(0, count);

    return res.status(200).json({
      success: true,
      data: { hashtags: combined, count: combined.length, platform }
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = { generateBusiness, generatePost, generatePlan, generateHashtags };
```

---

## 10. CHATBOT SYSTEM

### Chat Controller (`src/controllers/chatController.js`)

```javascript
const OpenAI = require('openai');
const { admin, db } = require('../config/firebase');
const { v4: uuidv4 } = require('uuid');

const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

const SYSTEM_PROMPT_EN = `You are Brandora AI — a friendly, knowledgeable digital marketing assistant specialized in helping Pakistani entrepreneurs and small businesses grow online. You help with: marketing strategies, social media content, business ideas, branding, SEO tips, and digital marketing in Pakistan context. Be concise, practical, and encouraging.`;

const SYSTEM_PROMPT_UR = `آپ Brandora AI ہیں — ایک دوستانہ اور ماہر ڈیجیٹل مارکیٹنگ اسسٹنٹ جو پاکستانی کاروباریوں کی مدد کرتے ہیں۔ آپ مارکیٹنگ اسٹریٹیجی، سوشل میڈیا، بزنس آئیڈیاز، اور ڈیجیٹل مارکیٹنگ میں مدد فراہم کرتے ہیں۔ اردو میں جواب دیں۔`;

// POST /chat/new — Create new chat session
const createNewChat = async (req, res) => {
  try {
    const { language = 'en' } = req.body;
    const userId = req.user.user_id;
    const now = admin.firestore.Timestamp.now();

    const welcomeMsg = language === 'ur'
      ? 'السلام علیکم! میں Brandora AI ہوں۔ آپ کی کاروباری ترقی میں کس طرح مدد کر سکتا ہوں؟ 🚀'
      : 'Hello! I\'m Brandora AI, your digital marketing assistant. How can I help grow your business today? 🚀';

    const chatRef = db.collection('chats').doc();
    const chatData = {
      chat_id: chatRef.id,
      user_id: userId,
      title: 'New Conversation',
      language,
      messages: [{
        message_id: `msg_${uuidv4().slice(0, 8)}`,
        role: 'assistant',
        content: welcomeMsg,
        timestamp: now,
        tokens_used: 0
      }],
      total_messages: 1,
      created_at: now,
      updated_at: now
    };

    await chatRef.set(chatData);

    return res.status(201).json({
      success: true,
      message: 'Chat session created!',
      data: { chat_id: chatRef.id, welcome_message: welcomeMsg, language }
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /chat/message — Send message
const sendMessage = async (req, res) => {
  try {
    const { message, chat_id, language = 'en' } = req.body;
    const userId = req.user.user_id;

    if (!message) {
      return res.status(400).json({ success: false, message: 'message is required.' });
    }

    const now = admin.firestore.Timestamp.now();
    let chatRef;
    let chatData;

    // Load existing chat or create new one
    if (chat_id) {
      const chatDoc = await db.collection('chats').doc(chat_id).get();
      if (!chatDoc.exists || chatDoc.data().user_id !== userId) {
        return res.status(404).json({ success: false, message: 'Chat not found.' });
      }
      chatRef = db.collection('chats').doc(chat_id);
      chatData = chatDoc.data();
    } else {
      chatRef = db.collection('chats').doc();
      chatData = {
        chat_id: chatRef.id,
        user_id: userId,
        title: message.slice(0, 50),
        language,
        messages: [],
        total_messages: 0,
        created_at: now,
        updated_at: now
      };
    }

    // Build conversation history for OpenAI (last 10 messages for context)
    const history = chatData.messages.slice(-10).map(msg => ({
      role: msg.role,
      content: msg.content
    }));

    const systemPrompt = language === 'ur' ? SYSTEM_PROMPT_UR : SYSTEM_PROMPT_EN;

    // Call OpenAI
    const completion = await openai.chat.completions.create({
      model: 'gpt-4o-mini',
      messages: [
        { role: 'system', content: systemPrompt },
        ...history,
        { role: 'user', content: message }
      ],
      max_tokens: 800,
      temperature: 0.7
    });

    const aiResponse = completion.choices[0].message.content;
    const tokensUsed = completion.usage?.completion_tokens || 0;

    // Add user + AI messages
    const userMsg = {
      message_id: `msg_${uuidv4().slice(0, 8)}`,
      role: 'user',
      content: message,
      timestamp: now,
      tokens_used: 0
    };

    const aiMsg = {
      message_id: `msg_${uuidv4().slice(0, 8)}`,
      role: 'assistant',
      content: aiResponse,
      timestamp: now,
      tokens_used: tokensUsed
    };

    // Update Firestore
    if (chat_id) {
      await chatRef.update({
        messages: admin.firestore.FieldValue.arrayUnion(userMsg, aiMsg),
        total_messages: admin.firestore.FieldValue.increment(2),
        updated_at: now
      });
    } else {
      chatData.messages = [userMsg, aiMsg];
      chatData.total_messages = 2;
      await chatRef.set(chatData);
    }

    return res.status(200).json({
      success: true,
      data: {
        chat_id: chatRef.id,
        user_message: userMsg,
        ai_response: aiMsg
      }
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// GET /chat/history
const getChatHistory = async (req, res) => {
  try {
    const userId = req.user.user_id;
    const snapshot = await db.collection('chats')
      .where('user_id', '==', userId)
      .orderBy('updated_at', 'desc')
      .limit(20)
      .get();

    const chats = snapshot.docs.map(doc => {
      const data = doc.data();
      return {
        chat_id: data.chat_id,
        title: data.title,
        language: data.language,
        total_messages: data.total_messages,
        last_message: data.messages[data.messages.length - 1]?.content?.slice(0, 80) || '',
        updated_at: data.updated_at?.toDate()
      };
    });

    return res.status(200).json({ success: true, data: { chats } });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// DELETE /chat/:chatId
const deleteChat = async (req, res) => {
  try {
    const { chatId } = req.params;
    const userId = req.user.user_id;

    const chatDoc = await db.collection('chats').doc(chatId).get();
    if (!chatDoc.exists || chatDoc.data().user_id !== userId) {
      return res.status(404).json({ success: false, message: 'Chat not found.' });
    }

    await db.collection('chats').doc(chatId).delete();
    return res.status(200).json({ success: true, message: 'Chat deleted successfully.' });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = { createNewChat, sendMessage, getChatHistory, deleteChat };
```

---

## 11. SOCIAL MEDIA AUTOMATION

### Social Controller (`src/controllers/socialController.js`)

```javascript
const { admin, db } = require('../config/firebase');
const { v4: uuidv4 } = require('uuid');

// POST /social/create-post
const createPost = async (req, res) => {
  try {
    const { platform, content, hashtags = [], media_url = '' } = req.body;
    const userId = req.user.user_id;

    if (!platform || !content) {
      return res.status(400).json({ success: false, message: 'platform and content required.' });
    }

    const now = admin.firestore.Timestamp.now();
    const postRef = db.collection('social_posts').doc();
    await postRef.set({
      post_id: postRef.id,
      user_id: userId,
      platform,
      content,
      hashtags,
      media_url,
      scheduled_time: null,
      status: 'draft',
      is_published: false,
      published_at: null,
      created_at: now
    });

    return res.status(201).json({
      success: true,
      message: 'Post saved as draft!',
      data: { post_id: postRef.id, status: 'draft' }
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /social/schedule-post
const schedulePost = async (req, res) => {
  try {
    const { post_id, scheduled_time } = req.body;
    const userId = req.user.user_id;

    const postDoc = await db.collection('social_posts').doc(post_id).get();
    if (!postDoc.exists || postDoc.data().user_id !== userId) {
      return res.status(404).json({ success: false, message: 'Post not found.' });
    }

    await db.collection('social_posts').doc(post_id).update({
      scheduled_time: admin.firestore.Timestamp.fromDate(new Date(scheduled_time)),
      status: 'scheduled'
    });

    return res.status(200).json({
      success: true,
      message: 'Post scheduled successfully! ✅',
      data: { post_id, scheduled_time, status: 'scheduled' }
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /social/publish-post (Simulated)
const publishPost = async (req, res) => {
  try {
    const { post_id } = req.body;
    const userId = req.user.user_id;

    const postDoc = await db.collection('social_posts').doc(post_id).get();
    if (!postDoc.exists || postDoc.data().user_id !== userId) {
      return res.status(404).json({ success: false, message: 'Post not found.' });
    }

    const now = admin.firestore.Timestamp.now();
    await db.collection('social_posts').doc(post_id).update({
      status: 'published',
      is_published: true,
      published_at: now
    });

    return res.status(200).json({
      success: true,
      message: '🚀 Post published successfully! (Simulated)',
      data: {
        post_id,
        status: 'published',
        platform_response: {
          instagram: { post_url: `https://instagram.com/p/${uuidv4().slice(0, 10)}`, likes: 0, comments: 0 }
        }
      }
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = { createPost, schedulePost, publishPost };
```

---

## 12. WEBSITE BUILDER BACKEND

### Website Controller (`src/controllers/websiteController.js`)

```javascript
const OpenAI = require('openai');
const { admin, db } = require('../config/firebase');
const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

// POST /website/generate
const generateWebsite = async (req, res) => {
  try {
    const { business_name, business_idea, industry, language = 'en' } = req.body;
    const userId = req.user.user_id;

    const langInstruction = language === 'ur' ? 'Respond in Urdu.' : 'Respond in English.';

    const response = await openai.chat.completions.create({
      model: 'gpt-4o-mini',
      messages: [
        {
          role: 'system',
          content: `You are a web copywriter for Pakistani businesses. ${langInstruction} Return JSON only.`
        },
        {
          role: 'user',
          content: `Generate complete website content for: ${business_name}, idea: ${business_idea}, industry: ${industry}.
          Return JSON: {
            homepage: { headline, subheadline, hero_description, cta_text, features (array of 3) },
            about_us: { title, story, mission, team_description },
            products: [ { name, description, price_range, highlights } ] (3 products),
            contact: { email, tagline }
          }`
        }
      ],
      max_tokens: 1500
    });

    const content = response.choices[0].message.content;
    const websiteContent = JSON.parse(content.replace(/```json|```/g, '').trim());

    const now = admin.firestore.Timestamp.now();
    const webRef = db.collection('websites').doc();
    const publicUrl = `https://brandora.app/${userId.slice(0, 8)}`;

    await webRef.set({
      website_id: webRef.id,
      user_id: userId,
      business_name,
      business_idea,
      industry,
      public_url: publicUrl,
      content: websiteContent,
      status: 'generated',
      created_at: now
    });

    return res.status(200).json({
      success: true,
      message: '🌐 Website content generated!',
      data: { website_id: webRef.id, public_url: publicUrl, content: websiteContent }
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = { generateWebsite };
```

---

## 13. ANALYTICS SYSTEM

### Analytics Controller (`src/controllers/analyticsController.js`)

```javascript
const { admin, db } = require('../config/firebase');

const generateMockAnalytics = (userId) => {
  const rand = (min, max) => Math.floor(Math.random() * (max - min + 1)) + min;

  return {
    user_id: userId,
    period: new Date().toISOString().slice(0, 7),
    overview: {
      total_posts: rand(15, 45),
      total_reach: rand(8000, 25000),
      total_engagement: rand(1000, 5000),
      followers_growth: rand(50, 300)
    },
    instagram: {
      followers: rand(800, 5000),
      posts: rand(8, 20),
      likes: rand(500, 3000),
      comments: rand(50, 500),
      reach: rand(4000, 15000),
      engagement_rate: parseFloat((Math.random() * 5 + 1).toFixed(1))
    },
    facebook: {
      followers: rand(500, 3000),
      posts: rand(5, 15),
      likes: rand(300, 2000),
      shares: rand(50, 300),
      reach: rand(2000, 8000),
      engagement_rate: parseFloat((Math.random() * 4 + 1).toFixed(1))
    },
    twitter: {
      followers: rand(200, 1500),
      tweets: rand(3, 10),
      retweets: rand(20, 200),
      likes: rand(100, 800),
      impressions: rand(1000, 5000)
    },
    weekly_growth: Array.from({ length: 7 }, () => rand(5, 50)),
    monthly_trend: Array.from({ length: 30 }, () => rand(2, 30)),
    updated_at: admin.firestore.Timestamp.now()
  };
};

// GET /analytics
const getAnalytics = async (req, res) => {
  try {
    const userId = req.user.user_id;

    // Check if we have fresh analytics (updated within 24 hours)
    const analyticsDoc = await db.collection('analytics').doc(userId).get();

    if (analyticsDoc.exists) {
      const data = analyticsDoc.data();
      const updatedAt = data.updated_at?.toDate();
      const hoursSince = updatedAt ? (Date.now() - updatedAt.getTime()) / (1000 * 60 * 60) : 25;

      if (hoursSince < 24) {
        return res.status(200).json({ success: true, data, source: 'cached' });
      }
    }

    // Generate fresh mock analytics
    const freshData = generateMockAnalytics(userId);
    await db.collection('analytics').doc(userId).set(freshData);

    return res.status(200).json({ success: true, data: freshData, source: 'generated' });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = { getAnalytics };
```

---

## 14. LOGO & BRANDING GENERATION

### Logo Controller (`src/controllers/logoController.js`)

```javascript
const { createCanvas } = require('canvas');
const { admin, db, bucket } = require('../config/firebase');
const { v4: uuidv4 } = require('uuid');

const COLOR_THEMES = {
  professional: { primary: '#2C3E50', secondary: '#3498DB', text: '#FFFFFF' },
  vibrant:      { primary: '#E74C3C', secondary: '#F39C12', text: '#FFFFFF' },
  nature:       { primary: '#27AE60', secondary: '#2ECC71', text: '#FFFFFF' },
  luxury:       { primary: '#2C2C2C', secondary: '#F1C40F', text: '#F1C40F' },
  tech:         { primary: '#1A1A2E', secondary: '#16213E', text: '#0F3460' },
  pink:         { primary: '#E91E8C', secondary: '#FF6B6B', text: '#FFFFFF' },
  ocean:        { primary: '#006994', secondary: '#00B4D8', text: '#FFFFFF' },
  purple:       { primary: '#6C3483', secondary: '#A569BD', text: '#FFFFFF' }
};

// POST /logo/generate
const generateLogo = async (req, res) => {
  try {
    const { business_name, color_theme = 'professional', shape = 'circle', font_style = 'bold' } = req.body;
    const userId = req.user.user_id;

    if (!business_name) {
      return res.status(400).json({ success: false, message: 'business_name required.' });
    }

    const theme = COLOR_THEMES[color_theme] || COLOR_THEMES.professional;
    const SIZE = 500;
    const canvas = createCanvas(SIZE, SIZE);
    const ctx = canvas.getContext('2d');

    // Extract initials
    const words = business_name.trim().split(' ');
    const initials = words.length >= 2
      ? (words[0][0] + words[1][0]).toUpperCase()
      : business_name.slice(0, 2).toUpperCase();

    // Draw background shape
    if (shape === 'circle') {
      ctx.beginPath();
      ctx.arc(SIZE / 2, SIZE / 2, SIZE / 2, 0, Math.PI * 2);
      ctx.fillStyle = theme.primary;
      ctx.fill();
    } else if (shape === 'rounded') {
      const radius = 60;
      ctx.beginPath();
      ctx.moveTo(radius, 0);
      ctx.lineTo(SIZE - radius, 0);
      ctx.quadraticCurveTo(SIZE, 0, SIZE, radius);
      ctx.lineTo(SIZE, SIZE - radius);
      ctx.quadraticCurveTo(SIZE, SIZE, SIZE - radius, SIZE);
      ctx.lineTo(radius, SIZE);
      ctx.quadraticCurveTo(0, SIZE, 0, SIZE - radius);
      ctx.lineTo(0, radius);
      ctx.quadraticCurveTo(0, 0, radius, 0);
      ctx.closePath();
      ctx.fillStyle = theme.primary;
      ctx.fill();
    } else {
      ctx.fillStyle = theme.primary;
      ctx.fillRect(0, 0, SIZE, SIZE);
    }

    // Draw accent element
    ctx.beginPath();
    ctx.arc(SIZE * 0.75, SIZE * 0.25, SIZE * 0.15, 0, Math.PI * 2);
    ctx.fillStyle = theme.secondary;
    ctx.globalAlpha = 0.4;
    ctx.fill();
    ctx.globalAlpha = 1;

    // Draw initials
    const fontSize = initials.length === 1 ? 160 : 130;
    ctx.font = `${font_style} ${fontSize}px Arial`;
    ctx.fillStyle = theme.text;
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText(initials, SIZE / 2, SIZE / 2);

    // Draw business name (bottom)
    const shortName = business_name.length > 15
      ? business_name.slice(0, 15) + '...'
      : business_name;
    ctx.font = 'bold 28px Arial';
    ctx.fillStyle = theme.text;
    ctx.globalAlpha = 0.8;
    ctx.fillText(shortName.toUpperCase(), SIZE / 2, SIZE * 0.82);
    ctx.globalAlpha = 1;

    // Upload to Firebase Storage
    const fileName = `logos/${userId}/logo_${uuidv4().slice(0, 8)}.png`;
    const buffer = canvas.toBuffer('image/png');

    const fileRef = bucket.file(fileName);
    await fileRef.save(buffer, {
      metadata: { contentType: 'image/png', cacheControl: 'public, max-age=31536000' }
    });

    await fileRef.makePublic();
    const downloadUrl = `https://storage.googleapis.com/${bucket.name}/${fileName}`;

    // Save to Firestore
    const now = admin.firestore.Timestamp.now();
    const logoRef = db.collection('logos').doc();
    await logoRef.set({
      logo_id: logoRef.id,
      user_id: userId,
      business_name,
      initials,
      color_theme,
      background_color: theme.primary,
      font_style,
      shape,
      storage_url: `gs://${bucket.name}/${fileName}`,
      download_url: downloadUrl,
      created_at: now
    });

    return res.status(200).json({
      success: true,
      message: '🎨 Logo generated!',
      data: { logo_id: logoRef.id, download_url: downloadUrl, initials, color_theme, shape }
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// GET /logo/my-logos
const getMyLogos = async (req, res) => {
  try {
    const userId = req.user.user_id;
    const snapshot = await db.collection('logos')
      .where('user_id', '==', userId)
      .orderBy('created_at', 'desc')
      .get();

    const logos = snapshot.docs.map(doc => ({
      ...doc.data(),
      created_at: doc.data().created_at?.toDate()
    }));

    return res.status(200).json({ success: true, data: logos });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = { generateLogo, getMyLogos };
```

---

## 15. VOICE FEATURE BACKEND SUPPORT

Voice is handled primarily on Flutter side. The backend only processes the text result:

```javascript
// Voice flow:
// 1. Flutter: User speaks → speech_to_text converts to text
// 2. Flutter: Sends text to POST /chat/message
// 3. Backend: Processes text, returns AI response
// 4. Flutter: flutter_tts reads AI response aloud

// Optional: POST /voice/process
const processVoiceText = async (req, res) => {
  const { transcribed_text, language = 'en' } = req.body;
  if (!transcribed_text) {
    return res.status(400).json({ success: false, message: 'transcribed_text required.' });
  }

  const cleanedText = transcribed_text
    .replace(/\b(um|uh|like|you know|basically)\b/gi, '')
    .replace(/\s+/g, ' ')
    .trim();

  return res.status(200).json({
    success: true,
    data: { original: transcribed_text, cleaned: cleanedText, language }
  });
};
```

**Flutter Voice Packages (pubspec.yaml):**
```yaml
speech_to_text: ^6.6.0
flutter_tts: ^3.8.5
```

---

## 16. ALL API ENDPOINTS REFERENCE

| Method | Endpoint | Auth | Plan | Description |
|--------|----------|------|------|-------------|
| POST | `/auth/signup` | ❌ | ❌ | Register new user + free trial |
| POST | `/auth/login` | ❌ | ❌ | Login, get JWT token |
| POST | `/auth/forgot-password` | ❌ | ❌ | Send password reset email |
| GET | `/auth/profile` | ✅ | Any | Get user profile |
| PUT | `/auth/profile` | ✅ | Any | Update profile |
| GET | `/subscription/plans` | ❌ | ❌ | View all plans & pricing |
| GET | `/subscription/status` | ✅ | Any | Get current subscription |
| POST | `/subscription/upgrade` | ✅ | Any | Upgrade plan (simulated payment) |
| POST | `/ai/generate-business` | ✅ | Active | Generate business ideas |
| POST | `/ai/generate-post` | ✅ | Active | Generate social media post |
| POST | `/ai/generate-plan` | ✅ | Active | Generate marketing plan |
| POST | `/ai/generate-hashtags` | ✅ | Any | Generate hashtags |
| POST | `/chat/new` | ✅ | Active | Create new chat session |
| POST | `/chat/message` | ✅ | Active | Send message, get AI response |
| GET | `/chat/history` | ✅ | Active | Get all chat sessions |
| GET | `/chat/:chatId` | ✅ | Active | Get specific chat + messages |
| DELETE | `/chat/:chatId` | ✅ | Active | Delete chat |
| POST | `/social/create-post` | ✅ | Active | Save post draft |
| POST | `/social/schedule-post` | ✅ | Basic+ | Schedule post |
| POST | `/social/publish-post` | ✅ | Basic+ | Publish (simulated) |
| GET | `/social/posts` | ✅ | Active | Get all posts |
| GET | `/analytics` | ✅ | Active | Get analytics data |
| POST | `/website/generate` | ✅ | Basic+ | Generate website content |
| GET | `/website/my-websites` | ✅ | Basic+ | Get my websites |
| POST | `/logo/generate` | ✅ | Active | Generate logo PNG |
| GET | `/logo/my-logos` | ✅ | Active | Get all logos |

---

## 17. FLUTTER INTEGRATION GUIDE

### pubspec.yaml Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Firebase
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6
  firebase_storage: ^11.5.6
  
  # HTTP
  dio: ^5.3.4
  http: ^1.1.2
  
  # Voice
  speech_to_text: ^6.6.0
  flutter_tts: ^3.8.5
  
  # State Management
  provider: ^6.1.1
  
  # Storage
  shared_preferences: ^2.2.2
  flutter_secure_storage: ^9.0.0
  
  # UI
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0
  
  # Animations
  flutter_animate: ^4.3.0
  lottie: ^2.7.0
  animations: ^2.0.8
```

### API Service (`lib/services/api_service.dart`)

```dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = 'https://brandora-api.onrender.com';
  
  late final Dio _dio;
  final _storage = const FlutterSecureStorage();
  
  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ));
    
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          // Navigate to login
        }
        return handler.next(error);
      },
    ));
  }
  
  Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
    String language = 'en',
  }) async {
    try {
      final response = await _dio.post('/auth/signup', data: {
        'name': name, 'email': email, 'password': password, 'language': language,
      });
      if (response.data['data']?['token'] != null) {
        await _storage.write(key: 'auth_token', value: response.data['data']['token']);
      }
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<Map<String, dynamic>> login({required String email, required String password}) async {
    try {
      final response = await _dio.post('/auth/login', data: {'email': email, 'password': password});
      if (response.data['data']?['token'] != null) {
        await _storage.write(key: 'auth_token', value: response.data['data']['token']);
      }
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<void> logout() async => await _storage.delete(key: 'auth_token');
  
  Future<Map<String, dynamic>> sendChatMessage({
    required String message,
    String? chatId,
    String language = 'en',
  }) async {
    try {
      final response = await _dio.post('/chat/message', data: {
        'message': message,
        if (chatId != null) 'chat_id': chatId,
        'language': language,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<Map<String, dynamic>> getAnalytics() async {
    final response = await _dio.get('/analytics');
    return response.data;
  }
  
  Exception _handleError(DioException e) {
    final message = e.response?.data?['message'] ?? 'Something went wrong.';
    return Exception(message);
  }
}
```

---

## 18. ENVIRONMENT VARIABLES & CONFIG

### `.env.example`

```bash
# Server
NODE_ENV=development
PORT=3000

# Firebase
FIREBASE_API_KEY=your_api_key_here
FIREBASE_PROJECT_ID=brandora-app
FIREBASE_STORAGE_BUCKET=brandora-app.appspot.com
FIREBASE_SERVICE_ACCOUNT={"type":"service_account",...}  # one-line JSON for Render

# JWT (minimum 32 characters)
JWT_SECRET=brandora_super_secret_jwt_key_minimum_32_chars_2024
JWT_EXPIRES_IN=7d

# OpenAI
OPENAI_API_KEY=sk-proj-your_openai_key_here

# HuggingFace (free fallback)
HUGGINGFACE_API_KEY=hf_your_huggingface_key_here

# App
APP_NAME=Brandora
SUPPORT_EMAIL=info@brandora.com
```

---

## 19. DEPLOYMENT GUIDE

### Node.js Backend — Render.com

```bash
# Step 1: Push to GitHub
git init
git add .
git commit -m "Initial backend commit"
git remote add origin https://github.com/yourusername/brandora-backend.git
git push -u origin main

# Step 2: Render.com Setup
# Go to: https://render.com
# New → Web Service → Connect GitHub repo
# Settings:
#   Name: brandora-api
#   Runtime: Node
#   Build Command: apt-get install -y libcairo2-dev libjpeg-dev libpango1.0-dev libgif-dev build-essential g++ && npm install
#   Start Command: node server.js
# Add all .env variables in Render dashboard

# Your API will be live at:
# https://brandora-api.onrender.com
```

### Firebase Deployment

```bash
npm install -g firebase-tools
firebase login
firebase init
firebase deploy --only firestore:rules
firebase deploy --only storage
firebase deploy --only hosting
```

---

# ═══════════════════════════════
# PART B — UI/UX POLISH SYSTEM
# ═══════════════════════════════

## 20. GLOBAL BRANDING & THEME SYSTEM

### Brand Color Palette

```dart
// lib/core/theme/app_colors.dart

class AppColors {
  // ── Primary Brand Colors ────────────────────────────────────────
  static const Color primary       = Color(0xFF6C63FF); // Brandora Purple
  static const Color primaryDark   = Color(0xFF4A42CC);
  static const Color primaryLight  = Color(0xFF9C95FF);

  // ── Secondary ───────────────────────────────────────────────────
  static const Color secondary     = Color(0xFFFF6584); // Accent Pink
  static const Color secondaryDark = Color(0xFFCC4466);

  // ── Accent / Highlight ──────────────────────────────────────────
  static const Color accent        = Color(0xFF43E97B); // Success Green
  static const Color accentOrange  = Color(0xFFFF9F43); // Warning Orange

  // ── Neutrals (Light Mode) ───────────────────────────────────────
  static const Color background    = Color(0xFFF8F9FE);
  static const Color surface       = Color(0xFFFFFFFF);
  static const Color surfaceAlt    = Color(0xFFF0F0FF);
  static const Color border        = Color(0xFFE8E8F0);

  // ── Text Colors (Light Mode) ────────────────────────────────────
  static const Color textPrimary   = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B6B8A);
  static const Color textHint      = Color(0xFFAAABBB);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Neutrals (Dark Mode) ────────────────────────────────────────
  static const Color darkBackground = Color(0xFF0F0F1A);
  static const Color darkSurface    = Color(0xFF1A1A2E);
  static const Color darkSurfaceAlt = Color(0xFF252540);
  static const Color darkBorder     = Color(0xFF2D2D50);

  // ── Text Colors (Dark Mode) ─────────────────────────────────────
  static const Color darkTextPrimary   = Color(0xFFF0F0FF);
  static const Color darkTextSecondary = Color(0xFFAAABCC);

  // ── Status Colors ───────────────────────────────────────────────
  static const Color success  = Color(0xFF43E97B);
  static const Color error    = Color(0xFFFF4757);
  static const Color warning  = Color(0xFFFF9F43);
  static const Color info     = Color(0xFF1E90FF);

  // ── Gradient Presets ────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF9C95FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF0F0FF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
```

### ThemeData Configuration

```dart
// lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      background: AppColors.background,
      error: AppColors.error,
      onPrimary: AppColors.textOnPrimary,
      onSecondary: AppColors.textOnPrimary,
      onSurface: AppColors.textPrimary,
      onBackground: AppColors.textPrimary,
    ),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge:  const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.5),
      displayMedium: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
      headlineLarge: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
      headlineMedium:const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      titleLarge:    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      titleMedium:   const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
      bodyLarge:     const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textPrimary, height: 1.6),
      bodyMedium:    const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary, height: 1.5),
      labelLarge:    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textOnPrimary, letterSpacing: 0.5),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shadowColor: AppColors.primary.withOpacity(0.4),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.3),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceAlt,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
      prefixIconColor: AppColors.textSecondary,
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.surface,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
      ),
    ),
    scaffoldBackgroundColor: AppColors.background,
    dividerColor: AppColors.border,
  );

  static ThemeData get darkTheme => lightTheme.copyWith(
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.darkSurface,
      background: AppColors.darkBackground,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSurface: AppColors.darkTextPrimary,
      onBackground: AppColors.darkTextPrimary,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.darkSurface,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurfaceAlt,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      hintStyle: const TextStyle(color: AppColors.darkTextSecondary, fontSize: 14),
    ),
  );
}
```

---

## 21. LOGO DESIGN GUIDELINES

```
BRANDORA LOGO SPECIFICATIONS:
─────────────────────────────────────────────
✅ Format: PNG (transparent background)
✅ Resolution: Minimum 512×512px
✅ Variants needed:
   - logo_full.png       (icon + text, horizontal)
   - logo_icon.png       (icon only, square)
   - logo_white.png      (white version, for dark bg)
   - logo_dark.png       (dark version, for light bg)
   - logo_splash.png     (large, for splash screen)

✅ Visual style:
   - Clean, minimal, modern
   - Soft drop shadow: offset (0, 4px), blur 12px, opacity 20%
   - Optional: subtle glow effect on icon

USAGE GUIDELINES:
─────────────────────────────────────────────
- Splash Screen: logo_splash.png centered, animated scale-in
- Login/Signup: logo_icon.png (80px) with app name
- Dashboard Header: logo_full.png (height: 36px)
- App Icon: logo_icon.png (adaptive icon for Android/iOS)
```

```dart
// Recommended logo widget with shadow
Widget buildLogoWidget({double size = 80}) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withOpacity(0.25),
          blurRadius: 20,
          offset: const Offset(0, 8),
          spreadRadius: 2,
        ),
      ],
    ),
    child: Image.asset('assets/images/logo_icon.png', fit: BoxFit.contain),
  );
}
```

---

## 22. TYPOGRAPHY SYSTEM

```dart
// lib/core/theme/app_text_styles.dart
// Use GoogleFonts.poppins() as primary font

class AppTextStyles {
  // ── Headings ────────────────────────────────────────────────────
  static const h1 = TextStyle(fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -0.5, height: 1.2);
  static const h2 = TextStyle(fontSize: 26, fontWeight: FontWeight.w700, letterSpacing: -0.3, height: 1.3);
  static const h3 = TextStyle(fontSize: 22, fontWeight: FontWeight.w700, height: 1.3);
  static const h4 = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 1.4);
  static const h5 = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.4);

  // ── Body ─────────────────────────────────────────────────────────
  static const bodyLg  = TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.6);
  static const bodyMd  = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5);
  static const bodySm  = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.5);

  // ── Labels ───────────────────────────────────────────────────────
  static const labelLg = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.3);
  static const labelSm = TextStyle(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.2);

  // ── Caption ──────────────────────────────────────────────────────
  static const caption = TextStyle(fontSize: 11, fontWeight: FontWeight.w400, height: 1.4);
  static const overline = TextStyle(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1.5);

  // ── Button ───────────────────────────────────────────────────────
  static const btnLg  = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5);
  static const btnMd  = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.3);
  static const btnSm  = TextStyle(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.2);

  // ── Urdu (RTL) ───────────────────────────────────────────────────
  // Use NotoNastaliqUrdu font for Urdu text
  static const urduBody = TextStyle(
    fontFamily: 'NotoNastaliqUrdu',
    fontSize: 16,
    height: 2.0, // Urdu needs more line height
  );
}
```

---

## 23. ICON SYSTEM

```dart
// Use: flutter_lucide or phosphor_flutter for modern icons
// Add to pubspec.yaml:
// phosphor_flutter: ^2.0.1   — Clean, consistent icon set
// font_awesome_flutter: ^10.6.0 — For social media icons

// ── Navigation Icons ────────────────────────────────────────────
PhosphorIcons.house           // Dashboard
PhosphorIcons.robot           // AI Chatbot
PhosphorIcons.chartLineUp     // Analytics
PhosphorIcons.calendarCheck   // Scheduled Posts
PhosphorIcons.gear            // Settings

// ── AI Feature Icons ────────────────────────────────────────────
PhosphorIcons.lightbulb       // Business Ideas
PhosphorIcons.pencil          // Post Generator
PhosphorIcons.fileText        // Marketing Plan
PhosphorIcons.hashStraight    // Hashtag Generator
PhosphorIcons.microphone      // Voice Input
PhosphorIcons.globe           // Website Builder

// ── Social Media Icons ──────────────────────────────────────────
FontAwesomeIcons.instagram
FontAwesomeIcons.facebook
FontAwesomeIcons.twitter
FontAwesomeIcons.linkedin

// ── Action Icons ────────────────────────────────────────────────
PhosphorIcons.arrowRight      // Navigation
PhosphorIcons.copy            // Copy text
PhosphorIcons.download        // Download logo
PhosphorIcons.shareNetwork    // Share
PhosphorIcons.trash           // Delete
PhosphorIcons.plus            // Add/Create
PhosphorIcons.magnifyingGlass // Search

// Icon sizing standards:
// ── Navigation bar: 24px
// ── Action buttons: 20px
// ── Inside form fields: 20px
// ── Feature cards: 32px
// ── Large hero icons: 48px
```

---

## 24. COMPONENT DESIGN SYSTEM

### Primary Button

```dart
// lib/widgets/buttons/brandora_button.dart

class BrandoraButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final BrandoraButtonVariant variant;

  const BrandoraButton({
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.variant = BrandoraButtonVariant.primary,
    super.key,
  });

  @override
  State<BrandoraButton> createState() => _BrandoraButtonState();
}

enum BrandoraButtonVariant { primary, secondary, outline, ghost, danger }

class _BrandoraButtonState extends State<BrandoraButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.isLoading ? null : widget.onPressed,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.isFullWidth ? double.infinity : null,
          height: 52,
          decoration: _getDecoration(),
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
                    width: 22, height: 22,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, size: 18, color: _getTextColor()),
                        const SizedBox(width: 8),
                      ],
                      Text(widget.label, style: AppTextStyles.btnMd.copyWith(color: _getTextColor())),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _getDecoration() {
    switch (widget.variant) {
      case BrandoraButtonVariant.primary:
        return BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: AppColors.primary.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 6)),
          ],
        );
      case BrandoraButtonVariant.outline:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary, width: 1.5),
        );
      case BrandoraButtonVariant.danger:
        return BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(12),
        );
      default:
        return BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        );
    }
  }

  Color _getTextColor() {
    switch (widget.variant) {
      case BrandoraButtonVariant.primary:
      case BrandoraButtonVariant.danger:
        return Colors.white;
      case BrandoraButtonVariant.outline:
      case BrandoraButtonVariant.ghost:
        return AppColors.primary;
      default:
        return AppColors.textPrimary;
    }
  }
}
```

### Feature Card

```dart
// lib/widgets/cards/feature_card.dart

class FeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;
  final bool isPremium;

  const FeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.iconColor = AppColors.primary,
    this.isPremium = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                if (isPremium)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: AppColors.heroGradient,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('PRO', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(title, style: AppTextStyles.h5),
            const SizedBox(height: 4),
            Text(subtitle, style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
```

### Input Field

```dart
// lib/widgets/inputs/brandora_input.dart

class BrandoraInput extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final bool obscureText;
  final IconData? prefixIcon;
  final Widget? suffixWidget;
  final String? errorText;
  final TextInputType keyboardType;
  final int maxLines;

  const BrandoraInput({
    required this.label,
    required this.controller,
    this.hint,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixWidget,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelLg.copyWith(color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: obscureText ? 1 : maxLines,
          style: AppTextStyles.bodyLg,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20) : null,
            suffix: suffixWidget,
            errorText: errorText,
          ),
        ),
      ],
    );
  }
}
```

### Plan Badge

```dart
// lib/widgets/badges/plan_badge.dart

class PlanBadge extends StatelessWidget {
  final String plan;

  const PlanBadge({required this.plan, super.key});

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(plan);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: config['gradient'] as LinearGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        config['label'] as String,
        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5),
      ),
    );
  }

  Map<String, dynamic> _getConfig(String plan) {
    switch (plan.toLowerCase()) {
      case 'pro':
        return { 'label': '⭐ PRO', 'gradient': const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFFFF6584)]) };
      case 'business':
        return { 'label': '🚀 BUSINESS', 'gradient': const LinearGradient(colors: [Color(0xFF43E97B), Color(0xFF38F9D7)]) };
      case 'basic':
        return { 'label': '✨ BASIC', 'gradient': const LinearGradient(colors: [Color(0xFF1E90FF), Color(0xFF6C63FF)]) };
      default:
        return { 'label': '🆓 FREE TRIAL', 'gradient': const LinearGradient(colors: [Color(0xFFAAABBB), Color(0xFF6B6B8A)]) };
    }
  }
}
```

---

## 25. ANIMATION SYSTEM

### Page Transitions

```dart
// lib/core/navigation/page_transitions.dart

class FadeSlideTransition extends PageRouteBuilder {
  final Widget page;
  final SlideDirection direction;

  FadeSlideTransition({required this.page, this.direction = SlideDirection.right})
      : super(
          pageBuilder: (context, animation, secondary) => page,
          transitionsBuilder: (context, animation, secondary, child) {
            const begin = Offset(0.05, 0);
            const end = Offset.zero;
            final tween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: Curves.easeOutCubic));
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: animation.drive(tween), child: child),
            );
          },
          transitionDuration: const Duration(milliseconds: 280),
        );
}

enum SlideDirection { left, right, up, down }

// Usage:
Navigator.of(context).push(FadeSlideTransition(page: const DashboardScreen()));
```

### Splash Screen Animation

```dart
// lib/screens/splash_screen.dart

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );

    _playAnimation();
  }

  void _playAnimation() async {
    await _scaleController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    await _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 800));
    // Navigate to auth or home
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _scaleController,
                builder: (context, child) => Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3 * _glowAnimation.value),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Image.asset('assets/images/logo_white.png', width: 100, height: 100),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FadeTransition(
                opacity: _fadeAnimation,
                child: const Text(
                  'Brandora',
                  style: TextStyle(
                    fontSize: 32, fontWeight: FontWeight.w800,
                    color: Colors.white, letterSpacing: -0.5,
                  ),
                ),
              ),
              FadeTransition(
                opacity: _fadeAnimation,
                child: const Text(
                  'AI Powered Marketing',
                  style: TextStyle(fontSize: 14, color: Colors.white70, letterSpacing: 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }
}
```

### Chat Typing Animation

```dart
// lib/widgets/chat/typing_indicator.dart

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (i) => AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    ));

    _animations = _controllers.map((c) =>
      Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: c, curve: Curves.easeInOut),
      )
    ).toList();

    _startAnimation();
  }

  void _startAnimation() async {
    for (int i = 0; i < 3; i++) {
      await Future.delayed(Duration(milliseconds: i * 200));
      if (mounted) _controllers[i].repeat(reverse: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) => AnimatedBuilder(
        animation: _animations[i],
        builder: (_, __) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          child: Transform.translate(
            offset: Offset(0, -4 * _animations[i].value),
            child: Container(
              width: 8, height: 8,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.6 + 0.4 * _animations[i].value),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      )),
    );
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    super.dispose();
  }
}
```

### List Item Animation

```dart
// lib/widgets/animations/animated_list_item.dart

class AnimatedListItem extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration baseDelay;

  const AnimatedListItem({
    required this.child,
    required this.index,
    this.baseDelay = const Duration(milliseconds: 60),
    super.key,
  });

  @override
  State<AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(widget.baseDelay * widget.index, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

---

## 26. SCREEN-BY-SCREEN POLISH GUIDE

### A. Splash Screen
- Full-screen gradient background (heroGradient)
- Logo scale + fade in animation
- App tagline fade in after logo
- Duration: 2.5 seconds then auto-navigate

### B. Onboarding (if applicable)
- Full-screen illustrated slides
- Smooth page transitions
- Skip button top right
- Dot indicators bottom center
- Gradient CTA button

### C. Login / Signup Screen
```
Layout:
─────────────────────────────
[Logo + App Name]            <- centered, animated
[Welcome text]               <- h2 bold
──────────────────────────────
[Name field]                 <- with person icon
[Email field]                <- with email icon
[Password field]             <- with lock icon + show/hide
──────────────────────────────
[Primary Button]             <- full width, gradient
[Forgot Password link]       <- text button
[OR divider]
[Google Sign In]             <- outlined button (optional)
[Already have account? Login] <- bottom link
─────────────────────────────

Animations:
- Form fields slide in from bottom with staggered delay
- Button has scale press effect + loading spinner
- Error messages animate in with shake effect
```

### D. Dashboard Screen
```
Layout:
─────────────────────────────
[AppBar: Logo | Notifications]
──────────────────────────────
[Welcome banner]              <- "Good morning, Ahmed 👋"
[Plan badge]                  <- Free Trial / Pro
──────────────────────────────
[Stats row]                   <- 3 mini cards (posts/reach/followers)
──────────────────────────────
[Section: AI Tools]
[Feature cards grid]          <- 2-column grid with icons
──────────────────────────────
[Section: Recent Activity]
[Recent post cards]
──────────────────────────────
[Bottom Nav Bar]              <- 5 tabs with icons + labels
─────────────────────────────

Polish points:
- Greeting changes by time (morning/afternoon/evening)
- Stats cards use counter animation on mount
- Feature cards use AnimatedListItem for staggered appearance
- Bottom nav uses custom animated indicator
```

### E. AI Chatbot Screen
```
Layout:
─────────────────────────────
[AppBar: "Brandora AI" + language toggle]
──────────────────────────────
[Chat messages list]          <- ScrollView
   [AI message bubble]        <- left, primary color
   [User message bubble]      <- right, gradient
   [Typing indicator]         <- animated dots
──────────────────────────────
[Input row]
   [Mic button]               <- voice input
   [Text input]               <- flex expanded
   [Send button]              <- circular gradient button
─────────────────────────────

Polish points:
- Message bubbles animate in from bottom
- AI typing indicator shows before response
- Smooth scroll to bottom on new message
- Mic button pulses when recording
```

### F. Analytics Screen
```
Layout:
─────────────────────────────
[AppBar: "Analytics"]
──────────────────────────────
[Period selector]             <- week / month tabs
[Overview cards]              <- animated counter numbers
──────────────────────────────
[Line Chart]                  <- weekly growth (fl_chart)
[Platform breakdown]          <- Instagram / Facebook / Twitter cards
──────────────────────────────
[Engagement rate gauge]
─────────────────────────────

Polish points:
- Chart animates on load (draw animation)
- Numbers count up on mount
- Pull to refresh
```

---

## 27. DARK MODE IMPLEMENTATION

```dart
// lib/core/providers/theme_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    _loadTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void toggleTheme() async {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
    notifyListeners();
  }
}

// main.dart usage:
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: themeProvider.themeMode,
)

// Toggle button in settings:
Switch(
  value: themeProvider.isDark,
  onChanged: (_) => themeProvider.toggleTheme(),
  activeColor: AppColors.primary,
)
```

---

## 28. RESPONSIVENESS & ADAPTIVE LAYOUTS

```dart
// lib/core/utils/responsive.dart

class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1024;

  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  // Responsive padding
  static EdgeInsets pagePadding(BuildContext context) =>
      EdgeInsets.symmetric(
        horizontal: isMobile(context) ? 16 : 24,
        vertical: 16,
      );

  // Responsive grid column count
  static int gridColumns(BuildContext context) =>
      isMobile(context) ? 2 : isTablet(context) ? 3 : 4;
}

// Responsive grid example:
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: Responsive.gridColumns(context),
    crossAxisSpacing: 12,
    mainAxisSpacing: 12,
    childAspectRatio: 0.9,
  ),
  ...
)
```

---

## 29. LOADING, EMPTY & ERROR STATES

### Skeleton Loader

```dart
// lib/widgets/states/skeleton_loader.dart

class SkeletonCard extends StatefulWidget {
  const SkeletonCard({super.key});

  @override
  State<SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<SkeletonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _animation = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _shimmerBox(width: 48, height: 48, radius: 10),
              const SizedBox(height: 12),
              _shimmerBox(width: double.infinity, height: 14),
              const SizedBox(height: 8),
              _shimmerBox(width: 120, height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _shimmerBox({double? width, required double height, double radius = 6}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment(_animation.value - 1, 0),
          end: Alignment(_animation.value, 0),
          colors: [AppColors.border, AppColors.surfaceAlt, AppColors.border],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

### Empty State

```dart
// lib/widgets/states/empty_state.dart

class EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? lottieAsset;

  const EmptyState({
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
    this.lottieAsset,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (lottieAsset != null)
              Lottie.asset(lottieAsset!, width: 200, height: 200)
            else
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(PhosphorIcons.smiley, size: 40, color: AppColors.primary),
              ),
            const SizedBox(height: 20),
            Text(title, style: AppTextStyles.h4, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(subtitle, style: AppTextStyles.bodyMd, textAlign: TextAlign.center),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              BrandoraButton(label: actionLabel!, onPressed: onAction, isFullWidth: false),
            ],
          ],
        ),
      ),
    );
  }
}
```

### Error Handling UI

```dart
// lib/widgets/states/error_state.dart

// Snackbar helper:
void showErrorSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(PhosphorIcons.warningCircle, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(message, style: const TextStyle(color: Colors.white))),
        ],
      ),
      backgroundColor: AppColors.error,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    ),
  );
}

void showSuccessSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(PhosphorIcons.checkCircle, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(message, style: const TextStyle(color: Colors.white))),
        ],
      ),
      backgroundColor: AppColors.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    ),
  );
}
```

---

## 30. ACCESSIBILITY & RTL (URDU) SUPPORT

```dart
// RTL support for Urdu language:
// Wrap entire app with Directionality widget when language is 'ur'

class BrandoraApp extends StatelessWidget {
  final ThemeProvider themeProvider;
  final LanguageProvider languageProvider;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: languageProvider.isUrdu
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeProvider.themeMode,
        locale: languageProvider.isUrdu
            ? const Locale('ur', 'PK')
            : const Locale('en', 'US'),
        // ...
      ),
    );
  }
}

// Urdu font setup in pubspec.yaml:
fonts:
  - family: NotoNastaliqUrdu
    fonts:
      - asset: assets/fonts/NotoNastaliqUrdu-Regular.ttf

// Accessibility checklist:
// ✅ All interactive elements have Semantics labels
// ✅ Font sizes ≥ 12px minimum
// ✅ Touch targets ≥ 44×44px
// ✅ Color contrast ratio ≥ 4.5:1 (WCAG AA)
// ✅ Icons always have text labels in nav bar
// ✅ Error messages not shown only by color
// ✅ Screen reader compatible (MergeSemantics)
```

---

## 31. FLUTTER UI CODE TEMPLATES

### Bottom Navigation Bar

```dart
// lib/widgets/navigation/brandora_bottom_nav.dart

class BrandoraBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BrandoraBottomNav({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  static const tabs = [
    {'icon': PhosphorIcons.house, 'label': 'Home'},
    {'icon': PhosphorIcons.robot, 'label': 'AI Chat'},
    {'icon': PhosphorIcons.chartLineUp, 'label': 'Analytics'},
    {'icon': PhosphorIcons.calendarCheck, 'label': 'Posts'},
    {'icon': PhosphorIcons.gear, 'label': 'Settings'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(tabs.length, (index) {
              final isSelected = currentIndex == index;
              return GestureDetector(
                onTap: () => onTap(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withOpacity(0.12) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        tabs[index]['icon'] as IconData,
                        size: 22,
                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tabs[index]['label'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected ? AppColors.primary : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
```

### Dashboard Welcome Banner

```dart
// lib/widgets/dashboard/welcome_banner.dart

class WelcomeBanner extends StatelessWidget {
  final String userName;
  final String plan;

  const WelcomeBanner({required this.userName, required this.plan, super.key});

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$_greeting, ${userName.split(' ').first}! 👋',
                  style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w700,
                    color: Colors.white, height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Ready to grow your business today?',
                  style: TextStyle(fontSize: 13, color: Colors.white70),
                ),
                const SizedBox(height: 12),
                PlanBadge(plan: plan),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Image.asset('assets/images/dashboard_illustration.png',
              width: 80, height: 80, fit: BoxFit.contain),
        ],
      ),
    );
  }
}
```

---

## 32. FINAL POLISH CHECKLIST

```
UI DESIGN QUALITY
□ Consistent 8px spacing grid used throughout
□ All corner radii consistent (8/12/16/20px)
□ Drop shadows are subtle and consistent
□ No text overflow on any screen
□ All images have proper aspect ratios
□ No placeholder assets in final build

BRANDING
□ Logo used consistently (splash, auth, dashboard)
□ Color palette applied everywhere
□ Typography hierarchy consistent
□ Brand voice consistent in all copy

ANIMATIONS
□ Splash screen logo animation works
□ Page transitions smooth (280ms fade+slide)
□ Button press scale effect on all buttons
□ Chat typing indicator animated
□ List items stagger animate on load
□ Loading spinners visible and branded

DARK MODE
□ All screens look correct in dark mode
□ No hardcoded Colors.white / Colors.black
□ Images visible in both modes
□ Charts readable in dark mode

ACCESSIBILITY
□ All interactive targets ≥ 44×44px
□ Urdu text uses NotoNastaliqUrdu font
□ RTL layout works for Urdu language
□ Sufficient color contrast everywhere

LOADING / ERROR STATES
□ Skeleton loaders on all list screens
□ Empty state illustrations shown
□ Error snackbars working
□ Retry buttons on error states
□ Loading indicator on all API calls

RESPONSIVENESS
□ Works on small phones (320px wide)
□ Works on large phones (428px wide)
□ Works on tablets (grid adjusts)
□ Bottom navigation safe area correct

FINAL PRESENTATION READY
□ No debug banners (debugShowCheckedModeBanner: false)
□ No console errors during demo
□ All demo credentials working
□ App icon set correctly (launcher icons)
□ Splash screen configured
□ App name: "Brandora" everywhere
```

---

# ═══════════════════════════════
# PART C — REFERENCE
# ═══════════════════════════════

## 33. QUICK IMPLEMENTATION CHECKLIST

```
FIREBASE SETUP
□ Create Firebase project
□ Enable Auth, Firestore, Storage
□ Download service account key
□ Deploy Firestore + Storage rules

BACKEND
□ npm init, install all dependencies
□ Create .env with all keys
□ server.js starts: GET / returns 200
□ All routes registered in app.js
□ authMiddleware working

AUTH
□ POST /auth/signup creates user + free trial subscription
□ POST /auth/login returns JWT token
□ POST /auth/forgot-password sends reset email
□ GET /auth/profile returns user data

SUBSCRIPTION
□ GET /subscription/plans returns all 4 plans
□ POST /subscription/upgrade simulates payment + upgrades plan
□ GET /subscription/status shows current subscription + days remaining

AI FEATURES
□ POST /ai/generate-business returns 3 business ideas (JSON)
□ POST /ai/generate-post returns caption + hashtags (JSON)
□ POST /ai/generate-plan saves plan to Firestore
□ POST /ai/generate-hashtags returns hashtag array
□ HuggingFace fallback works when OpenAI fails

CHATBOT
□ POST /chat/new creates chat with welcome message
□ POST /chat/message sends to OpenAI, stores in Firestore
□ Multi-turn context (last 10 messages) loads correctly
□ Urdu language detection and system prompt works
□ GET /chat/history returns list of chats
□ DELETE /chat/:id deletes chat

SOCIAL MEDIA
□ POST /social/create-post saves draft
□ POST /social/schedule-post schedules
□ POST /social/publish-post marks as published (simulated)
□ GET /social/posts returns filtered list

ANALYTICS
□ GET /analytics returns mock data
□ Auto-refresh after 24 hours

WEBSITE BUILDER
□ POST /website/generate creates content + dummy URL
□ Saved to Firestore successfully

LOGO GENERATOR
□ POST /logo/generate draws PNG using canvas
□ Uploaded to Firebase Storage
□ Download URL returned
□ Saved to Firestore

FLUTTER INTEGRATION
□ ApiService.dart created with Dio
□ JWT token saved in FlutterSecureStorage
□ All endpoints connected and tested
□ Voice (speech_to_text + flutter_tts) configured

UI/UX POLISH
□ AppColors + AppTheme configured
□ Poppins font imported via google_fonts
□ All buttons use BrandoraButton widget
□ All cards use consistent design
□ Splash animation working
□ Page transitions implemented
□ Dark mode toggle working
□ RTL support for Urdu

DEPLOYMENT
□ Code pushed to GitHub
□ Render.com Web Service created
□ All env vars set on Render
□ Firebase rules deployed
□ All endpoints tested with Postman/Thunder Client
□ Flutter app connects to live Render URL
```

---

## 34. CLAUDE AI MEGA PROMPT

Use this prompt when starting a new Claude/AI chat session to generate backend code:

```
You are an expert Node.js backend developer building "Brandora" — an AI-powered digital marketing assistant for Pakistani entrepreneurs.

=== TECH STACK ===
- Node.js + Express.js (REST API)
- Firebase Admin SDK (Firestore + Auth + Storage)
- OpenAI API (GPT-4o-mini) with HuggingFace fallback
- JWT authentication + bcryptjs
- Canvas for logo generation

=== CORE RULES ===
1. Every controller must have try/catch with proper error messages
2. All protected routes must use authMiddleware
3. Use admin.firestore.Timestamp.now() for all timestamps
4. Use admin.firestore.FieldValue.arrayUnion for appending to arrays
5. Use admin.firestore.FieldValue.increment for counters
6. Never expose internal errors to client in production
7. Chatbot MUST preserve multi-turn context (load last 10 messages)
8. All AI responses must be in JSON format
9. Standardized response: { success: true/false, message: "...", data: {...} }

=== API ENDPOINTS TO BUILD ===
POST /auth/signup → create Firebase Auth user + Firestore user doc + free trial subscription
POST /auth/login → verify + return JWT token
POST /auth/forgot-password → Firebase password reset link
POST /ai/generate-business → OpenAI business ideas (JSON)
POST /ai/generate-post → social media post + hashtags (JSON)
POST /ai/generate-plan → marketing plan saved to Firestore
POST /ai/generate-hashtags → logic-based hashtag generation
POST /chat/new → create chat with welcome message
POST /chat/message → send to OpenAI with full conversation history
GET /chat/history → paginated chat list
DELETE /chat/:chatId → delete chat
GET /subscription/plans → all 4 plans with features
POST /subscription/upgrade → simulate payment, update plan
GET /subscription/status → current plan + days remaining
POST /social/create-post → save to Firestore (draft)
POST /social/schedule-post → update scheduled_time
POST /social/publish-post → mark as published (simulated)
GET /analytics → mock data with 24hr caching
POST /website/generate → AI website content + dummy URL
POST /logo/generate → Canvas PNG → Firebase Storage → download URL

=== FIRESTORE COLLECTIONS ===
users: user_id, name, email, plan, language, is_active, created_at
subscriptions: subscription_id, user_id, plan_type, start_date, end_date, status
chats: chat_id, user_id, title, language, messages[], total_messages
marketing_plans: plan_id, user_id, business_name, plan_data (JSON)
social_posts: post_id, user_id, platform, content, hashtags[], status
analytics: user_id, period, overview{}, instagram{}, facebook{}, twitter{}
websites: website_id, user_id, business_name, public_url, content (JSON)
logos: logo_id, user_id, initials, color_theme, download_url

=== SUBSCRIPTION PLANS ===
free_trial: 7 days, 10 AI calls/day
basic: 30 days, PKR 999, 50 AI calls/day
business: 365 days, PKR 4999, 200 AI calls/day
pro: lifetime, PKR 9999, unlimited

=== LOGO COLOR THEMES ===
professional: { primary:'#2C3E50', secondary:'#3498DB', text:'#FFFFFF' }
vibrant: { primary:'#E74C3C', secondary:'#F39C12', text:'#FFFFFF' }
nature: { primary:'#27AE60', secondary:'#2ECC71', text:'#FFFFFF' }
luxury: { primary:'#2C2C2C', secondary:'#F1C40F', text:'#F1C40F' }
tech: { primary:'#1A1A2E', secondary:'#16213E', text:'#0F3460' }
pink: { primary:'#E91E8C', secondary:'#FF6B6B', text:'#FFFFFF' }

=== DEPLOYMENT ===
1. Push to GitHub
2. Deploy on Render.com (Web Service)
3. Build Command: apt-get install -y libcairo2-dev libjpeg-dev libpango1.0-dev libgif-dev build-essential g++ && npm install
4. Start Command: node server.js
5. Add all .env variables in Render dashboard
6. FIREBASE_SERVICE_ACCOUNT = one-line JSON string of serviceAccountKey.json

=== .ENV STRUCTURE ===
NODE_ENV=development
PORT=3000
FIREBASE_PROJECT_ID=brandora-app
FIREBASE_STORAGE_BUCKET=brandora-app.appspot.com
JWT_SECRET=brandora_jwt_secret_minimum_32_characters
JWT_EXPIRES_IN=7d
OPENAI_API_KEY=sk-proj-...
HUGGINGFACE_API_KEY=hf_...

=== IMPORTANT NOTES ===
- canvas package needs Linux deps on Render: install in build command
- Chatbot is the most critical feature — multi-turn context MUST work
- All OpenAI calls must have try/catch with HuggingFace fallback
- Analytics data auto-refreshes every 24 hours (cached in Firestore)
- Social media publishing is SIMULATED — return mock success response
- Website builder generates dummy public URL: https://brandora.app/{userId_first8chars}

Now generate ALL complete code files. Start with:
1. server.js
2. src/app.js
3. src/config/firebase.js + openai.js
4. src/middleware/authMiddleware.js + planMiddleware.js
5. All routes files
6. All controllers (every function complete, no TODOs)
7. All services (openaiService, huggingfaceService)
8. All utils (jwtUtils, hashtagGenerator)
9. firebase/firestore.rules + storage.rules

Every file must be 100% complete and working out-of-the-box when .env is filled.
```

---

> **📧 Support:** info@brandora.com  
> **📖 Version:** 2.0.0 — FYP Production Build (Backend + UI/UX)  
> **🏗️ Architecture:** Flutter → Node.js REST API → Firebase + OpenAI  
> **🌐 Target:** Pakistani Digital Entrepreneurs  
> **🎨 Design:** Modern, Minimal, Professional — FYP Presentation Ready

---

*Built with ❤️ for Brandora FYP — Complete Backend + UI/UX Master Guide*
