/*
  Warnings:

  - You are about to drop the `ConversationWithBot` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Device` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Feedback` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `HeartRateData` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Message` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `PowerData` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `PushNotification` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Response` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `SleepData` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `StressData` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `UserLocation` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "ConversationWithBot" DROP CONSTRAINT "ConversationWithBot_userId_fkey";

-- DropForeignKey
ALTER TABLE "Device" DROP CONSTRAINT "Device_userId_fkey";

-- DropForeignKey
ALTER TABLE "Feedback" DROP CONSTRAINT "Feedback_healthProId_fkey";

-- DropForeignKey
ALTER TABLE "Feedback" DROP CONSTRAINT "Feedback_userId_fkey";

-- DropForeignKey
ALTER TABLE "HeartRateData" DROP CONSTRAINT "HeartRateData_deviceId_fkey";

-- DropForeignKey
ALTER TABLE "HeartRateData" DROP CONSTRAINT "HeartRateData_enviromentalHealthDataId_fkey";

-- DropForeignKey
ALTER TABLE "Message" DROP CONSTRAINT "Message_conversationId_fkey";

-- DropForeignKey
ALTER TABLE "Message" DROP CONSTRAINT "Message_senderId_fkey";

-- DropForeignKey
ALTER TABLE "PowerData" DROP CONSTRAINT "PowerData_deviceId_fkey";

-- DropForeignKey
ALTER TABLE "PushNotification" DROP CONSTRAINT "PushNotification_userId_fkey";

-- DropForeignKey
ALTER TABLE "Response" DROP CONSTRAINT "Response_messageId_fkey";

-- DropForeignKey
ALTER TABLE "Response" DROP CONSTRAINT "Response_senderId_fkey";

-- DropForeignKey
ALTER TABLE "SleepData" DROP CONSTRAINT "SleepData_dailyHealthId_fkey";

-- DropForeignKey
ALTER TABLE "SleepData" DROP CONSTRAINT "SleepData_deviceId_fkey";

-- DropForeignKey
ALTER TABLE "SleepData" DROP CONSTRAINT "SleepData_userLocationId_fkey";

-- DropForeignKey
ALTER TABLE "StressData" DROP CONSTRAINT "StressData_dailyHealthId_fkey";

-- DropForeignKey
ALTER TABLE "StressData" DROP CONSTRAINT "StressData_deviceId_fkey";

-- DropForeignKey
ALTER TABLE "StressData" DROP CONSTRAINT "StressData_userLocationId_fkey";

-- DropForeignKey
ALTER TABLE "UserLocation" DROP CONSTRAINT "UserLocation_deviceId_fkey";

-- DropForeignKey
ALTER TABLE "UserLocation" DROP CONSTRAINT "UserLocation_userId_fkey";

-- DropTable
DROP TABLE "ConversationWithBot";

-- DropTable
DROP TABLE "Device";

-- DropTable
DROP TABLE "Feedback";

-- DropTable
DROP TABLE "HeartRateData";

-- DropTable
DROP TABLE "Message";

-- DropTable
DROP TABLE "PowerData";

-- DropTable
DROP TABLE "PushNotification";

-- DropTable
DROP TABLE "Response";

-- DropTable
DROP TABLE "SleepData";

-- DropTable
DROP TABLE "StressData";

-- DropTable
DROP TABLE "UserLocation";
