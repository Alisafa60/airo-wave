const express = require('express');
const router = express.Router();
const stress = require('../controllers/healthControllers/stress.controllers');

router.post('/user/health/stress', stress.createStressData);
router.get('/user/heath/stress/:id', stress.getStressDataById);
router.get('/user/health/stress/last', stress.getLastStressData);

module.exports = router;