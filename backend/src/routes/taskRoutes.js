import express from "express";
import { getTasks, updateTask } from "../controllers/taskController.js";
import authenticate from "../middleware/authMiddleware.js";
import upload from "../middleware/uploadMiddleware.js";

const router = express.Router();


router.get("/", authenticate, getTasks);


router.put(
  "/:id",
  authenticate,
  updateTask
);

export default router;