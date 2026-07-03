const express = require('express');
const router = express.Router();
const { createNewChat, sendMessage, getChatHistory, getChat, deleteChat } = require('../controllers/chatController');
const { authMiddleware } = require('../middleware/authMiddleware');
const { aiLimiter } = require('../middleware/rateLimiter');
const validate = require('../middleware/validate');
const { sendMessageValidator, createChatValidator } = require('../validators/chatValidator');
const { param } = require('express-validator');

router.use(authMiddleware);

router.post('/new', createChatValidator, validate, createNewChat);
router.post('/message', aiLimiter, sendMessageValidator, validate, sendMessage);
router.get('/history', getChatHistory);
router.get('/:chatId', [
  param('chatId').isMongoId().withMessage('Invalid chat ID')
], validate, getChat);
router.delete('/:chatId', [
  param('chatId').isMongoId().withMessage('Invalid chat ID')
], validate, deleteChat);

module.exports = router;
