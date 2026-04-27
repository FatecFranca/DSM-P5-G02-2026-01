import { Router } from "express";
import { authMiddleware } from "../middlewares/autentication";
import {
  createUsuarioController,
  listUsuariosController,
  getUsuarioByIdController,
  updateUsuarioController,
  deleteUsuarioController
} from "../controllers/usuarios";

const router = Router();

router.use(authMiddleware);

router.post("/", createUsuarioController);
router.get("/", listUsuariosController);
router.get("/:id", getUsuarioByIdController);
router.put("/:id", updateUsuarioController);
router.delete("/:id", deleteUsuarioController);

export default router;
