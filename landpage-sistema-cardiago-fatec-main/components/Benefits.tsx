import { CheckCircle2, Gauge, LockKeyhole, MousePointer2, ShieldCheck, Target } from "lucide-react";
import { MotionDiv } from "./Motion";
import { SectionHeader } from "./SectionHeader";

const benefits = [
  { icon: Gauge, title: "Diagnóstico rápido", text: "Análise visual e objetiva em poucos segundos, com fluxo simples para uso em triagens e acompanhamentos." },
  { icon: Target, title: "Alta precisão preditiva", text: "Modelos inteligentes combinam fatores clínicos e comportamentais para apoiar a tomada de decisão." },
  { icon: MousePointer2, title: "Interface intuitiva", text: "Experiência premium, responsiva e acessível para equipes médicas, clínicas e pacientes." },
  { icon: LockKeyhole, title: "Segurança dos dados", text: "Design pensado para privacidade, rastreabilidade e proteção de informações sensíveis." },
  { icon: ShieldCheck, title: "Apoio à decisão médica", text: "Resultados organizados para auxiliar condutas preventivas sem substituir a avaliação profissional." },
  { icon: CheckCircle2, title: "Prevenção contínua", text: "Acompanhamento inteligente para estimular hábitos saudáveis e monitoramento periódico." },
];

export function Benefits() {
  return (
    <section className="bg-slate-50 py-20 lg:py-28">
      <div className="mx-auto max-w-7xl px-5 lg:px-8">
        <SectionHeader
          eyebrow="Benefícios da solução"
          title="Tecnologia preditiva com experiência de produto SaaS premium"
          description="Uma plataforma moderna para acelerar análises, reduzir incertezas e fortalecer a cultura de prevenção cardiovascular."
        />
        <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
          {benefits.map((benefit, index) => {
            const Icon = benefit.icon;
            return (
              <MotionDiv
                key={benefit.title}
                initial={{ opacity: 0, y: 24 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.5, delay: index * 0.06 }}
                className="group rounded-[2rem] bg-white p-7 shadow-sm ring-1 ring-slate-200/70 transition hover:-translate-y-2 hover:shadow-premium"
              >
                <div className="mb-6 grid h-13 w-13 place-items-center rounded-2xl bg-sky-50 text-sky-600 ring-1 ring-sky-100 transition group-hover:bg-sky-600 group-hover:text-white">
                  <Icon className="h-6 w-6" />
                </div>
                <h3 className="text-xl font-black text-slate-950">{benefit.title}</h3>
                <p className="mt-4 leading-7 text-slate-600">{benefit.text}</p>
              </MotionDiv>
            );
          })}
        </div>
      </div>
    </section>
  );
}
