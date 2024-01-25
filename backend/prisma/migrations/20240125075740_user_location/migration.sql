-- DropForeignKey
ALTER TABLE "UserLocation" DROP CONSTRAINT "UserLocation_deviceId_fkey";

-- AlterTable
ALTER TABLE "UserLocation" ALTER COLUMN "deviceId" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "UserLocation" ADD CONSTRAINT "UserLocation_deviceId_fkey" FOREIGN KEY ("deviceId") REFERENCES "Device"("id") ON DELETE SET NULL ON UPDATE CASCADE;
