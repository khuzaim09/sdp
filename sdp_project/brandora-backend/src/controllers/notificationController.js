const Notification = require('../models/Notification');

// GET /notifications
const getNotifications = async (req, res) => {
  try {
    const userId = req.user.user_id;
    const { status } = req.query; // 'read', 'unread', or undefined for all

    const query = { userId, deletedAt: null };
    if (status === 'unread') query.isRead = false;
    if (status === 'read') query.isRead = true;

    const notifications = await Notification.find(query).sort({ createdAt: -1 }).limit(100).lean();
    return res.status(200).json({ success: true, data: notifications });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// PUT /notifications/:id/read
const markAsRead = async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.user_id;

    const notification = await Notification.findOneAndUpdate(
      { _id: id, userId },
      { isRead: true },
      { new: true }
    );

    if (!notification) return res.status(404).json({ success: false, message: 'Notification not found.' });

    return res.status(200).json({ success: true, message: 'Notification marked as read.', data: notification });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// PUT /notifications/read-all
const markAllAsRead = async (req, res) => {
  try {
    const userId = req.user.user_id;
    await Notification.updateMany({ userId, isRead: false }, { isRead: true });
    return res.status(200).json({ success: true, message: 'All notifications marked as read.' });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// DELETE /notifications/:id
const deleteNotification = async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.user_id;

    const notification = await Notification.findOneAndUpdate(
      { _id: id, userId },
      { deletedAt: new Date() },
      { new: true }
    );

    if (!notification) return res.status(404).json({ success: false, message: 'Notification not found.' });

    return res.status(200).json({ success: true, message: 'Notification deleted.' });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = {
  getNotifications,
  markAsRead,
  markAllAsRead,
  deleteNotification
};
