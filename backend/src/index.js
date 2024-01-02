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
const medicationRoutes = require('./routes/medication.routes')
const userHealth = require('./routes/userHealth.routes');
const respiratoryCondition = require('./routes/respiratoryCondition.routes');
const userLocation = require('./routes/userLocation.routes');
const dailyHealth = require('./routes/dailyHealth.routes');
const enviromentalHealth = require('./routes/enviromentalHealth.routes');
const notification = require('./routes/notification.routes');
const healthProfessional = require('./routes/healthProfessional.routes');
const userProfile = require('./routes/userHealth.routes')
const machineLearningPredictions = require('./routes/ml.routes');

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
app.use('api', authMiddleware, userProfile);
app.use('api', authMiddleware, machineLearningPredictions);

module.exports = app;

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});


process.on('beforeExit', () => {
  prisma.$disconnect();
});
