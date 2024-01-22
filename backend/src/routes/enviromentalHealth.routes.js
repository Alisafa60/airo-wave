const express = require('express');
const router = express.Router();
const environmentalDataController = require('../controllers/enviromentalHealthControllers/enviromentalHealth.controllers');

router.post('/user/environmental-data', environmentalDataController.createEnvironmentalData);
router.get('/user/environmental-data/dateRange', environmentalDataController.getEnvironmentalDataByDateRange);
router.get('/user/environmental-data', environmentalDataController.getEnvironmentalDataList);
router.get('/user/latest-environmental-data', environmentalDataController.getLastEnvironmentalData);
module.exports = router;
