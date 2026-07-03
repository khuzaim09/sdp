const { body } = require('express-validator');

const generateBusinessValidator = [
  body('industry').trim().notEmpty().withMessage('Industry is required'),
  body('budget').notEmpty().withMessage('Budget is required'),
  body('location').optional().trim(),
  body('language').optional().isIn(['en', 'ur']),
];

const generatePostValidator = [
  body('business_name').trim().notEmpty().withMessage('Business name is required'),
  body('product').trim().notEmpty().withMessage('Product is required'),
  body('platform').isIn(['instagram', 'facebook', 'twitter', 'linkedin', 'tiktok']).withMessage('Valid platform required'),
  body('tone').optional().trim(),
  body('language').optional().isIn(['en', 'ur']),
];

const generatePlanValidator = [
  body('business_name').trim().notEmpty().withMessage('Business name is required'),
  body('industry').trim().notEmpty().withMessage('Industry is required'),
  body('target_audience').optional().trim(),
  body('budget').optional().trim(),
  body('language').optional().isIn(['en', 'ur']),
];

const generateHashtagsValidator = [
  body('keywords').isArray({ min: 1 }).withMessage('Keywords array is required'),
  body('platform').optional().isIn(['instagram', 'facebook', 'twitter', 'linkedin']),
  body('count').optional().isInt({ min: 5, max: 30 }),
];

const generateCaptionValidator = [
  body('business_name').trim().notEmpty().withMessage('Business name is required'),
  body('product').trim().notEmpty().withMessage('Product is required'),
  body('platform').isIn(['instagram', 'facebook', 'twitter', 'linkedin', 'tiktok']).withMessage('Valid platform required'),
];

const generateSeoValidator = [
  body('business_name').trim().notEmpty().withMessage('Business name is required'),
  body('industry').trim().notEmpty().withMessage('Industry is required'),
];

const generateEmailValidator = [
  body('business_name').trim().notEmpty().withMessage('Business name is required'),
  body('purpose').trim().notEmpty().withMessage('Email purpose is required'),
];

const generateBlogValidator = [
  body('topic').trim().notEmpty().withMessage('Blog topic is required'),
  body('business_name').trim().notEmpty().withMessage('Business name is required'),
];

module.exports = {
  generateBusinessValidator,
  generatePostValidator,
  generatePlanValidator,
  generateHashtagsValidator,
  generateCaptionValidator,
  generateSeoValidator,
  generateEmailValidator,
  generateBlogValidator,
};
