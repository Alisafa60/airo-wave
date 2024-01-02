/*
  Warnings:

  - Added the required column `license` to the `HealthProfessional` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "HealthProfessional" ADD COLUMN     "license" TEXT NOT NULL;
