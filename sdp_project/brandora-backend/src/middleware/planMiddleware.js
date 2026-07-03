const { PLAN_CONFIG } = require('../config/constants');

// Check if user has an active subscription plan
const planMiddleware = (requiredPlans = []) => {
  return (req, res, next) => {
    try {
      const userPlan = req.user?.plan;

      if (!userPlan) {
        return res.status(403).json({
          success: false,
          message: 'No active subscription. Please subscribe to continue.'
        });
      }

      // If no specific plans required, any active plan is fine
      if (requiredPlans.length === 0) {
        return next();
      }

      // Check if user's plan is in required plans
      if (!requiredPlans.includes(userPlan)) {
        return res.status(403).json({
          success: false,
          message: `This feature requires ${requiredPlans.join(' or ')} plan. Current plan: ${userPlan}`
        });
      }

      next();
    } catch (error) {
      return res.status(500).json({ success: false, message: 'Plan verification failed.' });
    }
  };
};

module.exports = planMiddleware;
