const express = require('express');
const router = express.Router();
const {
  generateBusiness,
  generatePost,
  generatePlan,
  generateHashtagsEndpoint,
  generateCaption,
  generateSeo,
  generateEmail,
  generateBlog,
  generateAdCopy
} = require('../controllers/aiController');
const { authMiddleware } = require('../middleware/authMiddleware');
const { aiLimiter } = require('../middleware/rateLimiter');
const validate = require('../middleware/validate');
const {
  generateBusinessValidator,
  generatePostValidator,
  generatePlanValidator,
  generateHashtagsValidator,
  generateCaptionValidator,
  generateSeoValidator,
  generateEmailValidator,
  generateBlogValidator
} = require('../validators/aiValidator');

router.use(authMiddleware);

router.post('/generate-business', aiLimiter, generateBusinessValidator, validate, generateBusiness);
router.post('/generate-post', aiLimiter, generatePostValidator, validate, generatePost);
router.post('/generate-plan', aiLimiter, generatePlanValidator, validate, generatePlan);
router.post('/generate-hashtags', generateHashtagsValidator, validate, generateHashtagsEndpoint);
router.post('/generate-caption', aiLimiter, generateCaptionValidator, validate, generateCaption);
router.post('/generate-seo', aiLimiter, generateSeoValidator, validate, generateSeo);
router.post('/generate-email', aiLimiter, generateEmailValidator, validate, generateEmail);
router.post('/generate-blog', aiLimiter, generateBlogValidator, validate, generateBlog);
router.post('/generate-ad-copy', aiLimiter, generateAdCopy);

module.exports = router;
