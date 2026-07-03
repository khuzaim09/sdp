const mongoose = require('mongoose');

const analyticsSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    period: { type: String, default: '' },
    overview: {
      totalPosts: { type: Number, default: 0 },
      totalReach: { type: Number, default: 0 },
      totalEngagement: { type: Number, default: 0 },
      followersGrowth: { type: Number, default: 0 },
    },
    instagram: {
      followers: { type: Number, default: 0 },
      posts: { type: Number, default: 0 },
      likes: { type: Number, default: 0 },
      comments: { type: Number, default: 0 },
      reach: { type: Number, default: 0 },
      engagementRate: { type: Number, default: 0 },
    },
    facebook: {
      followers: { type: Number, default: 0 },
      posts: { type: Number, default: 0 },
      likes: { type: Number, default: 0 },
      shares: { type: Number, default: 0 },
      reach: { type: Number, default: 0 },
      engagementRate: { type: Number, default: 0 },
    },
    twitter: {
      followers: { type: Number, default: 0 },
      tweets: { type: Number, default: 0 },
      retweets: { type: Number, default: 0 },
      likes: { type: Number, default: 0 },
      impressions: { type: Number, default: 0 },
    },
    weeklyGrowth: [{ type: Number }],
    monthlyTrend: [{ type: Number }],
    deletedAt: { type: Date, default: null },
  },
  { timestamps: true }
);

analyticsSchema.index({ userId: 1 });

module.exports = mongoose.model('Analytics', analyticsSchema);
