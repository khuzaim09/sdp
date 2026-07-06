const mongoose = require('mongoose');

const userSchema = new mongoose.Schema(
  {
    name: { type: String, required: true, trim: true, minlength: 2, maxlength: 100 },
    email: { type: String, required: true, unique: true, lowercase: true, trim: true },
    password: { type: String, required: true, minlength: 6 },
    role: { type: String, enum: ['user', 'admin'], default: 'user' },
    plan: { type: String, enum: ['free_trial', 'basic', 'pro', 'business', 'expired'], default: 'free_trial' },
    language: { type: String, enum: ['en', 'ur'], default: 'en' },
    profileImage: { type: String, default: '' },
    isEmailVerified: { type: Boolean, default: false },
    isActive: { type: Boolean, default: true },
    lastLogin: { type: Date, default: Date.now },
    otpCode: { type: String, default: null },
    otpExpiry: { type: Date, default: null },
    resetPasswordToken: { type: String, default: null },
    resetPasswordExpiry: { type: Date, default: null },
    notificationSettings: {
      email: { type: Boolean, default: true },
      push: { type: Boolean, default: true },
      marketing: { type: Boolean, default: false },
    },
    deletedAt: { type: Date, default: null },
  },
  { timestamps: true, collection: 'create account' }
);

userSchema.index({ role: 1 });
userSchema.index({ plan: 1 });
userSchema.index({ deletedAt: 1 });

// Exclude soft-deleted users by default
userSchema.pre(/^find/, function (next) {
  if (!this.getQuery().deletedAt) {
    this.where({ deletedAt: null });
  }
  next();
});

module.exports = mongoose.model('User', userSchema);
