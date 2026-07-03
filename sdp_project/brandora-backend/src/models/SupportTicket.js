const mongoose = require('mongoose');

const supportTicketSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    subject: { type: String, required: true, trim: true },
    description: { type: String, required: true },
    category: { type: String, enum: ['bug', 'feature', 'billing', 'account', 'general'], default: 'general' },
    status: { type: String, enum: ['open', 'in_progress', 'resolved', 'closed'], default: 'open' },
    priority: { type: String, enum: ['low', 'medium', 'high', 'urgent'], default: 'medium' },
    messages: [
      {
        sender: { type: String, enum: ['user', 'support'], required: true },
        content: { type: String, required: true },
        createdAt: { type: Date, default: Date.now },
      },
    ],
    deletedAt: { type: Date, default: null },
  },
  { timestamps: true }
);

supportTicketSchema.index({ userId: 1, status: 1 });

module.exports = mongoose.model('SupportTicket', supportTicketSchema);
