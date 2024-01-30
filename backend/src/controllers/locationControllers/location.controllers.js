const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

const createLocation = async (req, res) => {
  const { location } = req.body;
  const userId = req.user.id;

  try {
    const newLocation = await prisma.location.create({
        data: {
            location: {
              longitude: location.longitude,
              latitude: location.latitude,
            },
            userId: userId,
          },
    });

    res.status(201).json(newLocation);
  } catch (error) {
    res.status(500).json({ error: 'Internal Server Error' });
  }
};

const getLastLocation = async (req, res) => {
  
  try {
    const userId = req.user.id; 
    const lastLocation = await prisma.location.findFirst({
    
      where: {
        userId:userId,
      },
      orderBy: {
        createdAt: 'desc',
      },
    });
    
    if (lastLocation) {
      res.json(lastLocation);
    } else {
      res.status(404).json({ error: 'Location not found for the user' });
    }
  } catch (error) {
    res.status(500).json({ error: 'Internal Server Error' });
   
  }
};

module.exports = {
    getLastLocation,
    createLocation
    };