const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const compression = require('compression');
const path = require('path');
const swaggerUi = require('swagger-ui-express');
const swaggerSpec = require('./config/swagger');
const { globalLimiter } = require('./middleware/rateLimiter');
const errorHandler = require('./middleware/errorHandler');

const app = express();

// Security & Compression
app.use(helmet({
  crossOriginResourcePolicy: { policy: "cross-origin" } // Required for loading local uploaded images in Flutter
}));
app.use(cors({
  origin: ['http://localhost:3000', 'http://localhost:8080', 'https://brandora.app'],
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));
app.use(compression());
app.use(morgan('dev'));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));
app.use(globalLimiter);

// Serve uploads statically
app.use('/uploads', express.static(path.join(__dirname, '../uploads')));

// Swagger Documentation Route
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

// Health check
app.get('/', (req, res) => {
  res.json({
    success: true,
    message: '🚀 Brandora API is running!',
    version: '2.0.0',
    timestamp: new Date().toISOString()
  });
});

// Routes
app.use('/auth', require('./routes/authRoutes'));
app.use('/user', require('./routes/userRoutes'));
app.use('/ai', require('./routes/aiRoutes'));
app.use('/subscription', require('./routes/subscriptionRoutes'));
app.use('/social', require('./routes/socialRoutes'));
app.use('/marketing', require('./routes/marketingRoutes'));
app.use('/branding', require('./routes/brandingRoutes'));
app.use('/website', require('./routes/websiteRoutes'));
app.use('/chat', require('./routes/chatRoutes'));
app.use('/logo', require('./routes/logoRoutes'));
app.use('/help', require('./routes/helpRoutes'));
app.use('/notifications', require('./routes/notificationRoutes'));

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({ success: false, message: `Route ${req.originalUrl} not found` });
});

// Global error handler
app.use(errorHandler);

module.exports = app;
