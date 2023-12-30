const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

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

    // Assuming userId is available in the request, replace it with the actual way you retrieve userId
    const userId = req.user.id;

    // Connect the medication to the user's health condition (UserHealth)
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
    console.error('Error creating medication', e);
    res.status(500).json({ error: e.message });
  }
};

const getAllMedications = async (req, res) => {
  try {
    const medications = await prisma.medication.findMany();
    res.json({ medications });
  } catch (e) {
    console.error('Error creating medication', e);
    res.status(500).json({ error: e.message });
  }
};

const getMedicationById = async (req, res) => {
  const { id } = req.params;
  try {
    const medication = await prisma.medication.findUnique({
      where: { id: parseInt(id) },
    });
    if (!medication) {
      return res.status(404).json({ error: 'Medication not found' });
    }
    res.json({ medication });
  } catch (e) {
    console.error('Error creating medication', e);
    res.status(500).json({ error: e.message });
  }
};

const updateMedicationById = async (req, res) => {
  const { id } = req.params;
  const { name, frequency, dosage, startDate } = req.body;
  try {
    const updatedMedication = await prisma.medication.update({
      where: { id: parseInt(id) },
      data: {
        name,
        frequency,
        dosage,
        startDate: startDate || null, 
      },
    });
    res.json({ medication: updatedMedication });
  } catch (e) {
    console.error('Error creating medication', e);
    res.status(500).json({ error: e.message });
  }
};


const deleteMedicationById = async (req, res) => {
  const { id } = req.params;
  try {
    await prisma.medication.delete({
      where: { id: parseInt(id) },
    });
    res.json({ message: 'Medication deleted successfully' });
  } catch (e) {
    console.error('Error creating medication', e);
    res.status(500).json({ error: e.message });
  }
};

module.exports = {
  createMedication,
  getAllMedications,
  getMedicationById,
  updateMedicationById,
  deleteMedicationById,
};