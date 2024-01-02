/*
  Warnings:

  - You are about to drop the column `userTypeId` on the `HealthProfessional` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "HealthProfessional" DROP CONSTRAINT "HealthProfessional_userTypeId_fkey";

-- AlterTable
ALTER TABLE "HealthProfessional" DROP COLUMN "userTypeId";
