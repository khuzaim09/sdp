const rateLimit = require('express-rate-limit');

// General API rate limiter
const globalLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 200,
  standardHeaders: true,
  message: { success: false, message: 'Too many requests. Please try again later.' }
});

// Stricter limiter for AI endpoints
const aiLimiter = rateLimit({
  windowMs: 60 * 1000, // 1 minute
  max: 10,
  standardHeaders: true,
  message: { success: false, message: 'AI rate limit exceeded. Please wait a moment.' }
});

// Auth rate limiter
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 20,
  standardHeaders: true,
  message: { success: false, message: 'Too many auth attempts. Please try again later.' }
});

module.exports = { globalLimiter, aiLimiter, authLimiter };
