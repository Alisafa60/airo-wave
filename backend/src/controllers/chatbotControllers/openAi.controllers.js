const openai = require('openai');
require('dotenv').config();
const openaiApiKey = process.env.OPENAI_API_KEY;
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
console.log('api key', openaiApiKey);

const axios = require('axios'); 

const determineSeverityRecommendation = (severity) => {
    if (severity >= 4) {
        return 'Your health severity is high. Please consult with a healthcare professional.';
    } else if (severity >= 2) {
        return 'Your health severity is moderate. Consider taking necessary precautions.';
    } else {
        return 'Your health severity is low. Continue with your regular health routine.';
    }
};

const generateHealthRecommendation = (
    lastSeverityEntry,
    sensorDataWithAverage,
    environmentalHealthDataWithAverage,
    last10Allergens,
    respiratoryConditions,
    allergies,
    lastLocation 
) => {
    
 
    const severityRecommendation = determineSeverityRecommendation(lastSeverityEntry.severity);
    const locationRecommendation = `Based on your last known location, please be aware of any specific health risks associated with that area.`;
    const indoorRecommendation = `Based on indoor sensor data, ensure proper ventilation and consider checking for potential sources of indoor pollution.`;
    const outdoorRecommendation = `Based on outdoor environmental data, be cautious of high levels of pollutants in the air. Consider staying indoors during poor air quality conditions.`;

    const respiratoryConditionRecommendation = (respiratoryConditions.length > 0)
        ? `Considering your respiratory condition, take extra precautions to avoid triggers and follow your prescribed medications.`
        : '';

    const recommendation = `
        Based on the collected data:
        - Severity Recommendation: ${severityRecommendation}
        - Location Recommendation: ${locationRecommendation}
        - Indoor Recommendation: ${indoorRecommendation}
        - Outdoor Recommendation: ${outdoorRecommendation}
        - Respiratory Condition Recommendation: ${respiratoryConditionRecommendation}
    `;

    return recommendation;
};

const buildPayload = async (
    last10Allergens,
    sensorDataWithAverage,
    environmentalHealthDataWithAverage,
    respiratoryConditions,
    allergies,
    medications,
    lastLocation 
) => {
    try {

        const lastSeverityEntry = await prisma.dailyHealth.findFirst({
            select: { severity: true },
            orderBy: { createdAt: 'desc' },
        });

        const healthRecommendation = generateHealthRecommendation(
            lastSeverityEntry,
            sensorDataWithAverage,
            environmentalHealthDataWithAverage,
            last10Allergens,
            respiratoryConditions,
            allergies,
            lastLocation
        );

        const payload = {
            messages: [
                { role: 'system', content: 'Your name is MedCat, your mainly care about users health, and you can be a little bit humorous too .' },
                { role: 'user', content: 'What is my health recommendation?' },
                { role: 'assistant', content: healthRecommendation },

            ],
        };

        return payload;
    } catch (error) {
        console.error('Error:', error);
    } finally {
        await prisma.$disconnect();
    }
};

const sendToOpenAI = async (payload) => {
    const openaiApiKey = process.env.OPENAI_API_KEY; 
    console.log('body api key', openaiApiKey);
    const openaiEndpoint = 'https://api.openai.com/v1/chat/completions';

    const headers = {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${openaiApiKey}`,
    };
    console.log('Request Headers:', headers);
    try {
        const response = await axios.post(openaiEndpoint, payload, { headers });
        console.log(response.data.choices[0].message['content']);
    } catch (error) {
        console.error('Error communicating with OpenAI API:', error);
    }
};

async function generateOpenAIPayload() {
    try {
        const last10Allergens = await prisma.allergen.findMany({
            take: 10,
            orderBy: {
            id: 'desc',
            },
        });
        console.log(last10Allergens);

        const lastSeverityEntry = await prisma.dailyHealth.findFirst({
            select : {severity: true},
            orderBy : { createdAt : 'desc'}
        })
        console.log(lastSeverityEntry);

        const sensorDataWithAverage = await prisma.sensorData.findMany({
            take: 200,
            orderBy: {
            createdAt: 'desc',
            },
            select: {
            id: true,
            co2: true,
            voc: true,
            createdAt: true,
            },
        });
      
        const calculatedAverages = sensorDataWithAverage.reduce((acc, data) => {
            acc.id.push(data.id);
            acc.co2.push(data.co2);
            acc.voc.push(data.voc);
            return acc;
        }, { id: [], co2: [], voc: [] });
        
        const averageCo2 = calculatedAverages.co2.reduce((sum, value) => sum + value, 0) / calculatedAverages.co2.length;
        const averageVoc = calculatedAverages.voc.reduce((sum, value) => sum + value, 0) / calculatedAverages.voc.length;
        fixedCo2 = parseFloat(averageCo2.toFixed(2));
        fixedVoC = parseFloat(averageVoc.toFixed(2));


        const environmentalHealthDataWithAverage = await prisma.enviromentalHealthData.groupBy({
            by: ['id', 'aqi', 'coLevel', 'o3Level', 'so2Level', 'no2Level', 'pm25', 'pm10', 'userId', 'createdAt', 'updatedAt'],
            orderBy: {
            updatedAt: 'desc',
            },
            take: 20,
            select: {
            id: true,
            aqi: true,
            coLevel: true,
            o3Level: true,
            so2Level: true,
            no2Level: true,
            pm25: true,
            pm10: true,
            userId: true,
            createdAt: true,
            },
        });
      
        const calculatedEnvironmentalAverages = environmentalHealthDataWithAverage.reduce((acc, data) => {
            acc.id.push(data.id);
            acc.aqi.push(data.aqi);
            acc.coLevel.push(data.coLevel);
            acc.o3Level.push(data.o3Level);
            acc.so2Level.push(data.so2Level);
            acc.no2Level.push(data.no2Level);
            acc.pm25.push(data.pm25);
            acc.pm10.push(data.pm10);
            
            return acc;
        }, {
            id :[],
            aqi: [],
            ozoneLevel: [],
            coLevel: [],
            o3Level: [],
            vocLevel: [],
            so2Level: [],
            no2Level: [],
            pm25: [],
            pm10: [],
            userId: [],
        });
      
        const averageAqi = calculatedEnvironmentalAverages.aqi.reduce((sum, value) => sum + value, 0) / calculatedEnvironmentalAverages.aqi.length;
        const averageCoLevel = calculatedEnvironmentalAverages.coLevel.reduce((sum, value) => sum + value, 0) / calculatedEnvironmentalAverages.coLevel.length;
        const averageO3Level = calculatedEnvironmentalAverages.o3Level.reduce((sum, value) => sum + value, 0) / calculatedEnvironmentalAverages.o3Level.length;
        const averageSo2Level = calculatedEnvironmentalAverages.so2Level.reduce((sum, value) => sum + value, 0) / calculatedEnvironmentalAverages.so2Level.length;
        const averageNo2Level = calculatedEnvironmentalAverages.no2Level.reduce((sum, value) => sum + value, 0) / calculatedEnvironmentalAverages.no2Level.length;
        const averagePm25 = calculatedEnvironmentalAverages.pm25.reduce((sum, value) => sum + value, 0) / calculatedEnvironmentalAverages.pm25.length;
        const averagePm10 = calculatedEnvironmentalAverages.pm10.reduce((sum, value) => sum + value, 0) / calculatedEnvironmentalAverages.pm10.length;

        const fixedAqi = parseFloat(averageAqi.toFixed(2));
        const fixedCoLevel = parseFloat(averageCoLevel.toFixed(2));
        const fixedO3Level = parseFloat(averageO3Level.toFixed(2));
        const fixedSo2Level = parseFloat(averageSo2Level.toFixed(2));
        const fixedNo2Level = parseFloat(averageNo2Level.toFixed(2));
        const fixedPm25 = parseFloat(averagePm25.toFixed(2));
        const fixedPm10 = parseFloat(averagePm10.toFixed(2));

  
        const respiratoryConditions = await prisma.respiratoryCondition.findMany();
        const allergies = await prisma.allergy.findMany();
        const medications = await prisma.medication.findMany();
        const lastLocation = await prisma.location.findFirst({
            orderBy: {
            id: 'desc',
            },
        });
    
        const payload = buildPayload(last10Allergens, sensorDataWithAverage, environmentalHealthDataWithAverage, respiratoryConditions, allergies, medications, lastLocation);
        await sendToOpenAI(payload);
        console.log({ payload });
        } catch (error) {
        console.error('Error:', error);
        } finally {
        await prisma.$disconnect();
        }
}

 generateOpenAIPayload();
