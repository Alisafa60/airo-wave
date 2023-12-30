const express = require('express');
const { PrismaClient } = require('@prisma/client');
const {authMiddleware} = require('./middlewares/auth.middleware');
require("dotenv").config();

const prisma = new PrismaClient();
const app = express();

app.use(express.json());

const authRoutes = require('./routes/auth.routes');
const imageRoutes = require('./routes/image.routes');
const allergyRoutes = require('./routes/allergy.routes');
const healtRoutes = require('./routes/userHealth.routes')

app.use('/auth', authRoutes);
app.use('/api', authMiddleware, imageRoutes);
app.use('/api', authMiddleware, allergyRoutes);
app.use('/api', authMiddleware, healtRoutes);

module.exports = app;

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});


process.on('beforeExit', () => {
  prisma.$disconnect();
});
