const express = require('express');
const router = express.Router();
const userHealthController = require('../controllers/healthControllers/userHealth.controllers');
const { healthRoutes } = require('../helpers');

// module.exports = healthRoutes(router, userHealthController);
router.post('/user/health', userHealthController.addUserHealth);
router.get('/user/health', userHealthController.getUserHealth);
router.put('/user/health', userHealthController.updateUserHealth);
router.delete('/user/health', userHealthController.deleteUserHealthById);

module.exports = router;