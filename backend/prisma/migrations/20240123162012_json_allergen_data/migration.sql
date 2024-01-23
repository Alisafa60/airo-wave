/*
  Warnings:

  - You are about to drop the column `allergen1` on the `EnviromentalHealthData` table. All the data in the column will be lost.
  - You are about to drop the column `allergen2` on the `EnviromentalHealthData` table. All the data in the column will be lost.
  - You are about to drop the column `allergen3` on the `EnviromentalHealthData` table. All the data in the column will be lost.
  - You are about to drop the column `allergen4` on the `EnviromentalHealthData` table. All the data in the column will be lost.
  - You are about to drop the column `allergen5` on the `EnviromentalHealthData` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "EnviromentalHealthData" DROP COLUMN "allergen1",
DROP COLUMN "allergen2",
DROP COLUMN "allergen3",
DROP COLUMN "allergen4",
DROP COLUMN "allergen5",
ADD COLUMN     "allergen_data" JSONB;
