const fs = require("fs");
const path = require("path");

const INPUT_PATH = path.resolve(process.cwd(), "Heart Attack.csv");
const OUTPUT_CSV_PATH = path.resolve(process.cwd(), "heart_attack_processado.csv");
const OUTPUT_PARAMS_PATH = path.resolve(process.cwd(), "parametros_preprocessamento.json");

const ATRIBUTOS = [
  "age",
  "gender",
  "impluse",
  "pressurehight",
  "pressurelow",
  "glucose",
  "kcm",
  "troponin",
];

function parseCsv(content) {
  const lines = content.split(/\r?\n/).filter(Boolean);
  const headers = lines.shift().split(",").map((h) => h.trim().toLowerCase());

  return lines.map((line) => {
    const cols = line.split(",");
    const item = {};
    headers.forEach((header, index) => {
      item[header] = cols[index] !== undefined ? cols[index].trim() : "";
    });
    return item;
  });
}

function mean(values) {
  if (values.length === 0) return 0;
  return values.reduce((sum, v) => sum + v, 0) / values.length;
}

function std(values, mu) {
  if (values.length <= 1) return 1;
  const variance =
    values.reduce((sum, v) => sum + (v - mu) ** 2, 0) / (values.length - 1);
  const result = Math.sqrt(variance);
  return result === 0 ? 1 : result;
}

function percentile(sortedValues, p) {
  if (sortedValues.length === 0) return 0;
  const index = (sortedValues.length - 1) * p;
  const lower = Math.floor(index);
  const upper = Math.ceil(index);
  if (lower === upper) return sortedValues[lower];
  return (
    sortedValues[lower] + (sortedValues[upper] - sortedValues[lower]) * (index - lower)
  );
}

function keyByFeatures(row) {
  return ATRIBUTOS.map((a) => row[a]).join("|");
}

function toNumber(value) {
  const n = Number(String(value).replace(",", "."));
  return Number.isFinite(n) ? n : NaN;
}

function preprocess() {
  if (!fs.existsSync(INPUT_PATH)) {
    throw new Error(`Arquivo nao encontrado: ${INPUT_PATH}`);
  }

  const raw = fs.readFileSync(INPUT_PATH, "utf-8");
  let rows = parseCsv(raw)
    .map((row) => {
      const parsed = { class: String(row.class || "").toLowerCase() };
      ATRIBUTOS.forEach((a) => {
        parsed[a] = toNumber(row[a]);
      });
      return parsed;
    })
    .filter((row) => row.class === "positive" || row.class === "negative");

  const meansByClass = { positive: {}, negative: {} };
  for (const cls of ["positive", "negative"]) {
    for (const atributo of ATRIBUTOS) {
      const vals = rows
        .filter((r) => r.class === cls)
        .map((r) => r[atributo])
        .filter((v) => !Number.isNaN(v));
      meansByClass[cls][atributo] = mean(vals);
    }
  }

  rows = rows.map((row) => {
    const next = { ...row };
    ATRIBUTOS.forEach((a) => {
      if (Number.isNaN(next[a])) {
        next[a] = meansByClass[next.class][a];
      }
    });
    return next;
  });

  const firstByFeature = new Map();
  for (const row of rows) {
    const key = keyByFeatures(row);
    if (!firstByFeature.has(key)) firstByFeature.set(key, row);
  }
  rows = [...firstByFeature.values()];

  const classesByFeature = new Map();
  for (const row of rows) {
    const key = keyByFeatures(row);
    if (!classesByFeature.has(key)) classesByFeature.set(key, new Set());
    classesByFeature.get(key).add(row.class);
  }
  rows = rows.filter((row) => classesByFeature.get(keyByFeatures(row)).size === 1);

  for (const atributo of ATRIBUTOS) {
    const sorted = rows.map((r) => r[atributo]).sort((a, b) => a - b);
    const q1 = percentile(sorted, 0.25);
    const q3 = percentile(sorted, 0.75);
    const iqr = q3 - q1;
    const min = q1 - 1.5 * iqr;
    const max = q3 + 1.5 * iqr;
    rows = rows.filter((r) => r[atributo] >= min && r[atributo] <= max);
  }

  const mu = ATRIBUTOS.map((a) => mean(rows.map((r) => r[a])));
  const sigma = ATRIBUTOS.map((a, idx) => std(rows.map((r) => r[a]), mu[idx]));

  const normRows = rows.map((row) => {
    const next = { class: row.class };
    ATRIBUTOS.forEach((a, idx) => {
      next[a] = (row[a] - mu[idx]) / sigma[idx];
    });
    return next;
  });

  const header = [...ATRIBUTOS, "class"].join(",");
  const csvLines = normRows.map((row) =>
    [...ATRIBUTOS.map((a) => row[a].toFixed(10)), row.class].join(",")
  );
  fs.writeFileSync(OUTPUT_CSV_PATH, [header, ...csvLines].join("\n"), "utf-8");

  const params = {
    atributos: ATRIBUTOS,
    mu,
    sigma,
    classes: ["negative", "positive"],
    total_amostras: normRows.length,
  };
  fs.writeFileSync(OUTPUT_PARAMS_PATH, JSON.stringify(params, null, 2), "utf-8");

  console.log("Pre-processamento concluido.");
  console.log(`Amostras finais: ${normRows.length}`);
  console.log(`CSV salvo em: ${OUTPUT_CSV_PATH}`);
  console.log(`Parametros salvos em: ${OUTPUT_PARAMS_PATH}`);
}

preprocess();
