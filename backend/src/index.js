const express = require('express');
const { PrismaClient } = require('@prisma/client');
const authRoutes = require('./routes/auth.routes');
require("dotenv").config();

const prisma = new PrismaClient();
const app = express();

app.use(express.json());


app.use('/auth', authRoutes);

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});


process.on('beforeExit', () => {
  prisma.$disconnect();
});
