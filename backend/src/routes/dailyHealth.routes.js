const express = require('express');
const router = express.Router();
const dailyHealthController = require('../controllers/healthControllers/dailyHealth.controllers'); 

router.post('/user/dailyHealth', dailyHealthController.createDailyHealth);
router.get('/user/dailyHealth', dailyHealthController.getAllDailyHealth);
router.get('/user/dailyHealth/:id', dailyHealthController.getLastDailyHealth);
router.get('/user/dailyHealth/:id/details', dailyHealthController.getDailyHealthById);
router.put('/user/dailyHealth/:id', dailyHealthController.updateDailyHealthById);

module.exports = router;