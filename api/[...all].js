const handler = require('../preview/server.js');

module.exports = (req, res) => {
    return handler(req, res);
};
