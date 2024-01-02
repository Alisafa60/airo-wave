const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
const { handleError } = require('../../helpers');

const createFeedback = async (req, res) => {
  try {
    const userId = req.user.id;
    const { feedbackType, comments, predictionId } = req.body;
    
    const healthProfessional = await prisma.healthProfessional.findFirst({
        where: {userId: userId}
    })
    const healthProId = healthProfessional ? healthProfessional.id : null;

    const newFeedback = await prisma.feedback.create({
      data: {
        feedbackType,
        comments,
        predictionId,
        healthProId,
        userId,
      },
    });

    res.status(201).json({ feedback: newFeedback });
  } catch (e) {
    handleError(res, e, 'Error creating Feedback');
  }
};

const getFeedbackByUser = async (req, res) => {
  try {
    const userId = req.user.id;

    const feedbackList = await prisma.feedback.findMany({
      where: { userId },
    });

    res.status(200).json({ feedbackList });
  } catch (e) {
    handleError(res, e, 'Error retrieving Feedback entries');
  }
};

const getFeedbackByPrediction = async (req, res) => {
  try {
    const userId = req.user.id;
    const { predictionId } = req.params;

    const feedbackList = await prisma.feedback.findMany({
      where: { userId, predictionId: parseInt(predictionId) },
    });

    res.status(200).json({ feedbackList });
  } catch (e) {
    handleError(res, e, 'Error retrieving Feedback entries by prediction');
  }
};

module.exports = {
  createFeedback,
  getFeedbackByUser,
  getFeedbackByPrediction,
};