const { PrismaClient } = require("@prisma/client");
const { handleError } = require("../../helpers");
const prisma = new PrismaClient();

const createHeartRateData = async (req, res) => {
    try {
        const { restingHr, maxHr, averageHr } = req.body;
        const userId = req.user.id;
        
        const userDevice = await prisma.device.findFirst({
            where: { userId: userId },
        });
      
        if (!userDevice) {
        return res.status(404).json({ error: 'User device not found' });
        }

        const healthData = await prisma.enviromentalHealthData.findFirst({
            where: { userId:userId},
            orderBy: {createdAt: 'desc'}
        });

        const heartRateData = await prisma.heartRateData.create({
        data: {
            restingHr,
            maxHr,
            averageHr,
            enviromentalHealthDataId: healthData.id,
            deviceId: userDevice.id
        },
        });

        res.status(201).json(heartRateData);
    } catch (e) {
        handleError(res, e, 'Error creating heart rate data');
    }
};

const getLastHeartRateData = async (req, res) => {
    try {
        const userId = req.user.id;
        
        const userDevice = await prisma.device.findFirst({
            where: { userId: userId },
        });
      
        if (!userDevice) {
        return res.status(404).json({ error: 'User device not found' });
        }

        const lastHeartRateData = await prisma.heartRateData.findFirst({
            where: {deviceId: userDevice.id},
            orderBy: { createdAt: 'desc' },
        });
    
        if (!lastHeartRateData) {
            return res.status(404).json({ error: 'No heart rate data found' });
        }
    
        res.status(200).json(lastHeartRateData);
        } catch (e) {
        handleError(res, e, 'Error retrieving last heart rate data');
        }
};

const getHeartRateDataById = async (req, res) => {
    try {
        const heartRateDataId = parseInt(req.params.id);
        const userId = req.user.id;
        
        const userDevice = await prisma.device.findFirst({
            where: { userId: userId },
        });
      
        if (!userDevice) {
        return res.status(404).json({ error: 'User device not found' });
        }

        const heartRateData = await prisma.heartRateData.findUnique({
        where: { id: heartRateDataId, deviceId: userDevice.id },
        });

        if (!heartRateData) {
        return res.status(404).json({ error: 'Heart rate data not found' });
        }

        res.status(200).json(heartRateData);
    } catch (e) {
        handleError(res, e, 'Error retrieving heart rate data by ID');
    }
};

module.exports = {
  createHeartRateData,
  getLastHeartRateData,
  getHeartRateDataById,
};
