/*
  Warnings:

  - You are about to drop the column `birchPollen` on the `EnviromentalHealthData` table. All the data in the column will be lost.
  - You are about to drop the column `grassPollen` on the `EnviromentalHealthData` table. All the data in the column will be lost.
  - You are about to drop the column `olivePollen` on the `EnviromentalHealthData` table. All the data in the column will be lost.
  - You are about to drop the column `treePollen` on the `EnviromentalHealthData` table. All the data in the column will be lost.
  - You are about to drop the column `weedPollen` on the `EnviromentalHealthData` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "EnviromentalHealthData" DROP COLUMN "birchPollen",
DROP COLUMN "grassPollen",
DROP COLUMN "olivePollen",
DROP COLUMN "treePollen",
DROP COLUMN "weedPollen",
ADD COLUMN     "allergen1" INTEGER,
ADD COLUMN     "allergen2" INTEGER,
ADD COLUMN     "allergen3" INTEGER,
ADD COLUMN     "allergen4" INTEGER,
ADD COLUMN     "allergen5" INTEGER;
