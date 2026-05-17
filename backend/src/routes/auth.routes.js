const express = require('express');
const { getMe, login, register } = require('../controllers/auth.controller');
const { authenticate } = require('../middleware/auth.middleware');
const { validateRequest } = require('../middleware/error.middleware');
const { loginValidator, registerValidator } = require('../utils/validators/auth.validator');

const router = express.Router();

router.post('/register', registerValidator, validateRequest, register);
router.post('/login', loginValidator, validateRequest, login);
router.get('/me', authenticate, getMe);

module.exports = router;
