const express = require('express');
const router = express.Router();
const {
  generateBrandNames,
  suggestColorPalettes,
  generateBrandGuidelines,
  generateBusinessCardTemplate,
  generateBannerTemplate,
  getMyAssets
} = require('../controllers/brandingController');
const { authMiddleware } = require('../middleware/authMiddleware');
const validate = require('../middleware/validate');
const { body } = require('express-validator');

router.use(authMiddleware);

router.post('/generate-names', [
  body('keywords').isArray({ min: 1 }).withMessage('Keywords must be an array of at least 1 keyword'),
  body('industry').notEmpty().withMessage('Industry is required')
], validate, generateBrandNames);

router.post('/color-palette', [
  body('business_name').notEmpty().withMessage('Business name is required'),
  body('industry').notEmpty().withMessage('Industry is required'),
  body('vibe').notEmpty().withMessage('Brand vibe is required')
], validate, suggestColorPalettes);

router.post('/guidelines', [
  body('business_name').notEmpty().withMessage('Business name is required'),
  body('industry').notEmpty().withMessage('Industry is required')
], validate, generateBrandGuidelines);

router.post('/business-card', [
  body('business_name').notEmpty().withMessage('Business name is required'),
  body('name').notEmpty().withMessage('Card name is required'),
  body('job_title').notEmpty().withMessage('Job title is required'),
  body('email').isEmail().withMessage('Valid email is required')
], validate, generateBusinessCardTemplate);

router.post('/banner', [
  body('business_name').notEmpty().withMessage('Business name is required'),
  body('tagline').notEmpty().withMessage('Tagline is required')
], validate, generateBannerTemplate);

router.get('/my-assets', getMyAssets);

module.exports = router;
