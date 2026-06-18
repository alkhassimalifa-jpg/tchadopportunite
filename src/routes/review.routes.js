const express = require('express');
const router = express.Router();
const {
  createReview,
  getUserReviews,
  getMyGivenReviews,
  deleteReview,
} = require('../controllers/review.controller');
const { authenticate } = require('../middlewares/auth.middleware');

// Specific routes first
router.get('/me/given', authenticate, getMyGivenReviews);

router.post('/', authenticate, createReview);
router.get('/user/:userId', getUserReviews);
router.delete('/:id', authenticate, deleteReview);

module.exports = router;