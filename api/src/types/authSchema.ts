import { extendZodWithOpenApi } from "@asteasolutions/zod-to-openapi";
import { z } from "zod";

extendZodWithOpenApi(z);

export const loginSchema = z.object({
  login: z.string().min(1, "Login e obrigatorio"),
  senha: z.string().min(1, "Senha e obrigatoria"),
});

export type LoginDTO = z.infer<typeof loginSchema>;
