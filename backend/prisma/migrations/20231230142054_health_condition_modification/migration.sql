-- AlterTable
ALTER TABLE "HealthCondition" ADD COLUMN     "medicationId" INTEGER;

-- AddForeignKey
ALTER TABLE "HealthCondition" ADD CONSTRAINT "HealthCondition_medicationId_fkey" FOREIGN KEY ("medicationId") REFERENCES "Medication"("id") ON DELETE SET NULL ON UPDATE CASCADE;
