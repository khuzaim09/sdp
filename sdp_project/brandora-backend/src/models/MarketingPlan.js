const mongoose = require('mongoose');

const marketingPlanSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    businessName: { type: String, required: true, trim: true },
    industry: { type: String, required: true },
    targetAudience: { type: String, default: '' },
    budget: { type: String, default: '' },
    language: { type: String, enum: ['en', 'ur'], default: 'en' },
    planData: { type: mongoose.Schema.Types.Mixed, default: {} },
    status: { type: String, enum: ['generated', 'active', 'completed', 'archived'], default: 'generated' },
    deletedAt: { type: Date, default: null },
  },
  { timestamps: true }
);

marketingPlanSchema.index({ userId: 1, createdAt: -1 });

module.exports = mongoose.model('MarketingPlan', marketingPlanSchema);
