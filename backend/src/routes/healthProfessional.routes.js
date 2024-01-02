const express = require('express');
const router = express.Router();
const healthProfessional = require('../controllers/healthProfessionalControllers/healthProfessional.controllers');

router.post('/healthProfessional', healthProfessional.createHealthProfessional);
router.get('/healthProfessional/:id', healthProfessional.getHealthProfessionalById);
router.put('/healthProfessional/:id', healthProfessional.updateHealthProfessionalById);

module.exports = router;