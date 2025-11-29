import Config

config :tesla, Infrastructure.AocClient, adapter: Tesla.Adapter.Httpc

if config_env() == :test do
  config :tesla, Infrastructure.AocClient, adapter: Tesla.Mock
end
