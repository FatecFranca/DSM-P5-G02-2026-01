import json
from pathlib import Path

import numpy as np
import pandas as pd
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, f1_score, precision_score, recall_score
from sklearn.model_selection import StratifiedKFold, cross_val_score, train_test_split
from sklearn.naive_bayes import GaussianNB
from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC
from sklearn.tree import DecisionTreeClassifier


BASE_DIR = Path(__file__).resolve().parents[1]
DATA_PATH = BASE_DIR / "heart_attack_processado.csv"
RESULTS_PATH = BASE_DIR / "model_results_classic.json"
CART_MODEL_PATH = BASE_DIR / "modelo_cart_melhor.json"


def export_cart_model(model: DecisionTreeClassifier, atributos: list[str]):
  tree = model.tree_
  return {
      "atributos": atributos,
      "classes": ["negative", "positive"],
      "tree": {
          "children_left": tree.children_left.tolist(),
          "children_right": tree.children_right.tolist(),
          "feature": tree.feature.tolist(),
          "threshold": tree.threshold.tolist(),
          "value": tree.value.reshape(tree.value.shape[0], tree.value.shape[2]).tolist(),
      },
  }


def main():
  df = pd.read_csv(DATA_PATH)
  atributos = [
      "age",
      "gender",
      "impluse",
      "pressurehight",
      "pressurelow",
      "glucose",
      "kcm",
      "troponin",
  ]
  x = df[atributos].values.astype(float)
  y = (df["class"].values == "positive").astype(int)

  x_train, x_test, y_train, y_test = train_test_split(
      x, y, test_size=0.2, random_state=42, stratify=y
  )

  modelos = [
      ("LR", LogisticRegression(max_iter=2000, solver="liblinear", random_state=42)),
      ("LDA", LinearDiscriminantAnalysis()),
      ("KNN", KNeighborsClassifier()),
      ("CART", DecisionTreeClassifier(random_state=42)),
      ("NB", GaussianNB()),
      ("SVM", SVC(gamma="scale", kernel="rbf", random_state=42)),
  ]

  skf = StratifiedKFold(n_splits=10, shuffle=True, random_state=42)
  resultados = []
  melhor_cart = None
  melhor = None

  for nome, modelo in modelos:
      cv = cross_val_score(modelo, x_train, y_train, cv=skf, scoring="accuracy")
      modelo.fit(x_train, y_train)
      pred = modelo.predict(x_test)
      linha = {
          "modelo": nome,
          "cv_mean": float(cv.mean()),
          "cv_std": float(cv.std()),
          "acuracia_teste": float(accuracy_score(y_test, pred)),
          "f1_weighted": float(f1_score(y_test, pred, average="weighted")),
          "precisao_weighted": float(
              precision_score(y_test, pred, average="weighted", zero_division=0)
          ),
          "recall_weighted": float(recall_score(y_test, pred, average="weighted")),
      }
      resultados.append(linha)

      if nome == "CART":
          melhor_cart = modelo
      if melhor is None or linha["acuracia_teste"] > melhor["acuracia_teste"]:
          melhor = linha

  resultados.sort(key=lambda row: row["acuracia_teste"], reverse=True)
  payload = {
      "dataset": DATA_PATH.name,
      "amostras": int(len(df)),
      "atributos": atributos,
      "split": {"train": int(len(x_train)), "test": int(len(x_test))},
      "resultados": resultados,
      "melhor_modelo": melhor,
      "modelo_escolhido_para_api": "CART",
  }
  RESULTS_PATH.write_text(json.dumps(payload, indent=2), encoding="utf-8")
  CART_MODEL_PATH.write_text(
      json.dumps(export_cart_model(melhor_cart, atributos)), encoding="utf-8"
  )

  print("Treino clássico concluído.")
  print(f"Melhor no comparativo: {melhor['modelo']} ({melhor['acuracia_teste']:.4f})")
  print("Modelo aplicado na API: CART")
  print(f"Resultados: {RESULTS_PATH}")
  print(f"CART exportado: {CART_MODEL_PATH}")


if __name__ == "__main__":
  main()
