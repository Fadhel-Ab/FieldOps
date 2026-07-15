const authService = require("../services/authService");
const activeTokens = require("../data/tokenStore");

async function login(req, res) {
  try {
    const { email, password } = req.body;

    const result = await authService.login(email, password);

    res.json(result);
  } catch (error) {
    res.status(401).json({
      message: error.message,
    });
  }
}

async function logout(req, res) {
  const authHeader = req.headers.authorization;
  const token = authHeader.split(" ")[1];

  const index = activeTokens.findIndex((session) => session.token === token);

  if (index !== -1) {
    activeTokens.splice(index, 1);
  }

  return res.status(200).json({
    message: "Logged out successfully",
  });
}

module.exports = {
  login,
  logout,
};
