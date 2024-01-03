/*
  Warnings:

  - You are about to drop the column `repliedAt` on the `ContactProfessional` table. All the data in the column will be lost.
  - You are about to drop the column `replyContent` on the `ContactProfessional` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "ContactProfessional" DROP COLUMN "repliedAt",
DROP COLUMN "replyContent";

-- CreateTable
CREATE TABLE "Reply" (
    "id" SERIAL NOT NULL,
    "contactId" INTEGER NOT NULL,
    "senderId" INTEGER NOT NULL,
    "content" TEXT NOT NULL,
    "sentAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Reply_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Reply" ADD CONSTRAINT "Reply_contactId_fkey" FOREIGN KEY ("contactId") REFERENCES "ContactProfessional"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Reply" ADD CONSTRAINT "Reply_senderId_fkey" FOREIGN KEY ("senderId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
