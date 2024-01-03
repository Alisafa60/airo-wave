/*
  Warnings:

  - You are about to drop the column `userId` on the `Conversation` table. All the data in the column will be lost.
  - Added the required column `conversationId` to the `ContactProfessional` table without a default value. This is not possible if the table is not empty.
  - Added the required column `recipientId` to the `Conversation` table without a default value. This is not possible if the table is not empty.
  - Added the required column `senderId` to the `Conversation` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "Conversation" DROP CONSTRAINT "Conversation_userId_fkey";

-- DropForeignKey
ALTER TABLE "Message" DROP CONSTRAINT "Message_conversationId_fkey";

-- AlterTable
ALTER TABLE "ContactProfessional" ADD COLUMN     "conversationId" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "Conversation" DROP COLUMN "userId",
ADD COLUMN     "recipientId" INTEGER NOT NULL,
ADD COLUMN     "senderId" INTEGER NOT NULL;

-- CreateTable
CREATE TABLE "ConversationWithBot" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,

    CONSTRAINT "ConversationWithBot_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Conversation" ADD CONSTRAINT "Conversation_senderId_fkey" FOREIGN KEY ("senderId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Conversation" ADD CONSTRAINT "Conversation_recipientId_fkey" FOREIGN KEY ("recipientId") REFERENCES "HealthProfessional"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ContactProfessional" ADD CONSTRAINT "ContactProfessional_conversationId_fkey" FOREIGN KEY ("conversationId") REFERENCES "Conversation"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ConversationWithBot" ADD CONSTRAINT "ConversationWithBot_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Message" ADD CONSTRAINT "Message_conversationId_fkey" FOREIGN KEY ("conversationId") REFERENCES "ConversationWithBot"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
