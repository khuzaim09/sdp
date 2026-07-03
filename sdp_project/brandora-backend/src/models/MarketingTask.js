const mongoose = require('mongoose');

const marketingTaskSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    planId: { type: mongoose.Schema.Types.ObjectId, ref: 'MarketingPlan', default: null },
    title: { type: String, required: true, trim: true },
    description: { type: String, default: '' },
    category: { type: String, enum: ['content', 'social', 'seo', 'ads', 'email', 'analytics', 'other'], default: 'other' },
    dueDate: { type: Date, default: null },
    status: { type: String, enum: ['pending', 'in_progress', 'completed', 'skipped'], default: 'pending' },
    priority: { type: String, enum: ['low', 'medium', 'high', 'urgent'], default: 'medium' },
    dayNumber: { type: Number, default: null },
    deletedAt: { type: Date, default: null },
  },
  { timestamps: true }
);

marketingTaskSchema.index({ userId: 1, status: 1 });
marketingTaskSchema.index({ planId: 1 });
marketingTaskSchema.index({ dueDate: 1 });

module.exports = mongoose.model('MarketingTask', marketingTaskSchema);
