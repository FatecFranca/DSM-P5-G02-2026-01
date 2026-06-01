import { Router } from "express";
import { authMiddleware } from "../middlewares/autentication";
import { diagnosticoRiscoController } from "../controllers/diagnosticos";

const router = Router();

router.post("/risco", authMiddleware, diagnosticoRiscoController);

export default router;
