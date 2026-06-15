import { Request, Response } from "express";
import * as examesModel from "../models/exames";
import { ExameSchema, ExameUpdateSchema } from "../types/exame";

export async function createExameController(req: Request, res: Response) {
  try {
    const parsed = ExameSchema.safeParse(req.body);
    if (!parsed.success) {
      return res.status(400).json({ errors: parsed.error.flatten() });
    }

    const exame = await examesModel.createExame(parsed.data);
    if (!exame) {
      return res.status(400).json({ error: "Erro ao criar exame" });
    }

    return res.status(201).json({ success: true, data: exame });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: "Erro ao criar exame",
      error: error instanceof Error ? error.message : "Erro desconhecido",
    });
  }
}

export async function listExamesController(_req: Request, res: Response) {
  try {
    const exames = await examesModel.listExames();
    return res.json({ success: true, data: exames });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: "Erro ao listar exames",
      error: error instanceof Error ? error.message : "Erro desconhecido",
    });
  }
}

export async function getExameByIdController(req: Request, res: Response) {
  const id: number = Number(req.params.id);
  if (!id) return res.status(400).json({ success: false, message: "ID invalido" });

  try {
    const exame = await examesModel.getExameById(id);
    if (!exame) return res.status(404).json({ success: false, message: "Registro nao encontrado" });
    return res.json({ success: true, data: exame });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: "Erro ao buscar exame",
      error: error instanceof Error ? error.message : "Erro desconhecido",
    });
  }
}

export async function updateExameController(req: Request, res: Response) {
  const id: number = Number(req.params.id);
  if (!id) return res.status(400).json({ success: false, message: "ID invalido" });

  try {
    const parsed = ExameUpdateSchema.safeParse(req.body);
    if (!parsed.success) {
      return res.status(400).json({ errors: parsed.error.flatten() });
    }

    const existing = await examesModel.getExameById(id);
    if (!existing) return res.status(404).json({ success: false, message: "Registro nao encontrado" });

    const exame = await examesModel.updateExame(id, parsed.data);
    return res.json({ success: true, data: exame });
  } catch (error) {
    return res.status(500).json({
      message: "Erro ao atualizar exame",
      error: error instanceof Error ? error.message : "Erro desconhecido",
    });
  }
}

export async function deleteExameController(req: Request, res: Response) {
  const id: number = Number(req.params.id);
  if (!id) return res.status(400).json({ success: false, message: "ID invalido" });

  try {
    const existing = await examesModel.getExameById(id);
    if (!existing) return res.status(404).json({ success: false, message: "Registro nao encontrado" });

    await examesModel.deleteExame(id);
    return res.json({ success: true, message: "Registro removido com sucesso" });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: "Erro ao remover exame",
      error: error instanceof Error ? error.message : "Erro desconhecido",
    });
  }
}
