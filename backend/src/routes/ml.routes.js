const express = require('express');
const router = express.Router();
const machineLearningPredictions = require('../controllers/machineLearningController/ml.controllers'); 

router.post('/predictions', machineLearningPredictions.createMlPrediction);
router.get('/predictions', machineLearningPredictions.getMlPredictions);
router.get('/predictions/date-range', machineLearningPredictions.getMlPredictionsInDateRange);
router.put('/predictions/:id', machineLearningPredictions.updateMlPredictionById);

module.exports = router;