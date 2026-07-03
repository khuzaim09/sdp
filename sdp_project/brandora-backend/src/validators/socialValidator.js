const { body } = require('express-validator');

const createPostValidator = [
  body('platform').isIn(['instagram', 'facebook', 'twitter', 'linkedin', 'tiktok']).withMessage('Valid platform required'),
  body('content').trim().notEmpty().withMessage('Content is required'),
  body('hashtags').optional().isArray(),
];

const schedulePostValidator = [
  body('post_id').notEmpty().withMessage('Post ID is required'),
  body('scheduled_time').isISO8601().withMessage('Valid scheduled time is required'),
];

const publishPostValidator = [
  body('post_id').notEmpty().withMessage('Post ID is required'),
];

module.exports = { createPostValidator, schedulePostValidator, publishPostValidator };
