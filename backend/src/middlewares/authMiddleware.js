const jwt = require("jsonwebtoken");
const activeTokens = require("../data/tokenStore");

function authMiddleware(req, res, next) {
  const authHeader = req.headers.authorization;

  if (!authHeader) {
    return res.status(401).json({
      message: "No token provided",
    });
  }

  const token = authHeader.split(" ")[1];
  const session = activeTokens.find((t) => t.token === token);

  if (!session) {
    return res.status(401).json({
      message: "Session expired or user is not logged in",
    });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    req.user = decoded;

    next();
  } catch (error) {
    return res.status(401).json({
      message: "Invalid or expired JWT",
    });
  }
}

module.exports = authMiddleware;
