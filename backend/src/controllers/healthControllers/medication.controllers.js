const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
const { handleError } = require('../../helpers');

const createMedication = async (req, res) => {

  try {
      const { name, frequency, dosage, startDate, context, allergen, respiratoryCondition } = req.body;
      const userId = req.user.id;
      // Find the user's health condition
      const userHealth = await prisma.healthCondition.findUnique({
        where: { userId: userId },
      });

      if (!userHealth || !userHealth.id) {
        return res.status(400).json({ error: 'User health information not found.' });
      }
      // Check if the medication already exists
      const existingMedication = await prisma.medication.findFirst({
        where: {
          name,
          frequency,
          dosage,
        },
      });

      if (existingMedication) {
        return res.status(400).json({ error: 'Medication already exists.' });
      }

      const newMedicationData = {
        name,
        frequency,
        dosage,
        startDate: startDate || null,
        healthCondition: { connect: { id: userHealth.id } },
      };
      //provide context in case the user has allergy or respiratory condition
      if (context === 'allergy') {
        if (allergen) {
          const existingAllergy = await prisma.allergy.findFirst({
            where: { allergen, healthConditionId: userHealth.id },
          });

          if (existingAllergy) {
            newMedicationData.allergy = { connect: { id: existingAllergy.id } };
          }
        } else {
          const existingAllergy = await prisma.allergy.findFirst({
            where: { healthConditionId: userHealth.id },
          });

          if (existingAllergy) {
            newMedicationData.allergy = { connect: { id: existingAllergy.id } };
          }
        }
      } else if (context === 'respiratoryCondition') {
        if (respiratoryCondition) {
          const existingRespiratoryCondition = await prisma.respiratoryCondition.findFirst({
            where: { condition: respiratoryCondition, healthConditionId: userHealth.id },
          });

          if (existingRespiratoryCondition) {
            newMedicationData.respiratoryCondition = { connect: { id: existingRespiratoryCondition.id } };
          }
        } else {
          const existingRespiratoryCondition = await prisma.respiratoryCondition.findFirst({
            where: { healthConditionId: userHealth.id },
          });

          if (existingRespiratoryCondition) {
            newMedicationData.respiratoryCondition = { connect: { id: existingRespiratoryCondition.id } };
          }
        }
      }

      const newMedication = await prisma.medication.create({
        data: newMedicationData,
      });

      res.status(201).json({ medication: newMedication });
    } catch (e) {
      handleError(res, e, 'Error creating medication');
    }
};

const getAllMedications = async (req, res) => {
  try {
      const userId = req.user.id;
      const medications = await prisma.medication.findMany({
        where: { healthCondition: { userId: userId } },
      });

      res.json({ medications });
    } catch (e) {
      handleError(res, e, 'Error fetching medications');
    }
};

const getMedicationById = async (req, res) => {
  try {
      const userId = req.user.id;
      const medicationId = req.params.id;

      const medication = await prisma.medication.findUnique({
        where: {
          id: parseInt(medicationId),
          healthCondition: {
            userId: userId,
          },
        },
      });

      if (!medication) {
        return res.status(404).json({ error: 'Medication not found for the logged-in user.' });
      }

      res.json({ medication });
    } catch (e) {
      handleError(res, e, 'Error fetching medication by ID');
    }
};

const updateMedicationById = async (req, res) => {
  try {
      const userId = req.user.id;
      const medicationId = req.params.id;
      const { name, frequency, dosage, startDate } = req.body;

      const existingMedication = await prisma.medication.findUnique({
        where: {
          id: parseInt(medicationId),
          healthCondition: {
            userId: userId,
          },
        },
      });

      if (!existingMedication) {
        return res.status(404).json({ error: 'Medication not found for the logged-in user.' });
      }

      const updatedMedication = await prisma.medication.update({
        where: {
          id: parseInt(medicationId),
        },
        data: {
          name: name || existingMedication.name,
          frequency: frequency || existingMedication.frequency,
          dosage: dosage || existingMedication.dosage,
          startDate: startDate || null,
        },
      });

      res.json({ updatedMedication });
    } catch (e) {
      handleError(res, e, 'Error updating medication');
    }
};

const updateMedicationByName = async (req, res) => {
  try {
    const userId = req.user.id;
    const { name, frequency, dosage, startDate } = req.body;

    const healthCondition = await prisma.healthCondition.findUnique({
      where: {
        userId: userId,
      }
    });

    let existingMedication = await prisma.medication.findFirst({
      where: {
        name: name,
        healthConditionId: healthCondition.id,
      },
    });

    if (!existingMedication) {
      // If the medication doesn't exist, create a new one
      existingMedication = await prisma.medication.create({
        data: {
          name: name,
          frequency: frequency, 
          dosage: dosage, 
          startDate: startDate, 
          healthConditionId: healthCondition.id,
        },
      });
    } else {
      // If the medication exists, update it
      existingMedication = await prisma.medication.update({
        where: {
          id: existingMedication.id,
        },
        data: {
          frequency: frequency || existingMedication.frequency,
          dosage: dosage || existingMedication.dosage,
          startDate: startDate || existingMedication.startDate || null,
        },
      });
    }

    res.json({ updatedMedication: existingMedication });
  } catch (e) {
    handleError(res, e, 'Error updating medication');
  }
};

const deleteMedicationById = async (req, res) => {
  try {
      const userId = req.user.id;
      const medicationId = req.params.id;

      const existingMedication = await prisma.medication.findUnique({
        where: {
          id: parseInt(medicationId),
          healthCondition: {
            userId: userId,
          },
        },
      });

      if (!existingMedication) {
        return res.status(404).json({ error: 'Medication not found for the logged-in user.' });
      }

      await prisma.medication.delete({
        where: {
          id: parseInt(medicationId),
        },
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
  updateMedicationByName,
};