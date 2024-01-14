const express = require('express');
const router = express.Router();
const { uploadProfilePicture, deleteProfilePicture } = require('../controllers/imageControllers/image.controllers');
const upload = require('../utils/imageUpload');

router.post('/user/profile-picture', upload.single('profilePicture'), uploadProfilePicture);
router.delete('/user/profile-picture', deleteProfilePicture);

module.exports = router;