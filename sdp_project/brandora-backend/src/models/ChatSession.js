const mongoose = require('mongoose');

const chatSessionSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    title: { type: String, default: 'New Conversation', trim: true },
    language: { type: String, enum: ['en', 'ur'], default: 'en' },
    totalMessages: { type: Number, default: 0 },
    summary: { type: String, default: '' },
    deletedAt: { type: Date, default: null },
  },
  { timestamps: true }
);

chatSessionSchema.index({ userId: 1, updatedAt: -1 });

module.exports = mongoose.model('ChatSession', chatSessionSchema);
