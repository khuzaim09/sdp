const User = require('../models/User');
const RefreshToken = require('../models/RefreshToken');
const Subscription = require('../models/Subscription');
const { generateToken, generateRefreshToken, verifyRefreshToken } = require('../utils/jwtUtils');
const bcrypt = require('bcryptjs');
const crypto = require('crypto');
const { v4: uuidv4 } = require('uuid');

// POST /auth/signup
const signup = async (req, res) => {
  try {
    const { name, email, password, language = 'en' } = req.body;

    // Check if user already exists
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(409).json({ success: false, message: 'Email already registered.' });
    }

    // Hash password
    const salt = await bcrypt.genSalt(12);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Create user
    const user = await User.create({
      name,
      email,
      password: hashedPassword,
      language,
      plan: 'free_trial',
    });

    // Create free trial subscription (7 days)
    const trialEnd = new Date();
    trialEnd.setDate(trialEnd.getDate() + 7);
    await Subscription.create({
      userId: user._id,
      planType: 'free_trial',
      pricePaid: 0,
      startDate: new Date(),
      endDate: trialEnd,
      status: 'active',
      paymentMethod: 'none',
      transactionId: `trial_${uuidv4().slice(0, 8)}`,
    });

    // Generate tokens
    const token = generateToken({ user_id: user._id, email: user.email });
    const refreshToken = generateRefreshToken({ user_id: user._id });

    // Store refresh token
    const refreshExpiry = new Date();
    refreshExpiry.setDate(refreshExpiry.getDate() + 30);
    await RefreshToken.create({
      userId: user._id,
      token: refreshToken,
      expiresAt: refreshExpiry,
    });

    return res.status(201).json({
      success: true,
      message: '🎉 Account created successfully! Free trial activated.',
      data: {
        token,
        refreshToken,
        user: {
          user_id: user._id,
          name: user.name,
          email: user.email,
          plan: user.plan,
          language: user.language,
        },
      },
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /auth/login
const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    // Find user (include password for comparison)
    const user = await User.findOne({ email }).select('+password');
    if (!user) {
      return res.status(401).json({ success: false, message: 'Invalid credentials.' });
    }

    if (!user.isActive) {
      return res.status(403).json({ success: false, message: 'Account has been deactivated.' });
    }

    // Compare password
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ success: false, message: 'Invalid credentials.' });
    }

    // Update last login
    user.lastLogin = new Date();
    await user.save();

    // Revoke old refresh tokens (single session)
    await RefreshToken.updateMany({ userId: user._id, isRevoked: false }, { isRevoked: true });

    // Generate new tokens
    const token = generateToken({ user_id: user._id, email: user.email });
    const refreshToken = generateRefreshToken({ user_id: user._id });

    const refreshExpiry = new Date();
    refreshExpiry.setDate(refreshExpiry.getDate() + 30);
    await RefreshToken.create({
      userId: user._id,
      token: refreshToken,
      expiresAt: refreshExpiry,
    });

    return res.status(200).json({
      success: true,
      message: 'Login successful!',
      data: {
        token,
        refreshToken,
        user: {
          user_id: user._id,
          name: user.name,
          email: user.email,
          plan: user.plan,
          language: user.language,
          profileImage: user.profileImage,
          isEmailVerified: user.isEmailVerified,
        },
      },
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /auth/logout
const logout = async (req, res) => {
  try {
    await RefreshToken.updateMany({ userId: req.user.user_id, isRevoked: false }, { isRevoked: true });
    return res.status(200).json({ success: true, message: 'Logged out successfully.' });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /auth/refresh-token
const refreshTokenHandler = async (req, res) => {
  try {
    const { refreshToken: token } = req.body;
    if (!token) {
      return res.status(400).json({ success: false, message: 'Refresh token is required.' });
    }

    // Verify token
    const decoded = verifyRefreshToken(token);

    // Check if token exists and is not revoked
    const storedToken = await RefreshToken.findOne({ token, isRevoked: false });
    if (!storedToken) {
      return res.status(401).json({ success: false, message: 'Invalid or revoked refresh token.' });
    }

    // Revoke old token
    storedToken.isRevoked = true;
    await storedToken.save();

    // Get user
    const user = await User.findById(decoded.user_id);
    if (!user || !user.isActive) {
      return res.status(401).json({ success: false, message: 'User not found or deactivated.' });
    }

    // Generate new tokens
    const newToken = generateToken({ user_id: user._id, email: user.email });
    const newRefreshToken = generateRefreshToken({ user_id: user._id });

    const refreshExpiry = new Date();
    refreshExpiry.setDate(refreshExpiry.getDate() + 30);
    await RefreshToken.create({
      userId: user._id,
      token: newRefreshToken,
      expiresAt: refreshExpiry,
    });

    return res.status(200).json({
      success: true,
      data: { token: newToken, refreshToken: newRefreshToken },
    });
  } catch (error) {
    return res.status(401).json({ success: false, message: 'Invalid or expired refresh token.' });
  }
};

// POST /auth/forgot-password
const forgotPassword = async (req, res) => {
  try {
    const { email } = req.body;
    const user = await User.findOne({ email });
    if (!user) {
      // Don't reveal if user exists
      return res.status(200).json({ success: true, message: 'If the email exists, a reset link has been sent.' });
    }

    // Generate reset token
    const resetToken = crypto.randomBytes(32).toString('hex');
    const hashedToken = crypto.createHash('sha256').update(resetToken).digest('hex');

    user.resetPasswordToken = hashedToken;
    user.resetPasswordExpiry = new Date(Date.now() + 60 * 60 * 1000); // 1 hour
    await user.save();

    // In production, send email with reset link
    // For now, return token in response (development only)
    return res.status(200).json({
      success: true,
      message: 'Password reset email sent.',
      ...(process.env.NODE_ENV === 'development' && { resetToken }),
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /auth/reset-password
const resetPassword = async (req, res) => {
  try {
    const { token, password } = req.body;
    const hashedToken = crypto.createHash('sha256').update(token).digest('hex');

    const user = await User.findOne({
      resetPasswordToken: hashedToken,
      resetPasswordExpiry: { $gt: new Date() },
    });

    if (!user) {
      return res.status(400).json({ success: false, message: 'Invalid or expired reset token.' });
    }

    const salt = await bcrypt.genSalt(12);
    user.password = await bcrypt.hash(password, salt);
    user.resetPasswordToken = null;
    user.resetPasswordExpiry = null;
    await user.save();

    // Revoke all refresh tokens
    await RefreshToken.updateMany({ userId: user._id }, { isRevoked: true });

    return res.status(200).json({ success: true, message: 'Password reset successfully. Please login again.' });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /auth/verify-otp
const verifyOtp = async (req, res) => {
  try {
    const { email, otp } = req.body;
    const user = await User.findOne({ email });

    if (!user || user.otpCode !== otp || new Date() > user.otpExpiry) {
      return res.status(400).json({ success: false, message: 'Invalid or expired OTP.' });
    }

    user.isEmailVerified = true;
    user.otpCode = null;
    user.otpExpiry = null;
    await user.save();

    return res.status(200).json({ success: true, message: 'Email verified successfully!' });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /auth/send-otp
const sendOtp = async (req, res) => {
  try {
    const { email } = req.body;
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found.' });
    }

    const otp = Math.floor(1000 + Math.random() * 9000).toString();
    user.otpCode = otp;
    user.otpExpiry = new Date(Date.now() + 10 * 60 * 1000); // 10 minutes
    await user.save();

    // In production, send OTP via email/SMS
    return res.status(200).json({
      success: true,
      message: 'OTP sent to your email.',
      ...(process.env.NODE_ENV === 'development' && { otp }),
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// GET /auth/profile
const getProfile = async (req, res) => {
  try {
    const user = await User.findById(req.user.user_id).select('-password');
    if (!user) {
      return res.status(404).json({ success: false, message: 'User not found.' });
    }

    return res.json({
      success: true,
      data: {
        user_id: user._id,
        name: user.name,
        email: user.email,
        plan: user.plan,
        language: user.language,
        profile_image: user.profileImage,
        is_email_verified: user.isEmailVerified,
        is_active: user.isActive,
        last_login: user.lastLogin,
        notification_settings: user.notificationSettings,
        created_at: user.createdAt,
        updated_at: user.updatedAt,
      },
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// PUT /auth/profile
const updateProfile = async (req, res) => {
  try {
    const { name, language, profile_image } = req.body;
    const userId = req.user.user_id;

    const updateData = {};
    if (name) updateData.name = name;
    if (language) updateData.language = language;
    if (profile_image) updateData.profileImage = profile_image;

    const user = await User.findByIdAndUpdate(userId, updateData, { new: true }).select('-password');

    return res.status(200).json({
      success: true,
      message: 'Profile updated successfully!',
      data: updateData,
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = {
  signup,
  login,
  logout,
  refreshTokenHandler,
  forgotPassword,
  resetPassword,
  verifyOtp,
  sendOtp,
  getProfile,
  updateProfile,
};
