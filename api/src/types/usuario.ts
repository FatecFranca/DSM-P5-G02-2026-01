import { z } from "zod";

export const UsuarioSchema = z.object({
  nome: z.string().min(1, "nome e obrigatorio"),
  email: z.string().email("email invalido"),
  hash_senha: z.string().min(1, "hash_senha e obrigatorio"),
});

export const UsuarioUpdateSchema = UsuarioSchema.partial();

export type UsuarioDTO = z.infer<typeof UsuarioSchema>;
export type UsuarioUpdateDTO = z.infer<typeof UsuarioUpdateSchema>;
