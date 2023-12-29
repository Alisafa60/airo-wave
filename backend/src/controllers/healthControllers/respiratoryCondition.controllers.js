const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();
const medicationController = require('./medication.controllers');

const addRespiratoryCondition = async (req, res) => {
    try {
        const { condition, diagnosis, symptomsFrequency, triggers, medicationFields } = req.body;

        let newMedication;
        // Check if medicationFields are provided
        if (medicationFields) {
            // Use the medication controller to create or find the medication
            newMedication = await medicationController.createOrFindMedication(medicationFields);
        }

        const newRespiratoryCondition = await prisma.respiratoryCondition.create({
            data: {
                condition,
                diagnosis,
                symptomsFrequency,
                triggers,
                medications: newMedication
                    ? { connect: { id: newMedication.id } }
                    : undefined,
            },
        });

        res.status(201).json({ respiratoryCondition: newRespiratoryCondition });
    } catch (e) {
        console.error("Error adding respiratory condition", e);
        res.status(500).json({ error: e.message });
    }
};

module.exports = { addRespiratoryCondition };
