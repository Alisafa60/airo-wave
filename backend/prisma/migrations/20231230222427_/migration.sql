/*
  Warnings:

  - You are about to drop the column `bloodO2Level` on the `Device` table. All the data in the column will be lost.
  - You are about to drop the column `co2Level` on the `Device` table. All the data in the column will be lost.
  - You are about to drop the column `humidity` on the `Device` table. All the data in the column will be lost.
  - You are about to drop the column `pm10` on the `Device` table. All the data in the column will be lost.
  - You are about to drop the column `pm1_0` on the `Device` table. All the data in the column will be lost.
  - You are about to drop the column `pm2_5` on the `Device` table. All the data in the column will be lost.
  - You are about to drop the column `temperature` on the `Device` table. All the data in the column will be lost.
  - You are about to drop the column `vocLevel` on the `Device` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Device" DROP COLUMN "bloodO2Level",
DROP COLUMN "co2Level",
DROP COLUMN "humidity",
DROP COLUMN "pm10",
DROP COLUMN "pm1_0",
DROP COLUMN "pm2_5",
DROP COLUMN "temperature",
DROP COLUMN "vocLevel";

-- AlterTable
ALTER TABLE "EnviromentalHealthData" ADD COLUMN     "bloodO2Level" TEXT,
ALTER COLUMN "temperature" DROP NOT NULL,
ALTER COLUMN "humidity" DROP NOT NULL,
ALTER COLUMN "aqi" DROP NOT NULL,
ALTER COLUMN "treePollen" DROP NOT NULL,
ALTER COLUMN "grassPollen" DROP NOT NULL,
ALTER COLUMN "weedPollen" DROP NOT NULL,
ALTER COLUMN "co2Level" DROP NOT NULL;
