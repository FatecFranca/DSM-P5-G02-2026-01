import {
  OpenAPIRegistry,
  OpenApiGeneratorV3,
  extendZodWithOpenApi,
} from "@asteasolutions/zod-to-openapi";
import { z } from "zod";
import { loginSchema } from "../types/authSchema";
import { UsuarioSchema, UsuarioUpdateSchema } from "../types/usuario";

extendZodWithOpenApi(z);
import dotenv from "dotenv";
dotenv.config();
const registry = new OpenAPIRegistry();

const idParamSchema = z.object({
  id: z.string().regex(/^\d+$/, "ID deve ser numerico"),
});

const successResponseSchema = z.object({
  success: z.boolean(),
  data: z.any().optional(),
  item: z.any().optional(),
  items: z.array(z.any()).optional(),
  message: z.string().optional(),
});

registry.registerPath({
  method: "post",
  path: "/auth/login",
  description: "Login do usuario",
  tags: ["Auth"],
  request: {
    body: {
      content: {
        "application/json": {
          schema: loginSchema,
        },
      },
    },
  },
  responses: {
    200: {
      description: "Login realizado com sucesso",
      content: { "application/json": { schema: successResponseSchema } },
    },
    400: { description: "Erro de validacao" },
    401: { description: "Credenciais invalidas" },
  },
});


registry.registerPath({
  method: "post",
  path: "/usuarios",
  description: "Criar usuario",
  tags: ["Usuarios"],
  request: {
    body: { content: { "application/json": { schema: UsuarioSchema } } },
  },
  responses: {
    201: { description: "Usuario criado com sucesso" },
    400: { description: "Erro de validacao" },
  },
});

registry.registerPath({
  method: "get",
  path: "/usuarios",
  description: "Listar usuarios",
  tags: ["Usuarios"],
  responses: {
    200: { description: "Usuarios listados com sucesso" },
  },
});

registry.registerPath({
  method: "get",
  path: "/usuarios/{id}",
  description: "Buscar usuario por ID",
  tags: ["Usuarios"],
  request: {
    params: idParamSchema,
  },
  responses: {
    200: { description: "Usuario encontrado" },
    400: { description: "ID invalido" },
    404: { description: "Registro nao encontrado" },
  },
});

registry.registerPath({
  method: "put",
  path: "/usuarios/{id}",
  description: "Atualizar usuario",
  tags: ["Usuarios"],
  request: {
    params: idParamSchema,
    body: { content: { "application/json": { schema: UsuarioUpdateSchema } } },
  },
  responses: {
    200: { description: "Usuario atualizado com sucesso" },
    400: { description: "Erro de validacao" },
    404: { description: "Registro nao encontrado" },
  },
});

registry.registerPath({
  method: "delete",
  path: "/usuarios/{id}",
  description: "Remover usuario",
  tags: ["Usuarios"],
  request: {
    params: idParamSchema,
  },
  responses: {
    200: { description: "Usuario removido com sucesso" },
    400: { description: "ID invalido" },
    404: { description: "Registro nao encontrado" },
  },
});


const generator = new OpenApiGeneratorV3(registry.definitions);

export const openApiDocument = generator.generateDocument({
  openapi: "3.0.0",
  info: {
    title: "API Backend Base",
    version: "1.0.0",
    description: "Documentacao da API",
  },
  servers: [{ url: `${process.env.HOST }${process.env.PORT }` }],
});
