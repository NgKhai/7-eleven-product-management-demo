const express = require('express');
const {
  createProduct,
  deleteProduct,
  getProductById,
  getProducts,
  updateProduct,
} = require('../controllers/product.controller');
const { authenticate } = require('../middleware/auth.middleware');
const { validateRequest } = require('../middleware/error.middleware');
const { requireRole } = require('../middleware/role.middleware');
const { upload } = require('../middleware/upload.middleware');
const {
  createProductValidator,
  listProductsValidator,
  productIdValidator,
  updateProductValidator,
} = require('../utils/validators/product.validator');

const router = express.Router();

router.get('/', listProductsValidator, validateRequest, getProducts);
router.get('/:id', productIdValidator, validateRequest, getProductById);
router.post(
  '/',
  authenticate,
  requireRole('admin'),
  upload.array('images', 5),
  createProductValidator,
  validateRequest,
  createProduct,
);
router.put(
  '/:id',
  authenticate,
  requireRole('admin'),
  upload.array('images', 5),
  updateProductValidator,
  validateRequest,
  updateProduct,
);
router.delete('/:id', authenticate, requireRole('admin'), productIdValidator, validateRequest, deleteProduct);

module.exports = router;
