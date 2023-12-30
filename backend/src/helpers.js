const handleError = (res, error, customMessage) => {
    console.error(customMessage || 'An error occurred:', error);
    res.status(500).json({ error: customMessage || 'Internal Server Error' });
  };
  
  module.exports = {
    handleError,
  };