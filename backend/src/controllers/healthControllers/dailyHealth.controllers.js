const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();
const { handleError } = require('../../helpers');


const createDailyHealth = async (req, res) => {
  try {
    const { severity } = req.body;
    const userId = req.user.id;

    const healthCondition = await prisma.healthCondition.findUnique({
      where: { userId: userId },
    });

    if (!healthCondition || !healthCondition.id) {
      return res.status(400).json({ error: 'User health information not found.' });
    }

    if (!severity) {
      return res.status(400).json({ error: 'Required field "severity" is missing for DailyHealth creation.' });
    }

    const newDailyHealth = await prisma.dailyHealth.create({
      data: {
        severity,
        healthConditions: { connect: { id: healthCondition.id }},
      },
    });

    res.status(201).json({ dailyHealth: newDailyHealth });
  } catch (e) {
    handleError(res, e, 'Error creating DailyHealth');
  }
};

const getAllDailyHealth = async (req, res) => {
  try {
    const userId = req.user.id;

    const dailyHealth = await prisma.dailyHealth.findMany({
      where: {
        healthConditions: {
          userId: userId,
        },
      },
      include: {
        healthConditions: true,
        sleepData: true,
        stressData: true,
      },
    });

    res.json({ dailyHealth });
  } catch (e) {
    handleError(res, e, 'Error retrieving DailyHealth entries');
  }
};

const getLastDailyHealth = async (req, res) => {
  try{
    const userId = req.user.id;
    const dailyHealthId = req.params.id;

    const dailyHealth = await prisma.dailyHealth.findUnique({
      where: {
        id: dailyHealthId,
        healthConditions:{
          userId: userId,
        },
      },
    });

    if (!dailyHealth){
      return res.status(404).json({ error: 'Daily health entry not found'});
    }

    res.status(200).json({ dailyHealth });
  }catch(e){
    handleError(res, e, 'Error retrieving DailyHealth entry');
  }
}

const getDailyHealthById = async (req, res) => {
  try {
    const userId = req.user.id;
    const dailyHealthId = req.params.id;
    
    const dailyHealth = await prisma.dailyHealth.findFirst({
      where: {
        id: parseInt(dailyHealthId),
        healthConditions: {
          userId: userId,
        },
        orderBy:{
          createdAt: 'desc',
        },
      },
    });

    if (!dailyHealth) {
      return res.status(404).json({ error: 'DailyHealth entry not found for the logged-in user.' });
    }

    res.json({ dailyHealth });
  } catch (e) {
    handleError(res, e, 'Error retrieving DailyHealth entry');
  }
};

const updateDailyHealthById = async (req, res) => {
  try {
    const userId = req.user.id;
    const dailyHealthId = req.params.id;
    const { severity } = req.body;

    const existingDailyHealth = await prisma.dailyHealth.findUnique({
      where: {
        id: parseInt(dailyHealthId),
        healthConditions: {
          userId: userId,
        },
      },
    });

    if (!existingDailyHealth) {
      return res.status(404).json({ error: 'DailyHealth entry not found.' });
    }

    const updatedDailyHealth = await prisma.dailyHealth.update({
      where: {
        id: parseInt(dailyHealthId),
      },
      data: {
        severity,
      },
    });

    res.json({ updatedDailyHealth });
  } catch (e) {
    handleError(res, e, 'Error updating DailyHealth entry');
  }
};

module.exports = {
  createDailyHealth,
  getAllDailyHealth,
  getLastDailyHealth,
  getDailyHealthById,
  updateDailyHealthById,
};
