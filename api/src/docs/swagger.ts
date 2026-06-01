import {
  OpenAPIRegistry,
  OpenApiGeneratorV3,
  extendZodWithOpenApi,
} from "@asteasolutions/zod-to-openapi";
import { z } from "zod";
import dotenv from "dotenv";
import { loginSchema } from "../types/authSchema";
import { UsuarioSchema, UsuarioUpdateSchema } from "../types/usuario";
import { DiagnosticoInputSchema } from "../types/diagnostico";

extendZodWithOpenApi(z);
dotenv.config();

const registry = new OpenAPIRegistry();

const idParamSchema = z.object({
  id: z.string().regex(/^\d+$/, "ID deve ser numerico"),
});

const errorResponseSchema = z.object({
  success: z.boolean().optional(),
  message: z.string().optional(),
  error: z.string().optional(),
  details: z.any().optional(),
});

const usuarioResponseSchema = UsuarioSchema.extend({
  id_usuario: z.number().int(),
});

const diagnosticoResponseSchema = z.object({
  chance_percentual: z.number(),
  classificacao: z.enum(["positive", "negative"]),
  tem_chance: z.boolean(),
  base_vizinhos: z.number().int(),
  modelo: z.literal("CART"),
});

const loginSuccessSchema = z.object({
  success: z.literal(true),
  token: z.string(),
});

const singleItemResponse = (itemSchema: z.ZodTypeAny) =>
  z.object({
    success: z.boolean(),
    data: itemSchema,
  });

const listResponse = (itemSchema: z.ZodTypeAny) =>
  z.object({
    success: z.boolean(),
    data: z.array(itemSchema),
  });

const deleteSuccessResponseSchema = z.object({
  success: z.literal(true),
  message: z.string(),
});

const unauthorizedResponse = {
  description: "Nao autorizado",
  content: { "application/json": { schema: errorResponseSchema } },
};

const registerProtectedPath = (input: Parameters<typeof registry.registerPath>[0]) => {
  registry.registerPath({
    ...input,
    security: [{ bearerAuth: [] }, { xAccessToken: [] }],
  });
};

registry.registerComponent("securitySchemes", "bearerAuth", {
  type: "http",
  scheme: "bearer",
  bearerFormat: "JWT",
});

registry.registerComponent("securitySchemes", "xAccessToken", {
  type: "apiKey",
  in: "header",
  name: "x-access-token",
});

registry.registerPath({
  method: "post",
  path: "/auth/login",
  description: "Autentica o usuario e retorna token JWT.",
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
      content: { "application/json": { schema: loginSuccessSchema } },
    },
    400: {
      description: "Dados invalidos",
      content: { "application/json": { schema: errorResponseSchema } },
    },
    401: {
      description: "Credenciais invalidas",
      content: { "application/json": { schema: errorResponseSchema } },
    },
    500: {
      description: "Erro interno",
      content: { "application/json": { schema: errorResponseSchema } },
    },
  },
});

registerProtectedPath({
  method: "post",
  path: "/usuarios",
  description: "Cria um usuario.",
  tags: ["Usuarios"],
  request: {
    body: { content: { "application/json": { schema: UsuarioSchema } } },
  },
  responses: {
    201: {
      description: "Usuario criado com sucesso",
      content: { "application/json": { schema: singleItemResponse(usuarioResponseSchema) } },
    },
    400: {
      description: "Erro de validacao ou regra de negocio",
      content: { "application/json": { schema: errorResponseSchema } },
    },
    500: {
      description: "Erro interno",
      content: { "application/json": { schema: errorResponseSchema } },
    },
    401: unauthorizedResponse,
  },
});

registerProtectedPath({
  method: "get",
  path: "/usuarios",
  description: "Lista usuarios.",
  tags: ["Usuarios"],
  responses: {
    200: {
      description: "Usuarios listados com sucesso",
      content: { "application/json": { schema: listResponse(usuarioResponseSchema) } },
    },
    500: {
      description: "Erro interno",
      content: { "application/json": { schema: errorResponseSchema } },
    },
    401: unauthorizedResponse,
  },
});

registerProtectedPath({
  method: "get",
  path: "/usuarios/{id}",
  description: "Busca usuario por ID.",
  tags: ["Usuarios"],
  request: { params: idParamSchema },
  responses: {
    200: {
      description: "Usuario encontrado",
      content: { "application/json": { schema: singleItemResponse(usuarioResponseSchema) } },
    },
    400: {
      description: "ID invalido",
      content: { "application/json": { schema: errorResponseSchema } },
    },
    404: {
      description: "Registro nao encontrado",
      content: { "application/json": { schema: errorResponseSchema } },
    },
    500: {
      description: "Erro interno",
      content: { "application/json": { schema: errorResponseSchema } },
    },
    401: unauthorizedResponse,
  },
});

registerProtectedPath({
  method: "put",
  path: "/usuarios/{id}",
  description: "Atualiza usuario por ID.",
  tags: ["Usuarios"],
  request: {
    params: idParamSchema,
    body: { content: { "application/json": { schema: UsuarioUpdateSchema } } },
  },
  responses: {
    200: {
      description: "Usuario atualizado com sucesso",
      content: { "application/json": { schema: singleItemResponse(usuarioResponseSchema) } },
    },
    400: {
      description: "Erro de validacao ou ID invalido",
      content: { "application/json": { schema: errorResponseSchema } },
    },
    404: {
      description: "Registro nao encontrado",
      content: { "application/json": { schema: errorResponseSchema } },
    },
    500: {
      description: "Erro interno",
      content: { "application/json": { schema: errorResponseSchema } },
    },
    401: unauthorizedResponse,
  },
});

registerProtectedPath({
  method: "delete",
  path: "/usuarios/{id}",
  description: "Remove usuario por ID.",
  tags: ["Usuarios"],
  request: { params: idParamSchema },
  responses: {
    200: {
      description: "Usuario removido com sucesso",
      content: { "application/json": { schema: deleteSuccessResponseSchema } },
    },
    400: {
      description: "ID invalido",
      content: { "application/json": { schema: errorResponseSchema } },
    },
    404: {
      description: "Registro nao encontrado",
      content: { "application/json": { schema: errorResponseSchema } },
    },
    500: {
      description: "Erro interno",
      content: { "application/json": { schema: errorResponseSchema } },
    },
    401: unauthorizedResponse,
  },
});

registerProtectedPath({
  method: "post",
  path: "/diagnosticos/risco",
  description:
    "Analisa chance de ataque cardiaco com base em exames informados usando o modelo CART treinado na base pre-processada.",
  tags: ["Diagnosticos"],
  request: {
    body: { content: { "application/json": { schema: DiagnosticoInputSchema } } },
  },
  responses: {
    200: {
      description: "Diagnostico calculado com sucesso",
      content: {
        "application/json": {
          schema: singleItemResponse(diagnosticoResponseSchema),
          example: {
            success: true,
            data: {
              chance_percentual: 74.38,
              classificacao: "positive",
              tem_chance: true,
              base_vizinhos: 0,
              modelo: "CART",
            },
          },
        },
      },
    },
    400: {
      description: "Dados de exame invalidos",
      content: { "application/json": { schema: errorResponseSchema } },
    },
    500: {
      description: "Erro interno",
      content: { "application/json": { schema: errorResponseSchema } },
    },
    401: unauthorizedResponse,
  },
});

const generator = new OpenApiGeneratorV3(registry.definitions);

const hostFromEnv = process.env.HOST?.trim();
const parsedHost = hostFromEnv
  ? (() => {
      try {
        return new URL(hostFromEnv);
      } catch {
        return null;
      }
    })()
  : null;
const port = Number(process.env.PORT ?? parsedHost?.port ?? 3000);
const serverUrl =
  hostFromEnv && parsedHost
    ? `${parsedHost.protocol}//${parsedHost.hostname}:${port}`
    : `http://localhost:${port}`;

export const openApiDocument = generator.generateDocument({
  openapi: "3.0.0",
  info: {
    title: "HeartX API",
    version: "1.0.0",
    description:
      "API HeartX para autenticacao de usuarios e diagnostico inicial de risco cardiaco. Modelo produtivo atual: CART.",
  },
  servers: [{ url: serverUrl }],
});
