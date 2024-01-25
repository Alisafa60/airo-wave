const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();
const {handleError} = require('../../helpers');

const addRespiratoryCondition = async (req, res) => {
    try {
        const { condition, diagnosis, symptomsFrequency, triggers } = req.body;
        const userId = req.user.id;
        // Find the user's health condition
        const healthCondition = await prisma.healthCondition.findUnique({
            where: { userId: userId },
        });

        if (!healthCondition || !healthCondition.id) {
            return res.status(400).json({ error: 'User health information not found.' });
        }

        if (!condition || !diagnosis || !symptomsFrequency || !triggers) {
            return res.status(400).json({ error: 'Required fields are missing for allergy creation.' });
        }

        const newRespiratoryCondition = await prisma.respiratoryCondition.create({
            data: {
                condition,
                diagnosis,
                symptomsFrequency,
                triggers,
                healthCondition: { connect: { id: healthCondition.id }},
            },
        });

        res.status(201).json({ respiratoryCondition: newRespiratoryCondition});
    } catch (e) {
        handleError(res, e, 'Error adding respiratory condition');
    }
};

const getAllRespiratoryConditions = async (req, res) => {
    try {
        const userId = req.user.id;
        const respiratoryConditions = await prisma.respiratoryCondition.findMany({
            where: {
                healthCondition: {
                    userId: userId,
                },
            },
        });

        res.json({ respiratoryConditions });
    } catch (e) {
        handleError(res, e, 'Error retrieving respiratory conditions');
    }
};

const getRespiratoryConditionById = async (req, res) => {
    try {
        const userId = req.user.id;
        const respiratoryConditionId = req.params.id;

        const respiratoryCondition = await prisma.respiratoryCondition.findUnique({
            where: {
                id: parseInt(respiratoryConditionId),
                healthCondition: {
                    userId: userId,
                },
            },
        });

        if (!respiratoryCondition) {
            return res.status(404).json({ error: 'Respiratory condition not found for the logged-in user.' });
        }

        res.json({ respiratoryCondition });
    } catch (e) {
        handleError(res, e, 'Error retrieving respiratory condition');
    }
};

const updateRespiratoryConditionById = async (req, res) => {
    try {
        const userId = req.user.id;
        const respiratoryConditionId = req.params.id;
        const { condition, diagnosis, symptomsFrequency, triggers } = req.body;

        const existingRespiratoryCondition = await prisma.respiratoryCondition.findUnique({
            where: {
                id: parseInt(respiratoryConditionId),
                healthCondition: {
                    userId: userId,
                },
            },
        });

        if (!existingRespiratoryCondition) {
            return res.status(404).json({ error: 'Respiratory condition not found for the logged-in user.' });
        }

        const updatedRespiratoryCondition = await prisma.respiratoryCondition.update({
            where: {
                id: parseInt(respiratoryConditionId),
            },
            data: {
                condition: condition || existingRespiratoryCondition.condition,
                diagnosis: diagnosis|| existingRespiratoryCondition.condition,
                symptomsFrequency: symptomsFrequency || existingRespiratoryCondition.symptomsFrequency,
                triggers: triggers || existingRespiratoryCondition.triggers,
            },
        });

        res.json({ updatedRespiratoryCondition });
    } catch (e) {
        handleError(res, e, 'Error updating respiratory condition');
    }
};

const updateRespiratoryConditionByName = async (req, res) => {
    try {
      const userId = req.user.id;
      const { name, diagnosis, symptomsFrequency, triggers } = req.body;
  
      const healthCondition = await prisma.healthCondition.findUnique({
        where: {
          userId: userId,
        }
      });
  
      let existingRespiratoryCondition = await prisma.respiratoryCondition.findFirst({
        where: {
          name: name,
          healthConditionId: healthCondition.id,
        },
      });
  
      if (!existingRespiratoryCondition) {
        // If the respiratory condition doesn't exist, create a new one
        existingRespiratoryCondition = await prisma.respiratoryCondition.create({
          data: {
            name: name,
            diagnosis: diagnosis,
            symptomsFrequency: symptomsFrequency, 
            triggers: triggers, 
            healthConditionId: healthCondition.id,
          },
        });
      } else {
        // If the respiratory condition exists, update it
        existingRespiratoryCondition = await prisma.respiratoryCondition.update({
          where: {
            id: existingRespiratoryCondition.id,
          },
          data: {
            diagnosis: diagnosis || existingRespiratoryCondition.diagnosis,
            symptomsFrequency: symptomsFrequency || existingRespiratoryCondition.symptomsFrequency,
            triggers: triggers || existingRespiratoryCondition.triggers,
          },
        });
      }
  
      res.json({ updatedRespiratoryCondition: existingRespiratoryCondition });
      console.log(req.body);
    } catch (e) {
      handleError(res, e, 'Error updating respiratory condition');
    }
  };
  
  

const deleteRespiratoryConditionById = async (req, res) => {
    try {
        const userId = req.user.id;
        const respiratoryConditionId = req.params.id;

        const existingRespiratoryCondition = await prisma.respiratoryCondition.findUnique({
            where: {
                id: parseInt(respiratoryConditionId),
                healthCondition: {
                    userId: userId,
                },
            },
        });

        if (!existingRespiratoryCondition) {
            return res.status(404).json({ error: 'Respiratory condition not found for the logged-in user.' });
        }

        await prisma.respiratoryCondition.delete({
            where: {
                id: parseInt(respiratoryConditionId),
            },
        });

        res.json({ message: 'Respiratory condition deleted successfully' });
    } catch (e) {
        handleError(res, e, 'Error deleting respiratory condition');
    }
};

const deleteRespiratoryConditionByName = async (req, res) => {
    try {
      const userId = req.user.id;
      const { name } = req.body;
      const healthCondition = await prisma.healthCondition.findUnique({
        where: {
          userId:userId,
        }
      })
      const existingRespiratoryCondition = await prisma.respiratoryCondition.findUnique({
        where: {
          name: name,
          healthConditionId: healthCondition.id,
        },
      });
  
      if (!existingRespiratoryCondition) {
        return res.status(404).json({ error: 'Respiratory condition not found for the logged-in user.' });
      }
  
      await prisma.respiratoryCondition.delete({
        where: {
          id: existingRespiratoryCondition.id,
        },
      });
  
      res.json({ message: 'Respiratory condition deleted successfully' });
    } catch (e) {
      handleError(res, e, 'Error deleting respiratory condition');
    }
};
  
  

module.exports = {
    addRespiratoryCondition,
    getAllRespiratoryConditions,
    getRespiratoryConditionById,
    updateRespiratoryConditionById,
    deleteRespiratoryConditionById,
    deleteRespiratoryConditionByName,
    updateRespiratoryConditionByName,
};