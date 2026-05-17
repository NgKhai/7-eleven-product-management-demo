const sendSuccess = (res, data = null, message = 'Success', statusCode = 200, meta = undefined) => {
  res.status(statusCode).json({ success: true, message, data, ...(meta ? { meta } : {}) });
};

const sendError = (res, message = 'Something went wrong', statusCode = 500, errors = undefined) => {
  res.status(statusCode).json({ success: false, message, ...(errors ? { errors } : {}) });
};

module.exports = { sendSuccess, sendError };
