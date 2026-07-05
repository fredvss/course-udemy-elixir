# Setup do ASDF 0.18 (binário) + Erlang/OTP 28 + Elixir 1.19

## Linux Mint / Ubuntu

---

## 1. Dependências do sistema

```bash id="dep1"
sudo apt update && sudo apt upgrade -y

sudo apt install -y \
  curl git unzip wget \
  build-essential autoconf m4 \
  libncurses-dev \
  libwxgtk3.2-dev \
  libgl1-mesa-dev libglu1-mesa-dev \
  libpng-dev libssh-dev unixodbc-dev \
  xsltproc fop libxml2-utils \
  openjdk-11-jdk
```

---

## 2. Instalação do ASDF 0.18 (binário)

### 2.1 Preparação

```bash id="prep1"
rm -rf ~/.asdf ~/asdf
mkdir -p ~/.local/bin ~/.asdf
```

---

### 2.2 Opção A — Linux x86_64 (amd64)

```bash id="tar1"
cd /tmp

wget https://github.com/asdf-vm/asdf/releases/download/v0.18.1/asdf-v0.18.1-linux-amd64.tar.gz

tar -xzf asdf-v0.18.1-linux-amd64.tar.gz

mv asdf ~/.local/bin/asdf
chmod +x ~/.local/bin/asdf
```

---

### 2.3 Opção B — Linux ARM64 (ex: Raspberry Pi, servidores ARM)

```bash id="tar_arm"
cd /tmp

wget https://github.com/asdf-vm/asdf/releases/download/v0.18.1/asdf-v0.18.1-linux-arm64.tar.gz

tar -xzf asdf-v0.18.1-linux-arm64.tar.gz

mv asdf ~/.local/bin/asdf
chmod +x ~/.local/bin/asdf
```
---

## 3. Configuração do ambiente (.bashrc)

Abra:

```bash id="bashrc1"
vi ~/.bashrc
```

Remova (se existir):

```bash id="bashrc_remove"
. "$HOME/.asdf/asdf.sh"
. "$HOME/.asdf/completions/asdf.bash"
```

Adicione ao final:

```bash id="bashrc_add"
# asdf (binário)
export ASDF_DATA_DIR="$HOME/.asdf"
export PATH="$HOME/.local/bin:$ASDF_DATA_DIR/shims:$PATH"
```

Recarregue:

```bash id="reload1"
source ~/.bashrc
hash -r
```

---

## 4. Validação

```bash id="val1"
type -a asdf
asdf --version
```

Esperado:

```text id="val_expected"
asdf version 0.18.0
```

---

## 5. Adicionar plugins

```bash id="plugins1"
asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git
```

---

## 6. Instalar Erlang/OTP 28

```bash id="erl1"
asdf list all erlang
asdf install erlang 28.3
asdf set -u erlang 28.3
```

---

## 7. Instalar Elixir 1.19

```bash id="elixir1"
asdf list all elixir
asdf install elixir 1.19.5-otp-28
asdf set -u elixir 1.19.5-otp-28
```

---

## 8. Verificação

```bash id="check1"
asdf current
erl -version
elixir -v
iex
```

---

## 9. Arquivo `.tool-versions`

Exemplo:

```text id="toolv1"
erlang 28.3
elixir 1.19.5-otp-28
```

Para projeto:

```bash id="proj1"
cd meu_projeto
asdf set erlang 28.3
asdf set elixir 1.19.5-otp-28
```

---

## 10. Comandos básicos do ASDF

### Plugins

```bash id="cmd_plugins"
# Listar plugins instalados
asdf plugin list

# Listar todos os plugins disponíveis
asdf plugin list all

# Adicionar plugin
asdf plugin add <plugin>
asdf plugin add <plugin> <url>

# Atualizar plugins
asdf plugin update --all
asdf plugin update <plugin>

# Remover plugin (e todas as versões instaladas)
asdf plugin remove <plugin>
```

### Versões

```bash id="cmd_versions"
# Listar versões disponíveis
asdf list all <plugin>

# Instalar uma versão
asdf install <plugin> <versao>

# Listar versões instaladas
asdf list <plugin>

# Remover uma versão instalada
asdf uninstall <plugin> <versao>
```

### Definir versões

```bash id="cmd_set"
# Global (equivale ao antigo `asdf global`)
asdf set -u <plugin> <versao>

# Local / projeto (cria ou atualiza .tool-versions)
asdf set <plugin> <versao>

# Ver versões ativas
asdf current
```

### Outros

```bash id="cmd_other"
# Recriar shims (necessário após install manual)
asdf reshim
asdf reshim <plugin>

# Onde está o executável de uma versão
asdf where <plugin> <versao>

# Qual versão está sendo usada agora
asdf which <executavel>   # ex: asdf which elixir
```

---

## 11. Troubleshooting

### asdf não encontrado

```bash id="tr1"
echo $PATH
which asdf
```

---

### erro ao compilar Erlang

```bash id="tr2"
export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac --without-wx"
asdf install erlang 28.3
```

---

### versão não aplicada

```bash id="tr3"
asdf reshim
```

---

## 12. Teste final

```bash id="final1"
elixir -v
iex
```

Se o shell abrir corretamente, o ambiente está pronto
