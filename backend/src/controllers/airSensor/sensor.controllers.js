const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

const storeSensorData = async (req, res) => {
  const { co2, voc } = req.body;

  const co2Value = parseInt(co2);
  const vocValue = parseInt(voc);

  if (isNaN(co2Value) || isNaN(vocValue)) {
    return res.status(400).json({ message: 'Invalid data format.' });
  }

  try {
    await prisma.sensorData.create({
      data: {
        co2: co2Value,
        voc: vocValue,
      },
    });

    res.status(201).json({ message: 'Data stored successfully.' });
  } catch (error) {
    console.error('Error storing data:', error, req.body);
    res.status(500).json({ message: 'Internal server error.' });
  }
};

const getLastSensorData = async (req, res) => {
  try {
    
    const lastSensorData = await prisma.sensorData.findFirst({
      orderBy: { createdAt: 'desc' },
    });

    if (!lastSensorData) {
      return res.status(404).json({ message: 'No sensor data found.' });
    }

    res.status(200).json({ lastSensorData });
  } catch (error) {
    console.error('Error getting last sensor data:', error);
    res.status(500).json({ message: 'Internal server error.' });
  }
};

module.exports = {
  storeSensorData,
  getLastSensorData,
};