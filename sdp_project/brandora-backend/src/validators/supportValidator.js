const { body } = require('express-validator');

const createTicketValidator = [
  body('subject').trim().notEmpty().withMessage('Subject is required'),
  body('description').trim().notEmpty().withMessage('Description is required'),
  body('category').optional().isIn(['bug', 'feature', 'billing', 'account', 'general']),
  body('priority').optional().isIn(['low', 'medium', 'high', 'urgent']),
];

const replyTicketValidator = [
  body('content').trim().notEmpty().withMessage('Reply content is required'),
];

const feedbackValidator = [
  body('message').trim().notEmpty().withMessage('Feedback message is required'),
  body('rating').optional().isInt({ min: 1, max: 5 }),
];

const contactFormValidator = [
  body('name').trim().notEmpty().withMessage('Name is required'),
  body('email').trim().isEmail().withMessage('Valid email is required'),
  body('message').trim().notEmpty().withMessage('Message is required'),
];

module.exports = { createTicketValidator, replyTicketValidator, feedbackValidator, contactFormValidator };
