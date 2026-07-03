const { body } = require('express-validator');

const upgradePlanValidator = [
  body('plan_type').isIn(['basic', 'pro', 'business']).withMessage('Valid plan type required'),
  body('card_number').optional().trim(),
  body('card_name').optional().trim(),
];

module.exports = { upgradePlanValidator };
