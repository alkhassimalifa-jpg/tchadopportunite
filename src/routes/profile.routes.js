const express = require('express');
const router = express.Router();
const { getMyProfile, updateMyProfile, getMyStats } = require('../controllers/profile.controller');
const { authenticate } = require('../middlewares/auth.middleware');

router.get('/me', authenticate, getMyProfile);
router.put('/me', authenticate, updateMyProfile);
router.get('/me/stats', authenticate, getMyStats);

module.exports = router;