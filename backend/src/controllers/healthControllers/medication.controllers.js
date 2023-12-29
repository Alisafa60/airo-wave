const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

const createOrFindMedication = async ({name, frequency, dosage, startDate }) => {

    const existingMedication = await prisma.medication.findFirst({
      where: { name },
    });
  
    if (existingMedication) {
      return existingMedication;
    }
  
    // If the medication doesn't exist, create a new one
    const newMedication = await prisma.medication.create({
      data: {
        name,
        frequency: frequency || null,
        dosage: dosage || null,
        startDate: startDate || null,
      },
    });
  
    return newMedication;
};

const createMedication = async (req, res) => {
  try {
    const { name, frequency, dosage, startDate } = req.body;

    const newMedication = await prisma.medication.create({
      data: {
        name,
        frequency,
        dosage,
        startDate: startDate || null, 
      },
    });

    res.status(201).json({ medication: newMedication });
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
  createOrFindMedication,
  createMedication,
  getAllMedications,
  getMedicationById,
  updateMedicationById,
  deleteMedicationById,
};