-- CreateTable
CREATE TABLE "tb_exame" (
    "id_exame" SERIAL NOT NULL,
    "id_usuario" INTEGER NOT NULL,
    "idade" INTEGER NOT NULL,
    "sexo" BOOLEAN NOT NULL,
    "pulso" DOUBLE PRECISION NOT NULL,
    "pressao_sistolica" DOUBLE PRECISION NOT NULL,
    "pressao_diastolica" DOUBLE PRECISION NOT NULL,
    "glicose" DOUBLE PRECISION NOT NULL,
    "ck_mb" DECIMAL(10,2) NOT NULL,
    "troponina" DECIMAL(10,2) NOT NULL,
    "result" BOOLEAN NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tb_exame_pkey" PRIMARY KEY ("id_exame")
);

-- AddForeignKey
ALTER TABLE "tb_exame" ADD CONSTRAINT "tb_exame_id_usuario_fkey" FOREIGN KEY ("id_usuario") REFERENCES "tb_usuario"("id_usuario") ON DELETE RESTRICT ON UPDATE CASCADE;
