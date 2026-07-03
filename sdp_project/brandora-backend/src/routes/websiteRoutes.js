const express = require('express');
const router = express.Router();
const { generateWebsite, getMyWebsites } = require('../controllers/websiteController');
const { authMiddleware } = require('../middleware/authMiddleware');
const validate = require('../middleware/validate');
const { generateWebsiteValidator } = require('../validators/websiteValidator');

router.post('/generate', authMiddleware, generateWebsiteValidator, validate, generateWebsite);
router.get('/my-websites', authMiddleware, getMyWebsites);

module.exports = router;
