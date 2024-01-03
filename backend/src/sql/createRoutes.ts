const { PrismaClient } = require('@prisma/client')

type MyPoint = {
  latitude: number;
  longitude: number;
};

type MyLineString = {
  coordinates: MyPoint[];
  userId: number;
};

type MyRoute = {
    id: number;
    geometry: Geolocation; 
    userId: number;
    createdAt: Date;
    updatedAt: Date | null;
  };

const prisma = new PrismaClient().$extends({
  model: {
    route: {
      async create(data: MyLineString) {
        // Create an object using the custom types from above
        const route: MyLineString = {
          coordinates: data.coordinates,
          userId: data.userId,
        };
        // Convert the custom LineString to a LINESTRING string
        const lineString = `LINESTRING(${route.coordinates
          .map(point => `${point.longitude} ${point.latitude}`)
          .join(', ')})`;
        // Insert the object into the database
        await prisma.$queryRaw`
          INSERT INTO "Route" (geometry, "userId") VALUES (ST_GeomFromText(${lineString}, 4326), ${route.userId});
        `;

        return route;
      },

      async findDistance(routeId: number): Promise<number | null> {
        const result = await prisma.$queryRaw`SELECT ST_Length(geometry::geography) as distance FROM "Route" WHERE id = ${routeId}`;
        return result?.[0]?.distance ?? null;
      },
    },
  },
});

module.exports = prisma;