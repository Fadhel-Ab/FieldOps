const express = require("express");
const authController = require("../controllers/authController");
const router = express.Router();
const authMiddleware = require("../middlewares/authMiddleware");
router.post("/login", authController.login);
router.post("/logout", authMiddleware, authController.logout);

module.exports = router;
