const express = require('express');
const router = express.Router();
const { getPlans, upgradePlan, getStatus } = require('../controllers/subscriptionController');
const { authMiddleware } = require('../middleware/authMiddleware');
const validate = require('../middleware/validate');
const { upgradePlanValidator } = require('../validators/subscriptionValidator');

router.get('/plans', getPlans);
router.post('/upgrade', authMiddleware, upgradePlanValidator, validate, upgradePlan);
router.get('/status', authMiddleware, getStatus);

module.exports = router;
