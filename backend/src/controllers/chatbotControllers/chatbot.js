const axios = require('axios');
const { PrismaClient } = require("@prisma/client");
const { default: OpenAI } = require('openai');
require('dotenv').config();
const openai = new OpenAI(process.env.OPENAI_API_KEY);
const prisma = new PrismaClient({
    // log: ['query', 'info', 'warn', 'error'],
});

async function sendToOpenAI(userId, payload, prompt) {
    try {
        const response = await openai.chat.completions.create({
            model: 'gpt-3.5-turbo',
            messages: [
                { role: 'system', content: "Your name is MedCat, you mainly care about user's health by analyzing the provided air quality and \
                allergens. And you give recommendation based speifically on their condition. You're concise, and can be fun. don't realy a lot on bullet point as\
                they can be boring. Don't elaborate a lot. Speak mostly in context of user health condition and \
                enviromental data unless you're asked otherwise" },
                { role: 'user', content: 'Give me recommendation by analyzing enviromental condition and my health conditions, start with greeting' },
                { role: 'assistant', content: prompt },
            ],
            
        });
        
        const result = response.choices[0].message.content;
        console.log(result)
        try {
            const openAiResponse = await prisma.openAiResponse.create({
               data : {
                userId:userId,
                response: result
               } 
               
            });
        
        } catch (error) {
            console.error('Error saving result to Prisma:', error);
        }
        
    } catch (error) {
        console.error('Error in sendToOpenAI:', error);
        throw error;
    }
}
async function generateOpenAIPayload(userId, userMessage) {
    
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
            take: 100,
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

        const medications = await prisma.medication.findMany({
            where: {healthConditionId: conditionId},
            select: {
                name: true,
                startDate: true,
                frequency: true,
                dosage: true,
                allergyId:true,
                respiratoryConditionId:true,
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
        const determineAllergenSeverity = (color) => {
            if (color === 'secondary') {
                return 'low';
            } else if (color === 'primary') {
                return 'moderate';
            } else if (color === 'red') {
                return 'high';
            } else {
                return 'unknown';
            }
        };

        const payload = {
            severity : lastSeverityEntry[{severity: lastSeverityEntry.severity}],
            allergens: [{ name: allergens.name, color: allergens.color }],
            respiratoryConditions: respiratoryConditions.map(condition => ({
                condition: condition.condition,
                symptomsFrequency: condition.symptomsFrequency,
                triggers: condition.triggers,
            })),
             medications : medications.map(medication => ({
                name: medication.name,
                startDate: medication.startDate,
                frequency: medication.frequency,
                dosage: medication.dosage,
                severity: determineMedicationSeverity(medication.dosage),
            })),
            allergies: allergies.map(allergy => ({
                allergen: allergy.allergen,
                severity: allergy.severity,
                duration: allergy.duration,
                trigger: allergy.triggers,
            })),
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
       
        const allergenPrompt = payload.allergens.length > 0 ? `- ${payload.allergens.map(allergen => `${allergen.name} (Severity: ${determineAllergenSeverity(allergen.color)})`).join(', ')}` : 'No allergens';
       
        const medicationPrompt = medications.length > 0 ?
                `- ${medications.map(med => `${med.name} (Severity: ${med.severity})`).join(', ')}` :
                'No medications';
        
        const prompt  = `
            Generate health recommendations for the user.

            Respiratory Conditions:
            ${payload.respiratoryConditions.length > 0 ? `- ${payload.respiratoryConditions.map(condition => condition.condition).join(', ')}` : 'No respiratory conditions'}
            
            Health information:
            - Weight: ${payload.healthData.weight} kg
            - Blood Type: ${payload.healthData.bloodType}

            Medications:
            ${medicationPrompt}

            Allergies:
            ${payload.allergies.length > 0 ? `- ${payload.allergies.map(allergy => allergy.allergen).join(', ')}` : 'No allergies'}
            
            Allergens:
            ${allergenPrompt}

            Indoor Air Quality:
            - CO2 levels: ${payload.indoorSensorData.co2} ppm
            - VOC levels: ${payload.indoorSensorData.voc} ppm

            Outdoor Air Quality:
            - AQI: ${payload.outdoorAirCondition.aqi}
            - CO levels: ${payload.outdoorAirCondition.coLevel} ppm
            - NO2 levels: ${payload.outdoorAirCondition.no2Level} ppm
            - O3 levels: ${payload.outdoorAirCondition.o3Level} ppm
            - PM10 levels: ${payload.outdoorAirCondition.pm10} µg/m³
            - PM2.5 levels: ${payload.outdoorAirCondition.pm25} µg/m³
            - SO2 levels: ${payload.outdoorAirCondition.so2Level} ppm
                `;

            await sendToOpenAI(userId, payload, userMessage + '\n' + prompt);;
    } catch (error) {
        console.error('Error:', error);
    } finally {
        await prisma.$disconnect();
    }
}

module.exports = {generateOpenAIPayload}