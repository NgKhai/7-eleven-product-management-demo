const { body, param, query } = require('express-validator');

const objectId = (field) => body(field).isMongoId().withMessage(`${field} must be a valid id`);

const listProductsValidator = [
  query('page').optional().isInt({ min: 1 }).withMessage('Page must be a positive number'),
  query('limit').optional().isInt({ min: 1, max: 100 }).withMessage('Limit must be 1-100'),
  query('status').optional().isIn(['active', 'inactive', 'out_of_stock']).withMessage('Invalid status'),
  query('categoryId').optional().isMongoId().withMessage('Invalid category id'),
  query('minPrice').optional().isFloat({ min: 0 }).withMessage('Invalid min price'),
  query('maxPrice').optional().isFloat({ min: 0 }).withMessage('Invalid max price'),
];

const createProductValidator = [
  body('name').trim().notEmpty().withMessage('Name is required'),
  body('description').trim().notEmpty().withMessage('Description is required'),
  body('price').isFloat({ min: 0 }).withMessage('Price must be greater than or equal to 0'),
  body('stockQuantity').isInt({ min: 0 }).withMessage('Stock quantity must be greater than or equal to 0'),
  objectId('categoryId'),
  body('status').optional().isIn(['active', 'inactive', 'out_of_stock']).withMessage('Invalid status'),
  body('imageUrls').optional(),
];

const updateProductValidator = [
  param('id').isMongoId().withMessage('Invalid product id'),
  body('name').optional().trim().notEmpty().withMessage('Name cannot be empty'),
  body('description').optional().trim().notEmpty().withMessage('Description cannot be empty'),
  body('price').optional().isFloat({ min: 0 }).withMessage('Price must be greater than or equal to 0'),
  body('stockQuantity').optional().isInt({ min: 0 }).withMessage('Stock quantity must be greater than or equal to 0'),
  body('categoryId').optional().isMongoId().withMessage('Invalid category id'),
  body('status').optional().isIn(['active', 'inactive', 'out_of_stock']).withMessage('Invalid status'),
  body('imageUrls').optional(),
  body('replaceImages').optional().isBoolean().withMessage('replaceImages must be true or false'),
];

const productIdValidator = [
  param('id').isMongoId().withMessage('Invalid product id'),
];

module.exports = {
  listProductsValidator,
  createProductValidator,
  updateProductValidator,
  productIdValidator,
};
