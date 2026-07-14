const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const activeTokens = require("../data/tokenStore");

const userRepository = require("../repositories/userRepository");

async function login(email, password) {
  const user = userRepository.findUserByEmail(email);

  if (!user) {
    throw new Error("User not found");
  }

  const passwordMatch = password === user.password;

  if (!passwordMatch) {
    throw new Error("Invalid password");
  }

  const token = jwt.sign(
    {
      id: user.id,
      email: user.email,
    },
    process.env.JWT_SECRET,
    {
      expiresIn: "1h",
    },
  );
  activeTokens.push({
    token,
    userId: user.id,
  });

  return {
    token,
  };
}

module.exports = {
  login,
};
