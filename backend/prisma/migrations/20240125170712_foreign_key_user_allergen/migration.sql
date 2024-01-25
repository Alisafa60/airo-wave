/*
  Warnings:

  - Added the required column `userId` to the `Allergen` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Allergen" ADD COLUMN     "userId" INTEGER NOT NULL;

-- AddForeignKey
ALTER TABLE "Allergen" ADD CONSTRAINT "Allergen_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
