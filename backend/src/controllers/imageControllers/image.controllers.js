const { PrismaClient } = require('@prisma/client');
const upload = require('../../utils/imageUpload');

const prisma = new PrismaClient();

const uploadProfilePicture = async (req, res) => {
  try {
    const userId = req.user.id; 

    if (!userId) {
      return res.status(400).json({ error: 'User not found in the request.' });
    }

    const imageUrl = req.file ? req.file.path : undefined;

    if (!imageUrl) {
      return res.status(400).json({ error: 'No image uploaded.' });
    }

    // Update user's profile picture
    await prisma.user.update({
      where: { id: userId },
      data: { profilePicture: imageUrl },
    });

    res.status(201).json({ message: 'Profile picture uploaded successfully', imageUrl });
  } catch (error) {
    res.status(500).json({ error: 'Internal Server Error' });
  }
};

const deleteProfilePicture = async (req, res) => {
    try {
      const userId = req.user.id;
  
      if (!userId) {
        return res.status(400).json({ error: 'User not found in the request.' });
      }
  
      const user = await prisma.user.findUnique({
        where: { id: userId },
        select: { profilePicture: true },
      });
  
      // Check if the user has a profile picture
      if (!user || !user.profilePicture) {
        return res.status(404).json({ message: 'No profile picture to delete.' });
      }
  
      // Remove user's profile picture
      await prisma.user.update({
        where: { id: userId },
        data: { profilePicture: null },
      });
  
      res.status(204).send();
    } catch (error) {
      res.status(500).json({ error: 'Internal Server Error' });
    }
  };
  
module.exports = { 
    uploadProfilePicture, 
    deleteProfilePicture
};
