const express = require('express');
const router = express.Router();
const userLocation = require('../controllers/locationControllers/userLocation.controllers');

router.post('/user/location', userLocation.createUserLocation);
router.get('/user/location/:id', userLocation.getUserLocationById);
router.get('/user/last-location', userLocation.getUserLastLocation);
// router.put('/user/location/:id', userLocation.updateUserLocationById);
module.exports = router;