const express = require('express');

const handleError = (res, error, customMessage) => {
    console.error(customMessage || 'An error occurred:', error);
    res.status(500).json({ error: customMessage || 'Internal Server Error' });
  };

  const healthRoutes = (router, controller, basePath = '/user/health') => {
    router.post(`${basePath}`, controller.add);
    router.get(`${basePath}`, controller.getAll);
    router.get(`${basePath}/:id`, controller.getById);
    router.put(`${basePath}/:id`, controller.updateById);
    router.delete(`${basePath}/:id`, controller.deleteById);
  
    return router;
  };

  module.exports = {
    handleError,
    healthRoutes
  };