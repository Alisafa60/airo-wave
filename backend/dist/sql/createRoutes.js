"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient().$extends({
    model: {
        route: {
            create(data) {
                return __awaiter(this, void 0, void 0, function* () {
                    // Create an object using the custom types from above
                    const route = {
                        coordinates: data.coordinates,
                        userId: data.userId,
                    };
                    // Convert the custom LineString to a LINESTRING string
                    const lineString = `LINESTRING(${route.coordinates
                        .map(point => `${point.longitude} ${point.latitude}`)
                        .join(', ')})`;
                    // Insert the object into the database
                    yield prisma.$queryRaw `
          INSERT INTO "Route" (geometry, "userId") VALUES (ST_GeomFromText(${lineString}, 4326), ${route.userId});
        `;
                    return route;
                });
            },
            findDistance(routeId) {
                var _a, _b;
                return __awaiter(this, void 0, void 0, function* () {
                    const result = yield prisma.$queryRaw `SELECT ST_Length(geometry::geography) as distance FROM "Route" WHERE id = ${routeId}`;
                    return (_b = (_a = result === null || result === void 0 ? void 0 : result[0]) === null || _a === void 0 ? void 0 : _a.distance) !== null && _b !== void 0 ? _b : null;
                });
            },
        },
    },
});
module.exports = prisma;
