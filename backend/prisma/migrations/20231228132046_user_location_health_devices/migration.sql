/*
  Warnings:

  - You are about to drop the `UserHealth` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `deviceId` to the `UserLocation` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "UserHealth" DROP CONSTRAINT "UserHealth_allergyId_fkey";

-- DropForeignKey
ALTER TABLE "UserHealth" DROP CONSTRAINT "UserHealth_respiratoryConditionId_fkey";

-- DropForeignKey
ALTER TABLE "UserHealth" DROP CONSTRAINT "UserHealth_userId_fkey";

-- AlterTable
ALTER TABLE "UserLocation" ADD COLUMN     "deviceId" INTEGER NOT NULL;

-- DropTable
DROP TABLE "UserHealth";

-- CreateTable
CREATE TABLE "HealthCondition" (
    "id" SERIAL NOT NULL,
    "weight" INTEGER NOT NULL,
    "bloodType" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,
    "allergyId" INTEGER NOT NULL,
    "respiratoryConditionId" INTEGER NOT NULL,

    CONSTRAINT "HealthCondition_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Device" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "manufacturer" TEXT NOT NULL,
    "model" TEXT NOT NULL,
    "connectivityStatus" INTEGER NOT NULL,
    "batteryLevel" TEXT NOT NULL,
    "temperature" TEXT,
    "humidity" TEXT,
    "pollenLevel" TEXT,
    "co2Level" TEXT,
    "vocLevel" TEXT,
    "heartRate" TEXT,
    "powerData" TEXT,
    "bloodO2Level" TEXT,
    "sleepDuration" INTEGER,
    "sleepQuality" TEXT,
    "stressLevel" TEXT,
    "pm1_0" DOUBLE PRECISION,
    "pm2_5" DOUBLE PRECISION,
    "pm10" DOUBLE PRECISION,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Device_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SleepData" (
    "id" SERIAL NOT NULL,
    "duration" INTEGER NOT NULL,
    "quality" TEXT NOT NULL,
    "deviceId" INTEGER NOT NULL,
    "userLocationId" INTEGER NOT NULL,

    CONSTRAINT "SleepData_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StressData" (
    "id" SERIAL NOT NULL,
    "stressLevel" TEXT NOT NULL,
    "deviceId" INTEGER NOT NULL,
    "userLocationId" INTEGER NOT NULL,

    CONSTRAINT "StressData_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DailyHealth" (
    "id" SERIAL NOT NULL,
    "severity" INTEGER NOT NULL,
    "userHealthId" INTEGER NOT NULL,
    "sleepDataId" INTEGER NOT NULL,
    "stressDataId" INTEGER NOT NULL,

    CONSTRAINT "DailyHealth_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "HealthCondition_userId_key" ON "HealthCondition"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "DailyHealth_sleepDataId_key" ON "DailyHealth"("sleepDataId");

-- AddForeignKey
ALTER TABLE "HealthCondition" ADD CONSTRAINT "HealthCondition_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HealthCondition" ADD CONSTRAINT "HealthCondition_allergyId_fkey" FOREIGN KEY ("allergyId") REFERENCES "Allergy"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HealthCondition" ADD CONSTRAINT "HealthCondition_respiratoryConditionId_fkey" FOREIGN KEY ("respiratoryConditionId") REFERENCES "RespiratoryCondition"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SleepData" ADD CONSTRAINT "SleepData_deviceId_fkey" FOREIGN KEY ("deviceId") REFERENCES "Device"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SleepData" ADD CONSTRAINT "SleepData_userLocationId_fkey" FOREIGN KEY ("userLocationId") REFERENCES "UserLocation"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StressData" ADD CONSTRAINT "StressData_deviceId_fkey" FOREIGN KEY ("deviceId") REFERENCES "Device"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StressData" ADD CONSTRAINT "StressData_userLocationId_fkey" FOREIGN KEY ("userLocationId") REFERENCES "UserLocation"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DailyHealth" ADD CONSTRAINT "DailyHealth_userHealthId_fkey" FOREIGN KEY ("userHealthId") REFERENCES "HealthCondition"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DailyHealth" ADD CONSTRAINT "DailyHealth_sleepDataId_fkey" FOREIGN KEY ("sleepDataId") REFERENCES "SleepData"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DailyHealth" ADD CONSTRAINT "DailyHealth_stressDataId_fkey" FOREIGN KEY ("stressDataId") REFERENCES "StressData"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserLocation" ADD CONSTRAINT "UserLocation_deviceId_fkey" FOREIGN KEY ("deviceId") REFERENCES "Device"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
