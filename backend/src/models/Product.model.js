const mongoose = require('mongoose');

const productImageSchema = new mongoose.Schema({
  url: { type: String, required: true },
  publicId: { type: String, default: '' },
}, { _id: false });

const productSchema = new mongoose.Schema({
  name: { type: String, required: true, trim: true },
  description: { type: String, required: true },
  price: { type: Number, required: true, min: 0 },
  stockQuantity: { type: Number, required: true, min: 0, default: 0 },
  categoryId: { type: mongoose.Schema.Types.ObjectId, ref: 'Category', required: true },
  images: [productImageSchema],
  status: {
    type: String,
    enum: ['active', 'inactive', 'out_of_stock'],
    default: 'active',
  },
  viewCount: { type: Number, default: 0 },
  createdBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
}, { timestamps: true });

productSchema.index({ name: 'text', description: 'text' });
productSchema.index({ categoryId: 1, price: 1 });

productSchema.pre('save', function updateStockStatus(next) {
  if (this.stockQuantity === 0) {
    this.status = 'out_of_stock';
  } else if (this.status === 'out_of_stock') {
    this.status = 'active';
  }
  next();
});

module.exports = mongoose.model('Product', productSchema);
