/*
  Warnings:

  - Added the required column `averageHr` to the `HeartRateData` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "HeartRateData" ADD COLUMN     "averageHr" INTEGER NOT NULL;
