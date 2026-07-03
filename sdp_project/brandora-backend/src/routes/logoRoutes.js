const express = require('express');
const router = express.Router();
const { generateLogo, getMyLogos } = require('../controllers/logoController');
const { authMiddleware } = require('../middleware/authMiddleware');
const validate = require('../middleware/validate');
const { generateLogoValidator } = require('../validators/brandingValidator');

router.post('/generate', authMiddleware, generateLogoValidator, validate, generateLogo);
router.get('/my-logos', authMiddleware, getMyLogos);

module.exports = router;
