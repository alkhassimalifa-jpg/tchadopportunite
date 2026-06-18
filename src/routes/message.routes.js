const express = require('express');
const router = express.Router();
const { getConversations, getMessages } = require('../controllers/message.controller');
const { authenticate } = require('../middlewares/auth.middleware');
 
router.get('/conversations', authenticate, getConversations);
router.get('/:otherUserId', authenticate, getMessages);
 
module.exports = router;
 