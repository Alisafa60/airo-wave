const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
const { handleError } = require('../../helpers');

const createHealthProfessional = async (req, res) => {
    try {
        const { specialization, certifications, license } = req.body;
        const userId = req.user.id;
        const userType = req.user.userType;
    
        if (userType.type !== 'healthProfessional') {
            return res.status(500).json({ error: 'Not a health professional' });
        }
    
        const existingHealthProfessional = await prisma.healthProfessional.findFirst({
            where: {
            userId: userId,
            specialization: specialization,
            },
        });
    
        if (existingHealthProfessional) {
            return res.status(400).json({ error: 'Duplicate health professional specialization' });
        }
    
        const newHealthProfessional = await prisma.healthProfessional.create({
            data: {
            specialization,
            certifications,
            license,
            userId,
            },
        });
    
        res.status(201).json({ healthProfessional: newHealthProfessional });
    } catch (e) {
    handleError(res, e, 'Error creating HealthProfessional');
    }
};

const getHealthProfessionalById = async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.id;

    const healthProfessional = await prisma.healthProfessional.findUnique({
      where: { id: parseInt(id), userId: userId },
    });

    if (!healthProfessional) {
      return res.status(404).json({ error: 'HealthProfessional not found' });
    }

    res.status(200).json({ healthProfessional });
  } catch (e) {
    handleError(res, e, 'Error retrieving HealthProfessional');
  }
};

const updateHealthProfessionalById = async (req, res) => {
    try {
        const { id } = req.params;
        const userId = req.user.id;
        const { specialization, certifications, license } = req.body;
    
        const existingHealthProfessional = await prisma.healthProfessional.findUnique({
            where: { id: parseInt(id), userId: userId },
        });
    
        if (!existingHealthProfessional) {
            return res.status(404).json({ error: 'HealthProfessional not found' });
        }
    
        const updatedHealthProfessional = await prisma.healthProfessional.update({
            where: { id: parseInt(id) },
            data: {
            specialization: specialization || existingHealthProfessional.specialization,
            certifications: certifications || existingHealthProfessional.certifications,
            license: license || existingHealthProfessional.license,
            },
        });
    
        res.status(200).json({ healthProfessional: updatedHealthProfessional });
    } catch (e) {
        handleError(res, e, 'Error updating HealthProfessional by ID');
    }
};
module.exports = {
  createHealthProfessional,
  getHealthProfessionalById,
  updateHealthProfessionalById,
};
