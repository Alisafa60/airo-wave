/*
  Warnings:

  - You are about to drop the column `diangnosis` on the `RespiratoryCondition` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "RespiratoryCondition" DROP COLUMN "diangnosis",
ADD COLUMN     "diagnosis" TEXT;
