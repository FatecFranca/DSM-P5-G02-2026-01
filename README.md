# HeartX

Aplicação para avaliação de risco de ataque cardíaco com base em exames clínicos. O usuário informa dados como pulso, pressão arterial, glicose, CK-MB e troponina; o modelo CART classifica o risco e salva o histórico de exames.

## Estrutura

```
├── api/                  # Backend Node.js + Express + Prisma
├── app/myApp/            # App mobile Flutter
└── landpage-*/           # Landing page Next.js
```

## Stack

| Camada | Tecnologias |
|--------|-------------|
| Backend | Node.js · TypeScript · Express · Prisma · PostgreSQL · JWT |
| Mobile | Flutter · Dart · go_router · http |
| Landing | Next.js · Tailwind CSS |

## API

Base URL: `http://localhost:3000` — documentação interativa em `/docs` (Swagger).

| Recurso | Métodos |
|---------|---------|
| `POST /auth/login` | Autentica e retorna JWT |
| `/usuarios` | CRUD de usuários |
| `POST /diagnosticos/risco` | Análise de risco (modelo CART) |
| `/exames` | CRUD de exames clínicos |

Todas as rotas exceto login e cadastro exigem `Authorization: Bearer <token>`.

## Como rodar

### Backend

```bash
cd api
cp .env.example .env   # configure DATABASE_URL, JWT_SECRET, PORT
npm install
npm run prisma:generate
npm run prisma:migrate
npm run dev            # http://localhost:3000
```

### App mobile

```bash
cd app/myApp
flutter pub get
flutter run
```

### Landing page

```bash
cd landpage-sistema-cardiago-fatec-main
npm install
npm run dev
```

## Banco de dados

| Tabela | Campos principais |
|--------|-------------------|
| `tb_usuario` | id, nome, email, hash_senha, ativo |
| `tb_exame` | id, id_usuario, idade, sexo, pulso, pressao_sistolica, pressao_diastolica, glicose, ck_mb, troponina, result |

## Repositório

https://github.com/FatecFranca/DSM-P5-G02-2026-01

## API


https://cardio-predict-api.canadacentral.cloudapp.azure.com/docs