const express = require('express');
const sensorController = require('../controllers/airSensor/sensor.controllers');

const router = express.Router();

router.post('/sensor-data', sensorController.storeSensorData);
router.get('/latest-sensor-data', sensorController.getLastSensorData);

module.exports = router;