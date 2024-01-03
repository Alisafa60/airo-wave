const Joi = require('joi');
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
const {handleError} = require('../../helpers');

//joi for validating data
const deviceSchema = Joi.object({
  name: Joi.string().required(),
  manufacturer: Joi.string().required(),
  model: Joi.string().required(),
  connectivityStatus: Joi.number().required(),
  batteryLevel: Joi.string().required(),
});

const createDevice = async (req, res) => {
  const { error } = deviceSchema.validate(req.body);
  if (error) {
    return res.status(400).json({ error: error.details[0].message });
  }

  try {
    const userId = req.user.id;
    const { name, manufacturer, model, connectivityStatus, batteryLevel } = req.body;

    const newDevice = await prisma.device.create({
      data: {
        name,
        manufacturer,
        model,
        connectivityStatus,
        batteryLevel,
        userId: {
          connect: {
            id: userId,
          },
        },
      },
    });

    res.status(201).json({ device: newDevice });
  } catch (e) {
    handleError(res, e, 'Error adding device');
  }
};

const getAllDevices = async(req, res) => {
    try{
        const userId = req.user.id;
        const getAllDevices = await prisma.device.findMany({
            where: { userId: userId }
        })
        res.json({ getAllDevices })
    }catch(e){
        handleError(res, e, 'Error retrieving devices');
    }
}

const getDeviceById = async (req, res) => {
  try {
    const id = req.params.id;
    const userId = req.user.id;

    const device = await prisma.device.findUnique({
      where: {
        id: parseInt(id),
        userId: userId,
      },
    });

    if (!device) {
      return res.status(404).json({ error: 'Device not found for the logged-in user.' });
    }

    res.json({ device });
  } catch (e) {
    handleError(res, e, 'Error fetching device by ID');
  }
};

const updateDevice = async (req, res) => {
  try {
    const id = req.params.id;
    const { name, manufacturer, model, connectivityStatus, batteryLevel } = req.body;
    const userId = req.user.id;

    const existingDevice = await prisma.device.findUnique({
      where: {
        id: parseInt(id),
        userId: userId,
      },
    });

    if (!existingDevice) {
      return res.status(404).json({ error: 'Device not found for the logged-in user.' });
    }

    const updatedDevice = await prisma.device.update({
      where: {
        id: parseInt(id),
      },
      data: {
        name,
        manufacturer,
        model,
        connectivityStatus,
        batteryLevel,
      },
    });

    res.json({ updatedDevice });
  } catch (e) {
    handleError(res, e, 'Error updating device');
  }
};

const deleteDevice = async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.id;

    const existingDevice = await prisma.device.findUnique({
      where: {
        id: parseInt(id),
        userId: userId,
      },
    });

    if (!existingDevice) {
      return res.status(404).json({ error: 'Device not found for the logged-in user.' });
    }

    await prisma.device.delete({
      where: {
        id: parseInt(id),
      },
    });

    res.json({ message: 'Device deleted successfully' });
  } catch (e) {
    handleError(res, e, 'Error deleting device');
  }
};

module.exports = {
  createDevice,
  getAllDevices,
  getDeviceById,
  updateDevice,
  deleteDevice,
};