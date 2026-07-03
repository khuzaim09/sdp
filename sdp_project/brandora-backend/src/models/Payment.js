const mongoose = require('mongoose');

const paymentSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    subscriptionId: { type: mongoose.Schema.Types.ObjectId, ref: 'Subscription', required: true },
    amount: { type: Number, required: true },
    currency: { type: String, default: 'PKR' },
    method: { type: String, enum: ['card', 'bank', 'wallet', 'none'], required: true },
    status: { type: String, enum: ['pending', 'completed', 'failed', 'refunded'], default: 'pending' },
    transactionId: { type: String, required: true },
    gatewayResponse: { type: mongoose.Schema.Types.Mixed, default: {} },
    deletedAt: { type: Date, default: null },
  },
  { timestamps: true }
);

paymentSchema.index({ userId: 1 });
paymentSchema.index({ transactionId: 1 });
paymentSchema.index({ status: 1 });

module.exports = mongoose.model('Payment', paymentSchema);
