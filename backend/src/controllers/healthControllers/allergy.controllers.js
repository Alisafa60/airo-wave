const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();

const addAllergy = async (req, res) => {
    try {
      const { allergen, severity, duration, triggers } = req.body;
  
      const userId = req.user.id;
  
      const userHealth = await prisma.healthCondition.findUnique({
        where: { userId: userId },
      });

      if (!userHealth || !userHealth.id) {
        return res.status(400).json({ error: 'User health information not found.' });
      }
  
      const userHealthId = userHealth.id;
  
      const newAllergy = await prisma.allergy.create({
        data: {
          allergen,
          severity,
          duration,
          triggers,
        },
      });
  
      // Connect the allergy to the obtained UserHealth entry
      const updatedUserHealth = await prisma.healthCondition.update({
        where: { id: userHealthId },
        data: {
          allergy: { connect: { id: newAllergy.id } },
        },
      });
  
      res.status(201).json({ allergy: newAllergy, updatedUserHealth });
    } catch (e) {
      console.error("Error adding allergy", e);
      res.status(500).json({ error: e.message });
    }
};


  module.exports = { 
    addAllergy,
 };
