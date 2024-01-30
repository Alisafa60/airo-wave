const { PrismaClient } = require('@prisma/client');
const jwt = require('jsonwebtoken');

const prisma = new PrismaClient();

const authMiddleware = async (req, res, next) => {
  const token = req.headers['authorization']?.split(' ')[1];

  if (!token) {
    res.status(403).send('Forbidden');
  } else {
    try {
      const decoded = jwt.verify(token, process.env.JWT_SECRET);
      const user = await prisma.user.findUnique({
        where: { email: decoded.email }, 
        select: {
          id: true,
          email: true,
          userType: { select: { type: true } },
        },
      });

      if (!user) {
        res.status(404).send('User not found');
      }

      req.user = user;
      next();
    } catch (error) {
      res.status(401).send('Unauthorized');
    }
  }
};

const adminMiddleware = async (req, res, next) => {
  try {
    
    const userType = req.user.userType;
    
    if (userType === 'admin') {
      next();
    } else {
      res.status(403).send('Forbidden: Admin access required');
    }
  } catch (error) {
    res.status(500).send('Internal Server Error');
  }
};
module.exports = {
  authMiddleware,
  adminMiddleware,
};
