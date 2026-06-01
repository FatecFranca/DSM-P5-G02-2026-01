import { z } from "zod";

export const DiagnosticoInputSchema = z.object({
  age: z.coerce.number().min(0).max(120),
  gender: z.coerce.number().int().min(0).max(1),
  impluse: z.coerce.number().min(20).max(300),
  pressurehight: z.coerce.number().min(50).max(300),
  pressurelow: z.coerce.number().min(30).max(200),
  glucose: z.coerce.number().min(20).max(600),
  kcm: z.coerce.number().min(0).max(400),
  troponin: z.coerce.number().min(0).max(20),
});

export type DiagnosticoInput = z.infer<typeof DiagnosticoInputSchema>;
