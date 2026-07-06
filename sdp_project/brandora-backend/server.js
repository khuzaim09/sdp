require('dotenv').config();
const app = require('./src/app');
const connectDB = require('./src/config/database');

const PORT = process.env.PORT || 3000;

// Connect to MongoDB
connectDB().then(() => {
  app.listen(PORT, '0.0.0.0', () => {
    console.log(`
    ╔═══════════════════════════════════════╗
    ║   🚀 Brandora Backend Running!        ║
    ║   Port: ${PORT}                           ║
    ║   Environment: ${process.env.NODE_ENV || 'development'}  ║
    ╚═══════════════════════════════════════╝
    `);
  });
}).catch(err => {
    console.error('❌ Failed to start server due to MongoDB connection failure:', err);
});

module.exports = app;
