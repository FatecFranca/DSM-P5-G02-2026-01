import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        navy: "#061833",
        azure: "#0EA5E9",
        cyanSoft: "#67E8F9",
      },
      boxShadow: {
        glow: "0 0 70px rgba(14, 165, 233, 0.25)",
        premium: "0 24px 80px rgba(2, 8, 23, 0.14)",
      },
      backgroundImage: {
        "radial-tech": "radial-gradient(circle at 20% 20%, rgba(14,165,233,.24), transparent 32%), radial-gradient(circle at 80% 10%, rgba(59,130,246,.20), transparent 35%), radial-gradient(circle at 50% 90%, rgba(103,232,249,.16), transparent 28%)",
      },
    },
  },
  plugins: [],
};

export default config;
