# Use an official Elixir runtime as a parent image
FROM elixir:1.10.2-slim

RUN apt-get update && apt-get install -y postgresql-client curl git make inotify-tools gnupg g++

# Create and set home directory
ENV HOME /app
WORKDIR $HOME

# Configure required environment
ENV MIX_HOME=/opt/mix HEX_HOME=/opt/hex

# Install hex (Elixir package manager)
RUN mix local.hex --force

# Install rebar (Erlang build tool)
RUN mix local.rebar --force

# Copy all dependencies files
COPY mix.* ./

# Install all production dependencies
RUN mix deps.get --only prod

# Compile all dependencies
RUN mix deps.compile

# Copy all application files
COPY . .

# Compile the entire project and build the digest for production
RUN mix deps.clean mime --build
RUN mix do compile, phx.digest
RUN (cd deps/bcrypt_elixir && make clean && make)

RUN chmod +x /app/docker-entrypoint.sh
CMD ["/app/docker-entrypoint.sh"]