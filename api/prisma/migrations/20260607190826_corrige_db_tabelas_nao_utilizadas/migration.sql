/*
  Warnings:

  - You are about to drop the `tb_classificacao` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `tb_classificacao_estabelecimento` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `tb_estabelecimento` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `tb_interacao_usuario_estabelecimento` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `tb_modelo_recomendacao` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `tb_recomendacao_cache` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `tb_usuario_feature_snapshot` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "tb_classificacao" DROP CONSTRAINT "tb_classificacao_id_usuario_fkey";

-- DropForeignKey
ALTER TABLE "tb_classificacao_estabelecimento" DROP CONSTRAINT "tb_classificacao_estabelecimento_id_classificacao_fkey";

-- DropForeignKey
ALTER TABLE "tb_classificacao_estabelecimento" DROP CONSTRAINT "tb_classificacao_estabelecimento_id_estabelecimento_fkey";

-- DropForeignKey
ALTER TABLE "tb_interacao_usuario_estabelecimento" DROP CONSTRAINT "tb_interacao_usuario_estabelecimento_id_estabelecimento_fkey";

-- DropForeignKey
ALTER TABLE "tb_interacao_usuario_estabelecimento" DROP CONSTRAINT "tb_interacao_usuario_estabelecimento_id_usuario_fkey";

-- DropForeignKey
ALTER TABLE "tb_recomendacao_cache" DROP CONSTRAINT "tb_recomendacao_cache_id_usuario_fkey";

-- DropForeignKey
ALTER TABLE "tb_recomendacao_cache" DROP CONSTRAINT "tb_recomendacao_cache_model_version_fkey";

-- DropForeignKey
ALTER TABLE "tb_usuario_feature_snapshot" DROP CONSTRAINT "tb_usuario_feature_snapshot_id_usuario_fkey";

-- AlterTable
ALTER TABLE "tb_usuario" ALTER COLUMN "updated_at" DROP DEFAULT;

-- DropTable
DROP TABLE "tb_classificacao";

-- DropTable
DROP TABLE "tb_classificacao_estabelecimento";

-- DropTable
DROP TABLE "tb_estabelecimento";

-- DropTable
DROP TABLE "tb_interacao_usuario_estabelecimento";

-- DropTable
DROP TABLE "tb_modelo_recomendacao";

-- DropTable
DROP TABLE "tb_recomendacao_cache";

-- DropTable
DROP TABLE "tb_usuario_feature_snapshot";

-- DropEnum
DROP TYPE "status_modelo_recomendacao";

-- DropEnum
DROP TYPE "tipo_evento_interacao";
