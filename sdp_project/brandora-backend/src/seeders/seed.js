require('dotenv').config();
const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const { v4: uuidv4 } = require('uuid');

const User = require('../models/User');
const Subscription = require('../models/Subscription');
const Payment = require('../models/Payment');
const BusinessIdea = require('../models/BusinessIdea');
const ChatSession = require('../models/ChatSession');
const Message = require('../models/Message');
const MarketingPlan = require('../models/MarketingPlan');
const MarketingTask = require('../models/MarketingTask');
const SocialAccount = require('../models/SocialAccount');
const SocialPost = require('../models/SocialPost');
const Website = require('../models/Website');
const BrandAsset = require('../models/BrandAsset');
const Logo = require('../models/Logo');
const Analytics = require('../models/Analytics');
const Notification = require('../models/Notification');
const SupportTicket = require('../models/SupportTicket');
const ActivityLog = require('../models/ActivityLog');

const seedDB = async () => {
  try {
    console.log('🔄 Connecting to MongoDB...');
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('✅ Connected to MongoDB.');

    // Clear all existing data
    console.log('🧹 Clearing existing collections...');
    const collections = Object.keys(mongoose.connection.collections);
    for (const collectionName of collections) {
      await mongoose.connection.collections[collectionName].deleteMany({});
    }
    console.log('✅ Collections cleared.');

    // 1. Create Users
    console.log('👥 Creating Users...');
    const salt = await bcrypt.genSalt(10);
    const passwordHash = await bcrypt.hash('password123', salt);

    const user1 = await User.create({
      name: 'Khuzaim Sajjad',
      email: 'khuzaim@brandora.app',
      password: passwordHash,
      role: 'user',
      plan: 'business',
      language: 'en',
      isEmailVerified: true
    });

    const adminUser = await User.create({
      name: 'Admin Brandora',
      email: 'admin@brandora.app',
      password: passwordHash,
      role: 'admin',
      plan: 'pro',
      language: 'en',
      isEmailVerified: true
    });

    // 2. Subscriptions & Payments
    console.log('💳 Creating Subscriptions & Payments...');
    const sub = await Subscription.create({
      userId: user1._id,
      planType: 'business',
      pricePaid: 2800,
      startDate: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000), // 30 days ago
      endDate: new Date(Date.now() + 120 * 24 * 60 * 60 * 1000), // 120 days left
      status: 'active',
      paymentMethod: 'card',
      transactionId: `txn_${uuidv4().slice(0, 12)}`
    });

    await Payment.create({
      userId: user1._id,
      subscriptionId: sub._id,
      amount: 2800,
      method: 'card',
      status: 'completed',
      transactionId: sub.transactionId
    });

    // 3. Business Ideas
    console.log('💡 Creating Business Ideas...');
    await BusinessIdea.create({
      userId: user1._id,
      industry: 'Fashion & Apparel',
      budget: '50,000',
      location: 'Lahore, Pakistan',
      ideas: [
        {
          title: 'Zari Thread Crafts',
          description: 'A premium boutique crafting custom traditional embroidered shirts online.',
          investmentRequired: 'PKR 45,000',
          potentialRevenue: 'PKR 120,000/month',
          pros: ['High margins', 'Rich culture appeal'],
          cons: ['Highly competitive', 'Skilled labor dependence'],
          firstSteps: ['Source raw fabric from Azam Market', 'Hire a custom tailor/embroidery artist']
        }
      ]
    });

    // 4. Chat Sessions & Messages
    console.log('💬 Creating Chat History...');
    const chatSession = await ChatSession.create({
      userId: user1._id,
      title: 'Marketing Strategy for boutique',
      totalMessages: 3
    });

    await Message.create([
      {
        chatSessionId: chatSession._id,
        role: 'assistant',
        content: 'Hello! I\'m Brandora AI. How can I help grow your boutique business today? 🚀'
      },
      {
        chatSessionId: chatSession._id,
        role: 'user',
        content: 'How should I launch my organic Instagram marketing strategy?'
      },
      {
        chatSessionId: chatSession._id,
        role: 'assistant',
        content: 'To grow organically on Instagram in Pakistan: 1. Post daily reels displaying traditional dress details. 2. Focus on localized hashtags like #fashionpakistan. 3. Engage directly with target customer demographics.'
      }
    ]);

    // 5. Marketing Plans & Tasks
    console.log('📋 Creating Marketing Plans & Tasks...');
    const plan = await MarketingPlan.create({
      userId: user1._id,
      businessName: 'Zari Boutique',
      industry: 'Fashion',
      targetAudience: 'Women aged 18-35',
      budget: 'PKR 50,000',
      status: 'active',
      planData: {
        executive_summary: 'Boutique targeting premium handmade embroidery.',
        marketing_channels: ['Instagram', 'Facebook', 'WhatsApp Business']
      }
    });

    await MarketingTask.create([
      {
        userId: user1._id,
        planId: plan._id,
        title: 'Create Business Instagram Account',
        description: 'Set up bio with clear contact info and branding.',
        category: 'social',
        dueDate: new Date(Date.now() + 1 * 24 * 60 * 60 * 1000),
        status: 'completed',
        priority: 'high',
        dayNumber: 1
      },
      {
        userId: user1._id,
        planId: plan._id,
        title: 'Design Logo Template',
        description: 'Generate initial brand colors and initials logo.',
        category: 'other',
        dueDate: new Date(Date.now() + 2 * 24 * 60 * 60 * 1000),
        status: 'pending',
        priority: 'high',
        dayNumber: 2
      }
    ]);

    // 6. Social Accounts & Posts
    console.log('📱 Creating Social Accounts & Posts...');
    await SocialAccount.create({
      userId: user1._id,
      platform: 'instagram',
      username: 'zariboutique_official',
      profileUrl: 'https://instagram.com/zariboutique_official',
      isConnected: true,
      followerCount: 1540
    });

    await SocialPost.create({
      userId: user1._id,
      platform: 'instagram',
      content: 'Introducing Zari boutique. Hand-threaded traditional kurtas launch soon.',
      hashtags: ['zariboutique', 'traditionalwear', 'madeinpakistan'],
      status: 'published',
      isPublished: true,
      publishedAt: new Date(Date.now() - 5 * 24 * 60 * 60 * 1000)
    });

    // 7. Website, BrandAssets, Logos
    console.log('🌐 Creating Website & Branding Assets...');
    await Website.create({
      userId: user1._id,
      businessName: 'Zari Boutique',
      businessIdea: 'Handmade traditional embroidery e-store',
      publicUrl: 'https://brandora.app/zariboutique',
      status: 'published',
      content: {
        homepage: { headline: 'Elegant Handmade traditional wear', subheadline: 'Designed in Lahore' }
      }
    });

    await Logo.create({
      userId: user1._id,
      businessName: 'Zari Boutique',
      initials: 'ZB',
      backgroundColor: '#2C3E50',
      shape: 'circle',
      downloadUrl: 'https://brandora.app/uploads/logos/default.svg'
    });

    // 8. Analytics
    console.log('📊 Creating Analytics...');
    await Analytics.create({
      userId: user1._id,
      period: new Date().toISOString().slice(0, 7),
      overview: { totalPosts: 12, totalReach: 15400, totalEngagement: 1240, followersGrowth: 145 },
      instagram: { followers: 1540, posts: 12, likes: 980, comments: 240, reach: 12400, engagementRate: 4.5 },
      weeklyGrowth: [10, 15, 22, 18, 30, 25, 35],
      monthlyTrend: Array.from({ length: 30 }, (_, i) => 10 + i * 2)
    });

    // 9. Notifications, Tickets, ActivityLogs
    console.log('🔔 Creating Notifications & Tickets...');
    await Notification.create({
      userId: user1._id,
      type: 'success',
      title: 'Welcome to Brandora Pro!',
      message: 'Your Business subscription is now active.'
    });

    await SupportTicket.create({
      userId: user1._id,
      subject: 'Inquiry regarding payment gateways',
      description: 'How can I connect local payment options in Pakistan?',
      status: 'open',
      priority: 'medium',
      messages: [{ sender: 'user', content: 'How can I connect local payment options in Pakistan?', createdAt: new Date() }]
    });

    await ActivityLog.create({
      userId: user1._id,
      action: 'LOGIN',
      resource: 'auth',
      ipAddress: '192.168.1.1'
    });

    console.log('🎉 Seeding successfully completed!');
    process.exit(0);
  } catch (error) {
    console.error('❌ Seeding failed:', error);
    process.exit(1);
  }
};

seedDB();
