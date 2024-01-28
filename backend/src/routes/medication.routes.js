const express = require('express');
const router = express.Router();
const medicationController = require('../controllers/healthControllers/medication.controllers');
const { healthRoutes } = require('../helpers');

// module.exports = healthRoutes(router, medicationController);
router.post('/user/health/medication', medicationController.createMedication);
router.get('/user/health/medications', medicationController.getAllMedications);
router.get('/user/health/medication/:id', medicationController.getMedicationById);
router.put('/user/health/medication/:id', medicationController.updateMedicationById);
router.post('/user/health/edit-medication', medicationController.updateMedicationByName);
router.delete('/user/health/medication/:id', medicationController.deleteMedicationById);

module.exports = router;
