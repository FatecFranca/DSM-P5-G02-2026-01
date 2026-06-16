import { Activity, Facebook, Instagram, Linkedin, Mail, MapPin, Phone } from "lucide-react";

const quickLinks = [
  { label: "Plataforma", href: "#plataforma" },
  { label: "Como funciona", href: "#como-funciona" },
  { label: "Indicadores", href: "#indicadores" },

];

const socialLinks = [
  { name: "linkedin", href: "#", Icon: Linkedin },
  { name: "instagram", href: "#", Icon: Instagram },
  { name: "facebook", href: "#", Icon: Facebook },
];

export function Footer() {
  return (
    <footer className="bg-slate-950 text-white">
      <div className="mx-auto grid max-w-7xl gap-10 px-5 py-14 md:grid-cols-[1.4fr_.8fr_.8fr] lg:px-8">
        <div>
          <div className="flex items-center gap-3">
            <span className="grid h-11 w-11 place-items-center rounded-2xl bg-gradient-to-br from-sky-500 to-blue-700 text-white">
              <Activity className="h-6 w-6" />
            </span>
            <div>
              <p className="text-lg font-black">CardioPredict AI</p>
              <p className="text-xs font-semibold uppercase tracking-[0.24em] text-sky-300">Predictive Health</p>
            </div>
          </div>
          <p className="mt-6 max-w-xl leading-8 text-slate-400">
            Solução de previsão de risco cardiovascular com inteligência artificial. Este projeto é uma demonstração visual e não substitui avaliação médica.
          </p>
        </div>

        <div>
          <h4 className="mb-5 font-black">Links rápidos</h4>
          <ul className="space-y-3 text-slate-400">
            {quickLinks.map((link) => (
              <li key={link.href}>
                <a className="transition hover:text-sky-300" href={link.href}>{link.label}</a>
              </li>
            ))}
          </ul>
        </div>

        <div>
          <h4 className="mb-5 font-black">Contato</h4>
          <ul className="space-y-4 text-slate-400">
            <li className="flex items-center gap-3"><Mail className="h-4 w-4 text-sky-300" /> Health@cardiopredict.com.br</li>
            <li className="flex items-center gap-3"><Phone className="h-4 w-4 text-sky-300" /> +55 (16) 4002-8922</li>
            <li className="flex items-center gap-3"><MapPin className="h-4 w-4 text-sky-300" /> Franca, Brasil</li>
          </ul>
          <div className="mt-6 flex gap-3">
            {socialLinks.map((social) => (
              <a key={social.name} href={social.href} className="grid h-10 w-10 place-items-center rounded-full bg-white/10 text-sky-100 transition hover:-translate-y-1 hover:bg-sky-500">
                <social.Icon className="h-5 w-5" />
              </a>
            ))}
          </div>
        </div>
      </div>
      <div className="border-t border-white/10 px-5 py-6 text-center text-sm text-slate-500">
        © {new Date().getFullYear()} CardioPredict. Todos os direitos reservados.
      </div>
    </footer>
  );
}
