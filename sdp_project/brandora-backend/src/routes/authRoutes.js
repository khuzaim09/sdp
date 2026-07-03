const express = require('express');
const router = express.Router();
const {
  signup,
  login,
  logout,
  refreshTokenHandler,
  forgotPassword,
  resetPassword,
  verifyOtp,
  sendOtp,
  getProfile,
  updateProfile
} = require('../controllers/authController');
const { authMiddleware } = require('../middleware/authMiddleware');
const { authLimiter } = require('../middleware/rateLimiter');
const validate = require('../middleware/validate');
const {
  signupValidator,
  loginValidator,
  forgotPasswordValidator,
  resetPasswordValidator,
  verifyOtpValidator
} = require('../validators/authValidator');

router.post('/signup', authLimiter, signupValidator, validate, signup);
router.post('/login', authLimiter, loginValidator, validate, login);
router.post('/logout', authMiddleware, logout);
router.post('/refresh-token', refreshTokenHandler);
router.post('/forgot-password', authLimiter, forgotPasswordValidator, validate, forgotPassword);
router.post('/reset-password', resetPasswordValidator, validate, resetPassword);
router.post('/verify-otp', verifyOtpValidator, validate, verifyOtp);
router.post('/send-otp', sendOtp);

router.get('/profile', authMiddleware, getProfile);
router.put('/profile', authMiddleware, updateProfile);

module.exports = router;
