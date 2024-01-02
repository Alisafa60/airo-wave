const express = require('express');
const router = express.Router();
const pushNotificationController = require('../controllers/notificationControllers/notification.controllers');

router.post('/user/notifications', pushNotificationController.createPushNotification);
router.get('/user/notifications', pushNotificationController.getPushNotificationsByUser);
router.put('/user/notifications/:id/mark-as-read', pushNotificationController.markNotificationAsRead);

module.exports = router;