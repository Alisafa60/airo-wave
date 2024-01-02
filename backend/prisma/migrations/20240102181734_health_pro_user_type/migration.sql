/*
  Warnings:

  - Changed the type of `feedbackType` on the `Feedback` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Added the required column `userTypeId` to the `HealthProfessional` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "FeedbackType" AS ENUM ('POSITIVE', 'NEUTRAL', 'NEGATIVE');

-- AlterTable
ALTER TABLE "Feedback" DROP COLUMN "feedbackType",
ADD COLUMN     "feedbackType" "FeedbackType" NOT NULL;

-- AlterTable
ALTER TABLE "HealthProfessional" ADD COLUMN     "userTypeId" INTEGER NOT NULL;

-- AddForeignKey
ALTER TABLE "HealthProfessional" ADD CONSTRAINT "HealthProfessional_userTypeId_fkey" FOREIGN KEY ("userTypeId") REFERENCES "UserType"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
