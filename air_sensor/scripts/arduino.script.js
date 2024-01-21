const { ReadlineParser } = require('serialport');
const http = require('http');
const SerialPort = require('serialport').SerialPort;
const Readline = require('@serialport/parser-readline').ReadlineParser;

const serialPort = new SerialPort(
  { path: "COM4", baudRate: 9600 },
);

const parser = serialPort.pipe(new Readline({ delimiter: '\r\n' }));
let receivedData = [];

serialPort.on('open', onOpen);
parser.on('data', onData);

function onOpen() {
  console.log('Open connection');
}

function onData(data) {
  console.log(`Received data: ${data}`);
  receivedData.push(data);

  const match = data.match(/CO2: (\d+)ppm, TVOC: (\d+)/);

  if (match) {
    const co2 = match[1];
    const voc = match[2];

    console.log(`the value of co2 and is: ${co2} and ${voc}`);
    sendDataToBackend({ co2, voc });
  } else {
    console.error('Invalid data format:', data);
  }
}

function sendDataToBackend(data) {
  const postData = JSON.stringify(data);

  const options = {
    hostname: '172.25.135.58',
    port: 3000,
    path: '/api/sensor-data',
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
  };

  const req = http.request(options, (res) => {
    let responseData = '';

    res.on('data', (chunk) => {
      responseData += chunk;
    });

    res.on('end', () => {
      console.log(responseData);
    });
  });

  req.on('error', (error) => {
    console.error('Error sending data to backend:', error.message);
  });

  req.write(postData);
  req.end();
}

serialPort.on('error', (err) => {
  console.error('Error with serial port:', err);
});
