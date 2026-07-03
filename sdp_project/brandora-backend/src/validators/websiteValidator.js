const { body } = require('express-validator');

const generateWebsiteValidator = [
  body('business_name').trim().notEmpty().withMessage('Business name is required'),
  body('business_idea').trim().notEmpty().withMessage('Business idea is required'),
  body('industry').optional().trim(),
  body('language').optional().isIn(['en', 'ur']),
];

module.exports = { generateWebsiteValidator };
