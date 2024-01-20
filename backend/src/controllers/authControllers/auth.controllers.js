const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

const prisma = new PrismaClient();

const hashPassword = async (password) => {
  const salt = await bcrypt.genSalt(10);
  return bcrypt.hash(password, salt);
};

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
    const userInDb = await prisma.user.findUnique({ where: { email } });

    // Check if the password has been modified or it's a new user
    const hashedPassword = userInDb ? userInDb.password : await hashPassword(password);

    if (type === 'user' || type === 'healthProfessional') {
      const userType = await prisma.userType.findFirst({ where: { type } });
      if (userType) {
        userTypeConnect = { id: userType.id };
      } else {
        return res.status(500).json({ error: `User type '${type}' not found` });
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

const login = async(req, res) => {

  const {email, password} = req.body;

  try{
    const user = await prisma.user.findUnique({
      where: {email},
      include:{
        userType: true,
      },
    });

    if(!user){
      return res.status(400).send({message: "Invalid email/password"});
    }

    const isValidPassword = await bcrypt.compare(password, user.password);
    if(!isValidPassword){
      return res.status(400).send({message: "Invalid email/password"});
    }

    const {password: hashedPassword, ...userDetails} = user;

    const token = jwt.sign(
      {...userDetails},
      process.env.JWT_SECRET,
      {expiresIn: "30 days"}
    );

    return res.status(200).send({
      user: userDetails,
      token,
    });
  } catch(e){
    console.error("error in login", e);
    return res.status(500).json({error: e.message});
  }
}

module.exports = {
  register,
  login,
};
