/*
  Warnings:

  - You are about to drop the column `deviceId` on the `EnviromentalHealthData` table. All the data in the column will be lost.
  - You are about to drop the column `userLocationId` on the `EnviromentalHealthData` table. All the data in the column will be lost.
  - Added the required column `location` to the `EnviromentalHealthData` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "EnviromentalHealthData" DROP CONSTRAINT "EnviromentalHealthData_deviceId_fkey";

-- DropForeignKey
ALTER TABLE "EnviromentalHealthData" DROP CONSTRAINT "EnviromentalHealthData_userLocationId_fkey";

-- AlterTable
ALTER TABLE "EnviromentalHealthData" DROP COLUMN "deviceId",
DROP COLUMN "userLocationId",
ADD COLUMN     "location" JSONB NOT NULL;
