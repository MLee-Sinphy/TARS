# TARS — Personal AI Agent

## Sobre o projeto

O **TARS** é um agente pessoal de inteligência artificial construído sobre o **Hermes Agent**.

O objetivo do projeto é criar uma camada própria de controle, configuração e personalização sobre um agente de IA, separando:

- identidade do agente;
- personalidade;
- metodologia de interação;
- modelos de linguagem;
- ferramentas;
- memória;
- contexto;
- automações;
- configurações do ambiente.

O Hermes funciona como o motor de execução da IA.

O TARS é a aplicação responsável por organizar, controlar e evoluir esse motor.

A ideia é transformar o TARS em um agente modular, versionado e portátil, desenvolvido seguindo princípios de engenharia de software.

---

# Arquitetura atual

A arquitetura atual:

```
Usuário
   |
   v
Comando: tars
   |
   v
~/.local/bin/tars
   |
   v
~/AI/TARS/scripts/tars
   |
   |
   +----------------+
   |                |
   v                v
Model Manager   Context Engine
   |
   v
Hermes Agent
   |
   v
Modelo de linguagem
```

Cada camada possui uma responsabilidade específica.

---

# Por que não usar apenas um alias?

A primeira implementação utilizava um alias no `.bashrc`.

Exemplo:

```bash
alias tars='hermes chat -m modelo ...'
```

Essa abordagem funciona, porém possui limitações:

- configuração misturada ao shell;
- difícil versionamento;
- pouca modularidade;
- difícil adicionar funcionalidades;
- dependência de configuração manual.

Por isso o TARS foi transformado em um programa próprio.

Agora:

```bash
tars
```

executa uma aplicação controlada pelo projeto.

---

# O papel do PATH no Linux

Quando um comando é digitado:

```bash
tars
```

o Bash procura um executável nos diretórios definidos pela variável:

```bash
PATH
```

Exemplo:

```
/usr/local/bin
/usr/bin
/bin
~/.local/bin
```

Como existe:

```
~/.local/bin/tars
```

o sistema encontra automaticamente o programa.

Fluxo:

```
Usuário digita:

tars

↓

Bash consulta PATH

↓

Encontra:

~/.local/bin/tars

↓

Executa o programa
```

---

# Launcher global

O arquivo:

```
~/.local/bin/tars
```

é apenas o ponto de entrada global.

Ele não possui a lógica do programa.

Conteúdo:

```bash
#!/usr/bin/env bash

exec ~/AI/TARS/scripts/tars "$@"
```

A função dele é encaminhar a execução para o projeto real.

Arquitetura:

```
PATH

 |

 v

Launcher

 |

 v

Projeto TARS
```

---

# Por que utilizar exec?

O comando:

```bash
exec
```

substitui o processo atual pelo novo processo.

Sem `exec`:

```
Shell
 |
 └── Launcher
       |
       └── TARS
             |
             └── Hermes
```

Com `exec`:

```
Shell
 |
 └── TARS
       |
       └── Hermes
```

Benefícios:

- evita processos intermediários;
- melhora gerenciamento de sinais;
- segue padrões Unix;
- é comum em scripts de serviços e containers.

---

# O significado de "$@"

Argumentos recebidos pelo Bash:

```bash
$1
$2
$3
```

Exemplo:

```bash
tars claude-opus teste
```

gera:

```
$1 = claude-opus
$2 = teste
```

A variável:

```bash
$@
```

representa todos os argumentos.

Então:

```bash
exec ~/AI/TARS/scripts/tars "$@"
```

significa:

> Execute o TARS real passando todos os argumentos recebidos.

Isso permite comandos futuros como:

```bash
tars models
tars update-default gpt5
tars read arquivo.md
```

---

# Estrutura atual do projeto

```
TARS/

├── lib/
│   └── model_manager.sh
│
├── models/
│   ├── available
│   └── current
│
├── scripts/
│   └── tars
│
├── prompts/
│
├── docs/
│
├── README.md
│
├── LICENSE
│
└── .gitignore
```

---

# Model Manager

O sistema de modelos foi separado da lógica principal.

Responsabilidade:

```
model_manager.sh

        |

        +── descobrir modelo atual

        +── buscar por índice

        +── buscar por alias

        +── listar modelos

        +── alterar modelo padrão
```

---

# Banco de modelos

Arquivo:

```
models/available
```

Formato:

```
id|alias|modelo|descrição
```

Exemplo:

```
1|claude-opus|anthropic/claude-opus-4|Máxima qualidade
2|gpt5|openai/gpt-5|Modelo premium geral
3|gemini-pro|google/gemini-2.5-pro|Grande contexto
```

O arquivo funciona como fonte única da verdade.

---

# Modelo atual

Arquivo:

```
models/current
```

Exemplo:

```
openai/o4-mini
```

Esse arquivo define o modelo padrão.

---

# Comandos atuais

## Abrir TARS com modelo padrão

```bash
tars
```

---

## Usar modelo específico temporariamente

Por alias:

```bash
tars claude-opus
```

Por índice:

```bash
tars 1
```

---

## Listar modelos disponíveis

```bash
tars models
```

Exibe:

- índice;
- alias;
- modelo;
- descrição;
- modelo atual.

---

## Alterar modelo padrão

```bash
tars update-default claude-opus
```

Atualiza:

```
models/current
```

A partir desse momento:

```bash
tars
```

usará o novo modelo.

---

# Filosofia de desenvolvimento

O TARS segue princípios de engenharia de software.

## Separação de responsabilidades

```
Launcher

    |
    apenas inicia


Scripts

    |
    lógica


Configurações

    |
    parâmetros


Models

    |
    modelos disponíveis


Context

    |
    conhecimento e comportamento
```

---

# Camadas de contexto (próxima etapa)

A próxima grande evolução será o sistema de contexto.

Objetivo:

O TARS deve entender automaticamente onde está sendo executado.

Exemplo:

```
my-study-vault/

├── .tars

└── physics/

    ├── .tars

    └── quantum_mechanics/

        └── .tars
```

Ao executar:

```bash
tars
```

dentro de:

```
quantum_mechanics
```

o TARS deverá montar:

```
identidade global

+

física e matemática

+

mecânica quântica
```

Esse sistema será chamado de:

```
Context Engine
```

---

# Próximos módulos

## Context Engine

Responsável por:

- buscar arquivos `.tars`;
- montar contexto hierárquico;
- carregar informações específicas;
- criar prompt final.

---

## Prompt Builder

Responsável por combinar:

```
Identidade

+

Personalidade

+

Contexto

+

Instruções específicas

+

Arquivo fornecido pelo usuário
```

---

## Memória

Possíveis camadas:

```
Memória curta
(sessão atual)

Memória média
(projeto)

Memória longa
(base de conhecimento)
```

Possíveis tecnologias:

- SQLite;
- embeddings;
- RAG.

---

## Interface própria

Objetivo futuro:

Substituir gradualmente a interface do Hermes por uma experiência própria:

- nome TARS;
- cores próprias;
- layout próprio;
- comandos próprios.

---

## Instalação automática

Futuro:

Criar:

```
install.sh
```

Responsável por:

- instalar dependências;
- criar diretórios;
- configurar permissões;
- configurar PATH;
- preparar ambiente.

Objetivo:

Em uma máquina nova:

```bash
git clone TARS
cd TARS
./install.sh
```

e o agente estará pronto.

---

# Estado atual

## Concluído

- [x] Criado projeto TARS
- [x] Criado launcher global
- [x] Configurado PATH
- [x] Criado script principal
- [x] Separado código e configuração
- [x] Integração com Hermes
- [x] Sistema de modelos
- [x] Seleção por índice
- [x] Seleção por alias
- [x] Lista de modelos
- [x] Alteração de modelo padrão

## Próximos passos

- [ ] Context Engine
- [ ] Sistema `.tars` hierárquico
- [ ] Prompt Builder
- [ ] Sistema de memória
- [ ] Sistema de plugins
- [ ] Instalador automático
- [ ] Interface própria

---

# Visão final

O objetivo final é transformar o TARS em um framework pessoal de agentes:

```
                 TARS

                   |

     ┌─────────────┼─────────────┐

     |             |             |

 Identidade     Contexto      Modelos

     |             |             |

Personalidade   Memória     Ferramentas

                   |

                Hermes

                   |

                LLM
```

O Hermes fornece capacidade de raciocínio.

O TARS fornece identidade, contexto, organização e evolução.
