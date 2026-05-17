const buildPagination = async (model, query, page = 1, limit = 12) => {
  const safePage = Math.max(Number(page) || 1, 1);
  const safeLimit = Math.min(Math.max(Number(limit) || 12, 1), 100);
  const totalItems = await model.countDocuments(query);
  const totalPages = Math.max(Math.ceil(totalItems / safeLimit), 1);

  return {
    skip: (safePage - 1) * safeLimit,
    limit: safeLimit,
    meta: {
      page: safePage,
      limit: safeLimit,
      totalItems,
      totalPages,
      hasNextPage: safePage < totalPages,
      hasPreviousPage: safePage > 1,
    },
  };
};

module.exports = { buildPagination };
