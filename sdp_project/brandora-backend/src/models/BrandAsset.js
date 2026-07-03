const mongoose = require('mongoose');

const brandAssetSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    type: { type: String, enum: ['logo', 'banner', 'business_card', 'social_template', 'poster', 'thumbnail', 'brand_guidelines'], required: true },
    businessName: { type: String, required: true, trim: true },
    title: { type: String, default: '' },
    fileUrl: { type: String, default: '' },
    fileData: { type: String, default: '' },
    metadata: { type: mongoose.Schema.Types.Mixed, default: {} },
    deletedAt: { type: Date, default: null },
  },
  { timestamps: true }
);

brandAssetSchema.index({ userId: 1, type: 1 });

module.exports = mongoose.model('BrandAsset', brandAssetSchema);
