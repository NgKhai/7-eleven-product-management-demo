const cloudinary = require('cloudinary').v2;
const env = require('./env');

if (env.cloudinary.cloudName && env.cloudinary.apiKey && env.cloudinary.apiSecret) {
  cloudinary.config({
    cloud_name: env.cloudinary.cloudName,
    api_key: env.cloudinary.apiKey,
    api_secret: env.cloudinary.apiSecret,
  });
}

const isCloudinaryConfigured = () => {
  const config = cloudinary.config();
  return Boolean(config.cloud_name && config.api_key && config.api_secret);
};

module.exports = { cloudinary, isCloudinaryConfigured };
