const { body } = require('express-validator');

const sendMessageValidator = [
  body('message').trim().notEmpty().withMessage('Message is required'),
  body('chat_id').optional().trim(),
  body('language').optional().isIn(['en', 'ur']),
];

const createChatValidator = [
  body('language').optional().isIn(['en', 'ur']),
];

module.exports = { sendMessageValidator, createChatValidator };
