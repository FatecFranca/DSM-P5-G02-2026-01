import { Request, Response } from "express";
import { DiagnosticoInputSchema } from "../types/diagnostico";
import { analisarRiscoAtaqueCardiaco } from "../services/diagnosticos";

export async function diagnosticoRiscoController(req: Request, res: Response) {
  const parsed = DiagnosticoInputSchema.safeParse(req.body);

  if (!parsed.success) {
    return res.status(400).json({
      success: false,
      error: "Dados de exame invalidos",
      details: parsed.error.flatten(),
    });
  }

  try {
    const resultado = analisarRiscoAtaqueCardiaco(parsed.data);
    return res.status(200).json({
      success: true,
      data: resultado,
    });
  } catch (error) {
    const message =
      error instanceof Error ? error.message : "Falha ao processar diagnostico.";

    return res.status(500).json({
      success: false,
      error: message,
    });
  }
}
