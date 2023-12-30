-- DropForeignKey
ALTER TABLE "HealthCondition" DROP CONSTRAINT "HealthCondition_allergyId_fkey";

-- DropForeignKey
ALTER TABLE "HealthCondition" DROP CONSTRAINT "HealthCondition_respiratoryConditionId_fkey";

-- AlterTable
ALTER TABLE "HealthCondition" ALTER COLUMN "allergyId" DROP NOT NULL,
ALTER COLUMN "respiratoryConditionId" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "HealthCondition" ADD CONSTRAINT "HealthCondition_allergyId_fkey" FOREIGN KEY ("allergyId") REFERENCES "Allergy"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HealthCondition" ADD CONSTRAINT "HealthCondition_respiratoryConditionId_fkey" FOREIGN KEY ("respiratoryConditionId") REFERENCES "RespiratoryCondition"("id") ON DELETE SET NULL ON UPDATE CASCADE;
