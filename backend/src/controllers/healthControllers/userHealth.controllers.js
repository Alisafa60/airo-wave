const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

const addUserHealth = async (req, res) => {
  try {
    const userId = req.user.id;
    const { weight, bloodType } = req.body;

    const newUserHealth = await prisma.healthCondition.create({
      data: {
        weight,
        bloodType,
        user: {
          connect: {
            id: userId,
          },
        },
      },
    });

    const userHealthId = newUserHealth.id;

    res.status(201).json({ userHealth: newUserHealth, userHealthId });
  } catch (e) {
    console.error('Error adding new user health', e);
    res.status(500).json({ error: e.message });
  }
};

module.exports = { addUserHealth };
