/*
  Warnings:

  - You are about to drop the column `pm2_5` on the `EnviromentalHealthData` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "EnviromentalHealthData" DROP COLUMN "pm2_5",
ADD COLUMN     "dominantPollutant" TEXT,
ADD COLUMN     "pm25" DOUBLE PRECISION;
