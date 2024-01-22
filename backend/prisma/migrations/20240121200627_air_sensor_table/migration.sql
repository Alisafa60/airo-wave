-- CreateTable
CREATE TABLE "SensorData" (
    "id" SERIAL NOT NULL,
    "co2" INTEGER NOT NULL,
    "voc" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "SensorData_pkey" PRIMARY KEY ("id")
);
