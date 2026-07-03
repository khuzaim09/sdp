const express = require('express');
const router = express.Router();
const {
  getFAQs,
  createTicket,
  getMyTickets,
  getTicketById,
  replyToTicket,
  submitFeedback,
  submitContactForm
} = require('../controllers/helpController');
const { authMiddleware } = require('../middleware/authMiddleware');
const validate = require('../middleware/validate');
const { createTicketValidator, replyTicketValidator, feedbackValidator, contactFormValidator } = require('../validators/supportValidator');
const { param } = require('express-validator');

// FAQs and Contact form don't strictly require authentication
router.get('/faq', getFAQs);
router.post('/contact', contactFormValidator, validate, submitContactForm);

// Authenticated support endpoints
router.use(authMiddleware);

router.post('/tickets', createTicketValidator, validate, createTicket);
router.get('/tickets', getMyTickets);
router.get('/tickets/:id', [
  param('id').isMongoId().withMessage('Invalid ticket ID')
], validate, getTicketById);
router.post('/tickets/:id/reply', [
  param('id').isMongoId().withMessage('Invalid ticket ID'),
  replyTicketValidator[0]
], validate, replyToTicket);

router.post('/feedback', feedbackValidator, validate, submitFeedback);

module.exports = router;
