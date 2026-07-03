const mongoose = require('mongoose');

const websiteSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    businessName: { type: String, required: true, trim: true },
    businessIdea: { type: String, default: '' },
    industry: { type: String, default: '' },
    publicUrl: { type: String, default: '' },
    content: { type: mongoose.Schema.Types.Mixed, default: {} },
    status: { type: String, enum: ['generated', 'published', 'unpublished', 'archived'], default: 'generated' },
    deletedAt: { type: Date, default: null },
  },
  { timestamps: true }
);

websiteSchema.index({ userId: 1, createdAt: -1 });

module.exports = mongoose.model('Website', websiteSchema);
