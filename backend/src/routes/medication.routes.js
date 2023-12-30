const express = require('express');
const router = express.Router();
const {createMedication} = require('../controllers/healthControllers/medication.controllers');

router.post('/addMedication', createMedication);

module.exports = router;