const express = require('express');
const router = express.Router();
const userRoutes = require('../controllers/locationControllers/createRoutes.controllers');

router.post('/routes/create', userRoutes.createRoute);
router.get('/routes/:id/distance', userRoutes.findDistance);

module.exports = router;