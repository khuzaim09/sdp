const mongoose = require('mongoose');

const messageSchema = new mongoose.Schema(
  {
    chatSessionId: { type: mongoose.Schema.Types.ObjectId, ref: 'ChatSession', required: true },
    role: { type: String, enum: ['user', 'assistant', 'system'], required: true },
    content: { type: String, required: true },
    tokensUsed: { type: Number, default: 0 },
  },
  { timestamps: true }
);

messageSchema.index({ chatSessionId: 1, createdAt: 1 });

module.exports = mongoose.model('Message', messageSchema);
