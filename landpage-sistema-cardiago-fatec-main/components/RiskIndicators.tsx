import { Activity, Cigarette, Dna, HeartPulse, Scale, UserRound } from "lucide-react";
import { MotionDiv } from "./Motion";
import { SectionHeader } from "./SectionHeader";

const indicators = [
  { label: "Pressão arterial", icon: Activity },
  { label: "Colesterol", icon: Scale },
  { label: "Frequência cardíaca", icon: HeartPulse },
  { label: "Histórico familiar", icon: Dna },
  { label: "Idade", icon: UserRound },
  { label: "Hábitos de vida", icon: Cigarette },
];

export function RiskIndicators() {
  return (
    <section id="indicadores" className="relative overflow-hidden bg-gradient-to-br from-navy via-blue-950 to-sky-900 py-20 text-white lg:py-28">
      <div className="absolute inset-0 tech-grid opacity-25" />
      <div className="absolute -left-32 top-20 h-96 w-96 rounded-full bg-sky-400/20 blur-3xl" />
      <div className="absolute -right-32 bottom-20 h-96 w-96 rounded-full bg-blue-500/20 blur-3xl" />
      <div className="relative mx-auto max-w-7xl px-5 lg:px-8">
        <SectionHeader
          eyebrow="Indicadores de risco"
          title="Variáveis clínicas monitoradas pela inteligência preditiva"
          description="A análise considera múltiplos fatores de risco para gerar uma visão ampla, contextual e preventiva sobre a saúde cardiovascular."
        />
        <div className="grid gap-5 md:grid-cols-2 lg:grid-cols-3">
          {indicators.map((item, index) => {
            const Icon = item.icon;
            return (
              <MotionDiv
                key={item.label}
                initial={{ opacity: 0, y: 24 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.55, delay: index * 0.06 }}
                className="dark-glass rounded-[2rem] p-6 transition hover:-translate-y-1 hover:bg-white/12"
              >
                <div className="mb-5 flex items-center gap-4">
                  <div className="grid h-12 w-12 place-items-center rounded-2xl bg-white/10 text-cyan-200 ring-1 ring-white/15">
                    <Icon className="h-6 w-6" />
                  </div>
                  <p className="font-bold">{item.label}</p>
                </div>
              </MotionDiv>
            );
          })}
        </div>
      </div>
    </section>
  );
}
