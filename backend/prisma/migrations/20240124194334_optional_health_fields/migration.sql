-- AlterTable
ALTER TABLE "Allergy" ALTER COLUMN "severity" DROP NOT NULL,
ALTER COLUMN "duration" DROP NOT NULL,
ALTER COLUMN "triggers" DROP NOT NULL;

-- AlterTable
ALTER TABLE "Medication" ALTER COLUMN "frequency" DROP NOT NULL,
ALTER COLUMN "dosage" DROP NOT NULL;

-- AlterTable
ALTER TABLE "RespiratoryCondition" ALTER COLUMN "diangnosis" DROP NOT NULL,
ALTER COLUMN "symptomsFrequency" DROP NOT NULL,
ALTER COLUMN "triggers" DROP NOT NULL;
