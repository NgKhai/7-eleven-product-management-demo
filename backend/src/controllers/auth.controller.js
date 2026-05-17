const jwt = require('jsonwebtoken');
const env = require('../config/env');
const User = require('../models/User.model');
const asyncHandler = require('../utils/asyncHandler');
const { sendSuccess } = require('../utils/apiResponse');
const { AppError } = require('../middleware/error.middleware');

const signToken = (user) => jwt.sign({ id: user._id, role: user.role }, env.jwtSecret, {
  expiresIn: env.jwtExpiresIn,
});

const serializeUser = (user) => ({
  id: user._id,
  name: user.name,
  email: user.email,
  role: user.role,
  phone: user.phone,
  address: user.address,
});

const register = asyncHandler(async (req, res) => {
  const { name, email, password, role, phone, address } = req.body;
  const exists = await User.exists({ email });
  if (exists) throw new AppError('Email is already registered', 409);

  const user = await User.create({ name, email, password, role: role || 'user', phone, address });
  const token = signToken(user);
  sendSuccess(res, { user: serializeUser(user), token }, 'Registered successfully', 201);
});

const login = asyncHandler(async (req, res) => {
  const { email, password } = req.body;
  const user = await User.findOne({ email }).select('+password');
  if (!user || !(await user.comparePassword(password))) {
    throw new AppError('Invalid email or password', 401);
  }
  if (!user.isActive) throw new AppError('Your account is inactive', 403);

  const token = signToken(user);
  sendSuccess(res, { user: serializeUser(user), token }, 'Logged in successfully');
});

const getMe = asyncHandler(async (req, res) => {
  sendSuccess(res, { user: serializeUser(req.user) }, 'Current user loaded');
});

module.exports = { register, login, getMe };
