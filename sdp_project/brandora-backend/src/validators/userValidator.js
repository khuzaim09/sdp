const { body } = require('express-validator');

const updateProfileValidator = [
  body('name').optional().trim().isLength({ min: 2, max: 100 }).withMessage('Name must be 2-100 characters'),
  body('language').optional().isIn(['en', 'ur']).withMessage('Language must be en or ur'),
];

const notificationSettingsValidator = [
  body('email').optional().isBoolean(),
  body('push').optional().isBoolean(),
  body('marketing').optional().isBoolean(),
];

const changePasswordValidator = [
  body('currentPassword').notEmpty().withMessage('Current password is required'),
  body('newPassword').isLength({ min: 6 }).withMessage('New password must be at least 6 characters'),
];

module.exports = { updateProfileValidator, notificationSettingsValidator, changePasswordValidator };
