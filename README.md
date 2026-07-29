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
- automações;
- configurações do ambiente.

O Hermes funciona como o motor de execução da IA. O TARS é a aplicação que organiza, controla e evolui esse motor.

A ideia é transformar o TARS em um agente modular, versionado e portátil, que possa ser instalado em diferentes máquinas e evoluir como um software real.

---

# Arquitetura atual

A arquitetura inicial do TARS segue o modelo:

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
   v
Configurações do TARS
   |
   v
Hermes Agent
   |
   v
Modelo de linguagem escolhido
```

Cada camada possui uma responsabilidade específica.

---

# Por que não usar apenas um alias?

A primeira implementação utilizava um alias no `.bashrc`.

Exemplo:

```bash
alias tars='hermes chat -m modelo ...'
```

Essa abordagem funciona, mas possui limitações:

- a configuração fica misturada com o shell;
- não existe uma estrutura de projeto;
- fica difícil versionar;
- dificulta adicionar novas funcionalidades;
- depende de uma configuração manual da máquina.

Por isso o TARS foi transformado em um programa próprio.

Agora o comando:

```bash
tars
```

executa um software controlado pelo projeto.

---

# O papel do PATH no Linux

Quando um comando é digitado:

```bash
tars
```

o shell procura um executável nos diretórios definidos pela variável de ambiente:

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

Como o TARS possui o arquivo:

```
~/.local/bin/tars
```

o Bash consegue encontrá-lo automaticamente.

O processo é:

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

# Estrutura atual do projeto

```
TARS/

├── config/
│
├── docs/
│
├── models/
│   └── current
│
├── prompts/
│
├── scripts/
│   └── tars
│
├── README.md
│
├── LICENSE
│
└── .gitignore
```

---

# O launcher

O arquivo:

```
~/.local/bin/tars
```

é o ponto de entrada global do programa.

Ele não contém a lógica principal.

Seu objetivo é apenas encaminhar a execução para o projeto:

```bash
#!/usr/bin/env bash

exec ~/AI/TARS/scripts/tars "$@"
```

Esse padrão mantém o sistema organizado:

```
PATH
 |
 v
Launcher
 |
 v
Projeto real
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

Isso evita processos intermediários desnecessários.

É uma prática comum em:

- scripts de inicialização;
- containers Docker;
- serviços Linux;
- sistemas Unix.

---

# O significado de "$@"

No Bash, argumentos passados para um programa são armazenados em variáveis:

```bash
$1
$2
$3
...
```

Exemplo:

```bash
tars arquivo.txt estudo
```

gera:

```
$1 = arquivo.txt
$2 = estudo
```

A variável especial:

```bash
$@
```

representa todos os argumentos recebidos.

Então:

```bash
exec ~/AI/TARS/scripts/tars "$@"
```

significa:

> Execute o TARS real e envie todos os argumentos que o usuário passou.

Exemplo futuro:

```bash
tars model 4
```

poderá chegar ao script principal como:

```
$1 = model
$2 = 4
```

permitindo criar comandos internos do próprio TARS.

---

# Configuração de modelos

Os modelos utilizados pelo TARS são separados do código.

O arquivo:

```
models/current
```

define o modelo atualmente ativo.

Exemplo:

```
openai/o4-mini
```

O script principal lê esse arquivo:

```bash
MODEL=$(cat "$TARS_HOME/models/current")
```

Depois inicia o Hermes:

```bash
hermes chat -m "$MODEL"
```

Essa separação permite trocar modelos sem alterar código.

Exemplo:

Antes:

```
openai/o4-mini
```

Depois:

```
openai/gpt-4o
```

O funcionamento do TARS permanece igual.

---

# Filosofia de desenvolvimento

O TARS será desenvolvido seguindo princípios de engenharia de software.

## Separação de responsabilidades

Cada componente possui uma função clara.

```
Launcher
    |
    apenas inicia

Scripts
    |
    lógica do programa

Config
    |
    parâmetros

Prompts
    |
    identidade e comportamento

Models
    |
    escolha do modelo
```

---

# Versionamento

Todo o projeto será mantido utilizando Git.

Objetivos:

- registrar evolução;
- recuperar versões antigas;
- documentar mudanças;
- facilitar migração para novas máquinas.

---

# Modularidade

O TARS deve crescer através de módulos independentes.

Possíveis módulos futuros:

- memória;
- gerenciamento de projetos;
- integração com GitHub;
- automação;
- pesquisa;
- calendário;
- ferramentas próprias.

---

# Próximos objetivos

## Sistema de prompts

Separar a identidade do agente em arquivos independentes:

```
prompts/

├── personality.md
├── physics_math.md
├── programming.md
├── research.md
└── tools.md
```

Permitindo diferentes modos de operação.

---

## Sistema de seleção de modelos

Criar comandos como:

```bash
tars model
```

ou:

```bash
tars model 4
```

Exemplo:

```
1 - o4-mini
2 - GPT-4o
3 - Claude
4 - Gemini
5 - DeepSeek
```

O usuário poderá escolher o modelo diretamente pelo terminal.

---

## Sistema de configuração

Criar comandos:

```bash
tars config
```

Permitindo:

- alterar nome do agente;
- modificar personalidade;
- escolher modelo;
- configurar memória;
- alterar comportamento.

---

## Instalação automática

Criar:

```
install.sh
```

Responsável por:

- instalar dependências;
- criar diretórios;
- configurar permissões;
- adicionar launcher;
- preparar ambiente.

Objetivo:

Em uma máquina nova:

```bash
git clone TARS
cd TARS
./install.sh
```

e o agente estará funcionando.

---

# Visão futura

A visão final é transformar o TARS em um framework pessoal de agentes:

```
              TARS

                |
 ┌──────────────┼──────────────┐
 |              |              |
Identidade   Memória      Modelos

 |              |              |

Personalidade Ferramentas   Plugins

                |

             Hermes
```

O Hermes fornece a capacidade de raciocínio.

O TARS fornece identidade, organização, contexto e evolução.

---

# Estado atual

Versão inicial:

- [x] Criado projeto TARS
- [x] Criado launcher global
- [x] Configurado PATH
- [x] Criado script principal
- [x] Separado modelo em configuração externa
- [x] Integração inicial com Hermes
- [ ] Sistema de prompts
- [ ] Sistema de memória
- [ ] Sistema de plugins
- [ ] Instalador automático
- [ ] Interface de configuração
