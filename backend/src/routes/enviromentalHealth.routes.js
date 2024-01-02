const express = require('express');
const router = express.Router();
const environmentalDataController = require('../controllers/enviromentalHealthControllers/enviromentalHealth.controllers'); // Replace with the correct path

router.post('/user/environmentalData', environmentalDataController.createEnvironmentalData);
router.get('/user/environmentalData/dateRange', environmentalDataController.getEnvironmentalDataByDateRange);
router.get('/user/environmentalData', environmentalDataController.getEnvironmentalDataList);

module.exports = router;
