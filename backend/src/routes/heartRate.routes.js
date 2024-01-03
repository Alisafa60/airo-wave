const express = require('express');
const router = express.Router();
const heartRate = require('../controllers/healthControllers/heartRate.controllers');

router.post('/heartRateData', heartRate.createHeartRateData);
router.get('/heartRateData/:id', heartRate.getHeartRateDataById);
router.get('/heartRateData/last', heartRate.getLastHeartRateData);
router.put('/heartRateData/:id', heartRate.updateHeartRateData);

module.exports = router;