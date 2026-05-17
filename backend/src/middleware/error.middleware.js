const { validationResult } = require('express-validator');
const { sendError } = require('../utils/apiResponse');

class AppError extends Error {
  constructor(message, statusCode = 500, errors = undefined) {
    super(message);
    this.statusCode = statusCode;
    this.errors = errors;
  }
}

const validateRequest = (req, _res, next) => {
  const result = validationResult(req);
  if (result.isEmpty()) return next();

  const errors = result.array().map((item) => ({
    field: item.path,
    message: item.msg,
  }));
  return next(new AppError('Validation failed', 400, errors));
};

const notFoundHandler = (req, _res, next) => {
  next(new AppError(`Route not found: ${req.method} ${req.originalUrl}`, 404));
};

const errorHandler = (error, _req, res, _next) => {
  const statusCode = error.statusCode || 500;
  const message = statusCode === 500 ? 'Internal server error' : error.message;

  if (statusCode === 500) {
    console.error(error);
  }

  sendError(res, message, statusCode, error.errors);
};

module.exports = { AppError, validateRequest, notFoundHandler, errorHandler };
