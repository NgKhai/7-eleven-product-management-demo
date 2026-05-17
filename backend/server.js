const app = require('./src/app');
const { connectDB } = require('./src/config/database');
const env = require('./src/config/env');

const start = async () => {
  await connectDB();
  app.listen(env.port, () => {
    console.log(`API listening on http://localhost:${env.port}/api`);
  });
};

start().catch((error) => {
  console.error('Failed to start API:', error);
  process.exit(1);
});
