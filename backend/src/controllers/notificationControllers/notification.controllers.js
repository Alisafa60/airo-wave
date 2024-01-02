const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();
const { handleError } = require('../../helpers');

const createPushNotification = async (req, res) => {
  try {
    const { title, body, data, type} = req.body;
    const userId = req.user.id;

    const newPushNotification = await prisma.pushNotification.create({
      data: {
        title,
        body,
        data,
        type,
        user: {
            connect: {
              id: userId,
            },
        }
      },
    });

    res.status(201).json({ pushNotification: newPushNotification });
  } catch (e) {
    handleError(res, e, 'Error creating PushNotification');
  }
};

const getPushNotificationsByUser = async (req, res) => {
  try {
    const userId = req.user.id;

    // Retrieve push notifications for a specific user
    const pushNotifications = await prisma.pushNotification.findMany({
      where: { userId:userId },
    });

    res.status(200).json({ pushNotifications });
  } catch (e) {
    handleError(res, e, 'Error retrieving PushNotifications');
  }
};

const markNotificationAsRead = async (req, res) => {
  try {
    const userId = req.user.id;
    const { id } = req.params;

    const existingPushNotification = await prisma.pushNotification.findUnique({
      where: { id: parseInt(id), userId:userId },
    });

    if (!existingPushNotification || existingPushNotification.userId !== userId) {
      return res.status(403).json({ error: 'Unauthorized access' });
    }

    const updatedPushNotification = await prisma.pushNotification.update({
      where: { id: parseInt(id) },
      data: { readAt: new Date() },
    });

    res.status(200).json({ pushNotification: updatedPushNotification });
  } catch (e) {
    handleError(res, e, 'Error marking PushNotification as read');
  }
};

module.exports = {
  createPushNotification,
  getPushNotificationsByUser,
  markNotificationAsRead,
};
