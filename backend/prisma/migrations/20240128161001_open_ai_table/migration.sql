/*
  Warnings:

  - You are about to drop the `MlPrediction` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "Feedback" DROP CONSTRAINT "Feedback_predictionId_fkey";

-- DropForeignKey
ALTER TABLE "MlPrediction" DROP CONSTRAINT "MlPrediction_userId_fkey";

-- DropTable
DROP TABLE "MlPrediction";

-- CreateTable
CREATE TABLE "openAiResponse" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "response" TEXT NOT NULL,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "openAiResponse_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "openAiResponse" ADD CONSTRAINT "openAiResponse_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
