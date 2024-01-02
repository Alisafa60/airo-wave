/*
  Warnings:

  - Added the required column `enviromentalHealthDataId` to the `HeartRateData` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "HeartRateData" ADD COLUMN     "enviromentalHealthDataId" INTEGER NOT NULL;

-- AddForeignKey
ALTER TABLE "HeartRateData" ADD CONSTRAINT "HeartRateData_enviromentalHealthDataId_fkey" FOREIGN KEY ("enviromentalHealthDataId") REFERENCES "EnviromentalHealthData"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
