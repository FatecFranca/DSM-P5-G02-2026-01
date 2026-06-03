import { Activity } from "lucide-react";

const navItems = [
  { label: "Plataforma", href: "#plataforma" },
  { label: "Como funciona", href: "#como-funciona" },
  { label: "Indicadores", href: "#indicadores" },
  { label: "Demonstração", href: "#demo" },
];

export function Header() {
  return (
    <header className="fixed inset-x-0 top-0 z-50 border-b border-white/40 bg-white/75 backdrop-blur-xl">
      <div className="mx-auto flex max-w-7xl items-center justify-between px-5 py-4 lg:px-8">
        <a href="#inicio" className="flex items-center gap-3">
          <span className="grid h-10 w-10 place-items-center rounded-2xl bg-gradient-to-br from-sky-500 to-blue-700 text-white shadow-lg shadow-sky-500/25">
            <Activity className="h-5 w-5" />
          </span>
          <div>
            <p className="text-base font-black tracking-tight text-slate-950">CardioPredict</p>
            <p className="text-xs font-semibold uppercase tracking-[0.22em] text-sky-600">AI Health</p>
          </div>
        </a>

        <nav className="hidden items-center gap-7 lg:flex">
          {navItems.map((item) => (
            <a
              key={item.href}
              href={item.href}
              className="text-sm font-semibold text-slate-600 transition hover:text-sky-600"
            >
              {item.label}
            </a>
          ))}
        </nav>

        {/* CTA removida conforme solicitado */}
      </div>
    </header>
  );
}
