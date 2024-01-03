const express = require('express');
const router = express.Router();
const deviceController = require('../controllers/deviceControllers/device.controllers'); 

router.post('/devices', deviceController.createDevice);
router.get('/devices', deviceController.getAllDevices);
router.get('/devices/:deviceId', deviceController.getDeviceById);
router.put('/devices/:deviceId', deviceController.updateDevice);
router.delete('/devices/:deviceId', deviceController.deleteDevice);

module.exports = router;