import { Brain, LineChart, ShieldPlus } from "lucide-react";
import { MotionDiv, MotionSection } from "./Motion";
import { SectionHeader } from "./SectionHeader";

const items = [
  {
    icon: Brain,
    title: "IA aplicada à cardiologia",
    text: "Modelos inteligentes analisam sinais clínicos, histórico e hábitos para identificar padrões associados a eventos cardiovasculares.",
  },
  {
    icon: LineChart,
    title: "Machine learning preditivo",
    text: "Algoritmos treinados para cruzar indicadores e estimar a probabilidade de risco, apoiando uma abordagem preventiva.",
  },
  {
    icon: ShieldPlus,
    title: "Prevenção orientada por dados",
    text: "Resultados claros ajudam profissionais e pacientes a priorizarem mudanças, exames e acompanhamento médico.",
  },
];

export function AboutPlatform() {
  return (
    <MotionSection
      id="plataforma"
      className="relative bg-slate-50 py-20 lg:py-28"
      initial={{ opacity: 0 }}
      whileInView={{ opacity: 1 }}
      viewport={{ once: true, amount: 0.2 }}
      transition={{ duration: 0.6 }}
    >
      <div className="mx-auto max-w-7xl px-5 lg:px-8">
        <SectionHeader
          eyebrow="Sobre a plataforma"
          title="Uma nova camada de inteligência para prevenção cardiovascular"
          description="A solução combina tecnologia, ciência de dados e experiência clínica para transformar informações médicas em uma visão prática de risco cardíaco."
        />
        <div className="grid gap-6 md:grid-cols-3">
          {items.map((item, index) => {
            const Icon = item.icon;
            return (
              <MotionDiv
                key={item.title}
                initial={{ opacity: 0, y: 30 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.5, delay: index * 0.08 }}
                className="group rounded-[2rem] border border-white bg-white p-7 shadow-premium transition hover:-translate-y-2 hover:shadow-glow"
              >
                <div className="mb-6 grid h-14 w-14 place-items-center rounded-2xl bg-gradient-to-br from-sky-100 to-blue-100 text-sky-700 transition group-hover:scale-110">
                  <Icon className="h-7 w-7" />
                </div>
                <h3 className="text-xl font-black text-slate-950">{item.title}</h3>
                <p className="mt-4 leading-7 text-slate-600">{item.text}</p>
              </MotionDiv>
            );
          })}
        </div>
      </div>
    </MotionSection>
  );
}
