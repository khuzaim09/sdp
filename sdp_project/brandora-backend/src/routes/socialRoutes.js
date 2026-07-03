const express = require('express');
const router = express.Router();
const { createPost, schedulePost, publishPost, getPosts } = require('../controllers/socialController');
const { authMiddleware } = require('../middleware/authMiddleware');
const validate = require('../middleware/validate');
const { createPostValidator, schedulePostValidator, publishPostValidator } = require('../validators/socialValidator');

router.use(authMiddleware);

router.post('/create-post', createPostValidator, validate, createPost);
router.post('/schedule-post', schedulePostValidator, validate, schedulePost);
router.post('/publish-post', publishPostValidator, validate, publishPost);
router.get('/posts', getPosts);

module.exports = router;
