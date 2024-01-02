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
        userLocation: {
            create(data) {
                return __awaiter(this, void 0, void 0, function* () {
                    // Create an object using the custom types from above
                    const userLocation = {
                        location: data.location,
                        userId: data.userId,
                        deviceId: data.deviceId,
                    };
                    // Convert the custom location to a POINT string
                    const point = `POINT(${userLocation.location.longitude} ${userLocation.location.latitude})`;
                    // Insert the object into the database
                    yield prisma.$queryRaw `
                    INSERT INTO "UserLocation" (location, "userId", "deviceId") VALUES (ST_GeomFromText(${point}, 4326), ${userLocation.userId}, ${userLocation.deviceId});
                    `;
                    // Return the object
                    return userLocation;
                });
            },
        },
    },
});
module.exports = prisma;
