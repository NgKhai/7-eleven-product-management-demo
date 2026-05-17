const { body, param, query } = require('express-validator');

const createOrderValidator = [
  body('items').isArray({ min: 1 }).withMessage('Order must contain at least one item'),
  body('items.*.productId').isMongoId().withMessage('Each product id must be valid'),
  body('items.*.quantity').isInt({ min: 1 }).withMessage('Quantity must be at least 1'),
  body('shippingAddress').trim().notEmpty().withMessage('Shipping address is required'),
  body('note').optional().trim(),
];

const updateOrderStatusValidator = [
  param('id').isMongoId().withMessage('Invalid order id'),
  body('status').isIn(['pending', 'processing', 'shipping', 'delivered', 'cancelled']).withMessage('Invalid status'),
  body('note').optional().trim(),
];

const listOrdersValidator = [
  query('page').optional().isInt({ min: 1 }).withMessage('Page must be a positive number'),
  query('limit').optional().isInt({ min: 1, max: 100 }).withMessage('Limit must be 1-100'),
  query('status').optional().isIn(['pending', 'processing', 'shipping', 'delivered', 'cancelled']).withMessage('Invalid status'),
];

const orderIdValidator = [
  param('id').isMongoId().withMessage('Invalid order id'),
];

module.exports = {
  createOrderValidator,
  updateOrderStatusValidator,
  listOrdersValidator,
  orderIdValidator,
};
