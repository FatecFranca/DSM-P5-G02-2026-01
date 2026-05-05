ALTER TABLE "tb_usuario" DROP COLUMN "login";
ALTER TABLE "tb_usuario" ALTER COLUMN "email" SET NOT NULL;
ALTER TABLE "tb_usuario" ADD CONSTRAINT "tb_usuario_email_key" UNIQUE ("email");
