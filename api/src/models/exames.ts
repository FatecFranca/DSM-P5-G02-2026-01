import { prisma } from "../../lib/prisma";
import * as type from "../types/exame";

export function createExame(data: type.ExameDTO) {
  return prisma.tb_exame.create({
    data: {
      id_usuario: data.id_usuario,
      idade: data.idade,
      sexo: data.sexo,
      pulso: data.pulso,
      pressao_sistolica: data.pressao_sistolica,
      pressao_diastolica: data.pressao_diastolica,
      glicose: data.glicose,
      ck_mb: data.ck_mb,
      troponina: data.troponina,
      result: data.result,
    },
  });
}

export function listExames() {
  return prisma.tb_exame.findMany();
}

export function getExameById(id_exame: number) {
  return prisma.tb_exame.findUnique({
    where: { id_exame },
  });
}

export function updateExame(id_exame: number, data: type.ExameUpdateDTO) {
  return prisma.tb_exame.update({
    where: { id_exame },
    data,
  });
}

export function deleteExame(id_exame: number) {
  return prisma.tb_exame.delete({
    where: { id_exame },
  });
}
