const express = require('express');
const router = express.Router();
const heartRate = require('../controllers/healthControllers/heartRate.controllers');

router.post('/user/health/heartRate', heartRate.createHeartRateData);
router.get('/user/heath/heartRate/:id', heartRate.getHeartRateDataById);
router.get('/user/health/heartRate/last', heartRate.getLastHeartRateData);

module.exports = router;