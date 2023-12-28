/*
  Warnings:

  - You are about to drop the `EnviromentalData` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "EnviromentalData" DROP CONSTRAINT "EnviromentalData_deviceId_fkey";

-- DropForeignKey
ALTER TABLE "EnviromentalData" DROP CONSTRAINT "EnviromentalData_userId_fkey";

-- DropForeignKey
ALTER TABLE "EnviromentalData" DROP CONSTRAINT "EnviromentalData_userLocationId_fkey";

-- DropTable
DROP TABLE "EnviromentalData";

-- CreateTable
CREATE TABLE "EnviromentalHealthData" (
    "id" SERIAL NOT NULL,
    "temperature" DOUBLE PRECISION NOT NULL,
    "humidity" DOUBLE PRECISION NOT NULL,
    "aqi" DOUBLE PRECISION NOT NULL,
    "treePollen" DOUBLE PRECISION NOT NULL,
    "grassPollen" DOUBLE PRECISION NOT NULL,
    "weedPollen" DOUBLE PRECISION NOT NULL,
    "co2Level" DOUBLE PRECISION NOT NULL,
    "ozoneLevel" DOUBLE PRECISION,
    "coLevel" DOUBLE PRECISION,
    "vocLevel" DOUBLE PRECISION,
    "so2Level" DOUBLE PRECISION,
    "no2Level" DOUBLE PRECISION,
    "pm1_0" DOUBLE PRECISION,
    "pm2_5" DOUBLE PRECISION,
    "pm10" DOUBLE PRECISION,
    "windSpeed" DOUBLE PRECISION,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deviceId" INTEGER NOT NULL,
    "userLocationId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,

    CONSTRAINT "EnviromentalHealthData_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PushNotification" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "body" TEXT NOT NULL,
    "data" JSONB NOT NULL,
    "type" TEXT NOT NULL,
    "sentAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deliveredAt" TIMESTAMP(3),
    "readAt" TIMESTAMP(3),
    "userId" INTEGER NOT NULL,

    CONSTRAINT "PushNotification_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "EnviromentalHealthData" ADD CONSTRAINT "EnviromentalHealthData_deviceId_fkey" FOREIGN KEY ("deviceId") REFERENCES "Device"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EnviromentalHealthData" ADD CONSTRAINT "EnviromentalHealthData_userLocationId_fkey" FOREIGN KEY ("userLocationId") REFERENCES "UserLocation"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EnviromentalHealthData" ADD CONSTRAINT "EnviromentalHealthData_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PushNotification" ADD CONSTRAINT "PushNotification_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
