const { PrismaClient } = require('@prisma/client');
const Joi = require('joi');
const prisma = new PrismaClient();
const { handleError } = require('../../helpers');
const prisma1 = require('../../../dist/sql/userLocation');

const environmentalDataSchema = Joi.object({
  temperature: Joi.number().allow(null),
  humidity: Joi.number().allow(null),
  aqi: Joi.number().allow(null),
  treePollen: Joi.number().allow(null),
  grassPollen: Joi.number().allow(null),
  weedPollen: Joi.number().allow(null),
  olivePollen: Joi.number().allow(null),
  birchPollen: Joi.number().allow(null),
  co2Level: Joi.number().allow(null),
  ozoneLevel: Joi.number().allow(null),
  coLevel: Joi.number().allow(null),
  vocLevel: Joi.number().allow(null),
  so2Level: Joi.number().allow(null),
  no2Level: Joi.number().allow(null),
  pm1_0: Joi.number().allow(null),
  pm25: Joi.number().allow(null),
  pm10: Joi.number().allow(null),
  dominantPollutant: Joi.string().allow(null),
  windSpeed: Joi.number().allow(null),
  bloodO2Level: Joi.string().allow(null),
  heartRate: Joi.array().items(Joi.object({
    value: Joi.number().required(),
    timestamp: Joi.date().required(),
  })).optional(),
  deviceId: Joi.number().optional(),
  userId: Joi.number().required(),
  location: Joi.object({
    latitude: Joi.number().required(),
    longitude: Joi.number().required(),
  }).required(),
});

const createEnvironmentalData = async (req, res) => {
  try {
    const { temperature, humidity, aqi, treePollen, grassPollen, weedPollen, olivePollen, birchPollen, co2Level, ozoneLevel, coLevel, vocLevel, so2Level, no2Level, pm1_0, pm25, pm10, windSpeed, bloodO2Level, dominantPollutant, heartRate, deviceId, location} = req.body;
    const userId = req.user.id;
    const { error, value } = environmentalDataSchema.validate({
      temperature, humidity, aqi, treePollen, grassPollen, weedPollen, olivePollen, birchPollen, co2Level, ozoneLevel, coLevel, vocLevel, so2Level, no2Level, pm1_0, pm25, pm10, windSpeed, bloodO2Level, dominantPollutant, heartRate, deviceId, userId, location
    });

    if (error) {
      return res.status(400).json({ error: error.details[0].message });
    }

    const newEnvironmentalData = await prisma.enviromentalHealthData.create({
      data: value,
    });

    res.status(201).json({ environmentalData: newEnvironmentalData });
  } catch (e) {
    handleError(res, e, 'Error creating EnvironmentalHealthData');
  }
};

const getLastEnvironmentalData = async (req, res) => {
  try{
    const userId = req.user.id;

    getLastEnvironmentalData = await prisma.enviromentalHealthData.findFirst({
      where: { userId: userId},
      orderBy:{ createdAt: 'desc'}
    })

    if (!getLastEnvironmentalData){
      return res.status(404).json({error: 'No Enviromental Data found'});
    }
    
    res.status(200).json({getLastEnvironmentalData});
  }catch(e){
    handleError(res, e, 'Error retrieving EnvironmentalHealthData');
  }
}

const getEnvironmentalDataByDateRange = async (req, res) => {
    try {
      const userId = req.user.id;
      const { startDate, endDate } = req.query;
  
      const dateRangeSchema = Joi.object({
        startDate: Joi.date().required(),
        endDate: Joi.date().required(),
      });
  
      const { error: dateRangeError, value: dateRange } = dateRangeSchema.validate({
        startDate, endDate
      });
  
      if (dateRangeError) {
        return res.status(400).json({ error: dateRangeError.details[0].message });
      }

      const environmentalDataList = await prisma.enviromentalHealthData.findMany({
        where: {
          userId:userId,
          createdAt: {
            gte: new Date(dateRange.startDate),
            lte: new Date(dateRange.endDate),
          },
        },
      });
  
      res.status(200).json({ environmentalDataList });
    } catch (e) {
      handleError(res, e, 'Error retrieving EnvironmentalHealthData');
    }
  };
  
const getEnvironmentalDataList = async (req, res) => {
  try {
    const userId = req.user.id;

    const environmentalDataList = await prisma.enviromentalHealthData.findMany({
      where: { userId:userId },
    });

    res.status(200).json({ environmentalDataList });
  } catch (e) {
    handleError(res, e, 'Error retrieving EnvironmentalHealthData');
  }
};

module.exports = {
  createEnvironmentalData,
  getEnvironmentalDataByDateRange,
  getEnvironmentalDataList,
  getLastEnvironmentalData,
}