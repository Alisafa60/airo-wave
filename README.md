<img src="./readme/title1.svg"/>

<br><br>

<!-- project philosophy -->
<img src="./readme/title2.svg"/>

> A mobile app for optimizing health management with real-time enviromental data.
>
> This app combines user profiles, medical history, symptom tracking, and real-time indoor and outdoor environmental data with heatmap visuals. It uses AI analysis to offer personalized recommendations.

### User Stories
- As an individual with respiratory problems, I need to monitor and receive real-time alerts about the air quality of my current location and those I plan to visit.
- As a cyclist with allergies, I want to access real-time environmental data on pollen levels and air quality as I plan for an activity to minimize allergens.
- As a healthcare professional, I need access to real-time environmental data alongside my patients' health information, enabling me to make informed clinical assessments and provide tailored recommendations.

<br><br>

<!-- Prototyping -->
<img src="./readme/title3.svg"/>

###  AiroWave is built using the following technologies:

-  This project uses the [Flutter app development framework](https://flutter.dev/). Flutter is a cross-platform hybrid app development platform that allows us to use a single codebase for apps on mobile, desktop, and the web.
- For Database, the app utilizes [PostgreSQL](https://www.postgresql.org/) as the backend database management system, providing a robust and scalable solution for data storage.
- The backend is implemented using [Node.js](https://nodejs.org/) along with [Prisma](https://www.prisma.io/) for efficient and type-safe database access and smooth communication.
- To monitor indoor air quality, the project incorporates an [Arduino Uno]([https://www.arduino.cc](https://store.arduino.cc/products/arduino-uno-rev3/) with a [CSS811 air quality sensor](https://learn.adafruit.com/adafruit-ccs811-air-quality-sensor/overview). This hardware component enables real-time tracking and analysis of indoor air quality parameters.
- For outdoor air quality data, the app integrates data from [Google's Air Quality API](https://developers.google.com/maps/documentation/urls/get-started#directions-action) to provide users with information about the air quality in their outdoor surroundings.
- To track plant/pollen allergens, the project leverages data from [Google's Pollen API](https://www.google.com/search?q=pollen+api) to give users insights into plant-related allergens in their area.
- For visualizing data on maps, the project integrates png heatmap tiles on maps from [Google Maps Platform](https://cloud.google.com/maps-platform/), enhancing the user experience with geospatial information.
- The project incorporates a chatbot powered by [OpenAI](https://www.openai.com/) to analyze the data and provide with personalized recommendations.

<br><br>

<!-- Implementation -->
<img src="./readme/title4.svg"/>

> We designed AiroWave using wireframes and mockups, iterating on the design until we reached the ideal layout for easy navigation and a seamless user experience.


### Mockups
| Home screen  | Health Screen | Order Screen |
| ---| ---| ---|
| ![Landing](./readme/home.png) | ![fsdaf](./readme/medcat.png) | ![fsdaf](./readme/profile.png) |

<br><bar>

> Using the wireframes and mockups as a guide, we implemented the Coffee Express app with the following features:

### User Screens (Mobile)
| Login screen  | Register screen | Landing screen | Loading screen |
| ---| ---| ---| ---|
| ![Landing](https://placehold.co/900x1600) | ![fsdaf](https://placehold.co/900x1600) | ![fsdaf](https://placehold.co/900x1600) | ![fsdaf](https://placehold.co/900x1600) |
| Home screen  | Menu Screen | Order Screen | Checkout Screen |
| ![Landing](https://placehold.co/900x1600) | ![fsdaf](https://placehold.co/900x1600) | ![fsdaf](https://placehold.co/900x1600) | ![fsdaf](https://placehold.co/900x1600) |


<br><br>

<!-- Tech stack -->
<img src="./readme/title5.svg"/>



<br><br>
<img src="./readme/title6.svg"/>
<br><br>

<br><br>
<img src="./readme/title7.svg"/>
<br><br>

<br><br>
<img src="./readme/title8.svg"/>
<br><br>

<img src="./readme/title9.svg"/>
<br><br>
<!-- How to run -->
<img src="./readme/title10svg"/>
> To set up Coffee Express locally, follow these steps:

### Prerequisites

This is an example of how to list things you need to use the software and how to install them.
* npm
  ```sh
  npm install npm@latest -g
  ```

### Installation

_Below is an example of how you can instruct your audience on installing and setting up your app. This template doesn't rely on any external dependencies or services._

1. Get a free API Key at [https://example.com](https://example.com)
2. Clone the repo
   ```sh
   git clone https://github.com/your_username_/Project-Name.git
   ```
3. Install NPM packages
   ```sh
   npm install
   ```
4. Enter your API in `config.js`
   ```js
   const API_KEY = 'ENTER YOUR API';
   ```

Now, you should be able to run Coffee Express locally and explore its features.
