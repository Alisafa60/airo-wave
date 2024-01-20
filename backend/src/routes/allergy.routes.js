const express = require('express');
const router = express.Router();
const allergyController = require('../controllers/healthControllers/allergy.controllers');

router.post('/user/health/allergy', allergyController.addAllergy);
router.get('/user/health/allergies', allergyController.getAllAllergies);
router.get('/user/health/allergy/:id', allergyController.getAllergyById);
router.put('/user/health/allergy/:id', allergyController.updateAllergyById);
router.delete('/user/health/allergy/:id', allergyController.deleteAllergyById);
router.put('/user/health/allergy', allergyController.updateAllergyByName);

module.exports = router;