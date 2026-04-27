import { z } from "zod";

export const UsuarioSchema = z.object({
  id_organizacao: z.number().int().min(1, "id_organizacao e obrigatorio"),
  id_cargo: z.number().int().min(1, "id_cargo e obrigatorio"),
  url_imagem: z.string().min(1, "url_imagem invalida").optional().nullable(),
  nome: z.string().min(1, "nome e obrigatorio"),
  email: z.string().email("email invalido").optional().nullable(),
  login: z.string().min(1, "login e obrigatorio"),
  telefone: z.string().min(1, "telefone invalido").optional().nullable(),
  hash_senha: z.string().min(1, "hash_senha e obrigatorio"),
  ativo: z.boolean().optional()
});

export const UsuarioUpdateSchema = UsuarioSchema.partial();

export type UsuarioDTO = z.infer<typeof UsuarioSchema>;
export type UsuarioUpdateDTO = z.infer<typeof UsuarioUpdateSchema>;
