const express = require('express');
const router = express.Router();
const { uploadProfilePhoto, uploadCV } = require('../controllers/upload.controller');
const { authenticate } = require('../middlewares/auth.middleware');
const { upload } = require('../config/cloudinary');

// Upload profile photo (image only)
router.post('/photo', authenticate, upload.single('photo'), uploadProfilePhoto);

// Upload CV (PDF)
router.post('/cv', authenticate, upload.single('cv'), uploadCV);

module.exports = router;