const Category = require('../models/Category.model');
const Product = require('../models/Product.model');
const asyncHandler = require('../utils/asyncHandler');
const { sendSuccess } = require('../utils/apiResponse');
const { AppError } = require('../middleware/error.middleware');

const getCategories = asyncHandler(async (_req, res) => {
  const categories = await Category.find().sort({ name: 1 });
  sendSuccess(res, categories, 'Categories loaded');
});

const createCategory = asyncHandler(async (req, res) => {
  const category = await Category.create(req.body);
  sendSuccess(res, category, 'Category created', 201);
});

const updateCategory = asyncHandler(async (req, res) => {
  const category = await Category.findByIdAndUpdate(req.params.id, req.body, {
    new: true,
    runValidators: true,
  });
  if (!category) throw new AppError('Category not found', 404);
  sendSuccess(res, category, 'Category updated');
});

const deleteCategory = asyncHandler(async (req, res) => {
  const productCount = await Product.countDocuments({ categoryId: req.params.id });
  if (productCount > 0) {
    throw new AppError('Cannot delete a category that still has products', 409);
  }

  const category = await Category.findByIdAndDelete(req.params.id);
  if (!category) throw new AppError('Category not found', 404);
  sendSuccess(res, category, 'Category deleted');
});

module.exports = { getCategories, createCategory, updateCategory, deleteCategory };
