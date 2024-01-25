const express = require('express');
const router = express.Router();
const userLocation = require('../controllers/locationControllers/location.controllers');

router.post('/user/location', userLocation.createLocation);
router.get('/user/last-location', userLocation.getLastLocation);;
module.exports = router;