<img src="./readme/title1.svg"/>

<br><br>

<!-- project philosophy -->
<img src="./readme/title2.svg"/>

> A mobile app for optimizing health management with real-time enviromental data.
>
> This app combines user profiles, medical history, symptom tracking, and real-time indoor and outdoor environmental data with heatmap visuals. It uses AI analysis to offer personalized recommendations.

### User Stories

#### Individual with Respiratory Problems

- Needs a device or app that continuously measures and reports real-time air quality data for the current location.
- Seeks historical data tracking to identify patterns and potential triggers.
- Wants the ability to check the air quality of planned destinations in advance.

#### Cyclist with Allergies

- Requires real-time pollen level information to plan outdoor activities and minimize allergen exposure.
- values integration with navigation apps to choose routes with lower allergen concentrations.
- Desires historical pollen data to identify seasonal patterns and plan activities during periods of lower allergen prevalence.

#### Healthcare Professional

- Needs a platform that integrates real-time environmental data with patients' health records.
- Seeks tools that analyze correlations between environmental data and patients' health outcomes.
- Requires the ability to generate reports or summaries for patients based on historical environmental data.

<br><br>

<!-- Prototyping -->
<img src="./readme/title3.svg"/>

###  AiroWave is built using the following technologies:

-  This project uses the [Flutter app development framework](https://flutter.dev/). Flutter is a cross-platform hybrid app development platform that allows us to use a single codebase for apps on mobile, desktop, and the web.
- For Database, the app utilizes [PostgreSQL](https://www.postgresql.org/) as the backend database management system, providing a robust and scalable solution for data storage.
- The backend is implemented using [Node.js](https://nodejs.org/) along with [Prisma](https://www.prisma.io/) for efficient and type-safe database access and smooth communication.
- To monitor indoor air quality, the project incorporates an [Arduino Uno](https://store.arduino.cc/products/arduino-uno-rev3/) with a [CSS811 air quality sensor](https://learn.adafruit.com/adafruit-ccs811-air-quality-sensor/overview). This hardware component enables real-time tracking and analysis of indoor air quality parameters.
- For outdoor air quality data, the app integrates data from [Google's Air Quality API](https://developers.google.com/maps/documentation/urls/get-started#directions-action).
- To track plant/pollen allergens, the project leverages data from [Google's Pollen API](https://www.google.com/search?q=pollen+api).
- For visualizing data on maps, the project integrates png heatmap tiles on maps from [Google Maps Platform](https://cloud.google.com/maps-platform/).
- The project incorporates a chatbot powered by [OpenAI](https://www.openai.com/) to analyze the data and provide with personalized recommendations.

<br><br>

<img src="./readme/title4.svg"/>

> AiroWave was using wireframes and mockups, iterating on the design until we reached the ideal layout for easy navigation and a seamless user experience.
- Link: [Airo Wave Design](https://www.figma.com/file/pWIkwLZGDMv897FVjYuDK8/FinalProject?type=design&node-id=0-1&mode=design&t=D9Ay4yLQnkpiZo7D-0)

### Mockups
| Home screen              | Health Screen              | Profile Screen              |
| ------------------------ | -------------------------- | ---------------------------- |
| <img src="./readme/home.png" width="200"> | <img src="./readme/medcat.png" width="200"> | <img src="./readme/profile.png" width="200"> |

<br><bar>



<img src="./readme/title5.svg"/>

###  User-Centric Data Management:

The data model, utilizing PostgreSQL, includes user profiles, medical history, symptom tracking, and real-time indoor and outdoor environmental data. 

<img src="./readme/airo_wave_er.png" width = "450"/>


<br><br>
<img src="./readme/title6.svg"/>

> Using the wireframes and mockups as a guide, AiroWave app with the following features:

### User Screens (Mobile)

| Login Screen                    | Register Screen                      | Landing Screen                        |
| ------------------------------- | -------------------------------------| --------------------------------------|
| <img src="./readme/login.png" width="240">    | <img src="./readme/signup.png" width="240">     | <img src="./readme/health-gif.gif" width="240">   |

---

| Home Screen                     | Heatmap Allergy Screen                  | Heatmap AQI Screen                    |
| ------------------------------ | ---------------------------------------- | -------------------------------------|
| <img src="./readme/sensor-gif.gif" width="240">    | <img src="./readme/heatmap-allergy.png" width="240"> | <img src="./readme/heatmap-aqi.png" width="240"> |

---

| Chatbot Screen                  | Profile Screen                           |
| ------------------------------- | ---------------------------------------- | 
| <img src="./readme/medcat.gif" width="240">  | <img src="./readme/profile.png" width="240">



https://github.com/Alisafa60/airo-wave/assets/149372082/2dc3fb65-5886-4e58-b26d-bab45df20fa7


<br><br>

<br><br>
<img src="./readme/title7.svg"/>

### Curated Dataset for Enhanced AI Insight

Aggregated indoor and outdoor air quality metrics were calculated as averages over number n of last entiers in the database. Additionally, allergens are selected and their severity levels are specified before passing them. And By specifying the user's health condition and condition severity input, insights are tailored for a personalized and targeted analysis.

This approach relies on two functions, where user identification and messages are passed to the first one, with the necessary data to pass to payload and prompt as shown below:

```javascript
async function generateOpenAIPayload(userId, userMessage) {
    
    try {
            ///calcualtions and queries, for reference check airowave/backend/src/controllers/chatbotControllers/chatbot.js///
        const ConditionSeverityInput = (severity) => {
            if (severity >= 4) {
                return 'User health condition severity is high';
            } else if (severity >= 2) {
                return 'Your health condition severity is moderate.';
            } else {
                return 'Your health condition severity is low.';
            }
        };

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
            severity: lastSeverityEntry ? ConditionSeverityInput(lastSeverityEntry.severity) : 'unknown',
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

            Health Condition Severity: ${payload.severity}

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
            - VOC levels: ${payload.indoorSensorData.voc} ppb

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
```
The second function, sendToOpenAI, is then triggered where the chatbot is defined there as follows:

```javascript

  { role: 'system', content: "Your name is MedCat, you mainly care about user's health by analyzing the  provided air quality and allergens. And you give recommendation based speifically on their condition and severity input. You're concise, and can be fun. Don't elaborate a lot. Speak mostly in context of user health condition and enviromental data unless you're asked otherwise" },

```


<br><br>

<img src="./readme/title8.svg"/>

### Deployed on AWS EC2 intance https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/putty.html

- Accessing the instance shell was achieved through [Putty](https://https://putty.org/).
- Below is the nodeJS instance running, where Prisma migrations of existing models was performed with initial seed on PostgreSQL which was installed prior the migration.

| EC2 intance              |
| ------------------------ |
| <img src="./readme/putty.png" width="450"> |



<br><br>

<img src="./readme/title9.svg"/>


Unit testing was performed using supertest, a Node.js library for API testing, designed for Express applications. It is an effective choice for ensuring the reliability and functionality of your API endpoints. Below are examples of testing scenarious using this library.


| Upload a photo           | Upload a photo fail        | Register                     |
| ------------------------ | -------------------------- | ---------------------------- |
| <img src="./readme/test-image.png" width="300"> | <img src="./readme/test-image2.png" width="300"> | <img src="./readme/test-image3.png" width="300"> |


<br><br>
<!-- How to run -->
<img src="./readme/title10.svg"/>

> To set up AiroWave locally, follow these steps:

### Prerequisites

- Install Flutter from: [Flutter](https://docs.flutter.dev/get-started/install/)
- Install NodeJS from: [NodeJS](https://nodejs.org/en/download)
- Install PostgreSQL from: [PostgreSQL](https://www.postgresql.org/download/)
- Install Android Studio from : [Android Studio](https://developer.android.com/studio)

### Installation

1. Install Flutter from 
2. Clone the repository
   ```sh
   git clone https://github.com/alisafa60/airo-wave.git
   ```
3. Install NPM packages and migrate Prisma models
   ```sh
   cd backend
   npm install
   npx prisma migrate dev
   npx prisma generate
   ```
4. Prisma generates then .env file
   ```js
   //.env
    DATABASE_URL="postgresql://user_name:password@systemlocalhost:5432/data_base_name"
    JWT_KEY = <A random string>
    OPENAI_API_KEY=<OpenAI key>
   ```
5. As for the front end, outdoors air quality, pollen forecast, and png heatmap tiles were fetched using Google API with a Google API key.
