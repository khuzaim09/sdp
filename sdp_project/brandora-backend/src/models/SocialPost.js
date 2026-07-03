const mongoose = require('mongoose');

const socialPostSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    platform: { type: String, enum: ['instagram', 'facebook', 'twitter', 'linkedin', 'tiktok'], required: true },
    content: { type: String, required: true },
    hashtags: [{ type: String }],
    mediaUrl: { type: String, default: '' },
    scheduledTime: { type: Date, default: null },
    status: { type: String, enum: ['draft', 'scheduled', 'published', 'failed'], default: 'draft' },
    isPublished: { type: Boolean, default: false },
    publishedAt: { type: Date, default: null },
    platformResponse: { type: mongoose.Schema.Types.Mixed, default: {} },
    deletedAt: { type: Date, default: null },
  },
  { timestamps: true }
);

socialPostSchema.index({ userId: 1, createdAt: -1 });
socialPostSchema.index({ status: 1 });
socialPostSchema.index({ scheduledTime: 1 });

module.exports = mongoose.model('SocialPost', socialPostSchema);
