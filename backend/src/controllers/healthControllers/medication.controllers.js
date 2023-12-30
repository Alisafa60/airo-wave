const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
const {handleError} = require('../../helpers');

const createMedication = async (req, res) => {
  try {
    const { name, frequency, dosage, startDate, context } = req.body;

    const newMedication = await prisma.medication.create({
      data: {
        name,
        frequency,
        dosage,
        startDate: startDate || null,
      },
    });

    const userId = req.user.id;

    // Connect the medication to the user's health condition 
    const userHealth = await prisma.healthCondition.findUnique({
      where: { userId: userId },
    });

    if (!userHealth || !userHealth.id) {
      return res.status(400).json({ error: 'User health information not found.' });
    }

    const updatedUserHealth = await prisma.healthCondition.update({
      where: { id: userHealth.id },
      data: {
        medications: {
          connect: { id: newMedication.id },
        },
      },
    });
    let conditionId = null;

    if (context === 'allergy' && userHealth.allergyId) {
      conditionId = userHealth.allergyId;
      await prisma.allergy.update({
        where: { id: conditionId },
        data: {
          medications: {
            connect: { id: newMedication.id },
          },
        },
      });
    } else if (context === 'respiratoryCondition' && userHealth.respiratoryConditionId) {
      conditionId = userHealth.respiratoryConditionId;
      await prisma.respiratoryCondition.update({
        where: { id: conditionId },
        data: {
          medications: {
            connect: { id: newMedication.id },
          },
        },
      });
    }

    res.status(201).json({ medication: newMedication, updatedUserHealth });
  } catch (e) {
    handleError(res, e, 'Error creating medication');
  }
};

const getAllMedications = async (req, res) => {
  try {
    const userId = req.user.id;
    const medications = await prisma.medication.findMany({
      where:{ healthConditon: { userId: userId }}
    });
    res.json({ medications });
  } catch (e) {
    handleError(res, e, 'Error retrieving medications');
  }
};

const getMedicationById = async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.id;
    const medication = await prisma.medication.findUnique({
      where: { id: id },
      include: { healthCondition: { where: { userId: userId }}},
    });
    if (!medication) {
      return res.status(404).json({ error: 'Medication not found' });
    }
    res.json({ medication });
  } catch (e) {
    handleError(res, e, 'Error retrieving medication');
  }
};

const updateMedicationById = async (req, res) => {
  try {
    const { id } = req.params;
    const { name, frequency, dosage, startDate } = req.body;
    const updatedMedication = await prisma.medication.update({
      where: { id: id },
      include: { healthCondition: { where: { userId: userId }}},
      data: {
        name,
        frequency,
        dosage,
        startDate: startDate || null, 
      },
    });
    res.json({ medication: updatedMedication });
  } catch (e) {
    handleError(res, e, 'Error creating medication');
  }
};

const deleteMedicationById = async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.id;
    await prisma.medication.delete({
      where: { id: id },
      include: { healthCondition: { where: { userId: userId }}},
    });
    res.json({ message: 'Medication deleted successfully' });
  } catch (e) {
    handleError(res, e, 'Error deleting medication');
  }
};

module.exports = {
  createMedication,
  getAllMedications,
  getMedicationById,
  updateMedicationById,
  deleteMedicationById,
};