const express = require('express');
const { body, param } = require('express-validator');
const {
  createCategory,
  deleteCategory,
  getCategories,
  updateCategory,
} = require('../controllers/category.controller');
const { authenticate } = require('../middleware/auth.middleware');
const { validateRequest } = require('../middleware/error.middleware');
const { requireRole } = require('../middleware/role.middleware');

const router = express.Router();

const categoryValidator = [
  body('name').trim().notEmpty().withMessage('Name is required'),
  body('description').optional().trim(),
  body('imageUrl').optional().trim(),
  body('isActive').optional().isBoolean().withMessage('isActive must be boolean'),
];

const idValidator = [param('id').isMongoId().withMessage('Invalid category id')];

router.get('/', getCategories);
router.post('/', authenticate, requireRole('admin'), categoryValidator, validateRequest, createCategory);
router.put('/:id', authenticate, requireRole('admin'), idValidator, categoryValidator, validateRequest, updateCategory);
router.delete('/:id', authenticate, requireRole('admin'), idValidator, validateRequest, deleteCategory);

module.exports = router;
