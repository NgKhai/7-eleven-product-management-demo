const Product = require('../models/Product.model');
const asyncHandler = require('../utils/asyncHandler');
const { sendSuccess } = require('../utils/apiResponse');
const { buildPagination } = require('../utils/pagination');
const { AppError } = require('../middleware/error.middleware');
const { deleteCloudinaryImages, uploadProductImages } = require('../middleware/upload.middleware');

const parseImageUrls = (value) => {
  if (!value) return [];
  if (Array.isArray(value)) return value.filter(Boolean).map((url) => ({ url }));
  try {
    const decoded = JSON.parse(value);
    return Array.isArray(decoded) ? decoded.filter(Boolean).map((url) => ({ url })) : [];
  } catch (_error) {
    return String(value).split(',').map((url) => url.trim()).filter(Boolean).map((url) => ({ url }));
  }
};

const buildProductQuery = (queryParams) => {
  const { search, status, categoryId, minPrice, maxPrice } = queryParams;
  const query = {};

  if (search) query.$text = { $search: search };
  if (status) query.status = status;
  if (categoryId) query.categoryId = categoryId;
  if (minPrice || maxPrice) {
    query.price = {};
    if (minPrice) query.price.$gte = Number(minPrice);
    if (maxPrice) query.price.$lte = Number(maxPrice);
  }

  return query;
};

const getProducts = asyncHandler(async (req, res) => {
  const query = buildProductQuery(req.query);
  const { skip, limit, meta } = await buildPagination(Product, query, req.query.page, req.query.limit);
  const sort = req.query.search ? { score: { $meta: 'textScore' } } : { createdAt: -1 };
  const projection = req.query.search ? { score: { $meta: 'textScore' } } : {};

  const products = await Product.find(query, projection)
    .populate('categoryId', 'name')
    .sort(sort)
    .skip(skip)
    .limit(limit);

  sendSuccess(res, products, 'Products loaded', 200, meta);
});

const getProductById = asyncHandler(async (req, res) => {
  const product = await Product.findByIdAndUpdate(
    req.params.id,
    { $inc: { viewCount: 1 } },
    { new: true },
  ).populate('categoryId', 'name');

  if (!product) throw new AppError('Product not found', 404);
  sendSuccess(res, product, 'Product loaded');
});

const createProduct = asyncHandler(async (req, res) => {
  const uploadedImages = await uploadProductImages(req.files);
  const manualImages = parseImageUrls(req.body.imageUrls);
  const product = await Product.create({
    ...req.body,
    images: [...uploadedImages, ...manualImages],
    createdBy: req.user._id,
  });

  const populated = await product.populate('categoryId', 'name');
  sendSuccess(res, populated, 'Product created', 201);
});

const updateProduct = asyncHandler(async (req, res) => {
  const product = await Product.findById(req.params.id);
  if (!product) throw new AppError('Product not found', 404);

  const uploadedImages = await uploadProductImages(req.files);
  const manualImages = parseImageUrls(req.body.imageUrls);
  const incomingImages = [...uploadedImages, ...manualImages];
  const replaceImages = req.body.replaceImages === true || req.body.replaceImages === 'true';

  Object.assign(product, {
    name: req.body.name ?? product.name,
    description: req.body.description ?? product.description,
    price: req.body.price ?? product.price,
    stockQuantity: req.body.stockQuantity ?? product.stockQuantity,
    categoryId: req.body.categoryId ?? product.categoryId,
    status: req.body.status ?? product.status,
  });

  if (incomingImages.length) {
    if (replaceImages) await deleteCloudinaryImages(product.images);
    product.images = replaceImages ? incomingImages : [...product.images, ...incomingImages];
  }

  await product.save();
  const populated = await product.populate('categoryId', 'name');
  sendSuccess(res, populated, 'Product updated');
});

const deleteProduct = asyncHandler(async (req, res) => {
  const product = await Product.findByIdAndDelete(req.params.id);
  if (!product) throw new AppError('Product not found', 404);
  await deleteCloudinaryImages(product.images);
  sendSuccess(res, product, 'Product deleted');
});

module.exports = { getProducts, getProductById, createProduct, updateProduct, deleteProduct };
