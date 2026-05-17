const mongoose = require('mongoose');
const Order = require('../models/Order.model');
const Product = require('../models/Product.model');
const asyncHandler = require('../utils/asyncHandler');
const { sendSuccess } = require('../utils/apiResponse');
const { buildPagination } = require('../utils/pagination');
const { AppError } = require('../middleware/error.middleware');

const validTransitions = {
  pending: ['processing', 'cancelled'],
  processing: ['shipping', 'cancelled'],
  shipping: ['delivered'],
  delivered: [],
  cancelled: [],
};

const createOrder = asyncHandler(async (req, res) => {
  const session = await mongoose.startSession();

  try {
    let savedOrder;
    await session.withTransaction(async () => {
      const items = [];
      let totalAmount = 0;

      for (const requestedItem of req.body.items) {
        const product = await Product.findById(requestedItem.productId).session(session);
        if (!product) throw new AppError(`Product not found: ${requestedItem.productId}`, 404);
        if (product.status !== 'active') throw new AppError(`${product.name} is not available`, 400);
        if (product.stockQuantity < requestedItem.quantity) {
          throw new AppError(`Not enough stock for ${product.name}`, 400);
        }

        const subtotal = product.price * requestedItem.quantity;
        totalAmount += subtotal;
        items.push({
          productId: product._id,
          productName: product.name,
          imageUrl: product.images?.[0]?.url || '',
          quantity: requestedItem.quantity,
          unitPrice: product.price,
          subtotal,
        });

        await Product.updateOne(
          { _id: product._id, stockQuantity: { $gte: requestedItem.quantity } },
          { $inc: { stockQuantity: -requestedItem.quantity } },
          { session },
        );
      }

      const [order] = await Order.create([{
        customerId: req.user._id,
        items,
        totalAmount,
        shippingAddress: req.body.shippingAddress,
        note: req.body.note || '',
        statusHistory: [{ status: 'pending', note: 'Order placed', updatedBy: req.user._id }],
      }], { session });

      savedOrder = order;
    });

    const populated = await Order.findById(savedOrder._id).populate('customerId', 'name email phone');
    sendSuccess(res, populated, 'Order placed', 201);
  } finally {
    await session.endSession();
  }
});

const listOrders = (ownerOnly) => asyncHandler(async (req, res) => {
  const query = {};
  if (ownerOnly) query.customerId = req.user._id;
  if (req.query.status) query.status = req.query.status;

  const { skip, limit, meta } = await buildPagination(Order, query, req.query.page, req.query.limit);
  const orders = await Order.find(query)
    .populate('customerId', 'name email phone')
    .sort({ createdAt: -1 })
    .skip(skip)
    .limit(limit);

  sendSuccess(res, orders, 'Orders loaded', 200, meta);
});

const getOrderById = asyncHandler(async (req, res) => {
  const order = await Order.findById(req.params.id).populate('customerId', 'name email phone address');
  if (!order) throw new AppError('Order not found', 404);

  const isOwner = String(order.customerId._id) === String(req.user._id);
  if (req.user.role !== 'admin' && !isOwner) {
    throw new AppError('You can only view your own orders', 403);
  }

  sendSuccess(res, order, 'Order loaded');
});

const updateOrderStatus = asyncHandler(async (req, res) => {
  const order = await Order.findById(req.params.id);
  if (!order) throw new AppError('Order not found', 404);

  if (!validTransitions[order.status].includes(req.body.status)) {
    throw new AppError(`Cannot move order from ${order.status} to ${req.body.status}`, 400);
  }

  order.status = req.body.status;
  order.statusHistory.push({
    status: req.body.status,
    note: req.body.note || '',
    updatedBy: req.user._id,
  });
  await order.save();

  const populated = await order.populate('customerId', 'name email phone');
  sendSuccess(res, populated, 'Order status updated');
});

module.exports = {
  createOrder,
  getAllOrders: listOrders(false),
  getMyOrders: listOrders(true),
  getOrderById,
  updateOrderStatus,
};
