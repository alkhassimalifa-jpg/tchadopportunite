const express = require('express');
const router = express.Router();

const authRoutes = require('./auth.routes');
const jobRoutes = require('./job.routes');
const messageRoutes = require('./message.routes');
const profileRoutes = require('./profile.routes');
const reviewRoutes = require('./review.routes');
const favoriteRoutes = require('./favorite.routes');
const notificationRoutes = require('./notification.routes');
const uploadRoutes = require('./upload.routes');

router.use('/auth', authRoutes);
router.use('/jobs', jobRoutes);
router.use('/messages', messageRoutes);
router.use('/profiles', profileRoutes);
router.use('/reviews', reviewRoutes);
router.use('/favorites', favoriteRoutes);
router.use('/notifications', notificationRoutes);
router.use('/upload', uploadRoutes);

// Health check
router.get('/health', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'TchadOpportunité API is running',
    timestamp: new Date().toISOString(),
  });
});

module.exports = router;