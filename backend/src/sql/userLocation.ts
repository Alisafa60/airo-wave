const { PrismaClient } = require('@prisma/client')

type MyPoint = {
  latitude: number;
  longitude: number;
};

type MyUserLocation = {
  location: MyPoint;
  userId: number;
  deviceId: number;
};
// This script is compiled to js script (in backend/dist/sql) which is then used in user location controller
const prisma1 = new PrismaClient().$extends({
  model: {
    userLocation: {
      async create(data: MyUserLocation) {
        // Create an object using the custom types from above
        const userLocation: MyUserLocation = {
          location: data.location,
          userId: data.userId,
          deviceId: data.deviceId,
        };
        // Convert the custom location to a POINT string
        const point = `POINT(${userLocation.location.longitude} ${userLocation.location.latitude})`;
        // Insert the object into the database
        await prisma.$queryRaw`
          INSERT INTO "UserLocation" (location, userId, deviceId) VALUES (ST_GeomFromText(${point}, 4326), ${userLocation.userId}, ${userLocation.deviceId});
        `;
        return userLocation;
      },
    },
  },
});

module.exports = prisma1;
