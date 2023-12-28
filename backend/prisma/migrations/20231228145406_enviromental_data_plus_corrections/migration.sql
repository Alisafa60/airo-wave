/*
  Warnings:

  - You are about to drop the column `heartRate` on the `Device` table. All the data in the column will be lost.
  - You are about to drop the column `pollenLevel` on the `Device` table. All the data in the column will be lost.
  - You are about to drop the column `powerData` on the `Device` table. All the data in the column will be lost.
  - You are about to drop the column `sleepDuration` on the `Device` table. All the data in the column will be lost.
  - You are about to drop the column `sleepQuality` on the `Device` table. All the data in the column will be lost.
  - You are about to drop the column `stressLevel` on the `Device` table. All the data in the column will be lost.
  - The `temperature` column on the `Device` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `humidity` column on the `Device` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `co2Level` column on the `Device` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `vocLevel` column on the `Device` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - Added the required column `userId` to the `Device` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Device" DROP COLUMN "heartRate",
DROP COLUMN "pollenLevel",
DROP COLUMN "powerData",
DROP COLUMN "sleepDuration",
DROP COLUMN "sleepQuality",
DROP COLUMN "stressLevel",
ADD COLUMN     "userId" INTEGER NOT NULL,
DROP COLUMN "temperature",
ADD COLUMN     "temperature" INTEGER,
DROP COLUMN "humidity",
ADD COLUMN     "humidity" DOUBLE PRECISION,
DROP COLUMN "co2Level",
ADD COLUMN     "co2Level" DOUBLE PRECISION,
DROP COLUMN "vocLevel",
ADD COLUMN     "vocLevel" DOUBLE PRECISION;

-- CreateTable
CREATE TABLE "HeartRateData" (
    "id" SERIAL NOT NULL,
    "restingHr" INTEGER NOT NULL,
    "maxHr" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deviceId" INTEGER NOT NULL,

    CONSTRAINT "HeartRateData_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PowerData" (
    "id" SERIAL NOT NULL,
    "power" INTEGER NOT NULL,
    "maxPower" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deviceId" INTEGER NOT NULL,

    CONSTRAINT "PowerData_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EnviromentalData" (
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

    CONSTRAINT "EnviromentalData_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Device" ADD CONSTRAINT "Device_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HeartRateData" ADD CONSTRAINT "HeartRateData_deviceId_fkey" FOREIGN KEY ("deviceId") REFERENCES "Device"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PowerData" ADD CONSTRAINT "PowerData_deviceId_fkey" FOREIGN KEY ("deviceId") REFERENCES "Device"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EnviromentalData" ADD CONSTRAINT "EnviromentalData_deviceId_fkey" FOREIGN KEY ("deviceId") REFERENCES "Device"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EnviromentalData" ADD CONSTRAINT "EnviromentalData_userLocationId_fkey" FOREIGN KEY ("userLocationId") REFERENCES "UserLocation"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EnviromentalData" ADD CONSTRAINT "EnviromentalData_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
