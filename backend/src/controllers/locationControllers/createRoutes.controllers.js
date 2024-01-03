const { PrismaClient } = require("@prisma/client");
const { handleError } = require('../../helpers');
const prisma = require('../../../dist/sql/createRoutes');
const prisma1 = new PrismaClient({
  log: ['query', 'info', 'warn'], 
});

const createRoute = async (req, res) => {
  try {
    const userId = req.user.id;
    const { coordinates } = req.body;

    const newRoute = await prisma.route.create({
      userId,
      coordinates,
    });

    res.status(201).json({ route: newRoute });
  } catch (e) {
    handleError(res, e, 'Error creating Route');
  }
};

const findDistance = async (req, res) => {
    try {
      const routeId = parseInt(req.params.id);
      const distance = await prisma.route.findDistance(routeId);
  
      if (distance === null) {
        return res.status(404).json({ error: 'Route not found' });
      }

      const distanceKM = distance > 1000 ? distance/1000 : distance;

      res.status(200).json({ distanceKM });
    } catch (e) {
      handleError(res, e, 'Error finding distance of route');
    }
};
  
module.exports = {
  createRoute,
  findDistance,
};
