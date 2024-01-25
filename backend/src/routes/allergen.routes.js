const express = require('express');
const router = express.Router();
const allergenControllers = require('../controllers/healthControllers/allergen.controllers');

router.post('/user/health/allergen', allergenControllers.addAllergen);

module.exports = router;