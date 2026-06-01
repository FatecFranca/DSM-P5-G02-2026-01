import fs from "fs";
import path from "path";
import { DiagnosticoInput } from "../types/diagnostico";

const ATRIBUTOS = [
  "age",
  "gender",
  "impluse",
  "pressurehight",
  "pressurelow",
  "glucose",
  "kcm",
  "troponin",
] as const;

type Classe = "negative" | "positive";

type Parametros = {
  atributos: string[];
  mu: number[];
  sigma: number[];
  classes: Classe[];
};

let cacheParams: Parametros | null = null;
type ModeloCart = {
  atributos: string[];
  classes: Classe[];
  tree: {
    children_left: number[];
    children_right: number[];
    feature: number[];
    threshold: number[];
    value: number[][];
  };
};

let cacheModelo: ModeloCart | null = null;

function getDadosPath(fileName: string) {
  return path.resolve(process.cwd(), fileName);
}

function carregarArtefatos() {
  if (cacheParams && cacheModelo) {
    return { params: cacheParams, modelo: cacheModelo };
  }

  const paramsPath = getDadosPath("parametros_preprocessamento.json");
  const modeloPath = getDadosPath("modelo_cart_melhor.json");

  if (!fs.existsSync(paramsPath) || !fs.existsSync(modeloPath)) {
    throw new Error(
      "Arquivos de preprocessamento/modelo nao encontrados. Execute: python scripts/train-classic-models-heart-attack.py"
    );
  }

  const paramsContent = fs.readFileSync(paramsPath, "utf-8");
  const modeloContent = fs.readFileSync(modeloPath, "utf-8");

  cacheParams = JSON.parse(paramsContent) as Parametros;
  cacheModelo = JSON.parse(modeloContent) as ModeloCart;

  return { params: cacheParams, modelo: cacheModelo };
}

function normalizarEntrada(entrada: DiagnosticoInput, params: Parametros) {
  const vetor = ATRIBUTOS.map((atributo, index) => {
    const value = Number(entrada[atributo]);
    const sigma = params.sigma[index] || 1;
    return (value - params.mu[index]) / sigma;
  });
  return vetor;
}

function inferirComCart(vetorEntrada: number[], modelo: ModeloCart) {
  let node = 0;
  const { children_left, children_right, feature, threshold, value } = modelo.tree;

  while (children_left[node] !== children_right[node]) {
    const featureIndex = feature[node];
    const limiar = threshold[node];
    node = vetorEntrada[featureIndex] <= limiar ? children_left[node] : children_right[node];
  }

  const counts = value[node] ?? [1, 1];
  const total = counts.reduce((acc, cur) => acc + cur, 0) || 1;
  return counts.map((count) => count / total);
}

export function analisarRiscoAtaqueCardiaco(entrada: DiagnosticoInput) {
  const { params, modelo } = carregarArtefatos();
  const entradaNorm = normalizarEntrada(entrada, params);
  const probs = inferirComCart(entradaNorm, modelo);
  const indexPositivo = modelo.classes.indexOf("positive");
  const probPositivo = indexPositivo >= 0 ? probs[indexPositivo] : probs[1];
  const chance = probPositivo * 100;
  const temChance = chance >= 50;

  return {
    chance_percentual: Number(chance.toFixed(2)),
    classificacao: temChance ? "positive" : "negative",
    tem_chance: temChance,
    base_vizinhos: 0,
    modelo: "CART",
  };
}
