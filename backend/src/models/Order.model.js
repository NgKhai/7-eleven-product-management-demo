const mongoose = require('mongoose');

const orderItemSchema = new mongoose.Schema({
  productId: { type: mongoose.Schema.Types.ObjectId, ref: 'Product', required: true },
  productName: { type: String, required: true },
  imageUrl: { type: String, default: '' },
  quantity: { type: Number, required: true, min: 1 },
  unitPrice: { type: Number, required: true, min: 0 },
  subtotal: { type: Number, required: true, min: 0 },
}, { _id: false });

const statusHistorySchema = new mongoose.Schema({
  status: {
    type: String,
    enum: ['pending', 'processing', 'shipping', 'delivered', 'cancelled'],
    required: true,
  },
  note: { type: String, default: '' },
  updatedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
}, { timestamps: true });

const orderSchema = new mongoose.Schema({
  orderNumber: { type: String, unique: true },
  customerId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  items: [orderItemSchema],
  totalAmount: { type: Number, required: true, min: 0 },
  status: {
    type: String,
    enum: ['pending', 'processing', 'shipping', 'delivered', 'cancelled'],
    default: 'pending',
  },
  shippingAddress: { type: String, required: true },
  note: { type: String, default: '' },
  statusHistory: [statusHistorySchema],
}, { timestamps: true });

orderSchema.pre('save', async function setOrderNumber(next) {
  if (this.orderNumber) return next();
  const now = new Date();
  const date = `${now.getFullYear()}${String(now.getMonth() + 1).padStart(2, '0')}${String(now.getDate()).padStart(2, '0')}`;
  const count = await mongoose.model('Order').countDocuments({
    createdAt: {
      $gte: new Date(now.getFullYear(), now.getMonth(), now.getDate()),
      $lt: new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1),
    },
  });
  this.orderNumber = `ORD-${date}-${String(count + 1).padStart(4, '0')}`;
  return next();
});

module.exports = mongoose.model('Order', orderSchema);
