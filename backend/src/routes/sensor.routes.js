const express = require('express');
const sensorController = require('../controllers/airSensor/sensor.controllers');

const router = express.Router();

router.post('/sensor-data', sensorController.storeSensorData);

module.exports = router;