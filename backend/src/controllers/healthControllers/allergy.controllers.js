const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();
const medicationController = require('./medication.controllers');

const addAllergy = async (req, res) => {
    try {
        const userId = req.user.id;
        const { allergen, severity, duration, triggers, medicationFields } = req.body;

        let newMedication;
        // Check if medicationFields are provided
        if (medicationFields) {
            // Use the medication controller to create or find the medication
            newMedication = await medicationController.createOrFindMedication(medicationFields);
        }

        const newAllergy = await prisma.allergy.create({
            data: {
                allergen,
                severity,
                duration,
                triggers,
                medications: newMedication
                    ? { connect: { id: newMedication.id } }
                    : undefined, 
            },
        });

        res.status(201).json({ allergy: newAllergy });
    } catch (e) {
        console.error("Error adding allergy", e);
        res.status(500).json({ error: e.message });
    }
};

module.exports = { addAllergy };