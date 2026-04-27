import { Prisma } from "../generated/prisma/client";
import { prisma } from "../../lib/prisma";
import bcrypt from "bcrypt";
import * as type from "../types/usuario";

function badRequest(message: string) {
  const error = new Error(message) as Error & { statusCode: number };
  error.statusCode = 400;
  return error;
}

function isBcryptHash(value: string) {
  return /^\$2[aby]\$\d{2}\$[./A-Za-z0-9]{53}$/.test(value);
}

export async function createUsuario(data: type.UsuarioDTO) {
  const organizacao = await prisma.tb_organizacao.findUnique({
    where: { id_organizacao: data.id_organizacao },
    select: { id_organizacao: true }
  });

  if (!organizacao) {
    throw badRequest("Organizacao nao encontrada");
  }

  const cargo = await prisma.tb_cargos.findUnique({
    where: {
      id_cargo_id_organizacao: {
        id_cargo: data.id_cargo,
        id_organizacao: data.id_organizacao
      }
    },
    select: { id_cargo: true }
  });

  if (!cargo) {
    throw badRequest("Cargo nao encontrado para a organizacao informada");
  }

  const senhaHash = isBcryptHash(data.hash_senha)
    ? data.hash_senha
    : await bcrypt.hash(data.hash_senha, 10);

  try {
    return await prisma.tb_usuario.create({
      data: {
        id_organizacao: data.id_organizacao,
        id_cargo: data.id_cargo,
        url_imagem: data.url_imagem,
        nome: data.nome,
        email: data.email,
        login: data.login,
        telefone: data.telefone,
        hash_senha: senhaHash,
        ativo: data.ativo
      }
    });
  } catch (error) {
    if (error instanceof Prisma.PrismaClientKnownRequestError && (error.code === "P2025" || error.code === "P2003")) {
      throw badRequest("Cargo nao encontrado para a organizacao informada");
    }

    throw error;
  }
}

export function listUsuarios() {
  return prisma.tb_usuario.findMany();
}

export function getUsuarioById(id_usuario: number) {
  return prisma.tb_usuario.findUnique({
    where: { id_usuario }
  });
}

export function updateUsuario(id_usuario: number, data: Prisma.tb_usuarioUncheckedUpdateInput) {
  return prisma.tb_usuario.update({
    where: { id_usuario },
    data
  });
}

export function deleteUsuario(id_usuario: number) {
  return prisma.tb_usuario.delete({
    where: { id_usuario }
  });
}
