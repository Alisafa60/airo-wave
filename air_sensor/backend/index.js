const { ReadlineParser } = require('serialport');

const SerialPort = require('serialport').SerialPort;
const Readline = require('@serialport/parser-readline').ReadlineParser;


const serialPort = new SerialPort(
  {path: "COM4",
  baudRate: 9600},
);

const parser = serialPort.pipe(new ReadlineParser({ delimiter: '\r\n' }));
let receivedData = [];
serialPort.on('open', onOpen);
parser.on('data', onData);

function onOpen() {
  console.log('Open connection');
}

function onData(data) {
  console.log(`Received data: ${data}`);
  receivedData.push(data);
}

serialPort.on('error', (err) => {
  console.error('Error with serial port:', err);
});