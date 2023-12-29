const express = require('express');
const { PrismaClient } = require('@prisma/client');
require("dotenv").config();

const prisma = new PrismaClient();
const app = express();

app.use(express.json());

const authRoutes = require('./routes/auth.routes');
const imageRoutes = require('./routes/image.routes');

app.use('/auth', authRoutes);
app.use('/api', imageRoutes);
module.exports = app;

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});


process.on('beforeExit', () => {
  prisma.$disconnect();
});
