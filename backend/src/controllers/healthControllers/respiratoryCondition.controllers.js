const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();
const {handleError} = require('../../helpers');

const addRespiratoryCondition = async (req, res) => {
    try {
        const { condition, diagnosis, symptomsFrequency, triggers } = req.body;
        const userId = req.user.id;
        const userHealth = await prisma.healthCondition.findUnique({
            where: { userId: userId },
        });

        if (!userHealth || !userHealth.id) {
            return res.status(400).json({ error: 'User health information not found.' });
          }
      
        const userHealthId = userHealth.id;

        const newRespiratoryCondition = await prisma.respiratoryCondition.create({
            data: {
                condition,
                diagnosis,
                symptomsFrequency,
                triggers,
            },
        });

        const updatedUserHealth = await prisma.healthCondition.update({
            where: { id: userHealthId },
            data: {
              respiratoryCondition: { connect: { id: newRespiratoryCondition.id } },
            },
          });

        res.status(201).json({ respiratoryCondition: newRespiratoryCondition, updatedUserHealth});
    } catch (e) {
        handleError(res, e, 'Error adding respiratory condition');
    }
};

const getAllRespiratoryConditions = async(req, res) => {
    try{
        const userId = req.user.id;
        const respiratoryConditions = await prisma.respiratoryCondition.findMany({
            where: { healthConditon: { userId : userId }}
        });

        res.json({respiratoryConditions})
    } catch (e) {
        handleError(res, e, 'Error retrieving respiratory conditons ')
    }
}

const getRespiratoryConditionById = async(req, res) => {
    try{
        const {id} = req.params;
        const userId = req.user.id;
        const respiratoryCondition = await prisma.respiratoryCondition.findUnique({
            where: { id: id },
            include: { healthCondition: { where: { userId: userId }}},
        });

        if (!respiratoryCondition){
            return res.status(404).json({error: 'Respiratory condition not found'});
        }

        res.json({ respiratoryCondition });
    } catch(e){
        handleError(res, e, 'Error getting respiratory condition');
    }
}

const updateRespiratoryConditionById = async (req, res) => {
    try {
        const { id } = req.params;
        const userId = req.user.id;
        const { condition, diagnosis, symptomsFrequency, triggers } = req.body;
        const updatedRespiratoryCondition = await prisma.respiratoryCondition.update({
            where: { id: id },
            include: { healthCondition: { where: { userId: userId }}},
            data: {
                condition,
                diagnosis,
                symptomsFrequency,
                triggers,
            },
        });

        res.json({ respiratoryCondition: updatedRespiratoryCondition });
    } catch (e) {
        handleError(res, e, 'Error updating respiratory condition by ID');
    }
};

const deleteRespiratoryConditionById = async (req, res) => {
    try {
        const { id } = req.params;
        const userId = req.user.id;
        await prisma.respiratoryCondition.delete({
            where: { id: id },
            include: { healthCondition: { where: { userId: userId }}},
        });
        
        res.json({ message: 'Respiratory condition deleted successfully' });
    } catch (e) {
        handleError(res, e, 'Error deleting respiratory condition by ID');
    }
};

module.exports = {
    addRespiratoryCondition,
    getAllRespiratoryConditions,
    getRespiratoryConditionById,
    updateRespiratoryConditionById,
    deleteRespiratoryConditionById,
};