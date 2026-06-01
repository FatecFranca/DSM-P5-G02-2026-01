import json
from pathlib import Path

import numpy as np
import pandas as pd
from sklearn.metrics import accuracy_score, f1_score, precision_score, recall_score
from sklearn.model_selection import train_test_split
from sklearn.neural_network import MLPClassifier


BASE_DIR = Path(__file__).resolve().parents[1]
DATA_PATH = BASE_DIR / "heart_attack_processado.csv"
RESULTS_PATH = BASE_DIR / "model_results_neural_networks.json"
MODEL_PATH = BASE_DIR / "modelo_neural_melhor.json"


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
    alvo = "class"

    x = df[atributos].values.astype(float)
    y_texto = df[alvo].values.astype(str)
    classes_ordenadas = np.array(["negative", "positive"])
    y = np.where(y_texto == "positive", 1, 0).astype(int)

    x_train, x_test, y_train, y_test = train_test_split(
        x,
        y,
        test_size=0.2,
        random_state=42,
        stratify=y,
    )

    configuracoes = [
        ("MLP_8", (8,), "relu"),
        ("MLP_16", (16,), "relu"),
        ("MLP_32", (32,), "relu"),
        ("MLP_16_8", (16, 8), "relu"),
        ("MLP_32_16", (32, 16), "relu"),
        ("MLP_64_32", (64, 32), "relu"),
        ("MLP_32_TANH", (32,), "tanh"),
        ("MLP_64_32_TANH", (64, 32), "tanh"),
    ]

    resultados = []
    melhor = None
    melhor_modelo = None

    for nome, hidden_layers, activation in configuracoes:
        modelo = MLPClassifier(
            hidden_layer_sizes=hidden_layers,
            activation=activation,
            solver="adam",
            alpha=1e-4,
            learning_rate_init=1e-3,
            max_iter=2000,
            early_stopping=True,
            n_iter_no_change=25,
            random_state=42,
        )
        modelo.fit(x_train, y_train)
        pred = modelo.predict(x_test).astype(int)

        metrica = {
            "modelo": nome,
            "hidden_layers": list(hidden_layers),
            "activation": activation,
            "acuracia": float(accuracy_score(y_test, pred)),
            "f1_weighted": float(f1_score(y_test, pred, average="weighted")),
            "precisao_weighted": float(
                precision_score(y_test, pred, average="weighted", zero_division=0)
            ),
            "recall_weighted": float(recall_score(y_test, pred, average="weighted")),
        }
        resultados.append(metrica)

        if melhor is None or metrica["acuracia"] > melhor["acuracia"]:
            melhor = metrica
            melhor_modelo = modelo

    resultados.sort(
        key=lambda item: (item["acuracia"], item["f1_weighted"]), reverse=True
    )

    payload = {
        "dataset": str(DATA_PATH.name),
        "amostras": int(len(df)),
        "atributos": atributos,
        "split": {"train": int(len(x_train)), "test": int(len(x_test))},
        "resultados": resultados,
        "melhor_modelo": resultados[0],
    }
    RESULTS_PATH.write_text(json.dumps(payload, indent=2), encoding="utf-8")

    model_payload = {
        "atributos": atributos,
        "classes": classes_ordenadas.tolist(),
        "hidden_layers": list(melhor_modelo.hidden_layer_sizes),
        "activation": melhor_modelo.activation,
        "coefs": [coef.tolist() for coef in melhor_modelo.coefs_],
        "intercepts": [bias.tolist() for bias in melhor_modelo.intercepts_],
    }
    MODEL_PATH.write_text(json.dumps(model_payload), encoding="utf-8")

    print(f"Treino concluido. Melhor: {resultados[0]['modelo']}")
    print(f"Acuracia: {resultados[0]['acuracia']:.4f}")
    print(f"Resultados salvos em: {RESULTS_PATH}")
    print(f"Modelo salvo em: {MODEL_PATH}")


if __name__ == "__main__":
    main()
