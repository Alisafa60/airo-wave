const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

const prisma = new PrismaClient();

const register = async (req, res) => {
  const { email, password, firstName, lastName, gender, unit, type, profilePicture } = req.body;

  if (!email || !password || !firstName || !lastName || !gender) {
    return res.status(400).send({ message: "Required field left empty!" });
  }

  const allowedUserTypes = ['user', 'healthProfessional'];
  if (!allowedUserTypes.includes(type)) {
    return res.status(400).send({ message: "Invalid user type" });
  }

  try {
    let userTypeConnect = { type };
    const hashedPassword = await bcrypt.hash(password, 10)
    
    if (type === 'user') {
      const userType = await prisma.userType.findFirst({ where: { type: 'user' } });
      if (userType) {
        userTypeConnect = { id: userType.id };
      } else {
        return res.status(500).json({ error: "User type 'user' not found" });
      }
    } else if (type === 'healthProfessional') {
      const userType = await prisma.userType.findFirst({ where: { type: 'healthProfessional' } });
      if (userType) {
        userTypeConnect = { id: userType.id };
      } else {
        return res.status(500).json({ error: "User type 'healthProfessional' not found" });
      }
    }

    const newUser = await prisma.user.create({
      data: {
        email,
        password: hashedPassword,
        firstName,
        lastName,
        gender,
        unit,
        userType: { connect: userTypeConnect },
        profilePicture,
      }
    });

    return res.status(200).json({ user: newUser });

  } catch (e) {
    console.error("Error in registration:", e);
    return res.status(500).json({ error: e.message });
  }
};

module.exports = {
  register,
};
