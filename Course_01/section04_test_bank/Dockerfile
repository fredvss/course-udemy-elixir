# Etapa base
FROM elixir:1.16-alpine

# Instala dependências do sistema
RUN apk add --no-cache build-base git nodejs npm

# Define o diretório de trabalho
WORKDIR /app

# Instala hex e rebar (gerenciadores do Elixir)
RUN mix local.hex --force && mix local.rebar --force

# Copia os arquivos de dependências
COPY mix.exs mix.lock ./
COPY config config

# Baixa dependências
RUN mix deps.get

# Copia o restante do código
COPY . .

# Compila os assets (caso use Phoenix com frontend)
RUN apk add --update git build-base nodejs yarn
RUN mix phx.digest

# Expõe a porta padrão do Phoenix
EXPOSE 4000

# Comando padrão para rodar o servidor
CMD ["mix", "phx.server"]
