# 🚀 Terraform com Azure — Guia para Iniciantes

> **Objetivo:** Do zero ao seu primeiro recurso provisionado no Azure com Terraform.  
> **Pré-requisitos:** Computador com Windows, macOS ou Linux. Nada instalado além disso.

---

## Sumário

1. [O que é Terraform?](#1-o-que-é-terraform)
2. [Instalando as ferramentas](#2-instalando-as-ferramentas)
3. [Configurando o Azure CLI](#3-configurando-o-azure-cli)
4. [Estrutura de um projeto Terraform](#4-estrutura-de-um-projeto-terraform)
5. [Criando seu primeiro recurso no Azure](#5-criando-seu-primeiro-recurso-no-azure)
6. [Comandos essenciais](#6-comandos-essenciais)
7. [Entendendo o ciclo de vida](#7-entendendo-o-ciclo-de-vida)
8. [Boas práticas para iniciantes](#8-boas-práticas-para-iniciantes)
9. [Próximos passos](#9-próximos-passos)

---

## 1. O que é Terraform?

Terraform é uma ferramenta de **Infraestrutura como Código (IaC)** criada pela HashiCorp. Com ela, você descreve sua infraestrutura em arquivos de texto (`.tf`) e o Terraform cuida de criar, modificar ou destruir os recursos na nuvem.

**Por que usar Terraform?**
- Infraestrutura versionada no Git como qualquer código
- Reprodutível: mesmo arquivo cria o mesmo ambiente em qualquer lugar
- Suporta Azure, AWS, GCP e centenas de outros provedores

---

## 2. Instalando as ferramentas

Você precisará de **3 ferramentas**: Terraform, Azure CLI e um editor de código.

### 2.1 Terraform

**Windows** (via winget):
```powershell
winget install HashiCorp.Terraform
```

**macOS** (via Homebrew):
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

**Linux (Ubuntu/Debian)**:
```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

✅ **Verifique a instalação:**
```bash
terraform -version
```

---

### 2.2 Azure CLI

**Windows** — Baixe o instalador em: https://aka.ms/installazurecliwindows

**macOS**:
```bash
brew update && brew install azure-cli
```

**Linux (Ubuntu/Debian)**:
```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

✅ **Verifique a instalação:**
```bash
az version
```

---

### 2.3 Editor de código — VS Code (recomendado)

Baixe em: https://code.visualstudio.com

Após instalar, adicione a extensão oficial do Terraform:
1. Abra o VS Code
2. Pressione `Ctrl+Shift+X` (ou `Cmd+Shift+X` no Mac)
3. Pesquise por **HashiCorp Terraform** e instale

---

## 3. Configurando o Azure CLI

### 3.1 Fazer login na sua conta Azure

```bash
az login
```

Isso abrirá o navegador para você autenticar. Após o login, o terminal mostrará suas assinaturas disponíveis.

### 3.2 Selecionar a assinatura correta (se tiver mais de uma)

```bash
# Listar assinaturas disponíveis
az account list --output table

# Definir a assinatura que será usada
az account set --subscription "NOME_OU_ID_DA_ASSINATURA"
```

### 3.3 Verificar o contexto ativo

```bash
az account show
```

> 💡 **Dica:** Anote o valor do campo `id` — ele é o seu **Subscription ID** e será usado no Terraform.

---

## 4. Estrutura de um projeto Terraform

Crie uma pasta para o seu projeto:

```bash
mkdir meu-projeto-terraform
cd meu-projeto-terraform
```

Um projeto Terraform básico tem esta estrutura:

```
meu-projeto-terraform/
├── main.tf           # Recursos a serem criados
├── variables.tf      # Declaração de variáveis
├── outputs.tf        # Valores que serão exibidos após o apply
└── terraform.tfvars  # Valores das variáveis (não versione dados sensíveis!)
```

### O arquivo `main.tf` — o coração do projeto

Todo arquivo `.tf` começa com o bloco `terraform` (configurações gerais) e o bloco `provider` (qual nuvem será usada):

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}
```

---

## 5. Criando seu primeiro recurso no Azure

Vamos criar um **Resource Group** — o contêiner básico de qualquer recurso no Azure.

### 5.1 Crie o arquivo `main.tf`

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Criando um Resource Group
resource "azurerm_resource_group" "meu_rg" {
  name     = "rg-meu-primeiro-projeto"
  location = "East US"

  tags = {
    ambiente = "aprendizado"
    criado_por = "terraform"
  }
}
```

### 5.2 Crie o arquivo `outputs.tf` (opcional, mas útil)

```hcl
output "resource_group_id" {
  description = "ID do Resource Group criado"
  value       = azurerm_resource_group.meu_rg.id
}

output "resource_group_location" {
  description = "Localização do Resource Group"
  value       = azurerm_resource_group.meu_rg.location
}
```

### 5.3 Execute o fluxo Terraform

**Passo 1 — Inicializar o projeto** (baixa o provider do Azure):
```bash
terraform init
```

Você verá uma mensagem como `Terraform has been successfully initialized!`

**Passo 2 — Visualizar o que será criado:**
```bash
terraform plan
```

O output mostrará um `+` verde ao lado de cada recurso que será **criado**.

**Passo 3 — Aplicar as mudanças:**
```bash
terraform apply
```

O Terraform pedirá confirmação. Digite `yes` e pressione Enter.

Após alguns segundos, você verá:
```
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

✅ **Verifique no Azure Portal:** Acesse https://portal.azure.com e procure por "Resource Groups" — seu grupo `rg-meu-primeiro-projeto` estará lá!

---

## 6. Comandos essenciais

| Comando | O que faz |
|---|---|
| `terraform init` | Inicializa o projeto e baixa os providers |
| `terraform plan` | Mostra o que será criado/modificado/destruído (não aplica nada) |
| `terraform apply` | Aplica as mudanças na nuvem |
| `terraform destroy` | **Destrói** todos os recursos gerenciados pelo Terraform |
| `terraform show` | Exibe o estado atual dos recursos |
| `terraform fmt` | Formata os arquivos `.tf` automaticamente |
| `terraform validate` | Valida a sintaxe dos arquivos sem se conectar à nuvem |

> ⚠️ **Cuidado com `terraform destroy`:** ele remove tudo que foi criado. Use com cautela em ambientes de produção.

---

## 7. Entendendo o ciclo de vida

```
Você edita os .tf
       ↓
terraform plan   →  Terraform compara o que existe (state) com o que você escreveu
       ↓
terraform apply  →  Terraform faz as mudanças necessárias na Azure
       ↓
terraform.tfstate  →  Arquivo que registra o que foi criado (não edite manualmente!)
```

### O arquivo `terraform.tfstate`

Este arquivo é criado automaticamente após o `apply`. Ele guarda o **estado atual** da sua infraestrutura. Pontos importantes:

- **Não o edite manualmente**
- **Não o versione no Git** se contiver dados sensíveis
- Em equipes, use um **backend remoto** (ex: Azure Storage) para compartilhar o state

Adicione ao seu `.gitignore`:
```
.terraform/
terraform.tfstate
terraform.tfstate.backup
*.tfvars
```

---

## 8. Boas práticas para iniciantes

### Use variáveis em vez de valores fixos

**`variables.tf`:**
```hcl
variable "location" {
  description = "Região do Azure"
  type        = string
  default     = "East US"
}

variable "prefixo" {
  description = "Prefixo para nomear os recursos"
  type        = string
}
```

**`main.tf`** (usando as variáveis):
```hcl
resource "azurerm_resource_group" "meu_rg" {
  name     = "${var.prefixo}-resource-group"
  location = var.location
}
```

**`terraform.tfvars`** (valores das variáveis):
```hcl
location = "Brazil South"
prefixo  = "meu-projeto"
```

### Use tags em todos os recursos

Tags ajudam a organizar e rastrear custos no Azure:
```hcl
tags = {
  projeto    = "meu-app"
  ambiente   = "dev"
  responsavel = "seu-nome"
}
```

### Sempre rode `terraform plan` antes do `apply`

Leia o plan com atenção antes de confirmar qualquer mudança.

---

## 9. Próximos passos

Depois de dominar o básico, explore:

- **Módulos:** Reutilize blocos de infraestrutura como funções
- **Backend remoto:** Armazene o state no Azure Storage para trabalho em equipe
- **Workspaces:** Gerencie múltiplos ambientes (dev, staging, prod) com um único código
- **Azure Provider docs:** https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
- **Terraform Registry:** https://registry.terraform.io (módulos prontos para uso)

### Recursos de aprendizado

- Documentação oficial: https://developer.hashicorp.com/terraform/docs
- Tutoriais do Terraform com Azure: https://developer.hashicorp.com/terraform/tutorials/azure-get-started
- Azure Provider no registry: https://registry.terraform.io/providers/hashicorp/azurerm/latest

---

> 💬 **Dica final:** Comece sempre pelo menor recurso possível, entenda o ciclo `init → plan → apply`, e vá adicionando complexidade aos poucos. A melhor forma de aprender Terraform é praticando!