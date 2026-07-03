const express = require('express');
const router = express.Router();
const {
  getMarketingPlans,
  getMarketingPlanById,
  generateTasksForPlan,
  getTasks,
  updateTaskStatus,
  generateCustomerPersona,
  generateStrategy
} = require('../controllers/marketingController');
const { authMiddleware } = require('../middleware/authMiddleware');
const validate = require('../middleware/validate');
const { body, param, query } = require('express-validator');

router.use(authMiddleware);

router.get('/plans', getMarketingPlans);
router.get('/plans/:id', [
  param('id').isMongoId().withMessage('Invalid plan ID')
], validate, getMarketingPlanById);

router.post('/generate-tasks', [
  body('plan_id').isMongoId().withMessage('Valid Plan ID required')
], validate, generateTasksForPlan);

router.get('/tasks', [
  query('plan_id').optional().isMongoId().withMessage('Invalid plan ID')
], validate, getTasks);

router.put('/tasks/:id/status', [
  param('id').isMongoId().withMessage('Invalid task ID'),
  body('status').notEmpty().withMessage('Status is required')
], validate, updateTaskStatus);

router.post('/persona', [
  body('business_name').notEmpty().withMessage('Business name is required'),
  body('industry').notEmpty().withMessage('Industry is required')
], validate, generateCustomerPersona);

router.post('/strategy', [
  body('business_name').notEmpty().withMessage('Business name is required'),
  body('industry').notEmpty().withMessage('Industry is required')
], validate, generateStrategy);

module.exports = router;
