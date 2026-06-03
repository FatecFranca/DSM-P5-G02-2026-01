"use client";

import { SectionHeader } from "./SectionHeader";

export function DemoAI() {
  return (
    <section id="about-app" className="relative overflow-hidden bg-white py-20 lg:py-28">
      <div className="mx-auto max-w-7xl px-5 lg:px-8">
        <SectionHeader
          eyebrow="Sobre o app"
          title="Conheça o Heart AI"
          description="O Heart AI reúne indicadores de saúde cardiovascular e conteúdo educativo para ajudar usuários a monitorar e entender seus riscos. Não substitui avaliação médica."
        />

        <div className="mt-8 prose max-w-none text-slate-700">
          <p>
            O aplicativo apresenta indicadores claros, recomendações preventivas e recursos educativos para apoiar hábitos saudáveis e
            a comunicação com profissionais de saúde.
          </p>
          <ul>
            <li>Visualização de indicadores principais</li>
            <li>Conteúdo educativo e recomendações preventivas</li>
            <li>Design focado em usabilidade e privacidade</li>
          </ul>
        </div>
      </div>
    </section>
  );
}
