import { Router } from "express";
import { authMiddleware } from "../middlewares/autentication";
import {
  createExameController,
  listExamesController,
  getExameByIdController,
  updateExameController,
  deleteExameController,
} from "../controllers/exames";

const router = Router();

router.use(authMiddleware);
router.post("/", createExameController);
router.get("/", listExamesController);
router.get("/:id", getExameByIdController);
router.put("/:id", updateExameController);
router.delete("/:id", deleteExameController);

export default router;
