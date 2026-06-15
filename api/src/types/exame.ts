import { z } from "zod";

export const ExameSchema = z.object({
  id_usuario: z.coerce.number().int().positive("id_usuario e obrigatorio"),
  idade: z.coerce.number().int().min(0).max(120),
  sexo: z.boolean(),
  pulso: z.coerce.number(),
  pressao_sistolica: z.coerce.number(),
  pressao_diastolica: z.coerce.number(),
  glicose: z.coerce.number(),
  ck_mb: z.coerce.number(),
  troponina: z.coerce.number(),
  result: z.boolean(),
});

export const ExameUpdateSchema = z.object({
  idade: z.coerce.number().int().min(0).max(120).optional(),
  sexo: z.boolean().optional(),
  pulso: z.coerce.number().optional(),
  pressao_sistolica: z.coerce.number().optional(),
  pressao_diastolica: z.coerce.number().optional(),
  glicose: z.coerce.number().optional(),
  ck_mb: z.coerce.number().optional(),
  troponina: z.coerce.number().optional(),
  result: z.boolean().optional(),
});

export type ExameDTO = z.infer<typeof ExameSchema>;
export type ExameUpdateDTO = z.infer<typeof ExameUpdateSchema>;
