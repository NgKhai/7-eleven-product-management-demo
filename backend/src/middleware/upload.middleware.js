const multer = require('multer');
const env = require('../config/env');
const { cloudinary, isCloudinaryConfigured } = require('../config/cloudinary');
const { AppError } = require('./error.middleware');

const upload = multer({
  storage: multer.memoryStorage(),
  limits: {
    files: 5,
    fileSize: 5 * 1024 * 1024,
  },
  fileFilter: (_req, file, cb) => {
    if (!file.mimetype.startsWith('image/')) {
      return cb(new AppError('Only image uploads are allowed', 400));
    }
    return cb(null, true);
  },
});

const uploadBufferToCloudinary = (file) => {
  if (!isCloudinaryConfigured()) {
    return Promise.reject(new AppError('Cloudinary is not configured on the API server', 500));
  }

  return new Promise((resolve, reject) => {
    const stream = cloudinary.uploader.upload_stream(
      {
        folder: env.cloudinary.folder,
        resource_type: 'image',
        use_filename: true,
        unique_filename: true,
        overwrite: false,
      },
      (error, result) => {
        if (error) return reject(error);
        return resolve({ url: result.secure_url, publicId: result.public_id });
      },
    );

    stream.end(file.buffer);
  });
};

const uploadProductImages = async (files = []) => {
  if (!files.length) return [];
  return Promise.all(files.map(uploadBufferToCloudinary));
};

const deleteCloudinaryImages = async (images = []) => {
  if (!isCloudinaryConfigured()) return;
  const publicIds = images.map((image) => image.publicId).filter(Boolean);
  if (!publicIds.length) return;
  await Promise.all(publicIds.map((publicId) => cloudinary.uploader.destroy(publicId)));
};

module.exports = { upload, uploadProductImages, deleteCloudinaryImages };
