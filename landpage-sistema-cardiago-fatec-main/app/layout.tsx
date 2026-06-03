import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";

const inter = Inter({ subsets: ["latin"], display: "swap" });

export const metadata: Metadata = {
  title: "CardioPredict AI | Previsão de Risco Cardíaco com IA",
  description:
    "Landing page profissional para sistema de diagnóstico preditivo de risco de ataque cardíaco usando inteligência artificial e dados clínicos.",
  keywords: [
    "inteligência artificial",
    "risco cardíaco",
    "machine learning",
    "diagnóstico preditivo",
    "saúde digital",
    "cardiologia",
  ],
  openGraph: {
    title: "CardioPredict AI",
    description: "Previsão inteligente de risco cardiovascular com IA.",
    type: "website",
    locale: "pt_BR",
  },
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="pt-BR">
      <body className={inter.className}>{children}</body>
    </html>
  );
}
