-- DropForeignKey
ALTER TABLE "Allergy" DROP CONSTRAINT "Allergy_medicationId_fkey";

-- DropForeignKey
ALTER TABLE "RespiratoryCondition" DROP CONSTRAINT "RespiratoryCondition_medicationId_fkey";

-- AlterTable
ALTER TABLE "Allergy" ALTER COLUMN "medicationId" DROP NOT NULL;

-- AlterTable
ALTER TABLE "Medication" ALTER COLUMN "startDate" DROP NOT NULL;

-- AlterTable
ALTER TABLE "RespiratoryCondition" ALTER COLUMN "medicationId" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "RespiratoryCondition" ADD CONSTRAINT "RespiratoryCondition_medicationId_fkey" FOREIGN KEY ("medicationId") REFERENCES "Medication"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Allergy" ADD CONSTRAINT "Allergy_medicationId_fkey" FOREIGN KEY ("medicationId") REFERENCES "Medication"("id") ON DELETE SET NULL ON UPDATE CASCADE;
