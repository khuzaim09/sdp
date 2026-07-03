const express = require('express');
const router = express.Router();
const {
  getNotifications,
  markAsRead,
  markAllAsRead,
  deleteNotification
} = require('../controllers/notificationController');
const { authMiddleware } = require('../middleware/authMiddleware');
const validate = require('../middleware/validate');
const { param } = require('express-validator');

router.use(authMiddleware);

router.get('/', getNotifications);
router.put('/read-all', markAllAsRead);
router.put('/:id/read', [
  param('id').isMongoId().withMessage('Invalid notification ID')
], validate, markAsRead);
router.delete('/:id', [
  param('id').isMongoId().withMessage('Invalid notification ID')
], validate, deleteNotification);

module.exports = router;
