const axios = require('axios');
const { PrismaClient } = require("@prisma/client");
const { default: OpenAI } = require('openai');
require('dotenv').config();
const openai = new OpenAI(process.env.OPENAI_API_KEY);
const prisma = new PrismaClient();

async function sendToOpenAI(payload, prompt) {
    try {
        const response = await openai.chat.completions.create({
            model: 'gpt-3.5-turbo',
            messages: [
                { role: 'system', content: 'Your name is MedCat, you mainly care about users health that provide you with enviromental data they provide and health condition.' },
                { role: 'user', content: 'can you tell me about my condition?' },
                { role: 'assistant', content: prompt },
            ],
            
        });

        result = response.choices[0].message.content;
        console.log(result)
    } catch (error) {
        console.error('Error in sendToOpenAI:', error);
        throw error;
    }
}
async function generateOpenAIPayload(userId) {
    
    try {
        const allergens = await prisma.allergen.findFirst({
            where: { userId: userId },
            orderBy: {
                id: 'desc',
            },
            select: { name: true, color: true }
        });
    
        const lastSeverityEntry = await prisma.dailyHealth.findFirst({
            select: { severity: true, userId: userId },
            orderBy: { createdAt: 'desc' }
        });
    
        const healthCondition = await prisma.healthCondition.findFirst({
            where: { userId: userId },
            select: {
                weight: true,
                bloodType: true,
                id: true
            }
        });
    
        const conditionId = healthCondition.id;
    
        const sensorDataWithAverage = await prisma.sensorData.findMany({
            take: 50,
            orderBy: {
                createdAt: 'desc',
            },
            select: {
                co2: true,
                voc: true,
                createdAt: true,
            },
        });
    
        const calculatedAverages = sensorDataWithAverage.reduce((acc, data) => {
            acc.co2.push(data.co2);
            acc.voc.push(data.voc);
            return acc;
        }, { co2: [], voc: [] });
    
        const averageCo2 = calculatedAverages.co2.reduce((sum, value) => sum + value, 0) / calculatedAverages.co2.length;
        const averageVoc = calculatedAverages.voc.reduce((sum, value) => sum + value, 0) / calculatedAverages.voc.length;
    
        const fixedCo2 = parseFloat(averageCo2.toFixed(2));
        const fixedVoC = parseFloat(averageVoc.toFixed(2));
    
        const environmentalHealthDataWithAverage = await prisma.enviromentalHealthData.groupBy({
            where: { userId: userId },
            by: ['aqi', 'coLevel', 'o3Level', 'so2Level', 'no2Level', 'pm25', 'pm10', 'userId', 'updatedAt'],
            orderBy: {
                updatedAt: 'desc',
            },
            take: 20,
            select: {
                aqi: true,
                coLevel: true,
                o3Level: true,
                so2Level: true,
                no2Level: true,
                pm25: true,
                pm10: true,
                userId: true,
                updatedAt: true,
            },
        });
    
        const calculatedEnvironmentalAverages = environmentalHealthDataWithAverage.reduce((acc, data) => {
            acc.aqi.push(data.aqi);
            acc.coLevel.push(data.coLevel);
            acc.o3Level.push(data.o3Level);
            acc.so2Level.push(data.so2Level);
            acc.no2Level.push(data.no2Level);
            acc.pm25.push(data.pm25);
            acc.pm10.push(data.pm10);
    
            return acc;
        }, {
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
    
        const respiratoryConditions = await prisma.respiratoryCondition.findMany({
            where: { healthConditionId: conditionId },
            select: {
                condition: true,
                symptomsFrequency: true,
                triggers: true,
                healthConditionId: true
            }
        });
    
        const allergies = await prisma.allergy.findMany({
            where: { healthConditionId: conditionId },
            select: {
                allergen: true,
                severity: true,
                duration: true,
                triggers: true
            }
        });
    
        const lastLocation = await prisma.location.findFirst({
            orderBy: {
                id: 'desc',
            },
            select: {
                location: true
            }
        });
    
        const determineSeverityRecommendation = (severity) => {
            if (severity >= 4) {
                return 'Your health severity is high. Please consult with a healthcare professional.';
            } else if (severity >= 2) {
                return 'Your health severity is moderate. Consider taking necessary precautions.';
            } else {
                return 'Your health severity is low. Continue with your regular health routine.';
            }
        };
    
        const healthRecommendation = 'Your health recommendation message goes here';
    
        const allergenData = allergens || [];
        const respiratoryConditionsData = respiratoryConditions || [];
        const allergyData = allergies || [];
        const airQualityData = {
            fixedCo2,
            fixedVoC,
            fixedAqi,
            fixedCoLevel,
            fixedNo2Level,
            fixedO3Level,
            fixedPm10,
            fixedPm25,
            fixedSo2Level
        } || {};
        const healthData = healthCondition || [];
        console.log('Allergens:', allergens)

        const payload = {
            severity : lastSeverityEntry[{severity: lastSeverityEntry.severity}],
            allergens: [{ name: allergens.name, color: allergens.color }],
            respiratoryConditions: [{
                condition: respiratoryConditions.condition,
                symptomsFrequency: respiratoryConditions.symptomsFrequency,
                triggers: respiratoryConditions.triggers,
            }],
            allergies: allergies[{
                allergen: allergies.allergen,
                severity: allergies.severity,
                duration: allergies.duration,
                trigger: allergies.triggers,
            }],
            healthData: {
                weight: healthCondition.weight,
                bloodType: healthCondition.bloodType,
            },
            indoorSensorData: { co2: fixedCo2, voc: fixedVoC },
            outdoorAirCondition: {
                aqi: fixedAqi,
                coLevel: fixedCoLevel,
                no2Level: fixedNo2Level,
                o3Level: fixedO3Level,
                pm10: fixedPm10,
                pm25: fixedPm25,
                so2Level: fixedSo2Level
            },
            lastLocation: lastLocation ? lastLocation.location : null,
        };

        const prompt = `
            Generate health recommendations for the user.

            Indoor Air Quality:
            - CO2 levels: ${payload.indoorSensorData.co2} ppm
            - VOC levels: ${payload.indoorSensorData.voc} ppm

            Allergens:
            ${payload.allergens.length > 0 ? `- ${payload.allergens[0].name}, Duration: ${payload.allergens[0].duration}, Recommendation: ${payload.severityRecommendation}` : ''}

            Outdoor Air Quality:
            - AQI: ${payload.outdoorAirCondition.aqi}
            - CO levels: ${payload.outdoorAirCondition.coLevel} ppm
            - NO2 levels: ${payload.outdoorAirCondition.no2Level} ppm
            - O3 levels: ${payload.outdoorAirCondition.o3Level} ppm
            - PM10 levels: ${payload.outdoorAirCondition.pm10} µg/m³
            - PM2.5 levels: ${payload.outdoorAirCondition.pm25} µg/m³
            - SO2 levels: ${payload.outdoorAirCondition.so2Level} ppm

            Health Condition:
            - Weight: ${payload.healthData.weight} kg
            - Blood Type: ${payload.healthData.bloodType}

            Respiratory Conditions:
            ${payload.respiratoryConditions.length > 0 ? `- ${payload.respiratoryConditions[0].condition}` : ''}

            Location:
            ${payload.lastLocation ? `- Last location: ${payload.lastLocation}` : '- Location not available'}
        `;
            console.log(payload.outdoorAirCondition.aqi);
        await sendToOpenAI(payload, prompt);
    } catch (error) {
        console.error('Error:', error);
    } finally {
        await prisma.$disconnect();
    }
}
generateOpenAIPayload(1);