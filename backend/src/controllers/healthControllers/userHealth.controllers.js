const { PrismaClient } = require('@prisma/client');
const { handleError } = require('../../helpers');
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
    handleError(res, e, 'Error adding new user health');
  }
};

const getUserHealth = async (req, res) => {
  try {
    const userId = req.user.id;
    const userHealth = await prisma.healthCondition.findUnique({
      where: { userId: userId },
    });

    if (!userHealth || !userHealth.id) {
      return res.status(404).json({ error: 'User health information not found.' });
    }

    res.json({ userHealth });
  } catch (e) {
    handleError(res, e, 'Error getting user health');
  }
};

const updateUserHealth = async (req, res) => {
  try{
    const userId = req.user.id;
    const updateUserHealth = await prisma.healthCondition.update({
      where: { userId: userId },
      data: {
        weight,
        bloodType,
      }
    });

    res.json({ updateUserHealth });
  }catch(e){
    handleError(res, e, 'Error updating user health');
  }
}

const deleteUserHealthById = async (req, res) => {
  try {
    const userId = req.user.id;
    await prisma.healthCondition.delete({
      where: { userId: userId },
    });

    res.json({ message: 'User health deleted successfully', deletedUserHealth });
  } catch (e) {
    handleError(res, e, 'Error deleting user health');
  }
};

module.exports = {
  addUserHealth,
  getUserHealth,
  updateUserHealth,
  deleteUserHealthById 
};
