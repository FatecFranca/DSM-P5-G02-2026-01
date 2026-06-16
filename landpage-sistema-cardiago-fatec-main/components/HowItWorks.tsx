import { ClipboardPlus, Cpu, FileHeart, Stethoscope } from "lucide-react";
import { MotionDiv } from "./Motion";
import { SectionHeader } from "./SectionHeader";

const steps = [
  {
    icon: ClipboardPlus,
    title: "Inserção dos dados médicos",
    text: "Informe idade, pressão arterial, colesterol, batimentos, diabetes, tabagismo e histórico familiar.",
  },
  {
    icon: Cpu,
    title: "Processamento via IA",
    text: "A plataforma cruza variáveis clínicas e comportamentais com modelos de machine learning.",
  },
  {
    icon: FileHeart,
    title: "Resultado da análise",
    text: "O sistema indica de forma objetiva se o paciente possui ou não risco de ataque cardíaco.",
  },
  {
    icon: Stethoscope,
    title: "Encaminhamento clínico",
    text: "O resultado apoia a decisão médica para definir o próximo passo no acompanhamento do paciente.",
  },
];

export function HowItWorks() {
  return (
    <section id="como-funciona" className="relative overflow-hidden bg-white py-20 lg:py-28">
      <div className="absolute inset-0 -z-10 tech-grid opacity-60" />
      <div className="mx-auto max-w-7xl px-5 lg:px-8">
        <SectionHeader
          eyebrow="Como funciona"
          title="Da coleta de dados ao insight clínico em poucos passos"
          description="Um fluxo simples, rápido e visual para transformar dados do paciente em uma leitura preditiva de risco cardiovascular."
        />
        <div className="grid gap-6 lg:grid-cols-4">
          {steps.map((step, index) => {
            const Icon = step.icon;
            return (
              <MotionDiv
                key={step.title}
                initial={{ opacity: 0, y: 26 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.5, delay: index * 0.08 }}
                className="relative rounded-[2rem] bg-slate-50 p-7 shadow-sm ring-1 ring-slate-200/70 transition hover:-translate-y-2 hover:bg-white hover:shadow-premium"
              >
                <span className="absolute right-6 top-6 text-5xl font-black text-slate-200">0{index + 1}</span>
                <div className="relative mb-8 grid h-14 w-14 place-items-center rounded-2xl bg-gradient-to-br from-blue-600 to-sky-400 text-white shadow-lg shadow-sky-500/20">
                  <Icon className="h-7 w-7" />
                </div>
                <h3 className="relative text-lg font-black text-slate-950">{step.title}</h3>
                <p className="relative mt-4 text-sm leading-7 text-slate-600">{step.text}</p>
              </MotionDiv>
            );
          })}
        </div>
      </div>
    </section>
  );
}
