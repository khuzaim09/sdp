const mongoose = require('mongoose');

const subscriptionSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    planType: { type: String, enum: ['free_trial', 'basic', 'pro', 'business'], required: true },
    pricePaid: { type: Number, default: 0 },
    startDate: { type: Date, default: Date.now },
    endDate: { type: Date, default: null },
    status: { type: String, enum: ['active', 'expired', 'cancelled', 'superseded'], default: 'active' },
    paymentMethod: { type: String, enum: ['none', 'card', 'bank', 'wallet'], default: 'none' },
    transactionId: { type: String, default: '' },
    autoRenew: { type: Boolean, default: false },
    deletedAt: { type: Date, default: null },
  },
  { timestamps: true }
);

subscriptionSchema.index({ userId: 1, status: 1 });
subscriptionSchema.index({ status: 1, endDate: 1 });

module.exports = mongoose.model('Subscription', subscriptionSchema);
