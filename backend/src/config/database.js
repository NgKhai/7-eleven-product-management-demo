const mongoose = require('mongoose');
const env = require('./env');

let cachedConnection = null;

const connectDB = async () => {
  if (cachedConnection) {
    console.log('Using cached MongoDB connection');
    return cachedConnection;
  }
  mongoose.set('strictQuery', true);
  const connection = await mongoose.connect(env.mongoUri);
  cachedConnection = connection;
  console.log(`MongoDB connected: ${connection.connection.host}`);
  return connection;
};

module.exports = { connectDB };
