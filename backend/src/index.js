const express = require('express');
const { PrismaClient } = require('@prisma/client');
const {authMiddleware} = require('./middlewares/auth.middleware');
const fs = require('fs/promises'); 
require("dotenv").config();
const path = require('path');
const prisma = new PrismaClient();
const app = express();
app.use(express.json());

const serveFilesFromUploads = async (req, res, next) => {
  try {
    const filePath = path.join(__dirname, 'uploads', req.url.replace(/^\/a\/uploads\//, ''));
    const stats = await fs.stat(filePath);

    if (stats.isFile()) {
      res.sendFile(filePath);
    } else {
      next();
    }
  } catch (error) {
    next();
  }
};

app.use('/uploads', serveFilesFromUploads);

const authRoutes = require('./routes/auth.routes');
const imageRoutes = require('./routes/image.routes');
const allergyRoutes = require('./routes/allergy.routes');
const healtRoutes = require('./routes/userHealth.routes')
const medicationRoutes = require('./routes/medication.routes')
const userHealth = require('./routes/userHealth.routes');
const respiratoryCondition = require('./routes/respiratoryCondition.routes');
const userLocation = require('./routes/userLocation.routes');
const dailyHealth = require('./routes/dailyHealth.routes');
const enviromentalHealth = require('./routes/enviromentalHealth.routes');
const notification = require('./routes/notification.routes');
const healthProfessional = require('./routes/healthProfessional.routes');
const userProfile = require('./routes/userProfile.routes')
const machineLearningPredictions = require('./routes/ml.routes');
const contactProfessional = require('./routes/contractProfessional.routes');
const chatbot = require('./routes/chatbot.routes');
const heartRate = require('./routes/heartRate.routes');
const stress = require('./routes/stress.routes');
const userRoutes = require('./routes/createRoutes.controllers');
const device = require('./routes/device.routes');


app.use('/auth', authRoutes);
app.use('/api', authMiddleware, imageRoutes);
app.use('/api', authMiddleware, allergyRoutes);
app.use('/api', authMiddleware, healtRoutes);
app.use('/api', authMiddleware, medicationRoutes);
app.use('/api', authMiddleware, userHealth);
app.use('/api', authMiddleware, respiratoryCondition);
app.use('/api', authMiddleware, userLocation);
app.use('/api', authMiddleware, dailyHealth );
app.use('/api', authMiddleware, enviromentalHealth);
app.use('/api', authMiddleware, notification);
app.use('/api', authMiddleware, healthProfessional);
app.use('/api', authMiddleware, userProfile);
app.use('/api', authMiddleware, machineLearningPredictions);
app.use('/api', authMiddleware, contactProfessional);
app.use('/api', authMiddleware, chatbot);
app.use('/api', authMiddleware, stress);
app.use('/api', authMiddleware, heartRate);
app.use('/api', authMiddleware, userRoutes);
app.use('/api', authMiddleware, device);
module.exports = app;

const PORT = process.env.PORT || 3000;


app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});


process.on('beforeExit', () => {
  prisma.$disconnect();
});
