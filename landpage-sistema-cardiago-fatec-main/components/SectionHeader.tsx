import { ReactNode } from "react";

interface SectionHeaderProps {
  eyebrow: string;
  title: string;
  description: string;
  centered?: boolean;
  children?: ReactNode;
}

export function SectionHeader({
  eyebrow,
  title,
  description,
  centered = true,
  children,
}: SectionHeaderProps) {
  return (
    <div className={centered ? "mx-auto mb-12 max-w-3xl text-center" : "mb-10 max-w-3xl"}>
      <div className="mb-4 inline-flex rounded-full border border-sky-200 bg-sky-50 px-4 py-2 text-sm font-semibold text-sky-700 shadow-sm">
        {eyebrow}
      </div>
      <h2 className="text-3xl font-bold tracking-tight text-slate-950 md:text-5xl">
        {title}
      </h2>
      <p className="mt-5 text-base leading-8 text-slate-600 md:text-lg">{description}</p>
      {children}
    </div>
  );
}
