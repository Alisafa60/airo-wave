const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();
const { handleError } = require('../../helpers');

const addAllergy = async (req, res) => {
  try {
    const { allergen, severity, duration, triggers } = req.body;
    const userId = req.user.id;
    // Find the user's health condition
    const healthCondition = await prisma.healthCondition.findUnique({
      where: { userId: userId },
    });

    if (!healthCondition || !healthCondition.id) {
      return res.status(400).json({ error: 'User health information not found.' });
    }

    if (!allergen || !severity || !duration || !triggers) {
      return res.status(400).json({ error: 'Required fields are missing for allergy creation.' });
    }

    const newAllergy = await prisma.allergy.create({
      data: {
        allergen,
        severity,
        duration,
        triggers,
        healthCondition: { connect: { id: healthCondition.id }},
      },
    });

    res.status(201).json({ allergy: newAllergy });
  } catch (e) {
    handleError(res, e, 'Error adding allergy');
  }
};

const getAllAllergies = async (req, res) => {
  try {
    const userId = req.user.id;
    const allergies = await prisma.allergy.findMany({
      where: {
        healthCondition: {
          userId: userId,
        },
      },
    });

    res.json({ allergies });
  } catch (e) {
    handleError(res, e, 'Error retrieving allergies');
  }
};

const getAllergyById = async (req, res) => {
  try {
    const userId = req.user.id;
    const allergyId = req.params.id; 

    const allergy = await prisma.allergy.findUnique({
      where: {
        id: parseInt(allergyId),
        healthCondition: {
          userId: userId,
        },
      },
    });

    if (!allergy) {
      return res.status(404).json({ error: 'Allergy not found for the logged-in user.' });
    }

    res.json({ allergy });
  } catch (e) {
    handleError(res, e, 'Error retrieving allergy');
  }
};

const updateAllergyById = async (req, res) => {
  try {
    const userId = req.user.id;
    const allergyId = req.params.id;
    const { allergen, severity, duration, triggers } = req.body;

    const existingAllergy = await prisma.allergy.findUnique({
      where: {
        id: parseInt(allergyId),
        healthCondition: {
          userId: userId,
        },
      },
    });

    if (!existingAllergy) {
      return res.status(404).json({ error: 'Allergy not found for the logged-in user.' });
    }

    const updatedAllergy = await prisma.allergy.update({
      where: {
        id: parseInt(allergyId),
      },
      data: {
        allergen,
        severity,
        duration,
        triggers,
      },
    });

    res.json({ updatedAllergy });
  } catch (e) {
    handleError(res, e, 'Error updating allergy');
  }
};

const deleteAllergyById = async (req, res) => {
  try {
    const userId = req.user.id;
    const allergyId = req.params.id;

    const existingAllergy = await prisma.allergy.findUnique({
      where: {
        id: parseInt(allergyId),
        healthCondition: {
          userId: userId,
        },
      },
    });

    if (!existingAllergy) {
      return res.status(404).json({ error: 'Allergy not found for the logged-in user.' });
    }

    await prisma.allergy.delete({
      where: {
        id: parseInt(allergyId),
      },
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