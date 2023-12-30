const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
const allergyController = require('./allergy.controllers');
const respiratoryConditionController = require('./respiratoryCondition.controllers');

const addUserHealth = async (req, res) => {
  try {
    const userId = req.user.id;
    const { weight, bloodType, respiratoryConditionFields, allergyFields } = req.body;

    const newRespiratoryCondition = respiratoryConditionFields
      ? await respiratoryConditionController.addRespiratoryCondition(req, res)
      : null;

    let existingAllergy;

    // Check if allergyFields are provided
    if (allergyFields) {
      // If allergyFields are provided, try to find an existing allergy
      existingAllergy = await allergyController.findExistingAllergy(allergyFields);
    }

    const newUserHealth = await prisma.healthCondition.create({
      data: {
        weight,
        bloodType,
        user: {
          connect: {
            id: userId,
          },
        },
        respiratoryCondition: newRespiratoryCondition
          ? { connect: { id: newRespiratoryCondition.id } }
          : undefined,
        allergy: existingAllergy
          ? { connect: { id: existingAllergy.id } }
          : undefined,
      },
    });

    res.status(201).json({ userHealth: newUserHealth });
  } catch (e) {
    console.error('Error adding new user health', e);

    // Check if the error is specifically related to the missing allergy
    if (e.message.includes('allergy')) {
      res.status(400).json({ error: 'Allergy is required for user health entry.' });
    } else {
      res.status(500).json({ error: e.message });
    }
  }
};

module.exports = { addUserHealth };

