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
            O aplicativo analisa dados clínicos e indica de forma clara se o paciente possui ou não risco de ataque cardíaco,
            apoiando a comunicação com profissionais de saúde.
          </p>
          <ul>
            <li>Visualização dos fatores clínicos analisados</li>
            <li>Resultado objetivo: sim ou não para risco de ataque cardíaco</li>
            <li>Design focado em usabilidade e privacidade</li>
          </ul>
        </div>
      </div>
    </section>
  );
}
