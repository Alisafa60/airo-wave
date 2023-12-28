-- AlterEnum
ALTER TYPE "Type" ADD VALUE 'healthProfessional';

-- AlterTable
ALTER TABLE "Feedback" ADD COLUMN     "healthProId" INTEGER;

-- CreateTable
CREATE TABLE "HealthProfessional" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "specialization" TEXT NOT NULL,
    "certifications" TEXT[],

    CONSTRAINT "HealthProfessional_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ContactProfessional" (
    "id" SERIAL NOT NULL,
    "senderId" INTEGER NOT NULL,
    "recipientId" INTEGER NOT NULL,
    "content" TEXT NOT NULL,
    "sentAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "readAt" TIMESTAMP(3),
    "repliedAt" TIMESTAMP(3),
    "replyContent" TEXT,

    CONSTRAINT "ContactProfessional_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "MlPrediction" ADD CONSTRAINT "MlPrediction_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Feedback" ADD CONSTRAINT "Feedback_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Feedback" ADD CONSTRAINT "Feedback_healthProId_fkey" FOREIGN KEY ("healthProId") REFERENCES "HealthProfessional"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HealthProfessional" ADD CONSTRAINT "HealthProfessional_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ContactProfessional" ADD CONSTRAINT "ContactProfessional_senderId_fkey" FOREIGN KEY ("senderId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ContactProfessional" ADD CONSTRAINT "ContactProfessional_recipientId_fkey" FOREIGN KEY ("recipientId") REFERENCES "HealthProfessional"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
