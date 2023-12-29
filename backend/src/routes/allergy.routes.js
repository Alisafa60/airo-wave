const express = require('express');
const router = express.Router();
const {addAllergy} = require('../controllers/healthControllers/allergy.controllers');

router.post('/allergies', addAllergy);

module.exports = router;