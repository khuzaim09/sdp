const mongoose = require('mongoose');

const socialAccountSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    platform: { type: String, enum: ['instagram', 'facebook', 'twitter', 'linkedin', 'tiktok'], required: true },
    username: { type: String, default: '' },
    profileUrl: { type: String, default: '' },
    accessToken: { type: String, default: '' },
    isConnected: { type: Boolean, default: false },
    followerCount: { type: Number, default: 0 },
    deletedAt: { type: Date, default: null },
  },
  { timestamps: true }
);

socialAccountSchema.index({ userId: 1, platform: 1 });

module.exports = mongoose.model('SocialAccount', socialAccountSchema);
