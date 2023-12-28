-- CreateTable
CREATE TABLE "MlPrediction" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "predictedValue" TEXT NOT NULL,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "MlPrediction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Feedback" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "feedbackType" TEXT NOT NULL,
    "comments" TEXT,
    "predictionId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Feedback_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Feedback" ADD CONSTRAINT "Feedback_predictionId_fkey" FOREIGN KEY ("predictionId") REFERENCES "MlPrediction"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
