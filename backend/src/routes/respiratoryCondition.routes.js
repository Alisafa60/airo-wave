const express = require('express');
const router = express.Router();
const respiratoryConditionController = require('../controllers/healthControllers/respiratoryCondition.controllers');

router.post('/user/health/respiratoryCondition', respiratoryConditionController.addRespiratoryCondition);
router.get('/user/health/respiratoryConditions', respiratoryConditionController.getAllRespiratoryConditions);
router.get('/user/health/respiratoryCondition/:id', respiratoryConditionController.getRespiratoryConditionById);
router.put('/user/health/respiratoryCondition/:id', respiratoryConditionController.updateRespiratoryConditionById);
router.delete('/user/health/respiratoryCondition/:id', respiratoryConditionController.deleteRespiratoryConditionById);

module.exports = router;
