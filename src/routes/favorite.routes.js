const express = require('express');
const router = express.Router();
const {
  addFavorite,
  removeFavorite,
  getMyFavorites,
  checkFavorite,
} = require('../controllers/favorite.controller');
const { authenticate } = require('../middlewares/auth.middleware');

router.get('/', authenticate, getMyFavorites);
router.post('/', authenticate, addFavorite);
router.get('/check/:targetType/:targetId', authenticate, checkFavorite);
router.delete('/:targetType/:targetId', authenticate, removeFavorite);

module.exports = router;