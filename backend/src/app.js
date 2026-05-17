const cors = require('cors');
const express = require('express');
const morgan = require('morgan');

const env = require('./config/env');
const authRoutes = require('./routes/auth.routes');
const categoryRoutes = require('./routes/category.routes');
const orderRoutes = require('./routes/order.routes');
const productRoutes = require('./routes/product.routes');
const { errorHandler, notFoundHandler } = require('./middleware/error.middleware');

const app = express();

app.use(cors({ origin: env.clientUrl === '*' ? true : env.clientUrl, credentials: true }));
app.use(express.json({ limit: '1mb' }));
app.use(express.urlencoded({ extended: true }));

if (env.nodeEnv !== 'test') {
  app.use(morgan('dev'));
}

app.get('/api/health', (_req, res) => {
  res.json({ success: true, message: 'API is healthy' });
});

app.use('/api/auth', authRoutes);
app.use('/api/categories', categoryRoutes);
app.use('/api/products', productRoutes);
app.use('/api/orders', orderRoutes);

app.use(notFoundHandler);
app.use(errorHandler);

module.exports = app;
