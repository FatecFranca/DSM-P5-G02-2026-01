import { prisma } from "../../lib/prisma";

export async function findUserByLogin(login: string) {
  return prisma.tb_usuario.findFirst({
    where: { login }
  });
}

export async function updateUserPassword(id_usuario: number, hash_senha: string) {
  return prisma.tb_usuario.update({
    where: { id_usuario },
    data: { hash_senha }
  });
}
