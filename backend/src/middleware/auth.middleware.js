const jwt = require('jsonwebtoken');
const env = require('../config/env');
const User = require('../models/User.model');
const asyncHandler = require('../utils/asyncHandler');
const { AppError } = require('./error.middleware');

const authenticate = asyncHandler(async (req, _res, next) => {
  const header = req.headers.authorization || '';
  const token = header.startsWith('Bearer ') ? header.slice(7) : null;

  if (!token) {
    throw new AppError('Authentication token is required', 401);
  }

  const payload = jwt.verify(token, env.jwtSecret);
  const user = await User.findById(payload.id).select('-password');
  if (!user || !user.isActive) {
    throw new AppError('Invalid or inactive user', 401);
  }

  req.user = user;
  next();
});

module.exports = { authenticate };
