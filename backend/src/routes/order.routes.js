const express = require('express');
const {
  createOrder,
  getAllOrders,
  getMyOrders,
  getOrderById,
  updateOrderStatus,
} = require('../controllers/order.controller');
const { authenticate } = require('../middleware/auth.middleware');
const { validateRequest } = require('../middleware/error.middleware');
const { requireRole } = require('../middleware/role.middleware');
const {
  createOrderValidator,
  listOrdersValidator,
  orderIdValidator,
  updateOrderStatusValidator,
} = require('../utils/validators/order.validator');

const router = express.Router();

router.use(authenticate);

router.post('/', requireRole('user', 'admin'), createOrderValidator, validateRequest, createOrder);
router.get('/my', listOrdersValidator, validateRequest, getMyOrders);
router.get('/', requireRole('admin'), listOrdersValidator, validateRequest, getAllOrders);
router.get('/:id', orderIdValidator, validateRequest, getOrderById);
router.patch('/:id/status', requireRole('admin'), updateOrderStatusValidator, validateRequest, updateOrderStatus);

module.exports = router;
