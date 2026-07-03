const { body } = require('express-validator');

const generateLogoValidator = [
  body('business_name').trim().notEmpty().withMessage('Business name is required'),
  body('color_theme').optional().isIn(['professional', 'vibrant', 'nature', 'luxury', 'tech', 'pink', 'ocean', 'purple']),
  body('shape').optional().isIn(['circle', 'rounded', 'square']),
  body('font_style').optional().trim(),
];

const generateBannerValidator = [
  body('business_name').trim().notEmpty().withMessage('Business name is required'),
  body('tagline').optional().trim(),
  body('color_theme').optional().trim(),
];

const generateBrandGuidelinesValidator = [
  body('business_name').trim().notEmpty().withMessage('Business name is required'),
  body('industry').optional().trim(),
];

module.exports = { generateLogoValidator, generateBannerValidator, generateBrandGuidelinesValidator };
