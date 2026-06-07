import "dotenv/config";
import { prisma } from "../lib/prisma";

async function main() {
  console.log("Seed concluido.");
}

main()
  .catch((error) => {
    console.error("Erro no seed:", error);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
