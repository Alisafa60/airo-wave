/*
  Warnings:

  - You are about to drop the column `medicationId` on the `Allergy` table. All the data in the column will be lost.
  - You are about to drop the column `sleepDataId` on the `DailyHealth` table. All the data in the column will be lost.
  - You are about to drop the column `stressDataId` on the `DailyHealth` table. All the data in the column will be lost.
  - You are about to drop the column `allergyId` on the `HealthCondition` table. All the data in the column will be lost.
  - You are about to drop the column `medicationId` on the `HealthCondition` table. All the data in the column will be lost.
  - You are about to drop the column `respiratoryConditionId` on the `HealthCondition` table. All the data in the column will be lost.
  - You are about to drop the column `medicationId` on the `RespiratoryCondition` table. All the data in the column will be lost.
  - Added the required column `healthConditionId` to the `Allergy` table without a default value. This is not possible if the table is not empty.
  - Added the required column `healthConditionId` to the `Medication` table without a default value. This is not possible if the table is not empty.
  - Added the required column `healthConditionId` to the `RespiratoryCondition` table without a default value. This is not possible if the table is not empty.
  - Added the required column `dailyHealthId` to the `SleepData` table without a default value. This is not possible if the table is not empty.
  - Added the required column `dailyHealthId` to the `StressData` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "Allergy" DROP CONSTRAINT "Allergy_medicationId_fkey";

-- DropForeignKey
ALTER TABLE "DailyHealth" DROP CONSTRAINT "DailyHealth_sleepDataId_fkey";

-- DropForeignKey
ALTER TABLE "DailyHealth" DROP CONSTRAINT "DailyHealth_stressDataId_fkey";

-- DropForeignKey
ALTER TABLE "HealthCondition" DROP CONSTRAINT "HealthCondition_allergyId_fkey";

-- DropForeignKey
ALTER TABLE "HealthCondition" DROP CONSTRAINT "HealthCondition_medicationId_fkey";

-- DropForeignKey
ALTER TABLE "HealthCondition" DROP CONSTRAINT "HealthCondition_respiratoryConditionId_fkey";

-- DropForeignKey
ALTER TABLE "RespiratoryCondition" DROP CONSTRAINT "RespiratoryCondition_medicationId_fkey";

-- DropIndex
DROP INDEX "DailyHealth_sleepDataId_key";

-- AlterTable
ALTER TABLE "Allergy" DROP COLUMN "medicationId",
ADD COLUMN     "healthConditionId" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "DailyHealth" DROP COLUMN "sleepDataId",
DROP COLUMN "stressDataId";

-- AlterTable
ALTER TABLE "HealthCondition" DROP COLUMN "allergyId",
DROP COLUMN "medicationId",
DROP COLUMN "respiratoryConditionId";

-- AlterTable
ALTER TABLE "Medication" ADD COLUMN     "allergyId" INTEGER,
ADD COLUMN     "healthConditionId" INTEGER NOT NULL,
ADD COLUMN     "respiratoryConditionId" INTEGER;

-- AlterTable
ALTER TABLE "RespiratoryCondition" DROP COLUMN "medicationId",
ADD COLUMN     "healthConditionId" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "SleepData" ADD COLUMN     "dailyHealthId" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "StressData" ADD COLUMN     "dailyHealthId" INTEGER NOT NULL;

-- AddForeignKey
ALTER TABLE "RespiratoryCondition" ADD CONSTRAINT "RespiratoryCondition_healthConditionId_fkey" FOREIGN KEY ("healthConditionId") REFERENCES "HealthCondition"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Allergy" ADD CONSTRAINT "Allergy_healthConditionId_fkey" FOREIGN KEY ("healthConditionId") REFERENCES "HealthCondition"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Medication" ADD CONSTRAINT "Medication_respiratoryConditionId_fkey" FOREIGN KEY ("respiratoryConditionId") REFERENCES "RespiratoryCondition"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Medication" ADD CONSTRAINT "Medication_allergyId_fkey" FOREIGN KEY ("allergyId") REFERENCES "Allergy"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Medication" ADD CONSTRAINT "Medication_healthConditionId_fkey" FOREIGN KEY ("healthConditionId") REFERENCES "HealthCondition"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SleepData" ADD CONSTRAINT "SleepData_dailyHealthId_fkey" FOREIGN KEY ("dailyHealthId") REFERENCES "DailyHealth"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StressData" ADD CONSTRAINT "StressData_dailyHealthId_fkey" FOREIGN KEY ("dailyHealthId") REFERENCES "DailyHealth"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
