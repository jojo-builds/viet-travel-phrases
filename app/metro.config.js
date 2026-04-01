const path = require('path');
const { getDefaultConfig } = require('expo/metro-config');
const { withNativeWind } = require('nativewind/metro');

const config = getDefaultConfig(__dirname);
const input = path.resolve(__dirname, 'global.css').replace(/\\/g, '/');

module.exports = withNativeWind(config, { input });
