const path = require('path');
const fs = require('fs');
const solc = require('solc');

const medriscPath = path.resolve(__dirname, 'contracts', 'Medrisc.sol');
const source = fs.readFileSync(medriscPath, 'utf8');

module.exports = solc.compile(source, 1).contracts[':Medrisc'];
