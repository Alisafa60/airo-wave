const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
const { handleError } = require('../../helpers');

const createMlPrediction = async (req, res) => {
    try {
        const { predictedValue } = req.body;
        const userId = req.user.id;
        let feedbackEntries = [];

        if (feedback) {
            feedbackEntries = feedback.map((text) => ({ text }));
        }
        
        const newMlPrediction = await prisma.mlPrediction.create({
            data: {
                predictedValue,
                user: {
                connect: {
                    id: userId,
                    },
                },
                feedback: {
                  create: feedbackEntries,
                },
            },
        });

        res.status(201).json({ mlPrediction: newMlPrediction });
    } catch (e) {
        handleError(res, e, 'Error creating MlPrediction');
    }
};

const getMlPredictions = async (req, res) => {
    try {
        const userId = req.user.id;

        const mlPredictions = await prisma.mlPrediction.findMany({
        where: { userId:userId },
        });

        res.status(200).json({ mlPredictions });
    } catch (e) {
        handleError(res, e, 'Error retrieving MlPredictions');
    }
};

const getMlPredictionsInDateRange = async (req, res) => {
    try {
      const userId = req.user.id;
      const { startDate, endDate } = req.query;
  
      const mlPredictions = await prisma.mlPrediction.findMany({
        where: {
          userId:userId,
          timestamp: {
            gte: new Date(startDate),
            lte: new Date(endDate),
          },
        },
      });
  
      res.status(200).json({ mlPredictions });
    } catch (e) {
      handleError(res, e, 'Error retrieving MlPredictions in date range');
    }
};

const updateMlPredictionById = async (req, res) => {
    try {
      const userId = req.user.id;
      const { id } = req.params;
      const { predictedValue } = req.body;
  
      const existingMlPrediction = await prisma.mlPrediction.findUnique({
        where: { id: parseInt(id), userId:userId },
      });
  
      if (!existingMlPrediction) {
        return res.status(403).json({ error: 'Unauthorized access' });
      }
  
      const updatedMlPrediction = await prisma.mlPrediction.update({
        where: { id: parseInt(id) },
        data: { predictedValue },
      });
  
      res.status(200).json({ mlPrediction: updatedMlPrediction });
    } catch (e) {
      handleError(res, e, 'Error updating MlPrediction');
    }
};
  
module.exports = {
  createMlPrediction,
  getMlPredictions,
  getMlPredictionsInDateRange,
  updateMlPredictionById,
};
