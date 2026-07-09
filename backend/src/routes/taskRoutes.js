// @ts-check
const express = require("express");
const router = express.Router();
const upload = require("../middlewares/uploadMiddleware");
const authenticate = require("../middlewares/authMiddleware");
const {
    getTasks,
    updateTask
} = require("../controllers/taskController");
router.get("/", authenticate, getTasks);


router.put(
  "/:id",
  authenticate,
 upload.single("image"),
  updateTask
);

module.exports = router;