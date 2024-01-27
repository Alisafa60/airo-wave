const express = require('express');
const router = express.Router();
const dailyHealthController = require('../controllers/healthControllers/dailyHealth.controllers'); 

router.post('/user/daily-health', dailyHealthController.createDailyHealth);
router.get('/user/daily-health', dailyHealthController.getAllDailyHealth);
router.get('/user/last-daily-health', dailyHealthController.getLastDailyHealth);
router.get('/user/daily-health/:id/details', dailyHealthController.getDailyHealthById);
router.put('/user/daily-health/:id', dailyHealthController.updateDailyHealthById);

module.exports = router;