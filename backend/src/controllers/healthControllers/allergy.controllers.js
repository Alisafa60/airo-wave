const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();
const {handleError} = require('../../helpers');

const addAllergy = async (req, res) => {
    try {
      const { allergen, severity, duration, triggers } = req.body;
      const userId = req.user.id;
      const userHealth = await prisma.healthCondition.findUnique({
        where: { userId: userId },
      });

      if (!userHealth || !userHealth.id) {
        return res.status(400).json({ error: 'User health information not found.' });
      }
  
      const userHealthId = userHealth.id;
  
      const newAllergy = await prisma.allergy.create({
        data: {
          allergen,
          severity,
          duration,
          triggers,
        },
      });
  
      // Connect the allergy to the obtained UserHealth entry
      const updatedUserHealth = await prisma.healthCondition.update({
        where: { id: userHealthId },
        data: {
          allergy: { connect: { id: newAllergy.id } },
        },
      });
  
      res.status(201).json({ allergy: newAllergy, updatedUserHealth });
    } catch (e) {
      handleError(res, e, 'Error adding allergy');
    }
};

 const getAllAllergies = async (req, res) => {
  try {
      const userId = req.user.id;
      const userAllergies = await prisma.healthCondition.findUnique({
          where: { userId: userId },
          include: { allergy: true },
      });

      if (!userAllergies || !userAllergies.allergy) {
          return res.status(404).json({ error: 'No allergies found for the user.' });
      }

      res.json({ allergies: userAllergies.allergy });
  } catch (e) {
      handleError(res, e, 'Error getting allergies');
  }
};

const getAllergyById = async (req, res) => {
  try {
      const { id } = req.params;
      const userId = req.user.id;
      const userAllergy = await prisma.allergy.findUnique({
          where: { id: id },
          include: { healthCondition: { where: { userId: userId }}},
      });

      if (!userAllergy || !userAllergy.healthCondition) {
          return res.status(404).json({ error: 'Allergy not found for the user.' });
      }

      res.json({ allergy: userAllergy });
  } catch (e) {
      handleError(res, e, 'Error getting allergy');
  }
};

const updateAllergyById = async (req, res) => {
  try {
      const { id } = req.params;
      const userId = req.user.id;
      const { allergen, severity, duration, triggers } = req.body;
      const updatedAllergy = await prisma.allergy.update({
          where: { id: id },
          include: { healthCondition: { where: { userId: userId }}},
          data: {
              allergen,
              severity,
              duration,
              triggers,
          },
      });

      res.json({ allergy: updatedAllergy });
  } catch (e) {
      handleError(res, e, 'Error updating allergy');
  }
};

const deleteAllergyById = async (req, res) => {
  try {
      const { id } = req.params;
      const userId = req.user.id;
      await prisma.allergy.delete({
          where: { id: id },
          include: { healthCondition: { where: { userId: userId }}},
      });
      
      res.json({ message: 'Allergy deleted successfully' });
  } catch (e) {
      handleError(res, e, 'Error deleting allergy');
  }
};

module.exports = {
  addAllergy,
  getAllAllergies,
  getAllergyById,
  updateAllergyById,
  deleteAllergyById,
};