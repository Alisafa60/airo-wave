const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();
const { handleError } = require('../../helpers');

const addAllergen = async (req, res) => {
  try {
    const { name, color } = req.body;
    const userId = req.user.id;

    if (!name || !color) {
      return res.status(400).json({ error: 'Required fields are missing for allergen creation.' });
    }

    const newAllergen = await prisma.allergen.create({
      data: {
        name,
        color,
        userId:userId,
      },
    });

    res.status(201).json({ allergen: newAllergen });
  } catch (e) {
    handleError(res, e, 'Error adding allergen');
  }
};

module.exports = {addAllergen};