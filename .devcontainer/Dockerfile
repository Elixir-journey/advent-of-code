FROM elixir:1.19.3-otp-28-alpine
ENV MIX_ENV=dev

# Install Hex, Rebar, and essential tools
RUN mix do local.hex --force, local.rebar --force \
    && apk add --no-cache \
    git \
    nodejs \
    npm \
    curl \
    inotify-tools \
    bash \
    openssh \
    postgresql-client

WORKDIR /workspace

COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV

COPY . .

# Run compilation in development mode
RUN mix compile

# Default command to keep container running for VS Code
CMD ["sleep", "infinity"]
