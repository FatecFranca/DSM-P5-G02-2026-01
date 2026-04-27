import {
  OpenAPIRegistry,
  OpenApiGeneratorV3,
  extendZodWithOpenApi,
} from "@asteasolutions/zod-to-openapi";
import { z } from "zod";
import { loginSchema } from "../types/authSchema";
import { UsuarioSchema, UsuarioUpdateSchema } from "../types/usuario";
import { EstabelecimentoSchema, EstabelecimentoUpdateSchema } from "../types/estabelecimento";
import { ClassificacaoSchema, ClassificacaoUpdateSchema } from "../types/classificacao";
import { ClassificacaoEstabelecimentoSchema } from "../types/classificacaoEstabelecimento";

extendZodWithOpenApi(z);
import dotenv from "dotenv";
dotenv.config();
const registry = new OpenAPIRegistry();

const idParamSchema = z.object({
  id: z.string().regex(/^\d+$/, "ID deve ser numerico"),
});

const classificacaoEstabelecimentoParamSchema = z.object({
  id_classificacao: z.string().regex(/^\d+$/, "id_classificacao deve ser numerico"),
  id_estabelecimento: z.string().regex(/^\d+$/, "id_estabelecimento deve ser numerico"),
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

registry.registerPath({
  method: "post",
  path: "/estabelecimentos",
  description: "Criar estabelecimento",
  tags: ["Estabelecimentos"],
  request: {
    body: { content: { "application/json": { schema: EstabelecimentoSchema } } },
  },
  responses: {
    201: { description: "Estabelecimento criado com sucesso" },
    400: { description: "Erro de validacao" },
  },
});

registry.registerPath({
  method: "get",
  path: "/estabelecimentos",
  description: "Listar estabelecimentos",
  tags: ["Estabelecimentos"],
  responses: {
    200: { description: "Estabelecimentos listados com sucesso" },
  },
});

registry.registerPath({
  method: "get",
  path: "/estabelecimentos/{id}",
  description: "Buscar estabelecimento por ID",
  tags: ["Estabelecimentos"],
  request: {
    params: idParamSchema,
  },
  responses: {
    200: { description: "Estabelecimento encontrado" },
    400: { description: "ID invalido" },
    404: { description: "Registro nao encontrado" },
  },
});

registry.registerPath({
  method: "put",
  path: "/estabelecimentos/{id}",
  description: "Atualizar estabelecimento",
  tags: ["Estabelecimentos"],
  request: {
    params: idParamSchema,
    body: { content: { "application/json": { schema: EstabelecimentoUpdateSchema } } },
  },
  responses: {
    200: { description: "Estabelecimento atualizado com sucesso" },
    400: { description: "Erro de validacao" },
    404: { description: "Registro nao encontrado" },
  },
});

registry.registerPath({
  method: "delete",
  path: "/estabelecimentos/{id}",
  description: "Remover estabelecimento",
  tags: ["Estabelecimentos"],
  request: {
    params: idParamSchema,
  },
  responses: {
    200: { description: "Estabelecimento removido com sucesso" },
    400: { description: "ID invalido" },
    404: { description: "Registro nao encontrado" },
  },
});

registry.registerPath({
  method: "post",
  path: "/classificacoes",
  description: "Criar classificacao",
  tags: ["Classificacoes"],
  request: {
    body: { content: { "application/json": { schema: ClassificacaoSchema } } },
  },
  responses: {
    201: { description: "Classificacao criada com sucesso" },
    400: { description: "Erro de validacao" },
  },
});

registry.registerPath({
  method: "get",
  path: "/classificacoes",
  description: "Listar classificacoes",
  tags: ["Classificacoes"],
  responses: {
    200: { description: "Classificacoes listadas com sucesso" },
  },
});

registry.registerPath({
  method: "get",
  path: "/classificacoes/{id}",
  description: "Buscar classificacao por ID",
  tags: ["Classificacoes"],
  request: {
    params: idParamSchema,
  },
  responses: {
    200: { description: "Classificacao encontrada" },
    400: { description: "ID invalido" },
    404: { description: "Registro nao encontrado" },
  },
});

registry.registerPath({
  method: "put",
  path: "/classificacoes/{id}",
  description: "Atualizar classificacao",
  tags: ["Classificacoes"],
  request: {
    params: idParamSchema,
    body: { content: { "application/json": { schema: ClassificacaoUpdateSchema } } },
  },
  responses: {
    200: { description: "Classificacao atualizada com sucesso" },
    400: { description: "Erro de validacao" },
    404: { description: "Registro nao encontrado" },
  },
});

registry.registerPath({
  method: "delete",
  path: "/classificacoes/{id}",
  description: "Remover classificacao",
  tags: ["Classificacoes"],
  request: {
    params: idParamSchema,
  },
  responses: {
    200: { description: "Classificacao removida com sucesso" },
    400: { description: "ID invalido" },
    404: { description: "Registro nao encontrado" },
  },
});

registry.registerPath({
  method: "post",
  path: "/classificacoes-estabelecimentos",
  description: "Criar relacionamento entre classificacao e estabelecimento",
  tags: ["ClassificacoesEstabelecimentos"],
  request: {
    body: {
      content: {
        "application/json": {
          schema: ClassificacaoEstabelecimentoSchema,
        },
      },
    },
  },
  responses: {
    201: { description: "Relacionamento criado com sucesso" },
    400: { description: "Erro de validacao" },
  },
});

registry.registerPath({
  method: "get",
  path: "/classificacoes-estabelecimentos",
  description: "Listar relacionamentos entre classificacoes e estabelecimentos",
  tags: ["ClassificacoesEstabelecimentos"],
  responses: {
    200: { description: "Relacionamentos listados com sucesso" },
  },
});

registry.registerPath({
  method: "get",
  path: "/classificacoes-estabelecimentos/{id_classificacao}/{id_estabelecimento}",
  description: "Buscar relacionamento por chave composta",
  tags: ["ClassificacoesEstabelecimentos"],
  request: {
    params: classificacaoEstabelecimentoParamSchema,
  },
  responses: {
    200: { description: "Relacionamento encontrado" },
    400: { description: "IDs invalidos" },
    404: { description: "Registro nao encontrado" },
  },
});

registry.registerPath({
  method: "delete",
  path: "/classificacoes-estabelecimentos/{id_classificacao}/{id_estabelecimento}",
  description: "Remover relacionamento por chave composta",
  tags: ["ClassificacoesEstabelecimentos"],
  request: {
    params: classificacaoEstabelecimentoParamSchema,
  },
  responses: {
    200: { description: "Relacionamento removido com sucesso" },
    400: { description: "IDs invalidos" },
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
