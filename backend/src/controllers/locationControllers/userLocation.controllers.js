const { PrismaClient } = require("@prisma/client");
const { handleError } = require('../../helpers');
const prisma = require('../../../dist/sql/userLocation');
const prisma1 = new PrismaClient({
  log: ['query', 'info', 'warn'], 
});
const wkx = require('wkx');

const createUserLocation = async (req, res) => {
  try {
    const userId = req.user.id;
    const { location, deviceId } = req.body;
    const newUserLocation = await prisma.userLocation.create({
      userId,
      location: { longitude: location.longitude, latitude: location.latitude },
      deviceId,
    });
    res.status(201).json({ userLocation: newUserLocation });
    
  } catch (e) {
    handleError(res, e, 'Error creating UserLocation');
  }
};

const getUserLocationById = async (req, res) => {
  try {
    const { id } = req.params;
    userId = req.user.id;
    const userLocation = await prisma1.userLocation.findUnique({
      where: { id: parseInt(id), userId: userId },
    });
    const location = await prisma1.$queryRaw`
    SELECT location::text
    FROM "UserLocation"
    WHERE id = ${parseInt(id)};
  `;
    if (!userLocation) {
      return res.status(404).json({ error: 'UserLocation not found' });
    }
    const wktString = location[0].location;
    const geometry = wkx.Geometry.parse(Buffer.from(wktString, 'hex'));
    const point = geometry.toWkt();
    res.status(200).json({ userLocation, point });
  } catch (e) {
    handleError(res, e, 'Error retrieving UserLocation');
  }
};

const getUserLastLocation = async (req, res) => {
  try {
    const userId = req.user.id;
    const lastUserLocation = await prisma.userLocation.findFirst({
      where: { userId },
      orderBy: { createdAt: 'desc' },
    });

    const location = await prisma1.$queryRaw`
    SELECT location::text
    FROM "UserLocation"
    WHERE "userId" = ${parseInt(userId)}
    ORDER BY "createdAt" Desc
  `;

    const wktString = location[0].location;
    const geometry = wkx.Geometry.parse(Buffer.from(wktString, 'hex'));
    const point = geometry.toWkt();

    if (!lastUserLocation) {
      return res.status(404).json({ error: 'UserLocation not found' });
    }

    res.status(200).json({ userLocation: lastUserLocation, point});
  } catch (e) {
    handleError(res, e, 'Error retrieving last UserLocation');
  }
};

const getUserLocationsByTimeRange = async (req, res) => {
  try {
    const userId = req.user.id;
    const { startTime, endTime } = req.query;

    const userLocations = await prisma.userLocation.findMany({
      where: {
        userId,
        createdAt: {
          gte: new Date(startTime),
          lte: new Date(endTime),
        },
      },
      orderBy: { createdAt: 'asc' },
    });

    res.status(200).json({ userLocations });
  } catch (e) {
    handleError(res, e, 'Error retrieving UserLocations by time range');
  }
};

const getUserLocationsWithPagination = async (req, res) => {
  try {
    const userId = req.user.id;
    const { page = 1, pageSize = 10 } = req.query;

    const userLocations = await prisma.userLocation.findMany({
      where: { userId },        
      orderBy: { createdAt: 'asc' }, 
      skip: (page - 1) * pageSize,    
      take: parseInt(pageSize),       
    });

    res.status(200).json({ userLocations });
  } catch (e) {
 
    handleError(res, e, 'Error retrieving paginated UserLocations');
  }
};


// const updateUserLocationById = async (req, res) => {
//   try {
//     const { id } = req.params;
//     userId = req.user.id;
//     const { location, deviceId } = req.body;
//     const updatedUserLocation = await prisma.userLocation.update({
//       where: { id: parseInt(id), userId: userId },
//       data: {
//         location: { longitude: location.longitude, latitude: location.latitude },
//         deviceId,
//       },
//     });
//     res.status(200).json({ userLocation: updatedUserLocation });
//   } catch (e) {
//     handleError(res, e, 'Error updating UserLocation');
//   }
// };

// const deleteUserLocationById = async (req, res) => {
//   const { id } = req.params;
//   try {
//     const deletedUserLocation = await prisma.userLocation.delete({
//       where: { id: parseInt(id) },
//     });
//     res.status(200).json({ userLocation: deletedUserLocation });
//   } catch (e) {
//     handleError(res, e, 'Error deleting UserLocation');
//   }
// };

module.exports = {
  createUserLocation,
  getUserLocationById,
  getUserLastLocation,
  getUserLocationsByTimeRange,
  getUserLocationsWithPagination,
  // updateUserLocationById,
  // deleteUserLocationById,
};