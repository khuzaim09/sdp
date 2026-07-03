const mongoose = require('mongoose');

const logoSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    businessName: { type: String, required: true, trim: true },
    initials: { type: String, default: '' },
    colorTheme: { type: String, default: 'professional' },
    backgroundColor: { type: String, default: '' },
    fontStyle: { type: String, default: 'bold' },
    shape: { type: String, enum: ['circle', 'rounded', 'square'], default: 'circle' },
    svgContent: { type: String, default: '' },
    downloadUrl: { type: String, default: '' },
    deletedAt: { type: Date, default: null },
  },
  { timestamps: true }
);

logoSchema.index({ userId: 1, createdAt: -1 });

module.exports = mongoose.model('Logo', logoSchema);
