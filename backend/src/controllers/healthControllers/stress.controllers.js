const { PrismaClient } = require("@prisma/client");
const { handleError } = require("../../helpers");
const prisma = new PrismaClient();

const createStressData = async (req, res) => {
  try {
        const { stressLevel, dailyHealthId, userLocationId } = req.body;
        const userId = req.user.id;
        
        const userDevice = await prisma.device.findFirst({
            where: { userId: userId },
        });
      
        if (!userDevice) {
        return res.status(404).json({ error: 'User device not found' });
        }

        const userLocation = await prisma.userLocation.findFirst({
            where: { userId: userId }
        });

        const userHealth = await prisma.healthCondition.findFirst({
            where: { userId: userId}
        });

        const dailyHealth = await prisma.dailyHealth.findFirst({
            where: { userHealthId: userHealth.id }
        })

        const stressData = await prisma.stressData.create({
        data: {
            stressLevel,
            dailyHealthId: dailyHealth.id,
            userLocationId: userLocation.id,
            deviceId: userDevice.id,
        },
        });

        res.status(201).json(stressData);
    } catch (e) {
        handleError(res, e, 'Error creating stress data');
    }
};

const getStressDataById = async (req, res) => {
  try {
        const stressDataId = parseInt(req.params.id);
        const userId = req.user.id;
        
        const userDevice = await prisma.device.findFirst({
            where: { userId: userId },
        });
      
        if (!userDevice) {
        return res.status(404).json({ error: 'User device not found' });
        }

        const stressData = await prisma.stressData.findUnique({
        where: { id: stressDataId },
        });

        if (!stressData) {
        return res.status(404).json({ error: 'Stress data not found' });
        }

        res.status(200).json(stressData);
    } catch (e) {
        handleError(res, e, 'Error retrieving stress data by ID');
    }
};

const getLastStressData = async (req, res) => {
  try {
        const userId = req.user.id;

        const userDevice = await prisma.device.findFirst({
            where: { userId: userId },
        });
      
        if (!userDevice) {
        return res.status(404).json({ error: 'User device not found' });
        }

        const lastStressData = await prisma.stressData.findFirst({
        where: { deviceId: userDevice.id },
        orderBy: { createdAt: 'desc' },
        });

        if (!lastStressData) {
        return res.status(404).json({ error: 'No stress data found for the user' });
        }

        res.status(200).json(lastStressData);
    } catch (e) {
        handleError(res, e, 'Error retrieving last stress data');
    }
};

module.exports = {
  createStressData,
  getStressDataById,
  getLastStressData,
};
