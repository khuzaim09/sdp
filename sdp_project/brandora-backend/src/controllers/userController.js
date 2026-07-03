const User = require('../models/User');
const RefreshToken = require('../models/RefreshToken');
const bcrypt = require('bcryptjs');

// GET /user/profile
const getProfile = async (req, res) => {
  try {
    const user = await User.findById(req.user.user_id);
    if (!user) return res.status(404).json({ success: false, message: 'User not found.' });

    return res.status(200).json({ success: true, data: user });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// PUT /user/profile
const updateProfile = async (req, res) => {
  try {
    const { name, language } = req.body;
    const userId = req.user.user_id;

    const updateData = {};
    if (name) updateData.name = name;
    if (language) updateData.language = language;

    const user = await User.findByIdAndUpdate(userId, updateData, { new: true });
    if (!user) return res.status(404).json({ success: false, message: 'User not found.' });

    return res.status(200).json({ success: true, message: 'Profile updated successfully!', data: user });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /user/upload-image
const uploadProfileImage = async (req, res) => {
  try {
    const userId = req.user.user_id;
    if (!req.file) {
      return res.status(400).json({ success: false, message: 'Please upload an image file.' });
    }

    const downloadUrl = `${req.protocol}://${req.get('host')}/uploads/profiles/${req.file.filename}`;
    const user = await User.findByIdAndUpdate(userId, { profileImage: downloadUrl }, { new: true });

    return res.status(200).json({
      success: true,
      message: 'Profile image uploaded successfully!',
      data: { profileImage: downloadUrl },
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /user/change-password
const changePassword = async (req, res) => {
  try {
    const { currentPassword, newPassword } = req.body;
    const userId = req.user.user_id;

    const user = await User.findById(userId).select('+password');
    if (!user) return res.status(404).json({ success: false, message: 'User not found.' });

    const isMatch = await bcrypt.compare(currentPassword, user.password);
    if (!isMatch) {
      return res.status(400).json({ success: false, message: 'Incorrect current password.' });
    }

    const salt = await bcrypt.genSalt(12);
    user.password = await bcrypt.hash(newPassword, salt);
    await user.save();

    return res.status(200).json({ success: true, message: 'Password changed successfully.' });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// PUT /user/notifications
const updateNotificationSettings = async (req, res) => {
  try {
    const { email, push, marketing } = req.body;
    const userId = req.user.user_id;

    const user = await User.findById(userId);
    if (!user) return res.status(404).json({ success: false, message: 'User not found.' });

    if (email !== undefined) user.notificationSettings.email = email;
    if (push !== undefined) user.notificationSettings.push = push;
    if (marketing !== undefined) user.notificationSettings.marketing = marketing;

    await user.save();

    return res.status(200).json({
      success: true,
      message: 'Notification settings updated.',
      data: user.notificationSettings,
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// DELETE /user/delete
const deleteAccount = async (req, res) => {
  try {
    const userId = req.user.user_id;

    const user = await User.findById(userId);
    if (!user) return res.status(404).json({ success: false, message: 'User not found.' });

    user.deletedAt = new Date();
    user.isActive = false;
    await user.save();

    // Revoke all refresh tokens
    await RefreshToken.updateMany({ userId }, { isRevoked: true });

    return res.status(200).json({ success: true, message: 'Account deleted successfully.' });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = {
  getProfile,
  updateProfile,
  uploadProfileImage,
  changePassword,
  updateNotificationSettings,
  deleteAccount,
};
