import { Benefits } from "@/components/Benefits";
import { DemoAI } from "@/components/DemoAI";
import { Footer } from "@/components/Footer";
import { Header } from "@/components/Header";
import { Hero } from "@/components/Hero";
import { HowItWorks } from "@/components/HowItWorks";
import { RiskIndicators } from "@/components/RiskIndicators";
import { AboutPlatform } from "@/components/AboutPlatform";

export default function Home() {
  return (
    <main className="min-h-screen overflow-hidden bg-slate-50 text-slate-950">
      <Header />
      <Hero />
      <AboutPlatform />
      <HowItWorks />
      <RiskIndicators />
      <Benefits />
      <DemoAI />
      <Footer />
    </main>
  );
}
