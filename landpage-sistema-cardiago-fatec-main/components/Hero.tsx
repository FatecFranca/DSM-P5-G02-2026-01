import { BrainCircuit, HeartPulse, ShieldCheck, Sparkles } from "lucide-react";
import { MotionDiv, MotionSection } from "./Motion";

const floatingCards = [
  { label: "Precisão preditiva", value: "92%", icon: BrainCircuit },
  { label: "Análise em tempo real", value: "IA", icon: Sparkles },
  { label: "Dados protegidos", value: "LGPD", icon: ShieldCheck },
];

export function Hero() {
  return (
    <section id="inicio" className="relative isolate overflow-hidden bg-white pt-28">
      <div className="absolute inset-0 -z-10 bg-radial-tech" />
      <div className="absolute inset-0 -z-10 tech-grid opacity-70" />
      <div className="absolute left-1/2 top-10 -z-10 h-[520px] w-[520px] -translate-x-1/2 rounded-full bg-sky-300/20 blur-3xl" />

      <div className="mx-auto grid max-w-7xl items-center gap-14 px-5 pb-20 pt-12 lg:grid-cols-[1.05fr_.95fr] lg:px-8 lg:pb-28 lg:pt-20">
        <MotionDiv
          initial={{ opacity: 0, y: 24 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.7 }}
        >
          <div className="mb-6 inline-flex items-center gap-2 rounded-full border border-sky-200 bg-white/80 px-4 py-2 text-sm font-bold text-sky-700 shadow-sm backdrop-blur">
            <Sparkles className="h-4 w-4" />
            Diagnóstico preditivo cardiovascular com IA
          </div>
          <h1 className="max-w-5xl text-4xl font-black tracking-tight text-slate-950 md:text-6xl lg:text-7xl">
            Descubra o Risco de Ataque Cardíaco com
            <span className="gradient-text"> Inteligência Artificial</span>
          </h1>
          <p className="mt-7 max-w-2xl text-lg leading-8 text-slate-600 md:text-xl">
            Plataforma inteligente para análise preditiva baseada em dados clínicos, hábitos de vida e indicadores cardiovasculares. Apoie decisões preventivas com tecnologia, velocidade e segurança.
          </p>
          <div className="mt-9 flex flex-col gap-4 sm:flex-row">
            {/* Botão principal removido conforme solicitado */}
            <a
              href="#plataforma"
              className="inline-flex items-center justify-center rounded-full border border-slate-200 bg-white px-7 py-4 text-base font-extrabold text-slate-800 shadow-sm transition hover:-translate-y-1 hover:border-sky-200 hover:text-sky-700 hover:shadow-xl"
            >
              Saiba Mais
            </a>
          </div>
        </MotionDiv>

        <MotionDiv
          initial={{ opacity: 0, scale: 0.94 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ duration: 0.8, delay: 0.15 }}
          className="relative"
        >
          <div className="relative mx-auto max-w-[560px] rounded-[2.5rem] border border-white/80 bg-white/60 p-4 shadow-premium backdrop-blur-xl">
            <div className="noise-mask relative overflow-hidden rounded-[2rem] bg-gradient-to-br from-navy via-blue-950 to-sky-800 p-7 text-white shadow-glow">
              <div className="absolute -right-24 -top-24 h-72 w-72 rounded-full bg-sky-400/30 blur-3xl" />
              <div className="absolute -bottom-24 -left-24 h-72 w-72 rounded-full bg-blue-500/25 blur-3xl" />

              <div className="relative flex items-center justify-between">
                <div>
                  <p className="text-sm font-semibold text-sky-100">Análise neural</p>
                  <h3 className="mt-1 text-2xl font-black">Heart Risk Scan</h3>
                </div>
                <div className="grid h-14 w-14 place-items-center rounded-2xl bg-white/10 ring-1 ring-white/20">
                  <HeartPulse className="h-7 w-7 text-cyan-200" />
                </div>
              </div>

              <div className="relative mt-10 grid gap-4 sm:grid-cols-3">
                {floatingCards.map((card) => {
                    const Icon = card.icon;
                    return (
                      <div key={card.label} className="rounded-3xl bg-white/10 p-4 ring-1 ring-white/15 backdrop-blur">
                        <Icon className="mb-5 h-6 w-6 text-cyan-200" />
                        <p className="text-2xl font-black">{card.value}</p>
                        <p className="mt-1 text-xs leading-5 text-sky-100">{card.label}</p>
                      </div>
                    );
                  })}
              </div>

              <div className="relative mt-8 rounded-3xl bg-white p-5 text-slate-900 shadow-2xl">
                <div className="mb-4 flex items-center justify-between">
                  <p className="font-black">Predição cardiovascular</p>
                  <span className="rounded-full bg-emerald-50 px-3 py-1 text-xs font-black text-emerald-600">Ativo</span>
                </div>
                <div className="flex flex-col items-center gap-3 py-2">
                  <p className="text-sm font-semibold text-slate-500">Resultado da análise</p>
                  <span className="rounded-2xl bg-red-50 px-6 py-3 text-xl font-black text-red-600 ring-1 ring-red-200">
                    SIM — Alto Risco
                  </span>
                  <p className="text-center text-xs leading-5 text-slate-400">
                    Paciente apresenta risco de ataque cardíaco
                  </p>
                </div>
              </div>
            </div>
          </div>
        </MotionDiv>
      </div>
    </section>
  );
}
