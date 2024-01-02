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

        if (!allergen || !severity || !duration || !triggers) {
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

module.exports = {
    addRespiratoryCondition,
    getAllRespiratoryConditions,
    getRespiratoryConditionById,
    updateRespiratoryConditionById,
    deleteRespiratoryConditionById,
};