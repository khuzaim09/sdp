const mongoose = require('mongoose');

const businessIdeaSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    industry: { type: String, required: true, trim: true },
    budget: { type: String, required: true },
    location: { type: String, default: 'Pakistan' },
    language: { type: String, enum: ['en', 'ur'], default: 'en' },
    ideas: [
      {
        title: { type: String },
        description: { type: String },
        investmentRequired: { type: String },
        potentialRevenue: { type: String },
        pros: [String],
        cons: [String],
        firstSteps: [String],
      },
    ],
    deletedAt: { type: Date, default: null },
  },
  { timestamps: true }
);

businessIdeaSchema.index({ userId: 1 });

module.exports = mongoose.model('BusinessIdea', businessIdeaSchema);
