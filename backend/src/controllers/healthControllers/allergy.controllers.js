const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();
const medicationController = require('./medication.controllers');

const addAllergy = async (req, res) => {
    try {
      const { allergen, severity, duration, triggers, medicationFields } = req.body;
  
      // Extract user ID from the JWT (assuming it's included in req.user)
      const userId = req.user.id;
  
      // Query the database to find the userHealthId based on the userId
      const userHealth = await prisma.healthCondition.findUnique({
        where: { userId: userId },
      });
  
      // Ensure that userHealth is not null and userHealthId is present
      if (!userHealth || !userHealth.id) {
        return res.status(400).json({ error: 'User health information not found.' });
      }
  
      // Use the obtained userHealthId in the allergy creation
      const userHealthId = userHealth.id;
  
      let newMedication = null;
  
      // Check if medicationFields are provided
      if (medicationFields) {
        // Use the medication controller to create or find the medication
        newMedication = await medicationController.createOrFindMedication(medicationFields);
      }
  
      // Create the allergy in the database
      const newAllergy = await prisma.allergy.create({
        data: {
          allergen,
          severity,
          duration,
          triggers,
          medications: newMedication
            ? { connect: { id: newMedication.id } }
            : undefined,
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

const findExistingAllergy = async ({ allergen, severity, duration, triggers }) => {
    const existingAllergy = await prisma.allergy.findUnique({
      where: {
        allergen,
        severity,
        duration,
        triggers,
      },
    });
  
    return existingAllergy;
  };
  
  module.exports = { 
    addAllergy,
    findExistingAllergy
 };

// module.exports = { addAllergy };

// const addAllergy = async (req, res) => {
//   try {
//     const userId = req.user.id;
//     const { allergen, severity, duration, triggers, medicationFields } = req.body;

//     // Check if medicationFields are provided
//     const newMedication = medicationFields
//       ? await medicationController.createOrFindMedication(medicationFields)
//       : null;

//     // Check if an existing allergy with the same details exists
//     const existingAllergy = await prisma.allergy.findFirst({
//       where: {
//         allergen,
//         severity,
//         duration,
//         triggers,
//       },
//     });

//     if (existingAllergy) {
//       // If the allergy already exists, return it
//       return res.status(200).json({ allergy: existingAllergy });
//     }

//     // If the allergy doesn't exist, create a new one
//     const newAllergy = await prisma.allergy.create({
//       data: {
//         allergen,
//         severity,
//         duration,
//         triggers,
//         medications: newMedication
//           ? { connect: { id: newMedication.id } }
//           : undefined,
//       },
//     });

//     res.status(201).json({ allergy: newAllergy });
//   } catch (e) {
//     console.error("Error adding allergy", e);
//     res.status(500).json({ error: e.message });
//   }
// };

